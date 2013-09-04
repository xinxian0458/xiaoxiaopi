class dodai_cinder_compute::dodai_cinder_compute::install {
    class { 'openstack::cinder::storage':
      sql_connection      => $cinder_sql_connection,
      rabbit_password     => $rabbit_password,
      rabbit_userid       => $rabbit_user,
      rabbit_host         => $rabbit_host,
      rabbit_virtual_host => $rabbit_virtual_host,
      volume_group        => $volume_group,
      iscsi_ip_address    => $iscsi_ip_address,
      enabled             => $enabled,
      verbose             => $verbose,
      setup_test_volume   => $setup_test_volume,
      volume_driver       => $cinder_volume_driver,
    }

    # set in nova::api
    if ! defined(Nova_config['DEFAULT/volume_api_class']) {
      nova_config { 'DEFAULT/volume_api_class': value => 'nova.volume.cinder.API' }
    }
}
