define lmod::ensure_package(
  $provider = 'homebrew',
  $project = undef,
  $tap = undef,
  $install_options=[]
) {
  require homebrew

  if ! defined(Package[$name]) {
    package { $name:
      provider        => $provider,
      install_options => $install_options
    }
  }
  if $tap and !defined(Homebrew::Tap[$tap]) {
    homebrew::tap{$tap: } -> Package[$name]
  }

  if $project {
    Package[$name] -> Lmod::Project[$project]
  }
}
