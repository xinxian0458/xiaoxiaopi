class dodai_quantum_compute::dodai_quantum_compute::install::setup_bridge (
	$br_names = []
) {
	file { '/root/setup_bridge.sh':
    	owner   => 'root',
    	group   => 'root',
    	mode    => '0755',
    	content => template("${module_name}/setup_bridge.erb"),
    	notify  => Exec['setup_bridge'],
  	}

  	exec { 'setup_bridge':
    	command     => '/root/setup_bridge.sh',
    	refreshonly => true,
  	}
}