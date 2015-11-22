# Creates sopt project
class projects::bempp($python = 3) {
  require homebrew
  require lmod
  require lmod::config
  require julia
  require julia::config
  $srcname = 'bempp'
  $project = $python ? {
    2       => "${srcname}-python${python}",
    default => $srcname
  }
  $workspace = "${lmod::config::workspaces}/${project}"
  $repodir = "${lmod::config::workspaces}/${project}/src/${srcname}"
  $julia = true

  lmod::project { $project:
    repository => "${srcname}/${srcname}",
    source_dir => "${workspace}/src/${srcname}",
    directory  => $workspace,
    python     => $python,
  }
  misc::ctags {"${workspace}/src/${srcname}":
    require => Lmod::Project[$project]
  }
  julia::virtualenv {$project: }
  julia::package {"RudeOil":
    repo       => 'https://github.com/UCL/RudeOil.jl.git',
    virtualenv => "${workspace}",
    require    => Julia::VirtualEnv[$project]
  }
  julia::package {"DebbyPacker":
    repo       => 'https://github.com/UCL/DebbyPacker.jl.git',
    virtualenv => "${workspace}",
    require    => Julia::VirtualEnv[$project]
  }
  lmod::project{ "${project}-packaging":
    repository    => "${srcname}/packaging",
    source_dir    => "${workspace}/src/packaging",
    julia         => true,
    julia_pkg_dir => "${workspace}/.julia",
    autodir       => "${workspace}/src/packaging",
  }
  homebrew::tap { 'bempp/homebrew-bempp': }
  package { [
    'dune-common', 'dune-foamgrid', 'dune-geometry', 'dune-grid',
    'dune-localfunctions']:
    require => Homebrew::Tap['bempp/homebrew-bempp']
  }
  misc::pip {
    "${project} mako":
      prefix  => $workspace,
      package => 'mako',
      require => Lmod::Project[$project];
    "${project} cython":
      prefix  => $workspace,
      package => 'cython',
      require => Lmod::Project[$project];
    "${project} pytest":
      prefix  => $workspace,
      package => 'pytest',
      require => Lmod::Project[$project];
    "${project} numpy":
      prefix  => $workspace,
      package => 'numpy',
      require => Lmod::Project[$project];
  }
  lmod::ensure_package{[
    'doxygen', 'eigen', 'docker', 'docker-machine',
    'boot2docker', 'tbb']:
    project => $project
  }
  lmod::ensure_package{
    'gpgtools':
      project  => $project,
      provider => 'brewcask';
    'boost':
      install_options => ['--c++11'],
      project         => $project;
  }

  file { "${workspace}/.vimrc":
    ensure  => file,
    content => template("projects/${srcname}/vimrc.erb"),
    require => Lmod::Project[$project]
  }
  file { "${workspace}/.cppconfig":
    ensure  => file,
    content => template("projects/${srcname}/cppconfig.erb"),
    require => Lmod::Project[$project],
  }
}
