class dodai_rabbitmq::dodai_rabbitmq::uninstall {
  package { 'rabbitmq-server':
    ensure => purged,
  }
}
