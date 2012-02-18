#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Moirai::Incident;
   
use strict;
use warnings;
use Data::Dumper;
   
sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   $self->{failcounter} = 0;
   $self->{firstfail}   = 0;

   return $self;
}

sub run {
   my ($self) = @_;

   $self->{failcounter}++;

   if($self->{firstfail} + $self->{during} <= time()) {
      $self->{firstfail} = time();
   }

   if($self->{firstfail} + $self->{during} >= time()
         && $self->{failcounter} >= $self->{errors}) {
      my $code = $self->{actions};
      &$code();

      # reset everything
      $self->{firstfail} = time();
      $self->{failcounter} = 0;
   }
}
   
1;
