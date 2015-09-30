# Mine
class people::mdavezac {
  git::config::global {
    'user.email':            value => 'm.davezac@ucl.ac.uk';
    'user.name':             value => 'Mayeul d\'Avezac';
    'core.editor':           value => '/opt/boxen/homebrew/bin/vim';
    'core.ignore':           value => '~/.dotfiles/gitignore';
    'core.autoclrf':         value => 'false';
    'color.ui':              value => 'true';
    'apply.whitespace':      value => 'nowarn';
    'branch.autosetupmerge': value => 'true';
    'push.default':          value => 'upstream';
    'advice.statusHints':    value => 'false';
  }
  git::config::global {
    'format.pretty':
      value => 'format:%C(blue)%ad%Creset %C(yellow)%h%C(green)%d%Creset %C(blue)%s %C(magenta) [%an]%Creset';
  }

  require lmod
  lmod::project { 'dotfiles':
    repository => "mdavezac/SIUnits.jl",
    source_dir => "/Users/${::boxen_user}/.dotfiles",
  } -> file {
    "/Users/${::boxen_user}/.hgrc":
      ensure  => 'link',
      target  => "/Users/${::boxen_user}/.dotfiles/hgrc";
    "/Users/${::boxen_user}/.ctags":
      ensure => 'link',
      target => "/Users/${::boxen_user}/.dotfiles/ctags",
  }

  include osx::dock::autohide
  include osx::global::natural_mouse_scrolling
  include osx::global::enable_standard_function_keys
  include osx::global::tap_to_click
  include osx::software_update
  class {
    'osx::mouse::swipe_between_pages':
      enabled => true;
    'osx::mouse::button_mode':
      mode => 2
  }

  include people::mdavezac::keyboard
  include people::mdavezac::applications
  include people::mdavezac::terminals
  include people::mdavezac::python
  include people::mdavezac::vim
  include projects::boxen
  include lmod
  include julia
}
