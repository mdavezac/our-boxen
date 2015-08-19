# Sets up projects
class people::mdavezac::projects {
  require people::mdavezac::lmod
  $workspaces="/Users/${::boxen_user}/workspaces"
  $lmodfiles="/Users/${::boxen_user}/.lmodfiles"

  file { $workspaces:
    ensure  => directory,
    recurse => true,
  }
  file { $lmodfiles:
    ensure  => directory,
    recurse => true,
  }
}
