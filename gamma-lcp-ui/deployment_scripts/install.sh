#!/bin/bash

declare -a roles=(lcp-gamma-dbng lcp-gamma-nova)

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

function run {

  for role in ${roles[@]}; do
     $FUEL role --rel $REL --create --file ${DIR}/${role}.yaml
     debug $role
  done

  $FUEL  rel --sync-deployment-tasks --dir /etc/puppet/
}



run