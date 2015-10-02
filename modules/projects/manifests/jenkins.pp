# Jenkins jobs at ucl
class projects::jenkins {
  require lmod
  $project = "jenkins"
  $workspace = "${lmod::config::workspaces}/${project}"
  $repodir = "${workspace}/src/${project}"

  lmod::project {$project:
    repository => 'UCL-RITS/jenkins-job-builder-files',
    python     => 3,
    modlines   => [
      "set_alias(\"production\", \"jenkins-jobs --conf ${workspace}/.production.ini\")",
      "set_alias(\"staging\", \"jenkins-jobs --conf ${workspace}/.staging.ini\")",
    ]
  }
  misc::pip {
    "${project}-jenkins-job-builder":
      prefix  => $workspace,
      package => 'jenkins-job-builder',
      require => Lmod::Project[$project];
    "${project}-jenkjobs":
      prefix  => $workspace,
      package => 'git+https://github.com/UCL/jenkjobs',
      require => Lmod::Project[$project];
  }

  file {
    "${workspace}/.staging.ini":
      content => template("projects/jenkins/staging.ini.erb"),
      require => Lmod::Project[$project];
    "${workspace}/.production.ini":
      content => template("projects/jenkins/production.ini.erb"),
      require => Lmod::Project[$project];
    "${workspace}/.vimrc":
      content => template("projects/jenkins/vimrc.erb"),
      require => Lmod::Project[$project];
  }

  repository { "${workspace}/src/build_files":
    source => 'UCL-RITS/rcps-buildscripts'
  }
}
