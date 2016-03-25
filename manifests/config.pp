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
  $homebrewdir = undef,
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
    $homebrewdir,
    $repodir,
    $srcdir,
    $login,
    $repo_url_template,
    $download_url_base,
  )

  # file { [ $home,
  #         $envdir,
  #       ]:
  #   ensure => directory,
  #   links  => follow
  # }

  file { "${home}/env.sh":
    content => template('boxen/env.sh.erb'),
    mode    => '0755',
  }

  group { 'puppet':
    ensure => present
  }

  $puppet_data_dirs = [
    "${home}/data/puppet",
    "${home}/data/puppet/graphs"
  ]

  file { $puppet_data_dirs:
    ensure => directory,
    owner  => $::boxen_user
  }

  include boxen::security
  include boxen::sudoers

  $relative_bin_on_path_ensure = $relative_bin_on_path ? {
    true    => present,
    default => absent,
  }

  boxen::env_script {
    'relative_bin_on_path':
      ensure   => $relative_bin_on_path_ensure,
      source   => 'puppet:///modules/boxen/relative_bin_on_path.sh',
      priority => 'lowest' ;
  }
}
