# eza: a modern ls with color, git status, and a tree mode (replaces `tree`).
# Icons are left off since they need a Nerd Font installed.
alias ls="eza"
alias ll="eza -la --git"
alias tree="eza --tree"

alias cd-="cd -"
alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias cd....="cd ../../../.."

# Swap two  paths
# $1 : path1
# $2 : path2
function swap() {
        mv "$2" "$2.swaptemp"
        mv "$1" "$2"
        mv "$2.swaptemp" "$1"
}

# Rename file with .bak appended to it. If a file with .bak is already found, it will undo the process
# and remove the .bak
# Example: If a file named test.txt exists.
# The following renamed test.txt to test.txt.bak
# >> bak test.txt
# And the following will renamed test.txt.bak back to test.txt
# >> bak test.txt.bak
# OR
# >> bak test.txt
function bak() {
	file="$1"
	REGEX='.*bak'
	if [[ ${file} =~ '.*bak' ]]; then
		# strip .bak from filename
		renamed="${file%".bak"}"
	elif [[ -f ${file} ]]; then
		# add .bak to filename
		renamed="${file}.bak"
	elif  [[ ! -f ${file} ]] && [[ -f "${file}.bak" ]]; then
		renamed="${file}"
		file="${file}.bak"
	fi
	mv -v -i "${file}" "${renamed}" 1>&2
}

# Compress a directory to .tar.gz
# $1 : Path to directory or file
# $2 : Output filename (Default: $1.tar.gz)
function tardir() {
	DIR="$1"
	OUT="${2:-$1.tar.gz}"
	tar -czf $OUT $DIR
}

# Untar / extract a .tar.gz file
# $1 : Path to .tar.gz
# $2 : Output path (Default: ./)
function untar() {
	TAR="$1"
	OUT="${2:-./}"
	tar -xzf $TAR -C $OUT
}

# List contents of tar file
# $1 : Path to .tar.gz
function tarview() {
	tar -tf "$1"
}
