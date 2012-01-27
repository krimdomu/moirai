#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Moirai;

use strict;
use warnings;

use Moirai::Time;
use Moirai::Service;
use Moirai::Logger;
use Moirai::Incident;
use Data::Dumper;

require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT);

@EXPORT = qw(Service Incident Time say run);

use vars qw(@services $log_file);

my %incidents = ();

sub Service {
   my (%service) = @_;
   my $service = Moirai::Service->new(%service);

   push(@services, $service);
}

sub Incident {
   my ($package, $file, $line) = (caller);

   if(exists $incidents{"$package-$file-$line"}) {
      $incidents{"$package-$file-$line"}->run;
   }
   else {
      $incidents{"$package-$file-$line"} = Moirai::Incident->new(@_);
      $incidents{"$package-$file-$line"}->run;
   }
}

sub Time {
   return Moirai::Time->new;
}

sub say {
   print join(" ", @_) . "\n";
}

sub run {
   for my $service (@services) {
      $service->run;
   }
}

1;
