# scollector

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with scollector](#setup)
    * [What scollector affects](#what-scollector-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with scollector](#beginning-with-scollector)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module will install and confgure the Scollector agent on both Windows and
Linux hosts. It will manage external collectors as well however there is
currently a dependency on the external collector being added to the module as a
static file.

## Setup

### What scollector affects

* Creates a directory structure to install and configure Scollector
* Creates a Scollector service on Windows and places a startup script on Linux

### Setup Requirements

* [cyberious-pget >= 0.1.3](https://github.com/cyberious/puppet-pget)
* [maestrodev-wget >= 1.7.3](https://github.com/maestrodev/puppet-wget)
* [puppetlabs-stdlib >= 4.12.0](https://github.com/puppetlabs/puppetlabs-stdlib)

### Beginning with scollector

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most
basic use of the module.

## Usage

This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference

**Classes**
* [scollector](https://github.com/discreet/scollector/blob/master/manifests/init.pp)
* [redhat](https://github.com/discreet/scollector/blob/master/manifests/redhat.pp)
* [windows](https://github.com/discreet/scollector/blob/master/manifests/windows.pp)

**Defines**
* [collector](https://github.com/discreet/scollector/blob/master/manifests/collector.pp)

**Parameters**

*Version*
The version of Scollector to install on the node

*Host*
The host to have Scollector send metrics to

*Port*
The port for Scollector to use to connect to the host

*User*
The user for Scollector to authenticate with

*Password*
The password for authentication

*Freq*
The frequency in seconds to send metrics

*Freq_Dir*
The directory to deploy external collectors to in relation to how often they
should be sending metrics

*Full_Host*
Whether or not to use the full hostname when sending metrics

*Proto*
The protocol to connect to the host with

*Processes*
The processes Scollector should monitor

## Limitations

* Only written for RHEL 6/7 and Windows 2008R2/2012R2
* Only supports x86_64 and x64 bit architecture

## Development

1. Fork the project
2. Create your feature and fully test it
3. Write your tests
4. Squash your commits
5. Submit a pull request to the upstream

