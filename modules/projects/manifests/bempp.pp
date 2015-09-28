# Creates sopt project
class projects::bempp($python = 3) {
  require homebrew
  require lmod
  require lmod::config
  require julia
  require julia::config
  $project = 'bempp'
  $julia = true

  lmod::project { $project:
    repository => "${project}/${project}",
    python     => $python,
  }
  misc::ctags {"${lmod::config::workspaces}/${project}/src/${project}":
    require => Lmod::Project[$project]
  }
  julia::virtualenv {$project: }
  julia::package {"RudeOil":
    repo       => 'https://github.com/UCL/RudeOil.jl.git',
    virtualenv => "${lmod::config::workspaces}/${project}",
    require    => Julia::VirtualEnv[$project]
  }
  julia::package {"DebbyPacker":
    repo       => 'https://github.com/UCL/DebbyPacker.jl.git',
    virtualenv => "${lmod::config::workspaces}/${project}",
    require    => Julia::VirtualEnv[$project]
  }
  lmod::project{ "${project}-packaging":
    repository    => "${project}/packaging",
    source_dir    => "${lmod::config::workspaces}/${project}/src/packaging",
    julia         => true,
    julia_pkg_dir => "${lmod::config::workspaces}/${project}/.julia",
    autodir       => "${lmod::config::workspaces}/${project}/src/packaging",
  }
  homebrew::tap { 'bempp/homebrew-bempp': }
  package { [
    'dune-common', 'dune-foamgrid', 'dune-geometry', 'dune-grid',
    'dune-localfunctions']:
    require => Homebrew::Tap['bempp/homebrew-bempp']
  }
  misc::pip {
    "${project} mako":
      prefix  => "${lmod::config::workspaces}/${project}/",
      package => 'mako',
      require => Lmod::Project[$project];
    "${project} cython":
      prefix  => "${lmod::config::workspaces}/${project}/",
      package => 'cython',
      require => Lmod::Project[$project];
    "${project} pytest":
      prefix  => "${lmod::config::workspaces}/${project}/",
      package => 'pytest',
      require => Lmod::Project[$project];
  }
  lmod::ensure_package{[
    'gcc', 'boost', 'doxygen', 'eigen', 'docker', 'docker-machine',
    'boot2docker', 'tbb']:
    project => $project
  }
  lmod::ensure_package{'gpgtools':
    project  => $project,
    provider => 'brewcask'
  }

  $repodir = "${lmod::config::workspaces}/${project}/src/${project}"
  file { "${lmod::config::workspaces}/${project}/.vimrc":
    ensure  => file,
    content => template("projects/${project}/vimrc.erb"),
    require => Lmod::Project[$project]
  }
  file { "${lmod::config::workspaces}/${project}/.cppconfig":
    ensure  => file,
    content => template("projects/${project}/cppconfig.erb"),
    require => Lmod::Project[$project],
  }
}
