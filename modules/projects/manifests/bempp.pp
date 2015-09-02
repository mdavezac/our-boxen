# Creates sopt project
class projects::bempp($python = 3) {
  require homebrew
  require lmod
  require lmod::config
  require julia
  require julia::config
  $proj = 'bempp'
  $julia = true

  lmod::project { $proj:
    repository => "${proj}/${proj}",
    python     => $python
  }
  misc::ctags {"${lmod::config::workspaces}/${proj}/src/${proj}":
    require => Lmod::Project[$proj]
  }
  julia::virtualenv {"${proj}::julia":
    directory => "${lmod::config::workspaces}/${proj}",
  }
  julia::package {"RudeOil":
    repo       => 'https://github.com/UCL/RudeOil.jl.git',
    virtualenv => "${lmod::config::workspaces}/${proj}",
    require    => Julia::VirtualEnv["${proj}::julia"]
  }
  julia::package {"DebbyPacker":
    repo       => 'https://github.com/UCL/DebbyPacker.jl.git',
    virtualenv => "${lmod::config::workspaces}/${proj}",
    require    => Julia::VirtualEnv["${proj}::julia"]
  }
  repository { "${lmod::config::workspaces}/${proj}/src/packaging":
    source => "${proj}/packaging"
  }
  homebrew::tap { 'bempp/homebrew-bempp': }
  package { [
    'dune-common', 'dune-foamgrid', 'dune-geometry', 'dune-grid',
    'dune-localfunctions']:
    require => Homebrew::Tap['bempp/homebrew-bempp']
  }
  misc::pip {'bempp mako':
    prefix  => "${lmod::config::workspaces}/bempp/",
    package => 'mako'
  }
  if ! defined(Package['gcc']) { package { 'gcc': } }
  Package['gcc'] -> Lmod::Project[$proj]

  if ! defined(Package['boost']) { package { 'boost': } }
  Package['boost'] -> Lmod::Project[$proj]

  if ! defined(Package['doxygen']) { package { 'doxygen': } }
  Package['doxygen'] -> Lmod::Project[$proj]

  if ! defined(Package['eigen']) { package { 'eigen': } }
  Package['eigen'] -> Lmod::Project[$proj]

  if ! defined(Package['docker']) { package { 'docker': } }
  Package['docker'] -> Lmod::Project[$proj]

  if ! defined(Package['docker-machine']) { package { 'docker-machine': } }
  Package['docker-machine'] -> Lmod::Project[$proj]

  if ! defined(Package['boot2docker']) { package { 'boot2docker': } }
  Package['boot2docker'] -> Lmod::Project[$proj]
}
