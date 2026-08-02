<div style="display: flex; justify-content:center"><p align="center">
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg" width="30" alt="Nix Logo" style="margin: 5px 5px 0 0">
</p>
<h1 align="center">hypr-nix-dots</h1>
</div>
<p align="center">
  NixOS + Hyprland, built with flakes and Home Manager. Sweet-Mars theme
  family, wallust-driven dynamic color palette, blur and transparency
  throughout.
</p>

## Bootstrap

```bash
curl -fsSL https://raw.githubusercontent.com/0xhealer/hypr-nix-dots/main/bootstrap.sh | bash
```

The script enables flakes, clones this repo to `~/.local/share/hypr-nix-dots`,
copies your hardware config in, and runs `nixos-rebuild switch --flake .#nixos`.
Safe to re-run.

**Before your first successful build:** `home/style/gtk.nix` builds three
theme packages (Sweet-Mars, Sweet-cursors, Sweet-folders) straight from
their upstream GitHub repos, and the placeholder hashes in there are fake
on purpose — Nix will refuse to build and print the real hash in the error.
Copy it in (three times, once per derivation) and re-run the script.

## The stack

| Purpose | Package / Module |
|---|---|
| Compositor | Hyprland (`wayland.windowManager.hyprland`) |
| Status bar | Waybar |
| App launcher | Rofi (wayland fork) |
| Notifications | Dunst |
| Terminal | Kitty |
| File manager | Thunar |
| Lock screen | hyprlock |
| Idle daemon | hypridle |
| Logout/power menu | wlogout |
| Wallpaper daemon | swww |
| GUI wallpaper picker | Waypaper |
| Central color palette | **wallust** — regenerates Waybar/Kitty/Rofi/Dunst/Hyprland colors from whatever wallpaper you pick |
| GTK theme | Sweet-Mars |
| Icons | candy-icons + Sweet-folders (Mars) |
| Cursor | Sweet-cursors |
| Qt theming | qt5ct / qt6ct |
| Screenshots | grim + slurp + swappy |
| Clipboard | cliphist + wl-clipboard |
| Display manager | SDDM |

Plus the general dev/productivity layer this repo already had: fish shell,
starship, neovim, VS Code, git/lazygit, fastfetch, zoxide/fzf/bat/eza, mpv,
Docker, Tailscale.

## Color theming — how it actually works

Waypaper's `post_command` (see `home/desktop/tools.nix`) runs `wallust run`
on whatever wallpaper you pick. wallust reads the templates in
`home/style/wallust.nix` and rewrites:

- `~/.config/waybar/colors.css`
- `~/.config/kitty/colors.conf`
- `~/.config/rofi/colors.rasi`
- `~/.config/dunst/dunstrc`
- `~/.config/hypr/colors.conf`

These five files are deliberately **not** managed via home-manager's
`xdg.configFile` (which would make them read-only symlinks wallust couldn't
overwrite). Instead, an activation script seeds them once — with your exact
supplied palette — the first time you run `home-manager switch` /
`nixos-rebuild switch`, and wallust owns them from then on. Re-running the
rebuild never clobbers whatever wallust has generated since.

Dunst is deliberately launched via Hyprland's `exec-once` rather than
home-manager's `services.dunst`, for the same reason — its config needs to
stay writable by wallust. If Dunst's colors look stale after a wallpaper
change, restart it (`killall dunst; dunst &`, or re-login).

## Blur & transparency

Set in `home/desktop/hyprland.nix`:
- `blur.size = 8`, `blur.passes = 4`, `new_optimizations = true`
- `active_opacity = 0.92`, `inactive_opacity = 0.85`
- Per-app overrides via `windowrulev2` (Kitty and Thunar get their own
  opacity levels)
- Kitty additionally uses `background_opacity = 0.85` with
  `dynamic_background_opacity` on

## Keybinds

| Key | Action |
|---|---|
| `Super + Return` | Terminal (Kitty) |
| `Super + Q` | Close focused window |
| `Super + E` | File manager (Thunar) |
| `Super + R` | App launcher (Rofi) |
| `Super + V` | Clipboard history |
| `Super + L` | Lock screen (hyprlock) |
| `Super + Shift + Q` | Power menu (wlogout) |
| `Print` | Screenshot region → editor (swappy) |
| `Super + 1-4` | Switch workspace |
| `Super + Shift + 1-4` | Move window to workspace |
| `Super + drag (LMB/RMB)` | Move / resize window |

## Layout

```
flake.nix                     — nixpkgs, home-manager, vscode-extensions inputs
bootstrap.sh                  — one-shot installer
hosts/nixos/default.nix       — host entry point, user account
modules/                      — system-level NixOS config
  display.nix                 — SDDM, programs.hyprland, polkit agent
  audio.nix / network.nix / system.nix / services.nix / virtualisation.nix
home/
  default.nix                 — home-manager entry point
  packages.nix                — general-purpose home.packages
  desktop/
    hyprland.nix               — the compositor config itself
    hyprlock.nix / hypridle.nix / wlogout.nix
    waybar.nix / rofi.nix / dunst.nix
    shell.nix                  — imports rofi.nix + dunst.nix
    tools.nix                  — cliphist, swappy, waypaper config.ini
  style/
    wallust.nix                 — wallust config + templates + seeding activation script
    gtk.nix                     — Sweet-Mars theme, candy-icons, Sweet-folders, Sweet-cursors
  apps/                        — terminal tools, editor, git, vscode, media, shell, fastfetch, etc.
```
