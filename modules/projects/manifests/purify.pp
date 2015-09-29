# Creates purify project
class projects::purify($python = 3) {
  require lmod
  $project = 'purify'
  $workspace = "${lmod::config::workspaces}/${project}"
  $repodir = "${workspace}/src/${project}"
  lmod::project { $project:
    repository => "astro-informatics/${project}",
    python     => 2,
    modlines   => [
      'set_alias("casapy", "/opt/homebrew-cask/Caskroom/casa/4.4.0-6/CASA.app/Contents/MacOS/casapy")',
    ]
  } -> misc::ctags {"${workspace}/src/${project}": }

  $cmake_options = "-DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${workspace}"
  repository { "${project}-sopt":
    source  => 'astro-informatics/sopt',
    path    => "${workspace}/src/sopt",
    require => [Lmod::Project[$project], Exec["${project}-cookoff-install"]]
  } -> file { "${workspace}/src/sopt/build":
    ensure => directory
  } -> exec { "${project}-sopt-configure":
    command => "checkout development && cmake .. -G Ninja ${cmake_options}",
    cwd     => "${workspace}/src/sopt/build",
    creates => "${workspace}/src/sopt/build/CMakeCache.txt",
  } -> exec { "${project}-sopt-install":
    command => 'ninja -j4 install',
    cwd     => "${workspace}/src/sopt/build",
    creates => "${workspace}/share/cmake/sopt/SoptConfig.cmake",
  }
  repository { "${project}-cookoff":
    source  => 'UCL/GreatCMakeCookOff',
    path    => "${workspace}/src/cookoff",
    require => Lmod::Project[$project]
  } -> file { "${workspace}/src/cookoff/build":
    ensure => directory
  } -> exec { "${project}-cookoff-configure":
    command => "cmake .. -G Ninja ${cmake_options}",
    cwd     => "${workspace}/src/cookoff/build",
    creates => "${workspace}/src/cookoff/build/CMakeCache.txt",
  } -> exec { "${project}-cookoff-install":
    command => 'ninja -j4 install',
    cwd     => "${workspace}/src/cookoff/build",
    creates => "${workspace}/share/cmake/GreatCMakeCookoff/GreatCMakeCookoffConfig.cmake",
  }

  misc::pip {
    "${project}-pytest":
      package => 'pytest',
      prefix  => $workspace,
      require => Lmod::Project[$project];
    "${project}-cython":
      package => 'cython',
      prefix  => $workspace,
      require => Lmod::Project[$project];
    "${project}-pandas":
      package => 'pandas',
      prefix  => $workspace,
      require => Lmod::Project[$project]
  }

  lmod::ensure_package{
    ['libtiff', 'ninja', 'fftw', 'eigen', 'cfitsio', 'doxygen']:
      project => $project,
  }
  package {'casa': provider => brewcask}


  file {
    "${lmod::config::workspaces}/${project}/.vimrc":
      ensure  => file,
      content => template("projects/${project}/vimrc.erb"),
      require => Lmod::Project[$project];
    "${lmod::config::workspaces}/${project}/.cppconfig":
      ensure  => file,
      content => template("projects/${project}/cppconfig.erb"),
      require => Lmod::Project[$project],
  }
}
