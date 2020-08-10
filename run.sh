#!/usr/bin/env bash

./localbuild.sh || exit $?

local_workdir=$(pwd)
rdfox_license="${local_workdir}/RDFox.lic"

if [[ ! -f "${rdfox_license}" ]] ; then
  echo "ERROR: Could not find RDFox license file: ${rdfox_license}"
  exit 1
fi

docker run \
  --interactive --tty --rm \
  --mount type=bind,source=${rdfox_license},target=/home/ekgprocess/rdfox/RDFox.lic \
  --mount type=bind,source=${local_workdir},target=/home/ekgprocess/workdir \
  --workdir="/home/ekgprocess/workdir" \
  "$(< image.id)" "$@"
exit $?
