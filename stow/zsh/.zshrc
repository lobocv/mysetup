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
