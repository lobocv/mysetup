# mysetup

My macOS setup, captured so I can wipe a machine and rebuild it exactly. It
tracks two things: the list of apps I use, and the config files that make them
behave the way I like. A single bootstrap script turns a blank Mac back into my
machine.

## Rebuilding a machine

```sh
git clone git@github.com:lobocv/mysetup.git ~/lobocv/mysetup
~/lobocv/mysetup/bootstrap.sh
```

Then follow [RESTORE.md](RESTORE.md) for the credential steps (logins, SSH,
Infisical) that can't live in a repo.

## How it works

Three tools do the heavy lifting. If you have not seen them before, here is
what each one is for.

### Homebrew + the Brewfile (installing apps)

[Homebrew](https://brew.sh) is the package manager for macOS. It installs
command-line tools (`git`, `just`, `go`) and desktop apps (Warp, Cursor) alike.

A `Brewfile` is just a list of everything Homebrew should install, written down
in one file. `brew bundle dump` writes your currently-installed apps into it,
and `brew bundle` reads it back to reinstall all of them on a fresh machine. It
is the modern version of a "here's every app I use" checklist, except it runs
itself.

The `Brewfile` captures brew formulae, casks (GUI apps), VS Code extensions,
and even Go / npm / uv globals.

### GNU Stow (placing config files)

Every app reads its settings from a specific file in your home directory, for
example Warp reads `~/.warp/settings.toml`. We want the real copy of that file
to live in this repo (so it is version-controlled and backed up), but the app
still needs to find it at its usual path.

[Stow](https://www.gnu.org/software/stow/) solves this with symlinks. The repo
holds the real files under `stow/`, laid out to mirror your home directory:

```
stow/
├── warp/.warp/settings.toml      ->  ~/.warp/settings.toml
├── zsh/.zshrc                     ->  ~/.zshrc
├── git/.gitconfig                 ->  ~/.gitconfig
└── ...
```

Running `stow warp` creates a symlink at `~/.warp/settings.toml` that points
back to the file in the repo. The app sees a normal file; edits flow straight
through to the repo. Each top-level folder under `stow/` is a "package" you can
link independently.

### Infisical (secrets)

Config files are safe to commit, but secrets (API keys, tokens) are not. If
they were tracked here they would leak the moment the repo was pushed.

[Infisical](https://infisical.com) is a secret manager: your secrets live in
its cloud, not in any file on disk. The `.zshrc` in this repo asks Infisical
for them at shell startup and loads them into the environment:

```sh
eval "$(infisical export --format=dotenv-export)"
```

So nothing secret is ever written to this repo. On a new machine you run
`infisical login` once (see RESTORE.md) and your secrets are back. To add a
secret, use `infisical secrets set NAME=value` or the Infisical dashboard, not
a file here.

## Keeping it up to date

Because the config files are symlinked into this repo, changing a setting in an
app edits the repo file directly. There is no copy step. The only routine is to
commit and push periodically.

The one thing that does not update itself is the `Brewfile`: it is a snapshot,
so re-dump it whenever you install or remove an app. The `just save` command
does the whole thing in one shot:

```sh
just save                       # re-dump Brewfile, commit, push
just save "add zed config"      # ...with a custom commit message
```

Other commands ([just](https://github.com/casey/just) is a simple command
runner; run `just` to list them):

- `just apply` — (re)create all the symlinks
- `just dump` — refresh the `Brewfile` only

Secrets need no syncing here; they already live in Infisical.

## What is tracked

- `Brewfile` — every app, CLI, cask, and extension
- `stow/` — config for zsh, git, Warp, Zed, Claude, Codex
- `aliases/`, `load_aliases.sh`, `lobocv.zsh-theme` — shell aliases and prompt
- `bootstrap.sh`, `Justfile`, `RESTORE.md` — the rebuild machinery

Deliberately **not** tracked: the large runtime state under `~/.claude` and
`~/.codex` (chat history, caches, logs, plugin installs), and anything secret.
