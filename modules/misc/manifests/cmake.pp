define misc::cmake(
  $url,
  $source_dir,
  $prefix,
  $tarfile=false,
  $options=""
) {
  $cmake_options = "-DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${prefix} $options"
  if( $tarfile == false ) {
    repository { "${name}-repo":
      source  => $url,
      path    => $source_dir,
    } -> file { "${source_dir}/build":
      ensure => directory
    }
  } else {
    exec { "${name}-repo":
      command => "curl -L $url | tar xv",
      cwd     => "${prefix}/src",
      creates => $source_dir
    } -> file { "${source_dir}/build":
      ensure => directory
    }
  }

  exec { "${name}-configure":
    command => "cmake .. -G Ninja ${cmake_options}",
    cwd     => "${source_dir}/build",
    creates => "${source_dir}/build/CMakeCache.txt",
    require => File["${source_dir}/build"]
  } -> exec { "${name}-install":
    command => 'ninja -j4 install',
    cwd     => "${source_dir}/build",
    creates => "${source_dir}/build/install_manifest.txt"
  }
}
