class dodai_glance::dodai_glance::install {
  class { 'openstack::glance':
    verbose          => $verbose,
    db_type          => $db_type,
    db_host          => $db_host,
    keystone_host    => $keystone_host,
    db_user          => $glance_db_user,
    db_name          => $glance_db_dbname,
    db_password      => $glance_db_password,
    user_password    => $glance_user_password,
    backend          => $glance_backend,
    swift_store_user => $swift_store_user,
    swift_store_key  => $swift_store_key,
    enabled          => $enabled,
  }

  file {
    "/root/mycirros.img":
    source => "puppet:///modules/dodai_glance/mycirros.img";
    notify  => Exec['create_image'],
  }

  exec { 'create_image':
    command     => 'source /root/openrc; glance image-create --is-public true --disk-format qcow2 --container-format bare --name "Cirros" < /root/mycirros.img',
    refreshonly => true,
  }
}
