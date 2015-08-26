define julia::virtualenv($directory=undef) {
  require julia::config
  if $directory {
    $dir = $directory
  } else {
    $dir = $name
  }
  repository {"${dir}/.julia/${julia::config::version}/METADATA":
    source => 'git@github.com:JuliaLang/METADATA.jl.git'
  }
}
