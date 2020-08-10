#!/usr/bin/env bash

./localbuild.sh || exit $?

local_workdir="$(pwd)/workdir"
rdfox_license="$(pwd)/RDFox.lic"

if [[ ! -f "${rdfox_license}" ]] ; then
  echo "ERROR: Could not find RDFox license file: ${rdfox_license}"
  exit 1
fi

HOST_PORT=12110
CONT_PORT=12110

docker run \
  --interactive --tty --rm \
  --mount type=bind,source=${rdfox_license},target=/home/ekgprocess/rdfox/RDFox.lic \
  --mount type=bind,source=${local_workdir},target=/home/ekgprocess/workdir \
  --publish ${HOST_PORT}:${CONT_PORT} \
  --workdir="/home/ekgprocess/workdir" \
  "$(< image.id)" $@
exit $?
