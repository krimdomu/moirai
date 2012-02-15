#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Moirai::Process;
   
use strict;
use warnings;

use Rex::Commands::Process;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}

sub pid {
   shift;
   
   my ($process) = grep { $_->{command} eq $_[0] } ps();
   return $process->{pid};
}

1;
