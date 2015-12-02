# Declares a few standard pythons
class people::mdavezac::python {
  $packages = [
    'ipython[\'all\']', 'scipy', 'numpy',
    'cython', 'pytest', 'virtualenv'
  ]
  package {['python', 'python3']: }
  -> misc::pip{ $packages: }
}
