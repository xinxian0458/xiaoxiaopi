class dodai_keystone::dodai_keystone::install {
  class { 'openstack::keystone':
    verbose               => $verbose,
    db_type               => $db_type,
    db_host               => $db_host,
    db_password           => $keystone_db_password,
    db_name               => $keystone_db_dbname,
    db_user               => $keystone_db_user,
    admin_token           => $keystone_admin_token,
    admin_tenant          => $keystone_admin_tenant,
    admin_email           => $admin_email,
    admin_password        => $admin_password,
    public_address        => $public_address,
    internal_address      => $internal_address_real,
    admin_address         => $admin_address_real,
    region                => $region,
    glance_user_password  => $glance_user_password,
    nova_user_password    => $nova_user_password,
    cinder                => $cinder,
    cinder_user_password  => $cinder_user_password,
    quantum               => $quantum,
    quantum_user_password => $quantum_user_password,
    enabled               => $enabled,
    bind_host             => $keystone_bind_address,
  }

  class { 'openstack::auth_file':
    admin_password       => $admin_password,
    keystone_admin_token => $keystone_admin_token,
    controller_node      => '127.0.0.1',
  }

  keystone_tenant { $demo_tenant:
    ensure      => present,
    enabled     => true,
    description => 'demo tenant',
  }
  keystone_user { $demo_user:
    ensure      => present,
    enabled     => true,
    tenant      => $demo_tenant,
    email       => $demo_email,
    password    => $demo_password,
  }

  keystone_user_role { "${demo_user}@${demo_tenant}":
    roles  => 'Member',
    ensure => present,
  }
}
