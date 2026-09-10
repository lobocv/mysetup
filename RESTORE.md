# Restoring a fresh machine

The steps below rebuild this Mac from scratch. Run them in order.

## 1. Clone this repo

```sh
mkdir -p ~/projects
git clone git@github.com:lobocv/mysetup.git ~/projects/mysetup
```

(If SSH is not set up yet, clone over HTTPS for now and fix the remote later.)

## 2. Run the bootstrap

```sh
cd ~/projects/mysetup
./bootstrap.sh
```

This installs Homebrew, reinstalls every app in the `Brewfile`, and symlinks
all the tracked config files into place. See the README for what each tool
does.

Any checkout location works. If you move it later or only need to fix broken
symlinks, run `python3 apply.py` from the checkout. Existing conflicting configs
are backed up under `~/.mysetup-backup-*`; app runtime state is preserved.

## 3. Restore secrets and credentials

None of these live in the repo (on purpose). Do them by hand:

- **Infisical (shell secrets):**
  ```sh
  infisical login          # log in to your account
  cd ~ && infisical init   # creates ~/.infisical.json (safe, no secrets in it)
  ```
  The `.zshrc` picks up secrets automatically on the next shell once
  `~/.infisical.json` exists. Add or edit secrets with
  `infisical secrets set NAME=value` (or in the Infisical web dashboard).

- **GitHub CLI:** `gh auth login`

- **SSH keys:** restore `~/.ssh` from your password manager / backup, or
  generate a new key with `ssh-keygen` and add it to GitHub.

- **Claude Code:** run `claude` and log in.

- **Codex:** run `codex` and log in.
