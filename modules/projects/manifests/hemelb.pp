# Creates sopt project
class projects::hemelb(
    $python = 2, $branch='red_blood_cells', $project='hemelb') {
  require lmod
  $repodir = "${lmod::config::workspaces}/${project}/src/${project}"
  $hemetool = "${repodir}/Tools/hemeTools/converters"

  lmod::project {$project:
    python   => $python,
    modlines => [
      "set_alias(\"extract_gmy\", \"python ${hemetool}/GmyUnstructuredGridReader.py\")",
      "set_alias(\"extract_grid\", \"python ${hemetool}/ExtractedPropertyUnstructuredGridReader.py\")"
    ]
  }
  file { "${lmod::config::workspaces}/${project}/.vimrc":
    ensure  => file,
    content => template('projects/hemelb/vimrc.erb'),
    require => Lmod::Project[$project]
  }
  file { "${lmod::config::workspaces}/${project}/.cppconfig":
    ensure  => file,
    content => template('projects/hemelb/cppconfig.erb'),
    require => Lmod::Project[$project],
  }

  exec { "${project} repo":
    command => "hg clone ssh://hg@entropy.chem.ucl.ac.uk/hemelb ${repodir} -r $branch",
    creates => "${repodir}/.hg/hgrc",
    require => Package['mercurial']
  } -> misc::ctags {$repodir: }
  file { "${repodir}/dependencies/build":
    ensure  => directory,
    require => Exec["${project} repo"]
  }
  exec { "${project} dependencies conf":
    command => "cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=${repodir}/dependencies",
    cwd     => "${repodir}/dependencies/build",
    creates => "${repodir}/dependencies/build/CMakeCache.txt",
    require => [File["${repodir}/dependencies/build"], Lmod::Project[$project]]
  } -> exec { "${project} dependencies make":
    command => 'make -j4',
    cwd     => "${repodir}/dependencies/build",
  }

  lmod::ensure_package{
    ['mercurial', 'ninja', 'ctemplate', 'tinyxml', 'cppunit']:
    project => $project
  }
  lmod::ensure_package{'java':
    project  => $project,
    provider => 'brewcask'
  }
  lmod::ensure_package{'openmpi':
    project => $project,
    require => Package['java']
  }
  lmod::ensure_package{'hdf5':
    install_options => ['--with-mpi', '--without-cxx'],
    tap             => 'homebrew/science',
    project         => $project
  }
  lmod::ensure_package{'parmetis':
    tap     => 'homebrew/science',
    project => $project
  }

  # helps with visualization
  lmod::ensure_package{'paraview':
    provider => 'brewcask',
    project  => $project,
    tap      => 'homebrew/science'
  }
}
