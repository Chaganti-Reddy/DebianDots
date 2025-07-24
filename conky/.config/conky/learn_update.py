import os
import re

LEARN_FILE = os.path.expanduser("/mnt/Karna/Git/Project-K/learn.md")
CACHE_FILE = os.path.expanduser("~/.cache/learn_current.txt")

PRIORITY_ORDER = {
    "*": 1,
    "**": 2,
    "***": 3,
    "****": 4,
    "*****": 5  # CodeGreen
}

PRIORITY_COLORS = {
    "*": "red",
    "**": "orange",
    "***": "blue",
    "****": "yellow",
    "*****": "grey"
}

def color(text, color_name):
    return f"${{color {color_name}}}{text}${{color}}"

with open(LEARN_FILE, 'r') as f:
    lines = f.readlines()

current_year = None
current_priority = None
current_sections = {}
section = None

# Pass 1: Parse structure
for i, line in enumerate(lines):
    stripped = line.strip()

    # Year header
    if re.match(r'^#\s+\d{4}\s+Learning\s+Goals', stripped):
        current_year = stripped.split()[1]
        continue

    # Priority line
    m = re.match(r'^(\*+)\s+(Code\w+)', stripped)
    if m:
        current_priority = m.group(1)
        continue

    # Section header
    if stripped.startswith("## "):
        section = stripped
        if current_priority:
            current_sections[section] = {
                "priority": current_priority,
                "line": i,
                "tasks": [],
                "done": True
            }
        continue

    # Tasks
    m = re.match(r'^[-*]\s+\[( |x)\]\s+(.*)', stripped)
    if m and section:
        done = m.group(1) == "x"
        task_line = lines[i]
        current_sections[section]["tasks"].append((task_line, done))
        if not done:
            current_sections[section]["done"] = False

# Pass 2: Auto-adjust CodeGreen / revert if needed
new_lines = lines.copy()
for section, data in current_sections.items():
    section_line = data["line"]
    prio_line = section_line - 1

    if 0 <= prio_line < len(new_lines):
        prio_line_text = new_lines[prio_line].strip()

        # Revert from CodeGreen if new tasks added
        if prio_line_text.startswith("***** CodeGreen") and not data["done"]:
            m = re.search(r'<!--was:(\*+\s+Code\w+)-->', prio_line_text)
            if m:
                original_priority = m.group(1)
                new_lines[prio_line] = original_priority + "\n"
            else:
                new_lines[prio_line] = "** CodeOrange\n"
        elif prio_line_text.startswith("***** CodeGreen"):
            # Already CodeGreen – do nothing
            pass
        elif re.match(r'^(\*+)\s+Code\w+', prio_line_text) and data["done"]:
            # Add CodeGreen with original as comment
            if '<!--was:' not in prio_line_text:
                new_lines[prio_line] = f"***** CodeGreen <!--was:{prio_line_text}-->\n"
            else:
                new_lines[prio_line] = "***** CodeGreen\n"

# Update learn.md
with open(LEARN_FILE, 'w') as f:
    f.writelines(new_lines)

# Pass 3: Find top-most pending priority
pending_priorities = {}
for section, data in current_sections.items():
    prio = data["priority"]
    if not data["done"]:
        level = PRIORITY_ORDER.get(prio, 99)
        pending_priorities.setdefault(level, []).append(section)

# Pass 4: Output Conky-compatible view
with open(CACHE_FILE, 'w') as f:
    if pending_priorities:
        top = min(pending_priorities.keys())
        f.write(f"\n{current_year} Learning Goals:\n")

        for section in pending_priorities[top]:
            prio_stars = current_sections[section]["priority"]
            prio_color = PRIORITY_COLORS.get(prio_stars, "white")
            heading_clean = section.strip("#").strip()
            heading = f"--- {heading_clean} ---"
            f.write(color(heading, prio_color) + "\n")

            for task_line, done in current_sections[section]["tasks"]:
                task = task_line.strip().lstrip("-* ").replace("[x]", "").replace("[ ]", "").strip()
                status = "C" if done else "P"
                status_color = "red" if done else "green"
                f.write(f"{task:<40} - {color(status, status_color)}\n")

            f.write("\n")
    else:
        f.write(color(f"\nNo goals for {current_year} yet!", "green") + "\n")

