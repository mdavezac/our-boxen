# Creates optimet project
class projects::optimet($project='optimet') {
  require lmod
  $repodir = "${lmod::config::workspaces}/${project}/src/${project}"
  $workspace = "${lmod::config::workspaces}/${project}"

  lmod::project {$project:
    repository => "OPTIMET/OPTIMET"
  } -> misc::ctags {"${workspace}/src/${project}": }

  file {
    "${workspace}/.vimrc":
      ensure  => file,
      content => template("projects/${project}/vimrc.erb"),
      require => Lmod::Project[$project];
    "${workspace}/.cppconfig":
      ensure  => file,
      content => template("projects/${project}/cppconfig.erb"),
      require => Lmod::Project[$project];
    # "${repodir}/.git/hooks/pre-commit":
    #   ensure  => file,
    #   content => template("projects/${project}/pre-commit.erb"),
    #   mode    => 700,
    #   require => Lmod::Project[$project];
  }

  exec { "${project} - Download gsl":
    command => 'curl -L http://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz | tar xv',
    creates => "${workspace}/src/gsl-1.16",
    cwd     => "${workspace}/src",
    require => Lmod::Project[$project];
  } -> exec { "${project} - gsl install":
    command => "zsh -lc \"./configure --prefix=${workspace} && make && make install -j8\"",
    cwd     => "${workspace}/src/gsl-1.16",
    path    => '/opt/boxen/homebrew/bin',
    creates => "${workspace}/lib/libgsl.dylib"
  }

  exec { "${project} - Download hdf5":
    command => 'curl -L http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.16.tar | tar xv',
    creates => "${workspace}/src/hdf5-1.8.16",
    cwd     => "${workspace}/src",
    require => Lmod::Project[$project];
  } -> exec { "${project} - hdf5 install":
    command => "zsh -lc \"./configure --prefix=${workspace} && make && make install -j8\"",
    cwd     => "${workspace}/src/hdf5-1.8.16",
    path    => '/opt/boxen/homebrew/bin',
    creates => "${workspace}/lib/libhdf5.dylib"
  }

  exec { "${project} - Download f2c":
    command => 'curl -L http://www.netlib.org/f2c/libf2c.zip -o libf2c.zip ',
    creates => "${workspace}/src/libf2c.zip",
    cwd     => "${workspace}/src",
    require => Lmod::Project[$project];
  } -> exec { "${project} - unzip f2c":
    command => 'unzip libf2c.zip -d libf2c',
    creates => "${workspace}/src/libf2c",
    cwd     => "${workspace}/src"
  } -> exec { "${project} make f2c.h":
    command => 'make -f makefile.u hadd && make -f makefile.u f2c.h',
    creates => "${workspace}/src/libf2c/f2c.h",
    cwd     => "${workspace}/src/libf2c"
  } -> exec { "${project} make libf2c":
    command => 'make -f makefile.u all',
    creates => "${workspace}/src/libf2c/libf2c.a",
    cwd     => "${workspace}/src/libf2c"
  } -> file {
    "${workspace}/include/f2c.h":
      ensure => file,
      source => "${workspace}/src/libf2c/f2c.h";
    "${workspace}/lib/libf2c.a":
      ensure => file,
      source => "${workspace}/src/libf2c/libf2c.a";
  }


  misc::cmake { "${project}-armadillo":
    url        => "https://downloads.sourceforge.net/project/arma/armadillo-6.100.0.tar.gz",
    source_dir => "${workspace}/src/armadillo-6.100.0",
    prefix     => $workspace,
    tarfile    => true,
    require =>  Lmod::Project[$project]
  }

  misc::catch{ $project:
    prefix  => $workspace,
    require => Lmod::Project[$project]
  }
  misc::cookoff{$project: }

  # for clang autoformat
  lmod::ensure_package{'clang-format': project => $project }

}
