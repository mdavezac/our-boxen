class people::mdavezac {
  git::config::global { 'user.email': value  => 'm.davezac@ucl.ac.uk' }
  git::config::global { 'user.name': value  => "Mayeul d'Avezac" }

  repository { "/Users/${::boxen_user}/.dotfiles":
    source => "${::github_login}/dotfiles",
  }

  include people::mdavezac::applications
  include people::mdavezac::terminals
}
