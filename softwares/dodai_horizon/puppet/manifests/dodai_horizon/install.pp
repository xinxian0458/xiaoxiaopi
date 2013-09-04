class dodai_horizon::dodai_horizon::install {
    class { 'openstack::horizon':
      secret_key        => $secret_key,
      cache_server_ip   => $cache_server_ip,
      cache_server_port => $cache_server_port,
      horizon_app_links => $horizon_app_links,
    }
}
