# == Class: icinga2::config
#
# Manages the config environment of Icinga 2.
#
class icinga2::config {
  validate_bool($::icinga2::default_features)

  File {
    owner => $::icinga2::config_owner,
    group => $::icinga2::config_group,
    mode  => $::icinga2::config_mode,
  }

  # maintained directories
  file {
    [
      '/etc/icinga2',
      '/etc/icinga2/pki',
      '/etc/icinga2/scripts',
      '/etc/icinga2/features-available',
    ]:
      ensure => directory,
  }

  # TODO: temporary until we provide some default templates
  file {
    [
      '/etc/icinga2/conf.d',
    ]:
      ensure  => directory,
      purge   => $::icinga2::purge_confd,
      recurse => $::icinga2::purge_confd,
      force   => $::icinga2::purge_confd,
  }

  file {
    [
      '/etc/icinga2/features-enabled',
      '/etc/icinga2/repository.d',
      '/etc/icinga2/zones.d',
    ]:
      ensure  => directory,
      purge   => $::icinga2::purge_configs,
      recurse => $::icinga2::purge_configs,
      force   => $::icinga2::purge_configs,
  }

  file { '/etc/icinga2/icinga2.conf':
    ensure  => file,
    content => template($::icinga2::config_template),
  }

  # maintained object directories
  file {
    [
      '/etc/icinga2/repository.d/hosts',
      '/etc/icinga2/repository.d/hostgroups',
      '/etc/icinga2/repository.d/services',
      '/etc/icinga2/repository.d/servicegroups',
      '/etc/icinga2/repository.d/users',
      '/etc/icinga2/repository.d/usergroups',
      '/etc/icinga2/repository.d/checkcommands',
      '/etc/icinga2/repository.d/notificationcommands',
      '/etc/icinga2/repository.d/eventcommands',
      '/etc/icinga2/repository.d/notifications',
      '/etc/icinga2/repository.d/timeperiods',
      '/etc/icinga2/repository.d/scheduleddowntimes',
      '/etc/icinga2/repository.d/dependencies',
      '/etc/icinga2/repository.d/perfdatawriters',
      '/etc/icinga2/repository.d/graphitewriters',
      '/etc/icinga2/repository.d/idomysqlconnections',
      '/etc/icinga2/repository.d/idopgsqlconnections',
      '/etc/icinga2/repository.d/livestatuslisteners',
      '/etc/icinga2/repository.d/statusdatawriters',
      '/etc/icinga2/repository.d/applys',
      '/etc/icinga2/repository.d/templates',
      '/etc/icinga2/repository.d/constants',
    ]:
      ensure  => directory,
      purge   => $::icinga2::purge_configs,
      recurse => $::icinga2::purge_configs,
      force   => $::icinga2::purge_configs,
  }

  file { '/etc/icinga2/zones.conf':
    ensure  => file,
    content => template('icinga2/zones.conf.erb'),
  }

  if $::icinga2::default_features {
    include ::icinga2::feature::checker
    include ::icinga2::feature::notification
    include ::icinga2::feature::mainlog
  }

}
