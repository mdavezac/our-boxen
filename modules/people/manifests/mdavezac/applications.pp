# Includes all general apps
class people::mdavezac::applications {
  include chrome
  include lastpass

  include brewcask
  include homebrew

  package {
    'skype': provider => brewcask;
    'slack': provider => brewcask;

    'bettertouchtool': provider => brewcask;

    'cmake':;
    'the_silver_searcher':;
    'lua':;
    'luajit':;

    'mactex': provider =>  brewcask;
    'pandoc':;
  }
}
