# Adds a julia package
define julia::package(
  $virtualenv=undef, $ensure=present, $package=$name, $repo=undef) {
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
    $envs = ["JULIA_PKGDIR=${virtualenv}/.julia", "HOME=/Users/${::boxe_user}/"]
    notify{ "PACKAGE  ${name} ${envs}": }
  } else {
    $envs = []
  }
  exec { "${name}":
    command     => "julia -e \"${cmd}\"",
    unless      => "julia -e \"Pkg.installed(\\\"${package}\\\") ${exitcmd}\"",
    environment => $envs
  }
}
