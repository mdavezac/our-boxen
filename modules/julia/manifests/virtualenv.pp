define julia::virtualenv(
  $metadir=undef,
  $fromsource=undef
) {
  require lmod::config
  if($fromsource == undef) {
    require julia
  }
  require julia::config
  $workspace = $metadir ? {
    undef   => "${lmod::config::workspaces}/${name}",
    default => $metadir
  }
  $metadirectory = "${workspace}/${julia::config::version}"
  repository {"${metadirectory}/METADATA":
    source => 'git@github.com:JuliaLang/METADATA.jl.git'
  }

  if($fromsource != undef) {
    repository {"${workspace}/julia":
      source => "JuliaLang/julia.git",
    } -> file{ "${workspace}/julia/Make.user":
      ensure  => file,
      content => template('julia/Make.user.erb')
    } -> exec { "${name} - build julia":
      command => "git checkout $fromsource && make install -j8",
      cwd     => "${workspace}/julia",
      creates => "${workspace}/bin/julia",
      tries   => 3,
      timeout => 3600,
      require => Package['gcc']
    }
  }
}
