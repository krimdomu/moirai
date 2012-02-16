#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

=head1 NAME

Moirai::Monitor::Memory - Helper Functions to monitor memory usage of a process.

=head1 DESCRIPTION

With this class you can monitor memory usage of a process.

=head1 SYNOPSIS

   Memory(
      pid        => Process->pid("/usr/bin/foo"),
      freq       => Time->seconds(1),
      max        => Size->MB(50),
      fail       => sub {
         # do something on a failure
      },
   );

=head1 EXPORTED FUNCTIONS

=over 4

=cut


   
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

=item Memory

Monitor Memory of a process.

=cut
sub Memory {
   return Moirai::Monitor::Memory->new(@_);
}

sub _check {
   my ($self) = @_;

   my ($process) = grep { $_->{pid} == $self->{pid} } ps();

   if($process->{rss} <= $self->{max}) {
      # erverything's green
      return 0;
   }

   # red! alert!
   return $process->{rss};
}

=back

=cut

1;
