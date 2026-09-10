source ~/lobocv/mysetup/load_aliases.sh

export PATH="$HOME/go/bin:$PATH"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/calvinlobo/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

alias cc="claude"
# macOS ships python3 but no bare `python`; alias it so `python` just works.
alias python="python3"
# Use bat (syntax-highlighted, paged) in place of less for viewing files.
alias less="bat"
alias gm="git checkout master && git pull"
alias gmm="git fetch origin && git merge origin/master"
alias snowball="cd /Users/calvinlobo/snowball/"

# Load secrets from Infisical into the environment, if it is set up.
# See RESTORE.md for how to log in and add secrets. The guards keep the
# shell quiet and fast when Infisical is not configured yet.
if command -v infisical >/dev/null 2>&1 && [ -f "$HOME/.infisical.json" ]; then
	eval "$(infisical export --format=dotenv-export 2>/dev/null)"
fi

# pnpm
export PNPM_HOME="/Users/calvinlobo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Created by `pipx`
export PATH="$PATH:/Users/calvinlobo/.local/bin"

# Prefer Homebrew binaries. Fixes node resolving to a stale /usr/local
# installer copy instead of brew's current node.
export PATH="/opt/homebrew/bin:$PATH"

# grc: colorize the output of common commands (df, du, ping, ps, netstat, ...).
[ -f /opt/homebrew/etc/grc.zsh ] && source /opt/homebrew/etc/grc.zsh

# zoxide: a smarter cd that learns your most-used directories. --cmd cd makes
# `cd` a superset (normal paths work as always; a bare keyword jumps to the
# best remembered match). `cdi` is the interactive picker.
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"

# fzf: fuzzy finder. `fzf --zsh` sets up the key bindings and completion:
#   Ctrl-R  fuzzy-search command history (replaces the default reverse search)
#   Ctrl-T  insert a fuzzy-picked file path onto the command line
#   Alt-C   cd into a fuzzy-picked subdirectory
# To keep the default Ctrl-R instead, add: bindkey '^R' history-incremental-search-backward
if command -v fzf >/dev/null 2>&1; then
	# Back fzf with fd: fast, and respects .gitignore.
	export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
	eval "$(fzf --zsh)"
fi

# Run an editor on an fzf-picked file when called with no arguments; pass
# arguments straight through otherwise. So bare `vi` opens the picker, while
# `vi file.txt` behaves exactly as normal.
vi() {
	if [ $# -eq 0 ]; then
		local file
		file=$(fzf) || return
		command vim "$file"
	else
		command vim "$@"
	fi
}
