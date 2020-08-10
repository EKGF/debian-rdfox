#!/bin/bash
#
# Load the example data via curl in to the running server.
#
# Assumptions:
#
# - You are running this on a mac or linux
# - You are running the .run.sh command in another shell
#   - With default port and creds 
# - You have curl installed (brew install curl)
#

host_port=12110
rdfox_server="localhost:${host_port}"
show_curl=0

if ! curl_bin=$(command -v curl) ; then
    echo "ERROR: Install curl"
    exit 1
fi


function log() {
    echo $@ >&2
}

function error() {
    log "ERROR: $@"
}

function curl() {

    if ((show_curl)) ; then
        (
            set -x
            "${curl_bin}" --write-out "HTTP_STATUS=%{http_code}\n" --user admin:admin --silent $@
        )
    else
        "${curl_bin}" --write-out "HTTP_STATUS=%{http_code}\n" --user admin:admin --silent $@
    fi
}

function createDatastore() {

    local datastore="$1"
    local type="${2:-par-complex-nn}"

    log "Creating datastore ${datastore} with type ${type}"

    curl -X POST "${rdfox_server}/datastores/${datastore}?type=${type}"
}

function deleteDatastore() {

    local datastore="$1"

    log "Deleting datastore ${datastore}"

    curl -X DELETE "${rdfox_server}/datastores/${datastore}"
}

function listDatastores() {

    log "List datastores:"

    curl -X GET "${rdfox_server}/datastores" | tail -n +2
}

function loadTurtle() {

    local datastore="$1"
    local turtleFile="$2"

    if [[ ! -f "${turtleFile}" ]] ; then
        error "File ${turtleFile} does not exist"
        return 1
    fi

    log "Load turtle file ${turtleFile} into datastore ${datastore}:"

    #
    # TODO: Check if RDFox understands the difference between PUT and POST
    #    
    curl --upload-file "${turtleFile}" -X POST --url "${rdfox_server}/datastores/${datastore}/content"

}

function listAsTurtle() {

    local datastore="$1"

    log "List content of datastore ${datastore} as turtle:"

    curl --header "Accept: text/turle" -X GET --url "${rdfox_server}/datastores/${datastore}/content"

}

function main() {

    deleteDatastore family || return $?
    createDatastore family || return $?
    listDatastores
    loadTurtle family ./workdir/data.ttl || return $?
    listAsTurtle family

    log "Load was successful"
}

main $@
exit $?
