# Define: scollector::collector
# Installs external collectors for RedHat and Windows
#
# Parameters
# ----------
#
# [*ensure*]
#  Enforce whether or not the external collector should be present
#
# [*freq*]
#  The frequency in which the external collector should send data.
#
define scollector::collector (
  $ensure = present,
  $freq   = undef,
){

  validate_re($ensure, '^(present)|(absent)$')

  if $freq.is_a(Integer) {
    $real_freq = "${freq}"
  }else {
    $real_freq = $freq
  }

  $collector_os    = downcase($::osfamily)
  $collector_path  = "${::scollector::collector_dir}/${real_freq}"
  $collector_source = "collectors/${collector_os}"

  unless $real_freq in $::scollector::collector_feq_dir {
    fail('The desired frequency is not valid.')
  }else {

    file { "collector-${name}":
      ensure  => file,
      path    => "${collector_path}/${name}",
      owner   => root,
      group   => root,
      mode    => '0755',
      require => File[$scollector::collector_freq_dir],
      source  => "puppet:///modules/scollector/${collector_source}/${name}",
    }
  }
}
