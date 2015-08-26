# All configs for vim
class people::mdavezac::vim {
  include dotvim

  dotvim::bundle { 'Valloric/YouCompleteMe':
    managed => false
  }
  $ycmdir = "/Users/${::boxen_user}/.vim/bundle/YouCompleteMe"
  exec { 'compile youcompleteme':
    command => "/usr/bin/env -i bash -c 'source ${boxen::config::home}/env.sh && ${ycmdir}/install.sh --clang-completer'",
    cwd     => $ycmdir,
    creates => [
      "${ycmdir}/third_party/ycmd/ycm_client_support.so",
      "${ycmdir}/third_party/ycmd/ycm_core.so"
    ],
    require => [
      Dotvim::Bundle['Valloric/YouCompleteMe'],
      Package['cmake'], Package['python']
    ]
  }

  file { "/Users/${::boxen_user}/.vimrc":
    target  => "/Users/${::boxen_user}/.dotfiles/vim/vimrc",
    require => Repository["/Users/${::boxen_user}/.dotfiles"]
  }
  file {"${dotvim::config::vimdir}/undo":
    ensure => directory
  }
}
