# Commands for keeping this setup repo in sync. Run `just` to list them.

# List available commands.
default:
	@just --list

# Symlink all dotfiles into $HOME (safe to re-run; --restow refreshes links).
apply:
	for pkg in stow/*/; do \
		stow --dir=stow --target="$HOME" --restow "$(basename "$pkg")"; \
	done

# Re-dump the Brewfile to capture newly installed / removed apps.
dump:
	brew bundle dump --force --file=Brewfile

# Capture current app list, then commit and push everything that changed.
save message="chore: sync setup":
	just dump
	git add -A
	git commit -m "{{message}}"
	git push
