# Class: scollector::windows
# Installs and configures for Windows specific Scollector
#
class scollector::windows {

  file { 'install-dir':
    ensure => directory,
    path   => $::scollector::install_path,
  }

  pget { 'download-scollector':
    source => $::scollector::download_url,
    target => "${::scollector::install_path}/${::scollector::binary}",
  }

  file { 'scollector-config':
    ensure  => file,
    path    => "${::scollector::install_path}/scollector.toml",
    content => template('scollector/windows.toml.erb'),
    notify  => Service['scollector'],
    require => File['install-dir'],
  }
}
