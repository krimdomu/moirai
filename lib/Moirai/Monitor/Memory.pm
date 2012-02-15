#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Moirai::Monitor::Memory;
   
use strict;
use warnings;

require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT);

use Rex::Commands::Process;
use Moirai::Monitor;
use Data::Dumper;
use base qw(Moirai::Monitor);
    
@EXPORT = qw(Memory);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = $that->SUPER::new(@_);

   bless($self, $proto);

   return $self;
}

sub Memory {
   return Moirai::Monitor::Memory->new(@_);
}

sub _check {
   my ($self) = @_;

   my ($process) = grep { $_->{pid} == $self->{pid} } ps();

   if($process->{rss} <= $self->{max_memory}) {
      # erverything's green
      return 0;
   }

   # red! alert!
   return $process->{rss};
}


1;
