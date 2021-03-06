# Most inititialization stuff
class dotvim::install {
  require dotvim::config
  $vimdir = $dotvim::config::vimdir
  $bundledir = $dotvim::config::bundledir

  package { 'macvim':
    ensure          => installed,
    install_options => ['--with-cscope', '--with-lua', '--with-luajit'],
    require         => [Package['lua'], Package['luajit'], Package['python']]
  }
  package { 'vim':
    install_options => [
      '--with-client-server', '--with-lua', '--with-luajit'
    ],
    require => Package['python']
  }
  homebrew::tap { 'neovim/neovim': }
  package { 'neovim':
    install_options => ['--HEAD']
  }

  file {
    $vimdir:
      ensure  => directory;
    $bundledir:
      ensure  => directory,
      require => File[$vimdir];
    "${vimdir}/autoload":
      ensure  => directory,
      require => File[$vimdir];
    "${vimdir}/.gissue-cache":
      ensure  => directory,
      require => File[$vimdir];
    "${vimdir}/after":
      ensure => link,
      target => "/Users/${::boxen_user}/.dotfiles/vim/after",
      require => File[$vimdir];
  }

  repository { "${bundledir}/Vundle.vim":
    source => 'VundleVim/Vundle.vim',
  }

  file {
    "${vimdir}/vundles.vim":
      ensure  => file,
      content => template('dotvim/vundles.vim.erb'),
      require => File[$vimdir];
    "${vimdir}/UltiSnips":
      ensure => 'link',
      target => "/Users/${::boxen_user}/.dotfiles/vim/UltiSnips",
      require => File[$vimdir];
  }

}
