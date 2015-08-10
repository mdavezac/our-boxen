class people::mdavezac::terminals {
  include iterm2::dev
  include iterm2::colors::solarized_dark
  class { 'powerline': manage_font_library_dir => true, }
  include zsh
  include prezto

  file_line { 'source boxen':
     path => "/Users/${::boxen_user}/.zshrc",
     line => 'source /opt/boxen/env.sh',
  }
  file_line { 'source zsh files':
     path => "/Users/${::boxen_user}/.zshrc",
     line => "for filename in /Users/${::boxen_user}/.dotfiles/zsh/*.zsh; do; source \$filename; done",
  }
}
