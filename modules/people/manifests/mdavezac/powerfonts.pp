# Adds powerline fonts
class people::mdavezac::powerfonts {
  repository { "$::boxen_home/powerlinefonts":
    source => "powerline/fonts"
  } -> exec { 'install powerline fonts':
    creates => "/Users/${::boxen_user}/Library/Fonts/DejaVu Sans Mono for Powerline.ttf",
    command => 'bash ./install.sh',
    cwd     => "${::boxen_home}/powerlinefonts"
  }
}
