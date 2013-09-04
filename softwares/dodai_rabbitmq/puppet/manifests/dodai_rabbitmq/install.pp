class dodai_rabbitmq::dodai_rabbitmq::install {
  class { 'rabbitmq::server':
    service_ensure    => 'running',
    port              => $port,
    delete_guest_user => false,
    notify			  => Exec['change_admin_password'],
  }

  exec { 'change_admin_password':
    command     => "rabbitmqctl change_password guest $rabbit_password",
    refreshonly => true,
  }
}
