#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Moirai::Notification::EMail;
   
use strict;
use warnings;
   
require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT %EMAIL_OPTION);

use Net::SMTP_auth;
use Net::SMTP_auth::SSL;
use Data::Dumper;

@EXPORT = qw(EMail);

sub EMail {
   my (%option) = @_;

   my $smtp = Net::SMTP_auth::SSL->new($EMAIL_OPTION{smtp}, Port => 465);

   if($smtp->auth($EMAIL_OPTION{auth}, $EMAIL_OPTION{user}, $EMAIL_OPTION{password})) {
      print "auth cool\n";
   }
   else {
      print Dumper($smtp);
      print "auth fail\n";
   }

}

sub configure {
   my ($class, %option) = @_;
   %EMAIL_OPTION = %option;
}

1;
