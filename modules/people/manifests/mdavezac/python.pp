class people::mdavezac::python {
  $version = "3.4.1"
  python::version { $version: }
  class { 'python::global': version => $version }
  python::package {"virtualenv for ${version}": package => 'virtualenv', python  => $version}
  python::package {"ipython for ${version}": package => "ipython['all']", python  => $version}
  python::package {"numpy for ${version}": package => "numpy", python  => $version}
  python::package {"scipy for ${version}": package => "scipy", python  => $version}
}
