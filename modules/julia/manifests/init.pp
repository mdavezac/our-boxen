class julia {
  homebrew::tap{'staticfloat/homebrew-julia': }
  package {'julia':
    require => Homebrew::Tap['staticfloat/homebrew-julia']
  }
}
