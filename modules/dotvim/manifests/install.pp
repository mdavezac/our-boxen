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
    require => Package['python']
  }

  file { $vimdir:
    ensure  => directory,
  }
  file { $dotvim::config::bundledir:
    ensure  => directory,
    require => File[$vimdir]
  }
  file { "$dotvim::config::vimdir/autoload":
    ensure  => directory,
    require => File[$vimdir]
  }

  repository { "${bundledir}/Vundle.vim":
    source => 'VundleVim/Vundle.vim',
  }

  file { "${vimdir}/vundles.vim":
    ensure  => file,
    content => template('dotvim/vundles.vim.erb'),
    require => File[$vimdir]
  }

  file { "/Users/${::boxen_user}/.vim/UltiSnips":
    ensure => 'link',
    target => "/Users/${::boxen_user}/.dotfiles/vim/UltiSnips",
    require => File[$vimdir]
  }

}
