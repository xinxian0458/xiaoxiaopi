class dodai_nova_controller::dodai_nova_controller::install {
  class { 'openstack::nova::controller':
    # Database
    db_host                 => $db_host,
    public_address          => $public_address,
    # Quantum
    quantum                 => $quantum,
    quantum_user_password   => $quantum_user_password,
    metadata_shared_secret  => $metadata_shared_secret,
    # Nova
    nova_admin_tenant_name  => $nova_admin_tenant_name,
    nova_admin_user         => $nova_admin_user,
    nova_user_password      => $nova_user_password,
    nova_db_password        => $nova_db_password,
    nova_db_user            => $nova_db_user,
    nova_db_dbname          => $nova_db_dbname,
    enabled_apis            => $enabled_apis,
    # Rabbit
    rabbit_user             => $rabbit_user,
    rabbit_password         => $rabbit_password,
    rabbit_virtual_host     => $rabbit_virtual_host,
    # Glance
    glance_api_servers      => $glance_api_servers_real,
    # VNC
    vnc_enabled             => $vnc_enabled,
    vncproxy_host           => $vncproxy_host_real,
    # General
    verbose                 => $verbose,
    enabled                 => $enabled,
  }
}
