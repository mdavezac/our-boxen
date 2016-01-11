# Hunter
class projects::hunter {
  require lmod
  $project = "hunter"
  $workspace = "${lmod::config::workspaces}/${project}"
  $repodir = "${workspace}/src/${project}"

  lmod::project {$project:
    repository => 'mdavezac/hunter',
    modlines   => [
      "setenv(\"HUNTER_ROOT\", \"${repodir}\")",
    ]
  } -> misc::ctags {"${workspace}/src/${project}": }
  misc::cookoff{$project:
    require => Lmod::Project[$project],
  }
}
