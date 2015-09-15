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
  julia::virtualenv {$proj: }
  julia::package {"RudeOil":
    repo       => 'https://github.com/UCL/RudeOil.jl.git',
    virtualenv => "${lmod::config::workspaces}/${proj}",
    require    => Julia::VirtualEnv[$proj]
  }
  julia::package {"DebbyPacker":
    repo       => 'https://github.com/UCL/DebbyPacker.jl.git',
    virtualenv => "${lmod::config::workspaces}/${proj}",
    require    => Julia::VirtualEnv[$proj]
  }
  lmod::project{ "${proj}-packaging":
    repository    => "${proj}/packaging",
    source_dir    => "${lmod::config::workspaces}/${proj}/src/packaging",
    julia         => true,
    julia_pkg_dir => "${lmod::config::workspaces}/${proj}/.julia",
    autodir       => "${lmod::config::workspaces}/${proj}/src/packaging",
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
  lmod::ensure_package{[
    'gcc', 'boost', 'doxygen', 'eigen', 'docker', 'docker-machine',
    'boot2docker']:
    project => $project
  }
  lmod::ensure_package{'gpgtools':
    project  => $project,
    provider => 'brewcask'
  }
}
