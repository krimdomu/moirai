#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

=head1 NAME

Moirai::Size - Helper Functions to calculate sizes.

=head1 DESCRIPTION

This class helps you calculating typical sizes used by Moirai.

=head1 SYNOPSIS

Use it in your Recipe the following way.

 Size->MB(5)
 Size->GB(2)

=head1 EXPORTED FUNCTIONS

=over 4

=cut

package Moirai::Size;
   
use strict;
use warnings;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}

=item MB($megabyte)

Returns the given value in bytes.

=cut
sub MB {
   shift;
   return $_[0] * 1024;
}

=item GB($gigabyte)

Returns the given value in bytes.

=cut
sub GB {
   shift;
   return $_[0] * 1024 * 1024;
}

=back

=cut

1;
