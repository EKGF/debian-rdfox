#!/bin/bash
#
# Launching RDFox as a server
#
echo "Process ID $$"
echo "User ID $(whoami)"

if [[ $$ -ne 1 ]] ; then
  echo "You're not running this script as the root process"
fi

params="daemon"
params+=" port ${PORT:-12110}"
params+=" channel unsecure"
params+=" protocol IPv4"

cat > script.rdfox << __HERE__
dstore create family par-complex-nn
active family
import data.ttl
__HERE__

#
# We use exec here to make sure that RDFox runs with the same process ID
# as this script which is hopefully process ID 1
#
exec /home/ekgprocess/rdfox/RDFox ${params} exec script.rdfox