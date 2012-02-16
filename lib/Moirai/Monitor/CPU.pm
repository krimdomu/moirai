#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

=head1 NAME

Moirai::Monitor::CPU - Helper Functions to monitor cpu usage of a process.

=head1 DESCRIPTION

With this class you can monitor cpu usage of a process.

=head1 SYNOPSIS

   CPU(
      pid        => Process->pid("/usr/bin/foo"),
      freq       => Time->seconds(1),
      max        => 50,  # percent
      fail       => sub {
         # do something on a failure
      },
   );

=head1 EXPORTED FUNCTIONS

=over 4

=cut


   
package Moirai::Monitor::CPU;
   
use strict;
use warnings;

require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT);

use Rex::Commands::Process;
use Moirai::Monitor;
use Data::Dumper;
use base qw(Moirai::Monitor);
    
@EXPORT = qw(CPU);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = $that->SUPER::new(@_);

   bless($self, $proto);

   return $self;
}

=item CPU

Monitor CPU usage of a process.

=cut
sub CPU {
   return Moirai::Monitor::CPU->new(@_);
}

sub _check {
   my ($self) = @_;

   my ($process) = grep { $_->{pid} == $self->{pid} } ps();

   if($process->{cpu} <= $self->{max}) {
      # erverything's green
      return 0;
   }

   # red! alert!
   return $process->{cpu};
}

=back

=cut

1;
