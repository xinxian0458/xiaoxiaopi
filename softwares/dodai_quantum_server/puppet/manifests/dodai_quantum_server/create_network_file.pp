class dodai_quantum_server::dodai_quantum_server::create_network_file(
  $tenant_name              = 'demo',
  $tenant_network           = 'demo-net',
  $tenant_subnet            = 'demo-net-subnet',
  $tenant_router            = 'demo-router',
  $fixed_network_range      = '192.168.0.0/24',
  $network_gateway          = '192.168.0.1',
  $public_gateway           = '10.4.0.1',
  $public_network_range     = '10.4.0.0/24',
  $public_address_start     = '10.4.0.200',
  $public_address_end       = '10.4.0.300',
) {

  file { '/root/create_network.sh':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/create_network.erb"),
    notify  => Exec['create_network'],
  }

  exec { 'create_network':
    command     => '/root/create_network.sh',
    refreshonly => true,
  }
}