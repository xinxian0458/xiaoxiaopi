class dodai_cinder_controller::dodai_cinder_controller::install {
    class { 'openstack::cinder::controller':
      bind_host          => $cinder_bind_address,
      sql_idle_timeout   => $sql_idle_timeout,
      keystone_auth_host => $keystone_host,
      keystone_password  => $cinder_user_password,
      rabbit_userid      => $rabbit_user,
      rabbit_password    => $rabbit_password,
      rabbit_host        => $rabbit_host,
      rabbit_hosts       => false,
      db_password        => $cinder_db_password,
      db_dbname          => $cinder_db_dbname,
      db_user            => $cinder_db_user,
      db_type            => $db_type,
      db_host            => $db_host,
      api_enabled        => $enabled,
      scheduler_enabled  => $enabled,
      debug              => $debug,
      verbose            => $verbose
    }
}
