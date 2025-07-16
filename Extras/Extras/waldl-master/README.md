# waldl from [waldl](https://github.com/pystardust/waldl)

Browser [wallhaven](https://wallhaven.cc/) using `sxiv`

## Usage
```
waldl <query>
```
> Leave query empty to use `dmenu`

- Select wallpapers by marking them using `m` in `sxiv`.
- Quit `sxiv` using `q`.

Selected images would be downloaded. The default download directory is

	~/dotfiles/Pictures/Pictures/Wallheaven/

which is my custom directory, you can change it before installation in the waldl script.

## Installation
Default installation path is `/usr/local/bin`, to change it edit the `INSTALL_PATH` variable in the Makefile.

To install `waldl` just run:
```
make install
```


To later uninstall `waldl` run:
```
make uninstall
```

## Dependencies

* sxiv
* jq
* curl
* dmenu ( *optional* )


