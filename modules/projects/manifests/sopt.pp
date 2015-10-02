# Creates sopt project
class projects::sopt($python = 3) {
  require lmod
  $project = 'sopt'
  $workspace = "${lmod::config::workspaces}/${project}"
  lmod::project { $project:
    repository => 'astro-informatics/sopt',
    python     => 3
  } -> misc::ctags {"${workspace}/src/${project}": }

  misc::cookoff{$project: }
  misc::cmake{"$project-gbenchmark":
    url        => 'google/benchmark.git',
    source_dir => "${workspace}/src/gbenchmark",
    prefix     => $workspace,
    require => Lmod::Project[$project]
  }
  repository {"$project-spdlog":
    source  => 'gabime/spdlog',
    path    => "${workspace}/src/spdlog",
    require => Lmod::Project[$project]
  } -> file {"${workspace}/include":
    ensure  => directory
  } -> file { "${workspace}/include/spdlog":
    source  => "${workspace}/src/spdlog/include/spdlog",
    recurse => true
  }

  misc::catch{ $project:
    prefix  => $workspace,
    require => Lmod::Project[$project]
  }


  lmod::ensure_package{['libtiff', 'ninja', 'fftw', 'eigen']:
      project => $project,
  }

  misc::pip{
    "${project}-cython":
      prefix  => $workspace,
      package => 'cython',
      require => Lmod::Project[$project];
    "${project}-pytest":
      prefix  => $workspace,
      package => 'pytest',
      require => Lmod::Project[$project];
    "${project}-pyWavelets":
      prefix  => $workspace,
      package => 'pyWavelets',
      require => Lmod::Project[$project];
  }

  $repodir = "${workspace}/src/${project}"
  file { "${workspace}/.vimrc":
    ensure  => file,
    content => template("projects/${project}/vimrc.erb"),
    require => Lmod::Project[$project]
  }
  file { "${workspace}/.cppconfig":
    ensure  => file,
    content => template("projects/${project}/cppconfig.erb"),
    require => Lmod::Project[$project],
  }
}
