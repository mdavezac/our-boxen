# Creates sopt project
class projects::sopt($python = 3) {
  require lmod
  lmod::project { 'sopt':
    repository => 'astro-informatics/sopt',
    python     => 3
  } -> misc::ctags {"${lmod::config::workspaces}/sopt/src/sopt": }

  if ! defined(Package['libtiff']) { package { 'libtiff': } }
  Package['libtiff'] -> Lmod::Project['sopt']

  if ! defined(Package['ninja']) { package { 'ninja': } }
  Package['ninja'] -> Lmod::Project['sopt']

  if ! defined(Package['fftw']) { package { 'fftw': } }
  Package['fftw'] -> Lmod::Project['sopt']

  if ! defined(Package['eigen']) { package { 'eigen': } }
  Package['eigen'] -> Lmod::Project['sopt']
}
