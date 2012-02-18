#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
=head1 NAME

Moirai::Monitor::SMTP - Helper Functions to monitor SMTP.

=head1 DESCRIPTION

With this class you can monitor SMTP Services. This CHECK will check for your server banner to appear.

=head1 SYNOPSIS

    SMTP(
       server  => "your-smtp-server",
       port    => 25,
       freq    => Time->seconds(1),
       timeout => Time->ms(10),
       fail    => sub {
          # do something on a failure
       },
    );

=head1 EXPORTED FUNCTIONS

=over 4

=cut


package Moirai::Monitor::SMTP;
   
use strict;
use warnings;

require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT);

use Moirai::Monitor;
use IO::Socket;
use Time::HiRes qw(ualarm);
use Data::Dumper;
use base qw(Moirai::Monitor);
    
@EXPORT = qw(SMTP);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = $that->SUPER::new(@_);

   bless($self, $proto);

   return $self;
}

=item SMTP

Monitor SMTP Services.

=cut

sub SMTP {
   return Moirai::Monitor::SMTP->new(@_);
}

sub _check {
   my ($self) = @_;

   my $sock = IO::Socket::INET->new(PeerAddr => $self->{server},
                                 PeerPort => $self->{port},
                                 Proto    => 'tcp');


   my $greet="";
   eval {
      local $SIG{ALRM} = sub { die("Timed out."); };
      ualarm $self->{timeout} * 1000000;
      my $greet = <$sock>;
      ualarm 0;
   };

   close $sock;

   if($@ || $greet !~ m/^220/ms) {
      return 1;
   }

   return 0; # pass, no timeout
}

=back

=cut

1;
