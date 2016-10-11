# Class: scollector::windows
# Installs and configures for Windows specific Scollector
#
class scollector::windows {

  file {
    'install-dir':
      ensure => directory,
      path   => $::scollector::install_path;

    'collector-dir':
      ensure  => directory,
      path    => "${::scollector::config_path}/${::scollector::external_collector}",
      require => File['install-dir'];

    'collector-freq-dir':
      ensure  => directory,
      path    => "${::scollector::config_path}/${::scollector::external_collector}/${::external_collector_freq}",
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
  }
}
