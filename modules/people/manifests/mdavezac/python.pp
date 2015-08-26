# Declares a few standard pythons
class people::mdavezac::python {
  package {['python', 'python3']: }
  $packages = [
    'ipython[\'all\']', 'scipy', 'numpy',
    'cython', 'pytest', 'virtualenv'
  ]
  misc::pip{ $packages: }
}
