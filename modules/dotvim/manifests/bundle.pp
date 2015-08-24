# Adds vim bundle to given file
define dotvim::bundle($group = 'general', $managed = true) {
  require dotvim::install
  require dotvim::config
  $bundle = split($name, '/')
  $bundle_file = "${dotvim::config::vimdir}/${group}-bundle.vim"
  repository { "${dotvim::config::bundledir}/${bundle[1]}":
    source  => $name,
  }
  if $managed {
    if ! defined(File[$bundle_file]) {
      file { $bundle_file: ensure => file }
    }

    file_line { "Bundle ${name}":
      path    => $bundle_file,
      line    => "Bundle \"${name}\"",
      require => File[$bundle_file],
    }
  }
}
