# Fedeya Dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/) in **symlink mode**: regular files in `~` are symlinks into this repo, so editing `~/.config/nvim/...` edits the repo directly; just commit. Templates, private and executable files are still copied.

> There is also a [mise](https://mise.jdx.dev/dotfiles.html) version of these dotfiles in the [`mise`](https://github.com/fedeya/dotfiles/tree/mise) branch. Use one or the other on a machine, not both.

## Installation

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply fedeya
```

`init` asks whether it's a work machine (adds work apps), then:

- `run_onchange_before_10-packages.sh`: Homebrew + `brew bundle` from [`.chezmoidata/packages.yaml`](.chezmoidata/packages.yaml), then `mise install`
- applies the dotfiles and externals (tpm, herdr-sesh)
- `run_onchange_after_20-macos-defaults.sh`: key repeat, Dock, Finder
- `run_onchange_after_30-setup.sh`: opencode/pi deps, herdr integration + plugins, worktrunk plugin, tmux plugins

## Day to day

```bash
chezmoi status            # anything out of sync?
chezmoi add ~/.config/foo # start managing a new file
chezmoi apply             # after pulling or editing packages.yaml
```

New files created inside a managed directory are not picked up automatically: `chezmoi add` them.

## Machine-specific config (not versioned)

- `~/.zshrc.local`: sourced at the end of `.zshrc`
- OpenCode work config: an `opencode.json` in the parent folder of the work projects (OpenCode merges every `opencode.json` from `/` down to the project)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
