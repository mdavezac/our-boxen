# creates a project
define lmod::project(
  $name,
  $repository,
  $python = false,
  $directory = undef,
) {
  require lmod::config

  if $directory { $workspace = $directory }
  else { $workspace = "${lmod::config::workspaces}/${name}" }

  $source_dir = "${workspace}/src/${name}"
  repository { $source_dir:
    source  => $repository,
  }
  if($python) {
    exec { "virtualenv_${name}":
      creates => "${workspace}/bin/python",
      command => "python -m virtualenv ${workspace}",
    } -> misc::pip {
      "${name}-ipython['all']":
        ensure  => present,
        prefix  => $workspace,
        package => 'ipython[\'all\']';
      "${name}-numpy":
        ensure  => present,
        prefix  => $workspace,
        package => 'numpy';
      "${name}-scipy":
        ensure  => present,
        prefix  => $workspace,
        package => 'scipy';
      "${name}-matplotlib":
        ensure  => present,
        prefix  => $workspace,
        package => 'matplotlib';
    }
  }
  file { 'lmodfile $name':
    path    => "${lmod::config::lmodfiles}/${name}.lua",
    content => template('lmod/project.lua.erb')
  }
}
