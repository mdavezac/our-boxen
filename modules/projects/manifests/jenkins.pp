# Jenkins jobs at ucl
class projects::jenkins {
  require lmod
  $project = "jenkins"
  $workspace = "${lmod::config::workspaces}/${project}"
  $repodir = "${workspace}/src/${project}"

  lmod::project {$project:
    repository => 'UCL-RITS/jenkins-job-builder-files',
    python     => 2,
    modlines   => [
      "set_alias(\"production\", \"jenkins-jobs --conf ${workspace}/.production.ini\")",
      "set_alias(\"staging\", \"jenkins-jobs --conf ${workspace}/.staging.ini\")",
    ]
  } -> repository { "${project}-rc-puppet":
    path   => "${workspace}/src/rc-puppet",
    source => 'UCL-RITS/rc_puppet.git'
  }
  misc::pip {
    "${project}-jenkins-job-builder":
      prefix  => $workspace,
      package => 'jenkins-job-builder',
      require => Lmod::Project[$project];
    "${project}-jenkjobs":
      prefix  => $workspace,
      package => 'git+https://github.com/UCL/jenkjobs==1.2.0',
      require => Lmod::Project[$project];
    "${project}-slack":
      prefix  => $workspace,
      package => 'git+https://github.com/asmundg/jenkins-jobs-slack.git',
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
    "${workspace}/src/jenkins/branch.yaml":
      content => "production",
      require => Lmod::Project[$project];
    "${workspace}/src/jenkins/jenkinsdescription.yaml":
      content => "UCL RSD Jenkins",
      require => Lmod::Project[$project];
    "${workspace}/src/jenkins/ucl-rits-slack-token":
      ensure  => link,
      target  => "/Users/${::boxen_user}/.secrets/ucl-rits-slack-token",
      require => Lmod::Project[$project];
    "${workspace}/src/jenkins/purify-slack-token":
      ensure  => link,
      target  => "/Users/${::boxen_user}/.secrets/purify-slack-token",
      require => Lmod::Project[$project];
    "${workspace}/bin/build.zsh":
      ensure  => file,
      content => "ssh jenkins_legion \"bash -l\" < \$1",
      mode    => 700;
  }

  repository { "${workspace}/src/build_files":
    source => 'UCL-RITS/rcps-buildscripts'
  }
}
