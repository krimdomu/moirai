use strict;
use warnings;

use Test::More tests => 2;

use_ok 'Moirai::Monitor::HTTP';
Moirai::Monitor::HTTP->import;

my $http_mon = HTTP(
      GET     => "foo",
      freq    => 5,
      timeout => 5,
      fail    => sub {
      },
);

ok(ref $http_mon eq "Moirai::Monitor::HTTP", "create http monitor");

