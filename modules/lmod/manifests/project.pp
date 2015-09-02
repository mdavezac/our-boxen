# creates a project
define lmod::project(
  $repository = $undef,
  $python = undef,
  $directory = undef,
) {
  require lmod::config

  if $directory { $workspace = $directory }
  else { $workspace = "${lmod::config::workspaces}/${name}" }

  $source_dir = "${workspace}/src/${name}"
  if $repository {
    repository { $source_dir:
      source  => $repository,
    }
  }
  if($python) {
    $venv = $python ? {
      2 => 'python -m virtualenv',
      3 => 'python3 -m venv'
    }
    exec { "virtualenv_${name}":
      creates => "${workspace}/bin/python",
      command => "${venv} ${workspace}",
    }
    misc::pip {
      "${name}-ipython['all']":
        ensure  => present,
        prefix  => $workspace,
        require => Exec["virtualenv_${name}"],
        package => 'ipython[\'all\']';
      "${name}-numpy":
        ensure  => present,
        prefix  => $workspace,
        require => Exec["virtualenv_${name}"],
        package => 'numpy';
      "${name}-scipy":
        ensure  => present,
        prefix  => $workspace,
        require => Exec["virtualenv_${name}"],
        package => 'scipy';
      "${name}-matplotlib":
        ensure  => present,
        prefix  => $workspace,
        require => Exec["virtualenv_${name}"],
        package => 'matplotlib';
      "${name}-pyside":
        ensure => present,
        prefix  => $workspace,
        require => Exec["virtualenv_${name}"],
        package => 'pyside';
    }
  }
  file { "lmodfile ${name}":
    path    => "${lmod::config::lmodfiles}/${name}.lua",
    content => template('lmod/project.lua.erb')
  }
}
