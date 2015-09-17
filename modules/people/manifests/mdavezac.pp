# Mine
class people::mdavezac {
  git::config::global { 'user.email': value  => 'm.davezac@ucl.ac.uk' }
  git::config::global { 'user.name': value  => 'Mayeul d\'Avezac' }

  repository { "/Users/${::boxen_user}/.dotfiles":
    source => "${::github_login}/dotfiles",
  } -> file { "/Users/${::boxen_user}/.hgrc":
    ensure => 'link',
    target => "/Users/${::boxen_user}/.dotfiles/hgrc"
  } -> file { "/Users/${::boxen_user}/.ctags":
    ensure => 'link',
    target => "/Users/${::boxen_user}/.dotfiles/ctags"
  }
  include osx::dock::autohide
  include osx::global::natural_mouse_scrolling
  include osx::global::enable_standard_function_keys
  include osx::global::tap_to_click
  include osx::software_update
  class { 'osx::mouse::swipe_between_pages':
    enabled => true
  }
  class { 'osx::mouse::button_mode':
    mode => 2
  }

  include people::mdavezac::keyboard
  include people::mdavezac::applications
  include people::mdavezac::terminals
  include people::mdavezac::python
  include people::mdavezac::vim
  include lmod
  include julia
}