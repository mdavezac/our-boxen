# Creates sopt project
class projects::sopt {
  require lmod
  lmod::project { 'sopt':
    name       => 'sopt',
    repository => 'astro-informatics/sopt',
    python     => true
  } -> misc::ctags {"${lmod::config::workspaces}/sopt/src/sopt": }

  if ! defined(Package['libtiff']) { package { 'libtiff': } }
  Lmod::Project['sopt'] -> Package['libtiff']

  if ! defined(Package['ninja']) { package { 'ninja': } }
  Lmod::Project['sopt'] -> Package['ninja']

  if ! defined(Package['fftw']) { package { 'fftw': } }
  Lmod::Project['sopt'] -> Package['fftw']

  if ! defined(Package['eigen']) { package { 'eigen': } }
  Lmod::Project['sopt'] -> Package['eigen']
}
