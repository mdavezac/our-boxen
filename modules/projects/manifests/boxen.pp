# Creates module to work on boxen stuff
class projects::boxen($python = 3) {
  require lmod
  $project = 'boxen'
  lmod::project { $project:
    directory => "${::boxen_home}/repo",
    autodir   => "${::boxen_home}/repo",
  }
}
