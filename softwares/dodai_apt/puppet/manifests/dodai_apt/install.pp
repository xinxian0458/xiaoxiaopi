class dodai_apt::dodai_apt::install {
  include apt::update
  apt::source { 'ubuntu-cloud-archive':
    location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
    release           => "precise-updates/$version",
    repos             => 'main',
    required_packages => 'ubuntu-cloud-keyring',
  }
}
