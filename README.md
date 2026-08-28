# OmaCleaner

A small TUI for **selectively removing the preinstalled applications** that ship
with [Omarchy](https://omarchy.org/).

Omarchy's stock `omarchy-remove-preinstalls` is an *all-or-nothing* switch — it
wipes every preinstalled web app, TUI, optional package, and AI/mise stub in one
go. OmaCleaner gives you the same operations in a space-to-toggle checklist so
you can keep exactly what you want and drop precisely the rest.

## Features

- **Auto-discovery** — scans what is actually installed rather than assuming:
  - **Web apps** (Discord, WhatsApp, Zoom, Basecamp, …) from `~/.local/share/applications`
  - **TUIs** (Disk Usage, Docker, …) from the same launcher directory
  - **Removable packages** (`libreoffice-fresh`, `obsidian`, `kdenlive`, `obs-studio`, `moonlight-qt`, `pinta`, `xournalpp`, `aether`, `cliamp`, `lazydocker`, `omacut`, `omacalc`, `omawrite`) — but *only* the ones currently installed
  - **AI / mise stubs** (`claude`, `gh`, `opencode`, `grok`, `copilot`, `pi`, `grok`, …) — again, only if present
- **Space-to-toggle checklist** with a filter, built on [`gum`](https://github.com/charmbracelet/gum) (already bundled with Omarchy — no new dependencies).
- **Confirm-before-you-commit** — shows a summary and asks for confirmation before removing anything.
- **Uses the stock Omarchy commands** under the hood (`omarchy-webapp-remove`, `omarchy-tui-remove`, `omarchy-pkg-drop`) so notifications, icon cleanup, and the desktop database stay correct.
- **Does not flip the global `preinstalls-removed` opt-out flag** — the stock all-or-nothing tool keeps working for you unchanged.
- **Installable as an app** — ships a desktop launcher + icon so you can run it from your app launcher (multiple times — no single-instance lock), plus `--install` / `--uninstall` commands.

## Requirements

- [Omarchy](https://omarchy.org/) (or any system with the Omarchy `omarchy-*` CLI + `gum` + `pacman`)
- `gum` (bundled with Omarchy; also installable via `sudo pacman -S gum`)

## Install

### As a command

```bash
git clone https://github.com/Deoxizn/omacleaner.git
cd omacleaner
./omacleaner --install     # copies binary to ~/.local/bin, adds launcher + icon
```

Or manually, just the binary:

```bash
install -Dm755 omacleaner ~/.local/bin/omacleaner
```

### App launcher (desktop entry)

`--install` creates `~/.local/share/applications/omacleaner.desktop` with the bundled
mop icon and `Terminal=true`, so it shows up in your app launcher (SUPER + SPACE).
You can launch it as many times as you like — every run opens a fresh checklist.

To undo:

```bash
omacleaner --uninstall     # removes launcher, icon, and ~/.local/bin copy
```

`--uninstall` is also available as a desktop action, so you can right-click the
OmaCleaner entry in your launcher and pick "Uninstall" there too.

## How the listing works

OmaCleaner scans three places and merges the result into a single checklist:

1. `~/.local/share/applications/*.desktop` — anything whose `Exec=` uses an
   Omarchy web-app launcher (`omarchy-launch-webapp` / `omarchy-webapp-handler`)
   or an Omarchy TUI launcher (`xdg-terminal-exec --app-id=TUI.*`).
2. `pacman -Qq` — which of the known removable packages are actually installed.
3. `~/.local/bin` — which of the known AI/mise stubs are actually present.

Only these three sources are shown, so the list always matches the machine you're
on: no phantom entries for things that were already removed, and no omissions for
web apps you added later through `omarchy-webapp-install`.

The checklist is a scrollable list that fills most of your terminal height. The
count in the header — `N items` — tells you how much is there; if every item
doesn't fit on screen, keep pressing **↓** and the list scrolls (the footer shows
the keybinds). It has no fixed "pages" like `1/3`; it's one continuous, filterable
list.

## Usage

```bash
omacleaner
```

1. Browse the checklist: **↓/↑** to move, **/** to filter.
2. Press **Space** to toggle each item you want removed.
3. Press **Enter** to continue, review the summary, and confirm.
4. Anything tied to packages will prompt for your sudo password.

If you later change your mind, reinstall the stock apps with
`omarchy-install-preinstalls`, and individual web apps / TUIs with
`omarchy-webapp-install` / `omarchy-tui-install`.

## Commands

| Command | What it does |
|---------|--------------|
| `omacleaner` | Open the interactive removal checklist |
| `omacleaner --install` | Install launcher + icon + `~/.local/bin` copy |
| `omacleaner --uninstall` | Remove launcher, icon, and `~/.local/bin` copy |
| `omacleaner --help` | Show usage |

## Safety notes

- Nothing is removed until you confirm the summary.
- Web apps / TUIs are matched with the exact same patterns Omarchy itself uses,
  so user-built launchers that don't follow Omarchy's conventions (for example a
  custom TUI launched from an arbitrary script) are left alone.
- The tool never touches `~/.local/state/omarchy/preinstalls-removed`, so the
  stock all-or-nothing remove (`omarchy-remove-preinstalls`) and restore
  (`omarchy-install-preinstalls`) behavior is preserved.

## License

[MIT](LICENSE)
