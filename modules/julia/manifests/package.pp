# Adds a julia package
define julia::package(
  $virtualenv=undef, $ensure=present, $package=$name, $repo=undef, $metadir=undef, $juliacmd="julia") {
  case $ensure {
    present: {
      $cmd = $repo ? {
        /git/   => "Pkg.clone(\\\"${repo}\\\")",
        /http/  => "Pkg.clone(\\\"${repo}\\\")",
        default => "Pkg.add(\\\"${package}\\\")"
      }
      $exitcmd = " == nothing ? exit(1): exit(0)"
    }
    absent : {
      $cmd = "Pkg.rm(\\\"${package}\\\")"
      $exitcmd = " == nothing ? exit(0): exit(1)"
    }
  }
  if $virtualenv {
    $envs = ["JULIA_PKGDIR=${virtualenv}/.julia", "HOME=/Users/${::boxen_user}/", "PATH=${virtualenv}/bin"]
  } elsif $metadir {
    $envs = ["JULIA_PKGDIR=${metadir}", "HOME=/Users/${::boxen_user}/"]
  } else {
    $envs = []
  }
  exec { "${name}":
    command     => "${juliacmd} -e \"${cmd}\"",
    unless      => "${juliacmd} -e \"Pkg.installed(\\\"${package}\\\") ${exitcmd}\"",
    environment => $envs
  }
}
