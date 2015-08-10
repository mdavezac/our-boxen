class people::mdavezac::applications {
  include chrome
  include dropbox
  include vagrant
  include lastpass
 
  include brewcask
  include homebrew
  package { 'skype': provider => 'brewcask' } 
  package { 'the_silver_searcher': }
}
