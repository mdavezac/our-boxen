# == Define: python::pip
#
# Installs and manages packages from pip.
#
# === Parameters
#
# [*ensure*]
#  present|absent. Default: present
#
# [*virtualenv*]
#  virtualenv to run pip in.
#
# [*proxy*]
#  Proxy server to use for outbound connections. Default: none
#
# === Examples
#
# python::pip { 'flask':
#   virtualenv => '/var/www/project1',
#   proxy      => 'http://proxy.domain.com:3128',
# }
#
# === Authors
#
# Sergey Stankevich
#
define misc::pip (
  $prefix = $boxen::config::homebrewdir,
  $ensure = present,
  $proxy  = false,
  $package = $name
) {
  $pip = "${prefix}/bin/pip"

  $grep_regex = $name ? {
    /==/    => "^${name}\$",
    default => "^${name}==",
  }

  case $ensure {
    present: {
      exec { "pip_install_${name}":
        command => "${pip} install ${package}",
        unless  => "${pip} freeze | grep -i -e ${grep_regex}",
      }
    }

    default: {
      exec { "pip_uninstall_${name}":
        command => "echo y | ${pip} uninstall ${package}",
        onlyif  => "${pip} freeze | grep -i -e ${grep_regex}",
      }
    }
  }

}
