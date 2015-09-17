# Includes all general apps
class people::mdavezac::applications {
  include chrome
  include lastpass

  include brewcask
  include homebrew

  package { 'skype': provider           => 'brewcask' }
  package { 'slack': provider           => 'brewcask' }
  package { 'bettertouchtool': provider => 'brewcask' }
  package { 'the_silver_searcher': }
  package { 'lua': }
  package { 'luajit': }
  package { 'cmake': }
  package { 'dropbox': provider    => 'brewcask' }
  package { 'firefox': provider    => 'brewcask' }
}
