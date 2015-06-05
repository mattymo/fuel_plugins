#!/bin/bash

declare -a roles=(gamma-lcp-dbng gamma-lcp-nova)

DEBUG=true
DIR=`dirname ${BASH_SOURCE[0]}`
FUEL='/usr/bin/fuel'
#Releases:
#CENTOS=1
#UBUNTU=2
REL=2

function debug {
  if $DEBUG; then
    echo $@
  fi
}

function create_roles {
  for role in ${roles[@]}; do
     $FUEL role --rel $REL | grep -q $role && \
     $FUEL role --rel $REL --update --file ${DIR}/${role}.yaml || \
     $FUEL role --rel $REL --create --file ${DIR}/${role}.yaml
     debug $role
  done
}

create_roles
cp -a ${DIR}/gamma-lcp /etc/puppet/modules/osnailyfacter/modular/
$FUEL  rel --sync-deployment-tasks --dir /etc/puppet/

