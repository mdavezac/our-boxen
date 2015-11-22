# This is a placeholder class.
# installs lmod
class lmod {
  include lmod::config
  include homebrew
  homebrew::tap { 'homebrew/science': }
  exec { 'lua filesystem':
    command => 'luarocks install luafilesystem',
    unless  => "zsh -c 'source /Users/${::boxen_user}/.zprofile && lua -e 'require \"elfs\"'",
    require => Package['lua']
  }
  exec { 'lua luaposix':
    creates => "${boxen::config::homebrewdir}/lib/lua/5.2/posix.so",
    unless  => "zsh -c 'source /Users/${::boxen_user}/.zprofile && lua -e 'require \"posix\"'",
    command => 'luarocks install luaposix',
    require => Package['lua']
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

  file { $lmod::config::workspaces:
    ensure  => directory,
  }
  file { $lmod::config::lmodfiles:
    ensure  => directory,
  }
}
