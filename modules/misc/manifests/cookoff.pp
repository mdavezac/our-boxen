# Installs GreatCMakeCookoff to project directory
define misc::cookoff(
  $project=$name,
  $options=""
) {
  $workspace =  "${lmod::config::workspaces}/${project}"
  $cmake_options = "-DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${workspace} $options"
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
}
