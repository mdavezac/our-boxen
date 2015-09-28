# Creates sopt project
class projects::sopt($python = 3) {
  require lmod
  $project = 'sopt'
  lmod::project { $project:
    repository => 'astro-informatics/sopt',
    python     => 3
  } -> misc::ctags {"${lmod::config::workspaces}/${project}/src/${project}": }

  lmod::ensure_package{['libtiff', 'ninja', 'fftw', 'eigen']:
      project => $project,
  }

  misc::pip{
    "${project}-cython":
      prefix  => "${lmod::config::workspaces}/${project}",
      package => 'cython',
      require => Lmod::Project[$project];
    "${project}-pytest":
      prefix  => "${lmod::config::workspaces}/${project}",
      package => 'pytest',
      require => Lmod::Project[$project];
    "${project}-pyWavelets":
      prefix  => "${lmod::config::workspaces}/${project}",
      package => 'pyWavelets',
      require => Lmod::Project[$project];
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
