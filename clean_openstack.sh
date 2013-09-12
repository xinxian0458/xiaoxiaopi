#!/bin/bash
##########################
# backup dir
##########################
BACKUP_DIR="/root/backup"

prepare_backup(){
	mkdir -p ${BACKUP_DIR}
}

##########################
# clean apt
##########################
clean_apt(){
	mkdir -p ${BACKUP_DIR}/apt
	mv /etc/apt/sources.list.d/* ${BACKUP_DIR}/apt/
	apt-get -y update
}

###########################
# clean ntp
###########################
clean_ntp(){
	service ntp stop
	mv /etc/ntp.conf ${BACKUP_DIR}/
	apt-get purge -y ntp
}

############################
# clean mysql
# HOSTIP=`ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d ":"`
############################
clean_mysql(){
	mkdir -p ${BACKUP_DIR}/mysql
	mv /etc/mysql/* ${BACKUP_DIR}/mysql/
	softwares=`dpkg -l | awk '/mysql/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	rm -rf /var/lib/mysql
	rm -rf /usr/share/mysql
	rm -rf /var/run/mysqld
	rm -rf /var/log/mysql
	rm -rf /root/.my.cnf
}

##############################
# clean rabbitmq
##############################
clean_rabbitmq(){
	service rabbitmq-server stop
	mkdir -p ${BACKUP_DIR}/rabbitmq
	mv /etc/rabbitmq/* ${BACKUP_DIR}/rabbitmq/
	apt-get purge -y rabbitmq-server
	rm -rf /var/lib/rabbitmq/*
}

################################
# clean keystone
################################
clean_keystone(){
	service keystone stop
	mkdir -p ${BACKUP_DIR}/keystone
	mv /etc/keystone/* ${BACKUP_DIR}/keystone/
	softwares=`dpkg -l | awk '/keystone/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	rm -rf /root/openrc
}

##################################
# clean glance
##################################
clean_glance(){
	mkdir -p ${BACKUP_DIR}/glance
	mv /etc/glance/* ${BACKUP_DIR}/glance/
	softwares=`dpkg -l | awk '/glance/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	rm -rf /var/lib/glance/*
	rm -rf /root/mycirros.img
}

####################################
# clean nova
####################################
clean_nova(){
	mkdir -p ${BACKUP_DIR}/nova
	mv /etc/nova/* ${BACKUP_DIR}/nova/
	softwares=`dpkg -l | awk '/nova/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	softwares="nova-compute nova-compute-kvm pm-utils libvirt-bin"
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	softwares=`dpkg -l | awk '/qemu/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	softwares=`dpkg -l | awk '/kvm/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	rm -rf /var/lib/nova/*
	rm -rf /root/setup_bridge.sh
	rm -rf /var/lib/libvirt/qemu/instance-*
	rm -rf /etc/libvirt/qemu/instance-*
}

#####################################
# clean cinder
#####################################
clean_cinder(){
	mkdir -p ${BACKUP_DIR}/cinder
	mv /etc/cinder/* ${BACKUP_DIR}/cinder/
	softwares=`dpkg -l | awk '/cinder/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	softwares="iscsitarget open-iscsi iscsitarget-dkms"
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	rm -rf /var/lib/cinder/*
	pvremove cinder-volumes
	vgremove cinder-volumes
	lodevice=`losetup -a | grep cinder | awk '{print $1}' | cut -f1 -d ":"`
	losetup -d ${lodevice}
}

######################################
# clean quantum
######################################
clean_quantum(){
	mkdir -p ${BACKUP_DIR}/quantum
	mv /etc/quantum/* ${BACKUP_DIR}/quantum/
	softwares=`dpkg -l | awk '/quantum/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	rm -rf /root/create_network.sh
	rm -rf /root/setup_bridge.sh
	rm -rf /root/setup_external_network.sh
}

#######################################
# clean horizon
#######################################
clean_horizon(){
	mkdir -p ${BACKUP_DIR}/dashboard
	mv /etc/openstack-dashboard/* ${BACKUP_DIR}/dashboard/
	softwares="openstack-dashboard openstack-dashboard-ubuntu-theme python-openstack-auth memcached python-memcache"
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	softwares=`dpkg -l | awk '/apache/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
}

#########################################
# clean openvswitch
#########################################
clean_openvswitch(){
	bridges=`ovs-vsctl show | awk '/Bridge/ {print $2}'`
	for bridge in $bridges
	do
		ports=`ovs-vsctl list-ports ${bridge}`
		for port in $ports
		do
			ovs-vsctl del-port ${bridge} ${port}
		done
		ovs-vsctl del-br ${bridge}
	done
	ovs-vsctl del-br int-br-ex
	ovs-vsctl del-br phy-br-ex
	mkdir -p ${BACKUP_DIR}/openvswitch
	mv /etc/openvswitch/* ${BACKUP_DIR}/openvswitch/
	mv /etc/openvswitch-switch/* ${BACKUP_DIR}/openvswitch/
	softwares="openvswitch-datapath-dkms openvswitch-datapath-source openvswitch-brcompat openvswitch-controller openvswitch-switch openvswitch-common openvswitch-pki quantum-plugin-openvswitch-agent quantum-dhcp-agent quantum-l3-agent"
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
	softwares=`dpkg -l | awk '/dnsmasq/ {print $2}'`
	for software in $softwares
	do
		apt-get purge -y ${software}
	done
}

################################################
# kill process
################################################
clean_process(){
	processes="kvm dnsmasq quantum"
	for process in $processes
	do
		ps uax | grep ${process} | grep -v "grep" |awk '{print $2}' | xargs kill -s 9
	done
}

#################################################
# clean network
#################################################
clean_network(){
	sleep 30
	ipnamespaces=`ip netns list`
	for ipnamespace in $ipnamespaces
	do
		ip netns delete ${ipnamespace}
	done
	interfaces=`ifconfig | grep Ethernet | grep -v eth | awk '{print $1}'`
	for interface in $interfaces
	do
		ip link set ${interface} down
		ip link delete ${interface}
	done
}

function clean {
	target=$1
	echo "-----------------Begin to clean $target-----------------------"
	clean_$target
	echo "-----------------Finished---------------------------------------"
	echo ""
}

type=$1
if [ "$type" = "all" ]; then
	clean_apt
	clean_mysql
	clean_rabbitmq
	clean_keystone
	clean_glance
	clean_nova
	clean_cinder
	clean_horizon
	clean_openvswitch
	clean_quantum
	clean_process
	clean_network
else
	clean $type
fi

apt-get -y autoremove
/etc/init.d/networking restart
