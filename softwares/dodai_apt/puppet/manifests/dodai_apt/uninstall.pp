class dodai_apt::dodai_apt::uninstall {
    include apt::update
    exec { "clear_sources_list_d":
        command => "sudo rm -rf /etc/apt/sources.list.d/ubuntu-cloud-archive*",
        notify	=> Exec['apt_update'],
    }
}
