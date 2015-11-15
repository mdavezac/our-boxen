class people::mdavezac::terminals {
  include iterm2::dev
  include iterm2::colors::solarized_dark
  include people::mdavezac::powerfonts
  include zsh
  include prezto

  file_line {
    'source boxen':
        path => "/Users/${::boxen_user}/.zshrc",
        line => 'source /opt/boxen/env.sh',
        require => Repository["/Users/${::boxen_user}/.dotfiles"];
    'source zsh files':
        path => "/Users/${::boxen_user}/.zshrc",
        line => "for filename in /Users/${::boxen_user}/.dotfiles/zsh/*.zsh; do; source \$filename; done",
        require => Repository["/Users/${::boxen_user}/.dotfiles"];
    'source local preztorc':
        path => "/Users/${::boxen_user}/.zpreztorc",
        line => "source /Users/${::boxen_user}/.dotfiles/zsh/preztorc",
        require => Repository["/Users/${::boxen_user}/.dotfiles"];
    'source local profile':
        path => "/Users/${::boxen_user}/.zprofile",
        line => "source /Users/${::boxen_user}/.dotfiles/zsh/zprofile",
        require => Repository["/Users/${::boxen_user}/.dotfiles"];
  }
}
