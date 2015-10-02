define misc::catch(
  $prefix,
) {
  $url = 'https://raw.githubusercontent.com/philsquared/Catch/develop/single_include/catch.hpp'
  file { "${prefix}-include":
    ensure => directory
  } -> exec { "${prefix}/include/catch.hpp":
    command => "curl -L ${url} -o ${prefix}/include/catch.hpp"
  }
}
