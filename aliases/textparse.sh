# Formats stdin to pretty JSON
alias jsonp="python -m json.tool"

alias stripnl="tr -d '\r' | tr -d '\n'"

# Replace words with another
# $1: Word or regex to replace
# $2: Replacement word
function replace() {
        sed -r "s|$1|$2|g"
}

# Find and replace all occurrences of a phrase in a directory
# $1: Word to look for
# $2: Word to replace
# $3: Directory to search (Default: .)
function textreplace() {
	lookfor=$1
	replacewith=$2
	searchdir=${3:-.}
	files=(`textsearch "${lookfor}" "${searchdir}" | cut -f 1 -d ":"`)
	for f in $files;
	do
		sed -i "s|"${lookfor}"|"${replacewith}"|g" "$f"
	done

}

# Select a specific line from input stream
# $1: Line number to select
# Example:  cat /etc/group | linesel 2
function linesel() {
	LINE=$1
	if [ -z "$1" ]; then
		return
	fi
	ln=1
	while read TEXT;
	do
		if [[ $ln = $LINE ]]; then
			echo $TEXT
			return
		fi
		ln=$((ln+1))
	done

}
