class dodai_quantum_server::dodai_quantum_server::install {
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
    enabled       => true,
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
    enabled       => false,
    bridge_uplinks   => [],
    bridge_mappings  => [],
    enable_tunneling => $ovs_enable_tunneling,
    local_ip         => $ovs_local_ip,
    firewall_driver  => $firewall_driver,
  }    
}
