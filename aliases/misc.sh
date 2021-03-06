# This is a collection of aliases that I find helpful

########### NAVIGATION ###########
# Go to previous dir
alias cdc="cd -"

# Go up one dir
alias cx="cd .."

# Go up two dir
alias cxx="cd ../.."

alias dl="cd ~/Downloads"

########### RC FILE #############
alias zshrc="vi ~/.zshrc"
alias zshrcl="source ~/.zshrc"


########### TOOLS ###############

# Open a file of URL in the default application
alias dopen="xdg-open"

# Echo the return code of the last command
alias rc="echo \$?"

# Retry a command repeatedly until it exits with status code 0
function retry() {
	ec="1"
	count=0
	cmd=${@:1}
	out=$(mktemp /tmp/retry.XXXXXX)
	while : ; do
		eval $cmd 2> "$out"
		ec="$?"
		result=$(cat "$out")
		# Only echo output if it is different
		if [[ "$result" != "$prev_result" ]]; then
			echo $result
		fi
		if [[ "$ec" = "0" ]]; then
			break
		fi
		echo -n "."
		sleep 5
		prev_result=$result
	done
}

# Get the default application for a file.
# $1: Filepath
function defaultapp() {
	MIMETYPE=$(xdg-mime query filetype "$1")
	DESKTOP_FILE_ID=$(xdg-mime query default "$MIMETYPE")
	if [[ ! -z "$DESKTOP_FILE_ID" ]]; then
		DESKTOP_FILE=$(find "/usr/share/applications" -name "$DESKTOP_FILE_ID")
		APP=$(cat "$DESKTOP_FILE" | grep "TryExec=\|Exec=" | cut -d "=" -f 2 | cut -d " " -f 1)
		echo $(which $APP)
	else
		echo "Failed to find default application for mime-type: $MIMETYPE"
		return 1
	fi
}
