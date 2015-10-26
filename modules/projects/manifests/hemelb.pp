# Creates sopt project
class projects::hemelb($python=2, $project='hemelb') {
  require lmod
  $repodir = "${lmod::config::workspaces}/${project}/src/${project}"
  $hemetool = "${repodir}/Tools/hemeTools/converters"
  $workspace = "${lmod::config::workspaces}/${project}"

  lmod::project {$project:
    repository => 'UCL-CCS/hemelb-dev',
    python   => $python,
    modlines => [
      "set_alias(\"extract_gmy\", \"python ${hemetool}/GmyUnstructuredGridReader.py\")",
      "set_alias(\"extract_grid\", \"python ${hemetool}/ExtractedPropertyUnstructuredGridReader.py\")",
      "set_alias(\"production\", \"jenkins-jobs --ignore-cache --conf ${workspace}/.production.ini\")",
      "set_alias(\"staging\", \"jenkins-jobs --ignore-cache --conf ${workspace}/.staging.ini\")",
      "setenv(\"CXXFLAGS\", \"-I/opt/boxen/homebrew/include -Wall -Wno-deprecated-register\")",
      "setenv(\"TMP\", pathjoin(srcdir, \"build\", \"tmp\"))",
    ]
  } -> misc::ctags {$repodir: }
  misc::cookoff { $project: }
  file {
    "${repodir}/build":
      ensure  => directory,
      require => Lmod::Project[$project];
    "${repodir}/build/tmp":
      ensure  => directory,
      require => File["${repodir}/build"];
    "${workspace}/.vimrc":
      ensure  => file,
      content => template('projects/hemelb/vimrc.erb'),
      require => Lmod::Project[$project];
    "${workspace}/.cppconfig":
      ensure  => file,
      content => template('projects/hemelb/cppconfig.erb'),
      require => Lmod::Project[$project];
    "${workspace}/.staging.ini":
      content => template("projects/jenkins/staging.ini.erb"),
      require => Lmod::Project[$project];
    "${workspace}/.production.ini":
      content => template("projects/jenkins/production.ini.erb"),
      require => Lmod::Project[$project];
    "${workspace}/src/${project}/ucl-ccs-slack-token":
      ensure  => link,
      target  => "/Users/${::boxen_user}/.secrets/ucl-ccs-slack-token",
      require => Lmod::Project[$project];
    "${workspace}/.vim":
      ensure  => directory,
      require => Lmod::Project[$project];
    "${workspace}/.vim/UltiSnips":
      ensure  => directory,
      require => File["${workspace}/.vim"];
    "${workspace}/.vim/UltiSnips/cpp.snippets":
      ensure  => link,
      target => "${::boxen_home}/repo/modules/projects/templates/${project}/cpp.snippets",
      require => File["${workspace}/.vim/UltiSnips"];
    "${workspace}/.vimrc.before":
      content => template('projects/hemelb/vimrc.before.erb'),
      require => Lmod::Project[$project];
  }

  lmod::ensure_package{
    ['ninja', 'ctemplate', 'tinyxml', 'cppunit']:
      project => $project;
    'java': # for openmpi only
      project  => $project,
      provider => 'brewcask';
    'openmpi':
      project => $project,
      require => Package['java'];
    'hdf5':
      install_options => ['--with-mpi', '--without-cxx'],
      tap             => 'homebrew/science',
      project         => $project;
    'parmetis':
      tap     => 'homebrew/science',
      project => $project;
    'boost':
      install_options => ['--c++11'],
      project         => $project;
  }

  # To add jenkins jobs
  misc::pip {
    "${project}-python-jenkins":
      prefix  => $workspace,
      package => 'python-jenkins==0.4.8';
    "${project}-jenkins-job-builder":
      prefix  => $workspace,
      package => 'jenkins-job-builder',
      require => [Lmod::Project[$project], Misc::Pip["${project}-python-jenkins"]];
    "${project}-jenkjobs":
      prefix  => $workspace,
      package => 'git+https://github.com/UCL/jenkjobs.git',
      require => Lmod::Project[$project];
    "${project}-slack":
      prefix  => $workspace,
      package => 'jenkins-jobs-slack',
      require => Lmod::Project[$project];
  }

  # helps with visualization
  lmod::ensure_package{'paraview':
    provider => 'brewcask',
    project  => $project,
    tap      => 'homebrew/science'
  }
}
