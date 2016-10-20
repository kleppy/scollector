# Class: scollector::windows
# Installs and configures for Windows specific Scollector
#
class scollector::windows {

  $scollector_path = "${::scollector::install_path}/${::scollector::binary}"

  file {
    'install-dir':
      ensure => directory,
      path   => $::scollector::install_path;

    'collector-dir':
      ensure  => directory,
      path    => "${::scollector::collector_dir}",
      require => File['install-dir'];

    'collector-freq-dir':
      ensure  => directory,
      path    => "${::scollector::collector_freq_dir}",
      require => File['collector-dir'];

    'scollector-config':
      ensure  => file,
      path    => "${::scollector::config_path}/scollector.toml",
      content => template('scollector/windows.toml.erb'),
      notify  => Service['scollector'],
      require => File['install-dir'];
  }

  pget { 'download-scollector':
    source => $::scollector::download_url,
    target => "${::scollector::install_path}/${::scollector::binary}",
    notify => Exec['register-service'],
  }

  exec { 'register-service':
    path        => $scollector_path,
    command     => 'scollector --winsvc install',
    refreshonly => true,
  }

  service { 'scollector':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Exec['register-service'],
  }
}
