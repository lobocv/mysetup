local ALIAS_DIR="${${(%):-%x}:A:h}/aliases"

function load_aliases() {
	local f
	
	for f in "$ALIAS_DIR"/*.sh; do
		if [[ ${f:t} == _* ]]; then
			continue
		fi
	        source "$f"
	done
}

load_aliases
