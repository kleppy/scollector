# Class: scollector
# ===========================
#
# This module will manage the installation and configuration of the Scollector
# agent for both the Windows and Linux operating systems.
#
# Parameters
# ----------
#
# [*version*]
#   The version of Scollector for Puppet to install.
#
# [*host*]
#   The host that Scollector will be sending metrics to.
#
# [*port*]
#   The port that the remote host will accept the metrics on.
#
# [*user*]
#   The user to connect to the remote host with.
#
# [*password*]
#   The password for the user account used to connect.
#
# [*freq*]
#   The frequency in which to send metrics.
#
# [*full_host*]
#   Whether or not to truncate the FQDN to just the hostname.
#
# [*proto*]
#  The protocol to connect to the remote host with.
#
# [*processes*]
#   What processes Scollector should collect metrics for.
#
# Examples
# --------
#
#  class { 'scollector':
#    versio    => '0.5.0',
#    host      => 'metrics.advisory.com',
#    port      => '8099',
#    user      => 'foo',
#    password  => 'bar',
#    freq      => 60,
#    full_host => true,
#    proto     => 'https'
#    process   => { java => { name    => 'java_name',
#                             command => 'java_cmd',
#                             args    => 'java_args',
#                           }
#                 }
#  }
#
# Authors
# -------
#
# Christopher Pisano <pisanoc@advisory.com>
#
# Copyright
# ---------
#
# Copyright 2016
#
class scollector (
  $version    = undef,
  $host       = undef,
  $port       = undef,
  $user       = undef,
  $password   = undef,
  $freq       = undef,
  $full_host  = undef,
  $proto      = undef,
  $processes  = undef,
) {

  validate_re($version, '^\d+\.\d+\.\d+$')
  validate_integer($freq)
  validate_hash($processes)
  validate_bool($full_host)
  validate_string($host)
  validate_re($port, '(^\d{4}$)')
  validate_string($user)
  validate_string($password)
  validate_re($proto, ['^http$', '^https$'], 'Valid protocols are http or https')
  validate_array($processes)

  if ('64' in $::architecture) {
    $real_arch   = 'amd64'
  } else {
    fail("${::architecture} is not a supported architecture")
  }

  case downcase($::kernel) {
    'linux': {
      $os           = 'linux'
      $ext          = undef
      $install_path = '/usr/local/scollector'
      $config_path  = '/etc/scollector'
    }
    'windows': {
      $os           = 'windows'
      $ext          = '.exe'
      $install_path = 'C:/Program Files/scollector'
      $config_path  = $install_path
    }
    default: {
      fail("${::kernel} is not a supported kernel")
    }
  }

  $binary = "scollector-${os}-${real_arch}${ext}"
  $download_url = "https://github.com/bosun-monitor/bosun/releases/download/${version}/${binary}"
  $klass = downcase($::osfamily)

  if !defined("::scollector::${klass}") {
    fail("no class for ${::osfamily}")
  }

  contain "::scollector::${klass}"
}
