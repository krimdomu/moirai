use strict;
use warnings;

use Test::More tests => 2;

use_ok 'Moirai::Monitor::Memory';
Moirai::Monitor::Memory->import;

my $memory_mon = Memory(
      freq       => 5,
      max_memory => 5,
      fail    => sub {
      },
);

ok(ref $memory_mon eq "Moirai::Monitor::Memory", "create memory monitor");

