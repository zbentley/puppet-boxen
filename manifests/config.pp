# Public: Set up necessary Boxen configuration
#
# Usage:
#
#   include boxen::config

class boxen::config (
  $home = undef,
  $bindir = undef,
  $cachedir = undef,
  $configdir = undef,
  $datadir = undef,
  $envdir = undef,
  $login = undef,
  $hiera_merge_hierarchy = undef
) {

  validate_string(
    $home,
    $bindir,
    $cachedir,
    $configdir,
    $datadir,
    $envdir,
    $repodir,
    $srcdir,
    $login,
    $repo_url_template,
    $download_url_base,
  )

  file { [ $home,
           $bindir,
          # $logdir,
           $cachedir,
           $configdir,
           $datadir,
           $envdir,
          "${home}/puppet",
          "${home}/data/puppet",
          "${home}/data/puppet/graphs",
        ]:
    ensure => directory,
    links  => follow,
    owner  => $::boxen_user,
  }

  file { "${home}/env.sh":
    content => template('boxen/env.sh.erb'),
    mode    => '0755',
  }

  group { 'puppet':
    ensure => present
  }

  include boxen::security
  include boxen::sudoers

  boxen::env_script {
    'relative_bin_on_path':
      ensure   => present,
      source   => 'puppet:///modules/boxen/relative_bin_on_path.sh',
      priority => 'lowest' ;
  }
}
