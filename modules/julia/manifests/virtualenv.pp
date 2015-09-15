define julia::virtualenv($metadir=undef) {
  require lmod::config
  require julia
  require julia::config
  $metadirectory = $metadir ? {
    undef   => "${lmod::config::workspaces}/${name}/.julia/${julia::config::version}",
    default => "$metadir/${julia::config::version}"
  }
  repository {"${metadirectory}/METADATA":
    source => 'git@github.com:JuliaLang/METADATA.jl.git'
  }
}
