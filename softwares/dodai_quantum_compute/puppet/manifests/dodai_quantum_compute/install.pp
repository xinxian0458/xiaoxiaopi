class dodai_quantum_compute::dodai_quantum_compute::install {
  
  include quantum

  Service['quantum-plugin-ovs-service']<||> ~> exec{ 'ip link set br-int up': } ~> exec{ 'ip link set br-tun up': }

  class { '::quantum':
    enabled             => true,
    core_plugin         => $core_plugin,
    bind_host           => $bind_address,
    rabbit_host         => $rabbit_host,
    rabbit_hosts        => false,
    rabbit_virtual_host => $rabbit_virtual_host,
    rabbit_user         => $rabbit_user,
    rabbit_password     => $rabbit_password,
    verbose             => $verbose,
    debug               => $debug,
  }

  class { 'quantum::server':
    enabled       => false,
    auth_host     => $keystone_host,
    auth_password => $keystone_password,
  }

  class { 'quantum::plugins::ovs':
    sql_connection      => $sql_connection,
    sql_idle_timeout    => $sql_idle_timeout,
    tenant_network_type => $tenant_network_type,
    network_vlan_ranges => undef,
  }  

  class { 'quantum::agents::ovs':
    bridge_uplinks   => [],
    bridge_mappings  => [],
    enable_tunneling => $ovs_enable_tunneling,
    local_ip         => $ovs_local_ip,
    firewall_driver  => $firewall_driver,
  }

  class { 'nova::compute::quantum':
    libvirt_vif_driver => $libvirt_vif_driver,
    notify             => Exec['restart_nova_compute'],
  }

  # Configures nova.conf entries applicable to Quantum.
  class { 'nova::network::quantum':
    quantum_admin_password    => $quantum_user_password,
    quantum_auth_strategy     => 'keystone',
    quantum_url               => "http://${quantum_host}:9696",
    quantum_admin_username    => $quantum_admin_user,
    quantum_admin_tenant_name => $quantum_admin_tenant_name,
    quantum_admin_auth_url    => "http://${keystone_host}:35357/v2.0",
    notify                    => Exec['restart_nova_compute'],
  }

  exec { 'restart_nova_compute':
      command     => "service nova-compute restart",
      refreshonly => true,
  }

}
