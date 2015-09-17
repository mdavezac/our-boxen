# Creates purify project
class projects::purify($python = 3) {
  require lmod
  $project = 'purify'
  lmod::project { $project:
    repository => "astro-informatics/${project}",
    python     => 2,
    modlines   => [
      'set_alias("casapy", "/opt/homebrew-cask/Caskroom/casa/4.4.0-6/CASA.app/Contents/MacOS/casapy")',
    ]
  } -> misc::ctags {"${lmod::config::workspaces}/${project}/src/${project}": }

  misc::pip {
    "${project}-pytest":
      package => 'pytest',
      prefix  => "${lmod::config::workspaces}/${project}",
      require => Lmod::Project[$project];
    "${project}-cython":
      package => 'cython',
      prefix  => "${lmod::config::workspaces}/${project}",
      require => Lmod::Project[$project];
    "${project}-pandas":
      package => 'pandas',
      prefix  => "${lmod::config::workspaces}/${project}",
      require => Lmod::Project[$project]
  }

  lmod::ensure_package{
    ['libtiff', 'ninja', 'fftw', 'eigen', 'cfitsio', 'doxygen']:
      project => $project,
  }
  package {'casa': provider => brewcask}


  $repodir = "${lmod::config::workspaces}/${project}/src/${project}"
  file { "${lmod::config::workspaces}/${project}/.vimrc":
    ensure  => file,
    content => template("projects/sopt/vimrc.erb"),
    require => Lmod::Project[$project]
  }

  file { "${lmod::config::workspaces}/${project}/.cppconfig":
    ensure  => file,
    content => template("projects/sopt/cppconfig.erb"),
    require => Lmod::Project[$project],
  }
}
