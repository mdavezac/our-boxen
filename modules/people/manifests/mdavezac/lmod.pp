# installs lmod
class people::mdavezac::lmod {
  include homebrew
  homebrew::tap { 'homebrew/science': }
  exec { 'lua filesystem':
    command => 'luarocks install luafilesystem'
  }
  exec { 'lua luaposix':
    creates => "${boxen::config::homebrewdir}/lib/lua/5.2/posix.so",
    command => 'luarocks install luaposix'
  }

  exec { 'lmod':
    command => "zsh -c 'source /Users/${::boxen_user}/.zprofile && brew install lmod'",
    require => [
      Homebrew::Tap['homebrew/science'],
      Package['lua'],
      Exec['lua filesystem'],
      Exec['lua luaposix']
    ]
  }

  file { "/Users/${::boxen_user}/.lmodfiles":
    ensure  => directory,
    recurse => true,
  }
}

