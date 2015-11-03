# Creates siunits project
class projects::siunits($python = 3) {
  require homebrew
  require lmod
  require lmod::config
  require julia
  require julia::config
  $srcname = 'SIUnits.jl'
  $project = 'siunits'
  $workspace = "${lmod::config::workspaces}/${project}"
  $repodir = "${workspace}/${julia::config::version}/${srcname}"
  $julia = true

  lmod::project { $project:
    repository    => "mdavezac/SIUnits.jl",
    source_dir    => $repodir,
    directory     => $workspace,
    python        => $python,
    julia         => true,
    julia_pkg_dir => $workspace,
    autodir       => $repodir
  }
  misc::ctags { $repodir:
    require => Lmod::Project[$project]
  }
  julia::virtualenv { $project:
    metadir    => $workspace,
    fromsource => 'v0.4.0'
  }
  julia::package {
    "${project}-FactCheck.jl":
      package => "FactCheck",
      metadir => "${workspace}/${julia::config::version}",
      require => Julia::VirtualEnv[$project];
    "${project}-ijulia":
      package => "IJulia",
      metadir => "${workspace}/${julia::config::version}",
      require => Julia::VirtualEnv[$project];
    "${project}-gadfly":
      package => "Gadfly",
      metadir => "${workspace}/${julia::config::version}",
      require => Julia::VirtualEnv[$project];
  }

  file {
    "${workspace}/.vimrc":
      ensure  => file,
      content => template("projects/siunitsjl/vimrc.erb"),
      require => Lmod::Project[$project];
  }
}
