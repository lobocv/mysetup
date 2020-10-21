#!/bin/bash

# get the es cluster host from optional flag or environment
function _es_curl() {
  local POSITIONAL=()
  local ES=${ES}
    for i in "$@"; do
        case "$i" in
        -h|--host)
                ES="$2"
                shift
                ;;
        *)
                POSITIONAL+=("$1") # save it in an array for later
                shift
        esac

    done
  	set -- "${POSITIONAL[@]}"

    echo "Calling: curl ${ES}/${1}" > /dev/stderr
    curl "${ES}/${1}"
}

# Call /_cat/indices endpoint
function es_indices() {
  _es_curl "_cat/indices?v" $@
}

# Call /_cat/aliases endpoint
function es_aliases() {
  _es_curl "_cat/aliases?v" $@
}

# Call /<INDEX>/_mapping endpoint
function es_mapping() {
  local INDEX="$1"
  _es_curl "${INDEX}/_mapping" | jq
}
