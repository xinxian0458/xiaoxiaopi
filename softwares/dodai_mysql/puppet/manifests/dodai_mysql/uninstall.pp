class dodai_mysql::dodai_mysql::uninstall {
  package { [mysql_client, mysql-server]:
    ensure => purged
  }
}
