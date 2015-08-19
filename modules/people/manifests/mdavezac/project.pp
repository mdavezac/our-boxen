# creates a project
define people::mdavezac::project(
  $name,
  $repository,
  $python = false,
  $directory = "/Users/${::boxen_user}/workspaces/${name}"
) {
  $source_dir = "${directory}/src/${name}"
  repository { $source_dir:
    source => $repository,
  }
  if($python) {
    exec { "virtualenv_${name}":
      creates => "${directory}/bin/python",
      command => "python -m virtualenv ${directory}",
    } -> people::mdavezac::pip {
      "${name}-ipython['all']":
        ensure  => present,
        prefix  => $directory,
        package => 'ipython[\'all\']';
      "${name}-numpy":
        ensure  => present,
        prefix  => $directory,
        package => 'numpy';
      "${name}-scipy":
        ensure  => present,
        prefix  => $directory,
        package => 'scipy';
      "${name}-matplotlib":
        ensure  => present,
        prefix  => $directory,
        package => 'matplotlib';
    }
  }
  file { 'lmodfile $name':
    path    => "/Users/${::boxen_user}/.lmodfiles/${name}.lua",
    content => template('people/mdavezac/lmodfile.erb')
  }
}
