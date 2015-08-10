class people::mdavezac::vim {
  include vim
  include macvim

  file { '/Users/${::boxen_user}/.vimrc'
    ensure => 'link',
    target => '/Users/${::boxen_user}/.dotfiles/vim/vimrc',
  }

  vim::bundle { 'bling/vim-airline.git': }
  vim::bundle { 'tpope/vim-sensible.git': }
  vim::bundle { 'tpope/vim-sleuth.git': }
  vim::bundle { 'sjl/gundo.git': }
  vim::bundle { 'scrooloose/vim-syntastic.git': }
  vim::bundle { 'scrooloose/nerdtree.git': }
  vim::bundle { 'kien/ctrlp.git': }
  vim::bundle { 'rking/ag.vim.git': }

  vim::bundle { 'tpope/vim-fugitive.git': }
  vim::bundle { 'gregsexton/gitv': }

  vim::bundle { 'tpope/vim-commentary.git': }
  vim::bundle { 'tpope/vim-markdown.git': }
  vim::bundle { 'JuliaLang/julia-vim.git': }
}
