# Commands for keeping this setup repo in sync. Run `just` to list them.

# List available commands.
default:
	@just --list

# Repair links and apply dotfiles, backing up conflicting files.
apply:
	python3 apply.py

# Re-dump the Brewfile to capture newly installed / removed apps.
dump:
	brew bundle dump --force --file=Brewfile

# Capture current app list, then commit and push everything that changed.
save message="chore: sync setup":
	just dump
	git add -A
	git commit -m "{{message}}"
	git push
