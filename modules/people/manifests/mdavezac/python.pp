# Declares a few standard pythons
class people::mdavezac::python {
  package {'python': }
  $packages = [
    'ipython[\'all\']', 'scipy', 'numpy',
    'cython', 'pytest', 'virtualenv'
  ]
  misc::pip{ $packages: }
}
