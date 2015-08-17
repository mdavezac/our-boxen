# All configs for vim
class people::mdavezac::vim {
  package { 'vim':
    require => Package['python']
  }

  $vimdir = "/Users/${::boxen_user}/.vim"
  file { [$vimdir, "${vimdir}/autoload", "${vimdir}/bundle"]:
    ensure  => directory,
    recurse => true,
  }
  repository { "${vimdir}/vim-pathogen":
    source => 'tpope/vim-pathogen'
  }
  file { "${vimdir}/autoload/pathogen.vim":
    target  => "${vimdir}/vim-pathogen/autoload/pathogen.vim",
    require => [
      File[$vimdir], File["${vimdir}/autoload"],
      File["${vimdir}/bundle"], Repository["${vimdir}/vim-pathogen"]
    ]
  }

  vim::bundle { 'bling/vim-airline.git': }
  vim::bundle { 'tpope/vim-sensible.git': }
  vim::bundle { 'tpope/vim-sleuth.git': }
  vim::bundle { 'scrooloose/nerdtree.git': }
  vim::bundle { 'jistr/vim-nerdtree-tabs.git': }
  vim::bundle { 'kien/ctrlp.vim.git': }
  vim::bundle { 'rking/ag.vim.git': }

  vim::bundle { 'tpope/vim-fugitive.git': }
  vim::bundle { 'gregsexton/gitv': }

  vim::bundle { 'tpope/vim-commentary.git': }
  vim::bundle { 'tpope/vim-markdown.git': }
  vim::bundle { 'JuliaLang/julia-vim.git': }
  vim::bundle { 'rodjek/vim-puppet': }

  vim::bundle { 'chrisbra/Colorizer.git': }
  vim::bundle { 'skwp/vim-colors-solarized': }
  vim::bundle { 'xsunsmile/showmarks.git': }
  vim::bundle { 'chriskempson/base16-vim': }
  vim::bundle { 'godlygeek/csapprox.git': }

  vim::bundle { 'sheerun/vim-polyglot': }
  vim::bundle { 'jtratner/vim-flavored-markdown.git': }
  vim::bundle { 'scrooloose/syntastic.git': }
  vim::bundle { 'nelstrom/vim-markdown-preview': }
  vim::bundle { 'skwp/vim-html-escape': }

  vim::bundle { 'Raimondi/delimitMate': }
  vim::bundle { 'tomtom/tcomment_vim.git': }
  vim::bundle { 'vim-scripts/camelcasemotion.git': }
  vim::bundle { 'sjl/gundo.vim': }
  vim::bundle { 'tpope/vim-endwise.git': }
  vim::bundle { 'tpope/vim-repeat.git': }
  vim::bundle { 'tpope/vim-surround.git': }
  vim::bundle { 'tpope/vim-unimpaired': }
  vim::bundle { 'vim-scripts/AnsiEsc.vim.git': }
  vim::bundle { 'vim-scripts/AutoTag.git': }
  vim::bundle { 'vim-scripts/lastpos.vim': }
  vim::bundle { 'vim-scripts/sudo.vim': }
  vim::bundle { 'goldfeld/ctrlr.vim': }

  vim::bundle { 'jaxbot/github-issues.vim': }
  vim::bundle { 'majutsushi/tagbar': }
  vim::bundle { 'SirVer/ultisnips': }
  vim::bundle { 'Valloric/YouCompleteMe': }
  $ycmdir = "/Users/${::boxen_user}/.vim/bundle/YouCompleteMe"
  exec { 'compile youcompleteme':
    command => "/usr/bin/env -i bash -c 'source ${boxen::config::home}/env.sh && ${ycmdir}/install.sh --clang-completer'",
    cwd     => $ycmdir,
    creates => [
      "${ycmdir}/third_party/ycmd/ycm_client_support.so",
      "${ycmdir}/third_party/ycmd/ycm_core.so"
    ],
    require => [
      Vim::Bundle['Valloric/YouCompleteMe'],
      Package['cmake'], Package['python']
    ]
  }
  vim::bundle { 'ervandew/supertab': }
  vim::bundle { 'tpope/vim-dispatch': }
  vim::bundle { 'vim-pandoc/vim-pandoc': }
  vim::bundle { 'vim-pandoc/vim-pandoc-syntax': }

  package { 'macvim':
    ensure          => installed,
    install_options => ['--with-cscope', '--with-lua', '--with-luajit'],
    require         => [Package['lua'], Package['luajit'], Package['python']]
  }

  file { "/Users/${::boxen_user}/.vimrc":
    target  => "/Users/${::boxen_user}/.dotfiles/vim/vimrc",
    require => Repository["/Users/${::boxen_user}/.dotfiles"]
  }
}
