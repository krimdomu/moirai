#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
=head1 NAME

Moirai::Monitor::HTTP - Helper Functions to monitor HTTP.

=head1 DESCRIPTION

With this class you can monitor HTTP Services.

=head1 SYNOPSIS

    HTTP(
       GET     => "http://www.google.com/",
       freq    => Time->seconds(1),
       timeout => Time->ms(10),
       fail    => sub {
          # do something on a failure
       },
    );

=head1 EXPORTED FUNCTIONS

=over 4

=cut


package Moirai::Monitor::HTTP;
   
use strict;
use warnings;

require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT);

use Moirai::Monitor;
use LWP::UserAgent;
use Data::Dumper;
use base qw(Moirai::Monitor);
    
@EXPORT = qw(HTTP);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = $that->SUPER::new(@_);

   bless($self, $proto);

   return $self;
}

=item HTTP

Monitor HTTP Services.

=cut

sub HTTP {
   return Moirai::Monitor::HTTP->new(@_);
}

sub _check {
   my ($self) = @_;

   my $ua = LWP::UserAgent->new;
   $ua->timeout($self->{timeout});

   my $resp = $ua->get($self->{GET});
   if($resp->is_success) {
      return 0; # pass
   }

   return $resp; # fail
}

=back

=cut

1;
