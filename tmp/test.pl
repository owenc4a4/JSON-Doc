use 5.016;
use lib 'lib';

use Path::Class;
use CLI::JSON::MD;



my $file = file('tmp/json.json');
system("perl tmp/build.pl");
printf "file:%s \n\n", $file->stringify;

CLI::JSON::MD->run($file->stringify);
