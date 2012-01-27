#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
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

sub seconds { 
   shift; 
   return shift;
}

sub s {
   shift;
   return __PACKAGE__->seconds(@_);
}

sub miliseconds {
   shift;
   my $ms = shift;
   return $ms / 1000;
}

sub ms {
   shift;
   return __PACKAGE__->miliseconds(@_);
}

1;
