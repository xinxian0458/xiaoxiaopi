#!/bin/bash

if [ ! -e "/etc/puppet/modules/openstack/manifests/init.pp" ]; then
	echo "class openstack{}" >> /etc/puppet/modules/openstack/manifests/init.pp
	chmod 744 /etc/puppet/modules/openstack/manifests/init.pp
fi
