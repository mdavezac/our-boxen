class people::mdavezac::settings {
  include osx::dock::autohide
  include osx::global::tap_to_click
  include osx::global::expand_save_dialog
  class osx_config::keyboard {
    'Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)':
      ensure => present,
      key    => 'AppleKeyboardUIMode',
      domain => 'NSGlobalDomain',
      value  => '3',
      type   => 'int',
      user   => $::boxen_user;

    'Follow the keyboard focus while zoomed in':
      ensure => present,
      key    => 'closeViewZoomFollowsFocus',
      domain => 'com.apple.universalaccess',
      value  => 'true',
      type   => 'bool',
      user   => $::boxen_user;

    'Set a blazingly fast keyboard repeat rate':
      ensure => present,
      key    => 'KeyRepeat',
      domain => 'NSGlobalDomain',
      value  => '5',
      type   => 'int',
      user   => $::boxen_user;

    'Automatically illuminate built-in MacBook keyboard in low light':
      ensure => present,
      key    => 'kDim',
      domain => 'com.apple.BezelServices',
      value  => 'true',
      type   => 'bool',
      user   => $::boxen_user;

    'Turn off keyboard illumination when computer is not used for 5 minutes':
      ensure => present,
      key    => 'kDimTime',
      domain => 'com.apple.BezelServices',
      value  => '300',
      type   => 'int',
      user   => $::boxen_user;
  }
}
