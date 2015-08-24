# All configs for vim
class people::mdavezac::vim {
  include dotvim

# dotvim::bundle { [
#   'bling/vim-airline.git', 'tpope/vim-sensible.git', 'tpope/vim-sleuth.git',
#   'scrooloose/nerdtree.git', 'jistr/vim-nerdtree-tabs.git',
#   'kien/ctrlp.vim.git', 'rking/ag.vim.git', 'sjl/gundo.vim']:
#     group => 'improvements'
# }

# dotvim::bundle { ['tpope/vim-fugitive.git', 'gregsexton/gitv']:
#   group => 'git'
# }


# dotvim::bundle { [
#   'chrisbra/Colorizer.git', 'skwp/vim-colors-solarized',
#   'xsunsmile/showmarks.git', 'chriskempson/base16-vim',
#   'godlygeek/csapprox.git']:
#     group => 'appearance'
# }

# dotvim::bundle { [
#   'sheerun/vim-polyglot', 'jtratner/vim-flavored-markdown.git',
#   'scrooloose/syntastic.git', 'nelstrom/vim-markdown-preview',
#   'skwp/vim-html-escape', 'tpope/vim-markdown.git',
#   'JuliaLang/julia-vim.git', 'rodjek/vim-puppet',
#   'vim-pandoc/vim-pandoc', 'vim-pandoc/vim-pandoc-syntax']:
#     group => 'languages'
# }

# dotvim::bundle { [
#   'jaxbot/github-issues.vim', 'majutsushi/tagbar', 'SirVer/ultisnips',
#   'Valloric/YouCompleteMe', 'tpope/vim-commentary.git',
#   'vim-scripts/AutoTag.git']:
#     group => 'devel'
# }


# dotvim::bundle { 'Raimondi/delimitMate': }
# dotvim::bundle { 'tomtom/tcomment_vim.git': }
# dotvim::bundle { 'vim-scripts/camelcasemotion.git': }
# dotvim::bundle { 'tpope/vim-endwise.git': }
# dotvim::bundle { 'tpope/vim-repeat.git': }
# dotvim::bundle { 'tpope/vim-surround.git': }
# dotvim::bundle { 'tpope/vim-unimpaired': }
# dotvim::bundle { 'vim-scripts/AnsiEsc.vim.git': }
# dotvim::bundle { 'vim-scripts/lastpos.vim': }
# dotvim::bundle { 'vim-scripts/sudo.vim': }
# dotvim::bundle { 'goldfeld/ctrlr.vim': }
# dotvim::bundle { 'ervandew/supertab': }
# dotvim::bundle { 'tpope/vim-dispatch': }

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
}
