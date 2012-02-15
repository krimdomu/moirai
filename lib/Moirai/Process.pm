#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

=head1 NAME

Moirai::Process - Helper Functions to work with processes.

=head1 DESCRIPTION

Helper Functions to work with processes.

=head1 SYNOPSIS

Use it in your Recipe the following way.

 Process->pid("foo")

=head1 EXPORTED FUNCTIONS

=over 4

=cut

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

=item pid($cmd)

Returns the pid of the given $cmd.

=cut
sub pid {
   shift;
   
   my ($process) = grep { $_->{command} eq $_[0] } ps();
   return $process->{pid};
}

=back

=cut

1;
