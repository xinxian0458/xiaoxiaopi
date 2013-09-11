class dodai_quantum_network::dodai_quantum_network::setup_external_network (
  $external_bridge_name,
  $external_bridge_interface
) {
	  file { '/root/setup_external_network.sh':
    	owner   => 'root',
    	group   => 'root',
    	mode    => '0755',
    	content => template("${module_name}/setup_external_network.erb"),
    	notify  => Exec['setup_external_network'],
  	}

  	exec { 'setup_external_network':
    	command     => '/root/setup_external_network.sh',
  	}
}