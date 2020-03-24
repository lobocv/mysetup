
function finddeployment() {
  local deployments
	local SEARCH=$1
	if [[ -z "${SEARCH}" ]]; then
		deployments=( `kubectl get deployments -o custom-columns=NAME:.metadata.name| sort`)
	else
		deployments=( `kubectl get deployments -o custom-columns=NAME:.metadata.name| grep ${SEARCH}` )
	fi
	num=${#deployments}
	if [[ $num -gt 1 ]]; then
		echo "More than one live deployments found for grep \"${SEARCH}\". Choose a deployment from below:"
		lc=1
		for x in $deployments;
		do
			echo $lc. $x
			lc=$((lc+1))
	       	done
		read c
		deployment=$deployments[$(($c))]
	else
		deployment=$deployments[1]
	fi
}

# List the Kubernetes deployments
# $1: deployment regex
# $2: Number of replicas
function kdeps() {
	local SEARCH=$1
  if [[ -z "${SEARCH}" ]]; then
		kubectl get deployments| sort
	else
		kubectl get deployments | grep ${SEARCH}
	fi
}

# List the Kubernetes deployments
# $1: deployment regex
# $2: Number of replicas
function kpods() {
	local SEARCH=$1
  if [[ -z "${SEARCH}" ]]; then
		kubectl get pods| sort
	else
		kubectl get pods | grep ${SEARCH}
	fi
}

# Scale the Kubernetes deployment
# $1: deployment regex
# $2: Number of replicas
function kscaledep() {
  if [[ -z "$2" ]]; then
    echo "Second argument should be the number of replicas"
    return 1
  fi
  finddeployment $1
  echo "Are you sure you want to scale this deployment? [n]/y \ndeployment/$deployment => $2"
	read cont
	_confirm_yesno "$cont" && kubectl scale --replicas=$2 deployment/$deployment
}