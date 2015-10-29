# creates a project
define lmod::project(
  $repository = $undef,
  $python = undef,
  $directory = undef,
  $source_dir = undef,
  $template = 'lmod/project.lua.erb',
  $julia = false,
  $julia_pkg_dir = undef,
  $autodir = undef,
  $modlines = []
) {
  require lmod::config

  $workspace = $directory ? {
    undef   => "${lmod::config::workspaces}/${name}",
    default => $directory
  }
  $source_directory = $source_dir ? {
    undef   => "${workspace}/src/${name}",
    default => $source_dir
  }
  $move_here = $autodir ? {
    undef   => $source_directory,
    default => $autodir
  }
  $julia_package_dir = $julia_pkg_dir ? {
    undef   => "$workspace/.julia",
    default => "$julia_pkg_dir/${julia::config::version}"
  }

  if $repository {
    repository { $source_directory:
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
      # "${name}-pyside":
      #   ensure => present,
      #   prefix  => $workspace,
      #   require => Exec["virtualenv_${name}"],
      #   package => 'pyside';
    }
  }

  file { "lmodfile ${name}":
    path    => "${lmod::config::lmodfiles}/${name}.lua",
    content => template($template)
  }
}
