#!/bin/bash

#TODO: move yamls to deployment_scripts/roles/ and read all yamls in dir
declare -a roles=(gamma-lcp-dbng gamma-lcp-nova)

DEBUG=true
DIR=`dirname ${BASH_SOURCE[0]}`
FUEL='/usr/bin/fuel'
#FIXME: rels are dynamic and will be different on upgraded Fuel node
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
  #FIXME: parse rels from fuel rel (and optionally grep -i ubuntu)
  #This will break if you try to apply to an upgraded env
  for role in ${roles[@]}; do
     #FIXME: if/else is safer in rpm script because of -e bash mode
     $FUEL role --rel $REL | grep -q $role && \
     $FUEL role --rel $REL --update --file ${DIR}/${role}.yaml || \
     $FUEL role --rel $REL --create --file ${DIR}/${role}.yaml
     debug $role
  done
}

create_roles
#FIXME: needs to to /etc/puppet/$FUEL_REL/modules because /etc/pup/mod is symlink
cp -a ${DIR}/gamma-lcp /etc/puppet/modules/osnailyfacter/modular/
#FIXME: just sync tasks for current release
$FUEL  rel --sync-deployment-tasks --dir /etc/puppet/

