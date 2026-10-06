# Fedeya Dotfiles

My personal dotfiles, managed with [mise](https://mise.jdx.dev/dotfiles.html) (`[dotfiles]` + `mise bootstrap`).

- `home/` mirrors `$HOME`. Each path listed in [`home/.config/mise/config.toml`](home/.config/mise/config.toml) is symlinked into place, so editing `~/.config/nvim/...` edits this repo; just commit.
- The same config declares Homebrew packages, macOS defaults, repos and a setup task ([`bootstrap/setup.sh`](bootstrap/setup.sh)).
- `linux/` holds Linux-only configs.

## New machine

```bash
curl -fsSL https://raw.githubusercontent.com/fedeya/dotfiles/mise/bootstrap/install.sh | bash
```

It installs mise, clones this repo to `~/dotfiles`, links the global mise config and runs `mise bootstrap`. If an app already created its own config, replace it with `mise bootstrap --force-dotfiles`.

## Day to day

```bash
mise dot status              # everything linked?
mise dot add ~/.config/foo   # start managing a new file/dir (moves it here, links it back)
mise bootstrap --dry-run     # preview packages/defaults/dotfiles changes
mise bootstrap
```

## Machine-specific config (not versioned)

- `~/.config/mise/config.local.toml`: extra packages/tools for this machine (e.g. work apps)
- `~/.zshrc.local`: sourced at the end of `.zshrc`
- OpenCode work config: an `opencode.json` in the parent folder of the work projects (OpenCode merges every `opencode.json` from `/` down to the project)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
