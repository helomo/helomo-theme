# dotfiles

Personal system configuration for an Arch Linux + Hyprland setup, managed with
[GNU Stow](https://www.gnu.org/software/stow/). The real files live in this repo;
each is symlinked into place under `$HOME`.

## Layout

Each top-level directory is a **stow package** whose contents mirror the path
relative to `$HOME`:

| Package       | Symlinks into                     |
|---------------|-----------------------------------|
| `bash`        | `~/.bashrc`, `~/.bash_profile`    |
| `hypr`        | `~/.config/hypr/`                 |
| `kitty`       | `~/.config/kitty/`                |
| `neofetch`    | `~/.config/neofetch/`             |
| `waybar`      | `~/.config/waybar/`               |
| `wofi`        | `~/.config/wofi/`                 |
| `ascii`       | `~/ASCII/`                        |
| `helomotheme` | `~/helomoTheme/`                  |

## Bootstrap on a new machine

```sh
sudo pacman -S stow          # if not already installed
git clone https://github.com/helomo/helomo-theme.git ~/dotfiles
cd ~/dotfiles
stow */                      # or list packages: stow bash hypr kitty ...
```

Stow's default target is the parent directory (`~`), so run it from `~/dotfiles`.

## Usage

```sh
cd ~/dotfiles
stow <package>      # create symlinks for a package
stow -D <package>   # remove symlinks (unstow)
stow -R <package>   # restow (remove + recreate)
stow -nv <package>  # dry-run, show what would happen
```

Edit any config through its normal path (e.g. `~/.bashrc`) — you're editing the
versioned file via its symlink. Commit changes from `~/dotfiles`.
