# All configs for vim
class people::mdavezac::vim {
  class { 'dotvim':
    require => Repository['dotfiles']
  }

  dotvim::bundle { 'Valloric/YouCompleteMe':
    managed => false
  }
  $ycmdir = "/Users/${::boxen_user}/.vim/bundle/YouCompleteMe"
  exec { 'compile youcompleteme':
    command => "/usr/bin/env -i bash -c 'source ${boxen::config::home}/env.sh && ${ycmdir}/install.py --clang-completer --system-boost'",
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
  package { ['boost', 'boost-python']: }

  file {
    "/Users/${::boxen_user}/.vimrc":
      target  => "/Users/${::boxen_user}/.dotfiles/vim/vimrc",
      require => Repository['dotfiles'];
    "/Users/${::boxen_user}/.gvimrc":
      target  => "/Users/${::boxen_user}/.dotfiles/vim/gvimrc",
      require => Repository['dotfiles'];
    "${dotvim::config::vimdir}/undo":
      ensure => directory;
    "/Users/${::boxen_user}/.ycm_extra_conf.py":
      target => "/Users/${::boxen_user}/.dotfiles/vim/ycm_extra_conf.py",
      ensure => 'link',
      require => Repository['dotfiles'];
  }
}
