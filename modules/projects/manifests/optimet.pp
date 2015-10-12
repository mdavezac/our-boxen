# Creates optimet project
class projects::optimet($project='optimet') {
  require lmod
  $repodir = "${lmod::config::workspaces}/${project}/src/${project}"
  $workspace = "${lmod::config::workspaces}/${project}"

  lmod::project {$project:
  }

  file {
    "${workspace}/src":
      ensure => directory,
      require => Lmod::Project[$project];
    "${workspace}/.vimrc":
      ensure  => file,
      content => template("projects/${project}/vimrc.erb"),
      require => Lmod::Project[$project];
    "${workspace}/.cppconfig":
      ensure  => file,
      content => template("projects/${project}/cppconfig.erb"),
      require => Lmod::Project[$project];
  }

  exec { "${project} - Download gsl":
    command => 'curl -L http://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz | tar xv',
 creates => "${workspace}/src/gsl-1.16",
    cwd     => "${workspace}/src",
    require => File["${workspace}/src"]
  } -> exec { "${project} - install":
    command => "zsh -lc \"./configure --prefix=${workspace} && make && make install -j8\"",
    cwd     => "${workspace}/src/gsl-1.16",
    path    => '/opt/boxen/homebrew/bin',
    creates => "${workspace}/lib/libgsl.dylib"
  }

  misc::cmake { "${project}-armadillo":
    url        => "https://downloads.sourceforge.net/project/arma/armadillo-6.100.0.tar.gz",
    source_dir => "${workspace}/src/armadillo-6.100.0",
    prefix     => $workspace,
    tarfile    => true,
    require => File["${workspace}/src"]
  }

}
