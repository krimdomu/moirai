#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

=head1 NAME

Moirai::Notification::EMail - Helper Functions to send mails.

=head1 DESCRIPTION

This class helps you sending mails on check failure.

=head1 SYNOPSIS

Configure the EMail Notification the following way.

 Moirai::Notification::EMail->configure(
    from => 'sender@bar.tld',
    to   => 'recipient@foo.tld',
    smtp => 'smtp.your.server.tld',
    user => 'smtpuser',
    password => 'smtppass',
    auth => 'PLAIN',
    ssl => 1,   # optional, to use ssl
 );

Use it in your Recipe the following way.

 EMail(
    subject => "Subject of the email",
 );
   
 EMail(
    subject => "Subject of the email",
    template => "/path/to/a/template/for/the/mail/body.tpl",
    additional_template_var1 => "foo",
    additional_template_var2 => "bar",
 );

Your template could look like this:

 There is something going wrong.
 Addition info 1: <%= $::additional_template_var1 %>
 Addition info 2: <%= $::additional_template_var2 %>

=head1 EXPORTED FUNCTIONS

=over 4

=cut

package Moirai::Notification::EMail;
   
use strict;
use warnings;
   
require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT %EMAIL_OPTION);

use Moirai::Logger;
use Moirai::Template;
use Net::SMTP_auth;
use Net::SMTP_auth::SSL;
use Data::Dumper;

@EXPORT = qw(EMail);

=item EMail(%option)

Function to send emails.

=cut
sub EMail {
   my (%option) = @_;

   my $smtp;

   if(exists $EMAIL_OPTION{ssl} && $EMAIL_OPTION{ssl} == 1) {
      my $port = $EMAIL_OPTION{port} || 465;
      $smtp = Net::SMTP_auth::SSL->new($EMAIL_OPTION{smtp}, Port => $port);
   }
   else {
      my $port = $EMAIL_OPTION{port} || 25;
      $smtp = Net::SMTP_auth->new($EMAIL_OPTION{smtp}, Port => $port);
   }

   if($smtp->auth($EMAIL_OPTION{auth}, $EMAIL_OPTION{user}, $EMAIL_OPTION{password})) {
      Moirai::Logger::debug("Successfully logged into SMTP host.");     

      $smtp->mail($EMAIL_OPTION{from});
      $smtp->to($EMAIL_OPTION{to});

      $smtp->data;
      $smtp->datasend(_generate_mail_content(%option));

      $smtp->dataend;
      $smtp->quit;
   }
   else {
      Moirai::Logger::info("Can't login to SMTP host. Please check your configuration.");     
   }

}

sub configure {
   my ($class, %option) = @_;
   %EMAIL_OPTION = %option;
}

sub _generate_mail_content {
   my (%option) = @_;

   if(exists $option{template}) {
      my $file_content = eval { local(@ARGV, $/) = ($option{template}); <>; };

      my $t = Moirai::Template->new;  

      my $s = "Subject: " . ($option{subject}?$option{subject}:"Check failed.") . "\n";
         $s.= "From: " . $EMAIL_OPTION{from} . "\n";
         $s.= "To: " . $EMAIL_OPTION{to} . "\n";
         $s.= "\n";

         $s.= $t->parse($file_content, \%option);

      return $s;
   }

   # no template, generate content
   my $s = "Subject: " . ($option{subject}?$option{subject}:"Check failed.") . "\n";
      $s.= "From: " . $EMAIL_OPTION{from} . "\n";
      $s.= "To: " . $EMAIL_OPTION{to} . "\n";
      $s.= "\n";

   for my $key (keys %option) {
      $s.= "$key: " . $option{$key} . "\n";
   }

   return $s;
}

=back

=cut

1;
