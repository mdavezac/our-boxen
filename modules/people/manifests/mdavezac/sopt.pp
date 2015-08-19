# Creates sopt project
class people::mdavezac::sopt {
  people::mdavezac::project { 'sopt':
    name       => 'sopt',
    repository => 'astro-informatics/sopt',
    python     => true
  } -> people::mdavezac::ctags {"${people::mdavezac::projects::workspaces}/sopt/src/sopt": }

  if ! defined(Package['libtiff']) { package { 'libtiff': } }
  People::Mdavezac::Project['sopt'] -> Package['libtiff']

  if ! defined(Package['ninja']) { package { 'ninja': } }
  People::Mdavezac::Project['sopt'] -> Package['ninja']

  if ! defined(Package['fftw']) { package { 'fftw': } }
  People::Mdavezac::Project['sopt'] -> Package['fftw']

  if ! defined(Package['eigen']) { package { 'eigen': } }
  People::Mdavezac::Project['sopt'] -> Package['eigen']
}
