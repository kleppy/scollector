# Class: scollector::redhat
# Installs and configures for RedHat specific Scollector
#
class scollector::redhat {

  file { 'install-dir':
    ensure => directory,
    path   => $::scollector::install_path,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  wget::fetch { 'download-scollector':
    source      => $::scollector::download_url,
    destination => "${::scollector::install_path}/${::scollector::binary}",
    require     => File['install-dir'],
  }

  file { 'scollector-binary':
    ensure  => file,
    path    => "${::scollector::install_path}/${::scollector::binary}",
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Wget::Fetch['download-scollector'],
  }

  file { 'config-dir':
    ensure => directory,
    path   => $::scollector::config_path,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { 'scollector-config':
    ensure  => file,
    path    => "${::scollector::install_path}/scollector.toml",
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template("scollector/redhat.toml.erb"),
    notify  => Service['scollector'],
    require => File['install-dir'],
  }
}
