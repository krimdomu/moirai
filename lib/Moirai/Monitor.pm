#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Moirai::Monitor;
   
use strict;
use warnings;
use Data::Dumper;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}

sub run {
   my ($self) = @_;

   my $frequence = $self->{freq} || 30;

   while(1) {
      
      if(my $ret = $self->_check) {
         # fail
         my $code = $self->{fail} || sub {};
         if($self->{incident}) {
            &$code($ret, $self->{incident});
         }
         else {
            $self->{incident} = &$code($ret);
         }
      }

      select undef, undef, undef, $frequence;
   }

}

sub _check {
   die("_check must be implemented by monitor");
}

1;
