# Runs ctags in given directory
define people::mdavezac::ctags($arguments="") {
  if ! defined(Package['ctags']) { package { 'ctags': } }
  exec { 'ctags on ${name}':
    command => "ctags -R --fields=+l --exclude=.git --exclude=build ${arguments} .",
    cwd     => $name
  }
}
