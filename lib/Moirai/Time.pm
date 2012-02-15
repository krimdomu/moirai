#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
=head1 NAME

Moirai::Time - Helper Functions to calculate times.

=head1 DESCRIPTION

This class helps you calculating typical times used by Moirai.

=head1 SYNOPSIS

Use it in your Recipe the following way.

 Time->s(5)
 Time->seconds(5)
 Time->ms(40)
 Time->miliseconds(40)

=head1 EXPORTED FUNCTIONS

=over 4

=cut


package Moirai::Time;
   
use strict;
use warnings;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}

=item seconds($seconds)

Returns the given value in seconds.

=cut
sub seconds { 
   shift; 
   return shift;
}

=item s($seconds)

Just an alias for $self->seconds().

=cut
sub s {

   shift;
   return __PACKAGE__->seconds(@_);
}

=item miliseconds($miliseconds)

Returns the given value in seconds. (For example 0.04)

=cut
sub miliseconds {
   shift;
   my $ms = shift;
   return $ms / 1000;
}

=item ms($miliseconds)

Just an alias for $self->miliseconds().

=cut
sub ms {
   shift;
   return __PACKAGE__->miliseconds(@_);
}

=back

=cut

1;
