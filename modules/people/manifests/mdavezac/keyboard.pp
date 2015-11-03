# All configs for karabiner
class people::mdavezac::keyboard {
  include karabiner
  # launch and add login-item
  include karabiner::login_item

  # create profile
  karabiner::profile{ 'Default': }
  -> karabiner::set {
    'Default repeat.wait':
      identifier => 'repeat.wait',
      value      => 42;
    'Default repeat.initial_wait':
      identifier => 'repeat.initial_wait',
      value      => 401;
  }

  # create profile
  karabiner::profile{ 'office': }
  -> karabiner::set {
    'remap.uk_backslash2hash':
      value      => 1,
      profile    => 'office';
    'remap.uk_swap_at_doublequote':
      value      => 1,
      profile    => 'office';
    'remap.uk_section2backslash':
      value      => 1,
      profile    => 'office';
    'office repeat.wait':
      identifier => 'repeat.wait',
      value      => 43,
      profile    => 'office';
    'office repeat.initial_wait':
      identifier => 'repeat.initial_wait',
      value      => 400,
      profile    => 'office';
  }
}
