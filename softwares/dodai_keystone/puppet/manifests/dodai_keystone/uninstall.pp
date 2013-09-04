class dodai_keystone::dodai_keystone::uninstall {
	package {
        [keystone, python-keystone, python-keystoneclient]:
            ensure => purged;
    }

    exec {
        "sudo rm -rf /var/lib/keystone/*":
            require => Package[keystone]
    }
}
