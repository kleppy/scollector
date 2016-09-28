# Class: scollector::redhat
# Installs and configures for RedHat specific Scollector
#
class scollector::redhat {

  $init_file = $::operatingsystemmajrelease ? {
    /^6/ => 'scollector',
    /^7/ => 'scollector.service',
  }

  $init_path = $::operatingsystemmajrelease ? {
    /^6/ => '/etc/init.d',
    /^7/ => '/etc/systemd/system',
  }

  wget::fetch { 'download-scollector':
    source      => $::scollector::download_url,
    destination => "${::scollector::install_path}/scollector",
    require     => File['install-dir'],
  }

  file {
    'install-dir':
      ensure => directory,
      path   => $::scollector::install_path,
      owner  => root,
      group  => root,
      mode   => '0755',
      purge  => true;

    'scollector-binary':
      ensure  => file,
      path    => "${::scollector::install_path}/scollector",
      owner   => root,
      group   => root,
      mode    => '0755',
      require => Wget::Fetch['download-scollector'];

    'config-dir':
      ensure => directory,
      path   => $::scollector::config_path,
      owner  => root,
      group  => root,
      mode   => '0755',
      purge  => true;

    'scollector-config':
      ensure  => file,
      path    => "${::scollector::config_path}/scollector.toml",
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('scollector/redhat.toml.erb'),
      notify  => Service['scollector'],
      require => File['install-dir'];

    'scollector-init':
      ensure => file,
      path   => "${init_path}/${init_file}",
      owner  => root,
      group  => root,
      mode   => '0755',
      source => "puppet:///modules/scollector/init_scripts/${init_file}";
  }

  service { 'scollector':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => [ File['scollector-init'],
                    File['scollector-binary'],
                  ],
    require    => [ File['scollector-binary'],
                    File['scollector-init'],
                  ],
  }
}
