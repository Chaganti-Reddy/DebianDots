/* See LICENSE file for copyright and license details. */
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include "../slstatus.h"
#include "../util.h"

const char *
vol_icon(const char *arg)
{
	const char *perc_str;
	unsigned long vol;
	int is_muted = 0;
	const char *icon;
//	char *p;

	if (!(perc_str = vol_perc(arg)))
		return NULL;

	// Handle possible mute marker like "󰝟 Off" or custom mute output
	if (strstr(perc_str, "Off") || strstr(perc_str, "󰝟 ") || atoi(perc_str) == 0) {
		is_muted = 1;
		vol = 0;
	} else {
		vol = strtoul(perc_str, NULL, 10);
	}

	if (is_muted) {
		icon = "󰝟 "; // Muted
	} else if (vol == 0) {
		icon = "󰕿"; // 0%
	} else if (vol <= 20) {
		icon = ""; // 1–20%
	} else if (vol <= 40) {
		icon = "󰖀"; // 21–40%
	} else if (vol <= 60) {
		icon = "󰕾"; // 41–60%
	} else if (vol <= 90) {
		icon = " "; // 61–90%
	} else {
		icon = "󰝝"; // 91–100%
	}

	return bprintf("%s %lu%%", icon, vol);
}


#if defined(__OpenBSD__) || defined(__FreeBSD__)
#include <poll.h>
#include <sndio.h>
#include <stdlib.h>
#include <sys/queue.h>

struct control {
    LIST_ENTRY(control) next;
    unsigned int addr;
#define CTRL_NONE 0
#define CTRL_LEVEL 1
#define CTRL_MUTE 2
    unsigned int type;
    unsigned int maxval;
    unsigned int val;
};

static LIST_HEAD(, control) controls = LIST_HEAD_INITIALIZER(controls);
static struct pollfd *pfds;
static struct sioctl_hdl *hdl;
static int initialized;

static void
ondesc(void *unused, struct sioctl_desc *desc, int val)
{
    struct control *c, *ctmp;
    unsigned int type = CTRL_NONE;

    if (desc == NULL)
        return;

    LIST_FOREACH_SAFE(c, &controls, next, ctmp) {
        if (desc->addr == c->addr) {
            LIST_REMOVE(c, next);
            free(c);
            break;
        }
    }

    if (desc->group[0] != 0 || strcmp(desc->node0.name, "output") != 0)
        return;
    if (desc->type == SIOCTL_NUM && strcmp(desc->func, "level") == 0)
        type = CTRL_LEVEL;
    else if (desc->type == SIOCTL_SW && strcmp(desc->func, "mute") == 0)
        type = CTRL_MUTE;
    else
        return;

    c = malloc(sizeof(struct control));
    if (c == NULL) {
        warn("sndio: failed to allocate audio control\n");
        return;
    }

    c->addr = desc->addr;
    c->type = type;
    c->maxval = desc->maxval;
    c->val = val;
    LIST_INSERT_HEAD(&controls, c, next);
}

static void
onval(void *unused, unsigned int addr, unsigned int val)
{
    struct control *c;

    LIST_FOREACH(c, &controls, next) {
        if (c->addr == addr)
            break;
    }
    c->val = val;
}

static void
cleanup(void)
{
    struct control *c;

    if (hdl) {
        sioctl_close(hdl);
        hdl = NULL;
    }

    free(pfds);
    pfds = NULL;

    while (!LIST_EMPTY(&controls)) {
        c = LIST_FIRST(&controls);
        LIST_REMOVE(c, next);
        free(c);
    }
}

static int
init(void)
{
    hdl = sioctl_open(SIO_DEVANY, SIOCTL_READ, 0);
    if (hdl == NULL) {
        warn("sndio: cannot open device");
        goto failed;
    }

    if (!sioctl_ondesc(hdl, ondesc, NULL)) {
        warn("sndio: cannot set control description call-back");
        goto failed;
    }

    if (!sioctl_onval(hdl, onval, NULL)) {
        warn("sndio: cannot set control values call-back");
        goto failed;
    }

    pfds = calloc(sioctl_nfds(hdl), sizeof(struct pollfd));
    if (pfds == NULL) {
        warn("sndio: cannot allocate pollfd structures");
        goto failed;
    }

    return 1;
failed:
    cleanup();
    return 0;
}

const char *
vol_perc(const char *unused)
{
    struct control *c;
    int n, v, value;

    if (!initialized)
        initialized = init();

    if (hdl == NULL)
        return NULL;

    n = sioctl_pollfd(hdl, pfds, POLLIN);
    if (n > 0) {
        n = poll(pfds, n, 0);
        if (n > 0) {
            if (sioctl_revents(hdl, pfds) & POLLHUP) {
                warn("sndio: disconnected");
                cleanup();
                initialized = 0;
                return NULL;
            }
        }
    }

    value = 100;
    LIST_FOREACH(c, &controls, next) {
        if (c->type == CTRL_MUTE && c->val == 1)
            value = 0;
        else if (c->type == CTRL_LEVEL) {
            v = (c->val * 100 + c->maxval / 2) / c->maxval;
            if (v < value)
                value = v;
        }
    }

    return bprintf("%d", value);
}

#else
#include <sys/soundcard.h>

const char *
vol_perc(const char *card)
{
    // PipeWire support when called with ""
    if (card && card[0] == '\0') {
        FILE *fp;
        char buf[128];
        float volume = 0.0;

        fp = popen("wpctl get-volume @DEFAULT_AUDIO_SINK@", "r");
        if (!fp)
            return NULL;

        if (fgets(buf, sizeof(buf), fp) != NULL) {
            char *volstr = strstr(buf, "Volume:");
            if (volstr)
                volume = atof(volstr + 7);
        }
        pclose(fp);

        int perc = (int)(volume * 100);
        return bprintf("%d", perc);
    }

    // Fallback: OSS/ALSA
    size_t i;
    int v, afd, devmask;
    char *vnames[] = SOUND_DEVICE_NAMES;

    if ((afd = open(card, O_RDONLY | O_NONBLOCK)) < 0) {
        warn("open '%s':", card);
        return NULL;
    }

    if (ioctl(afd, (int)SOUND_MIXER_READ_DEVMASK, &devmask) < 0) {
        warn("ioctl 'SOUND_MIXER_READ_DEVMASK':");
        close(afd);
        return NULL;
    }

    for (i = 0; i < LEN(vnames); i++) {
        if (devmask & (1 << i) && !strcmp("vol", vnames[i])) {
            if (ioctl(afd, MIXER_READ(i), &v) < 0) {
                warn("ioctl 'MIXER_READ(%ld)':", i);
                close(afd);
                return NULL;
            }
        }
    }

    close(afd);
    return bprintf("%d", v & 0xff);
}
#endif
