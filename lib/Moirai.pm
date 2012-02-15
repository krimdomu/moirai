#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

=head1 NAME

Moirai - Simple small script based monitoring Library

=head1 DESCRIPTION

With Moirai you can write small recipes to monitor your services and to responde to failures.

=head1 SYNOPSIS

 #!/usr/bin/perl
    
 use Moirai;
 use Moirai::Monitor::HTTP;
 use Moirai::Notification::EMail;
    
 use base qw(Moirai);
    
 Moirai::Notification::EMail->configure(
    from => 'xxx',
    to   => 'xxx',
    smtp => 'xxx',
    user => 'xxx',
    password => 'xxx',
    auth => 'PLAIN',
 );
     
 Service(
    name    => "google-search-latency",
    monitor => HTTP(
       GET     => "http://www.google.com/",
       freq    => Time->seconds(1),
       timeout => Time->ms(80),
       fail    => sub {
     
          # notify only on 5 failures during 10 seconds
          Incident(
             errors => 5,
             during => Time->seconds(10),
             actions => sub {
                EMail(
                   subject => "Google search failed.",
                );
             }
          ),

       },
    )
 );
    
 run;

=head1 START MONITORING

To start monitoring just execute your Moirai Recipe.

 chmod 700 /path/to/your/recipe
 /path/to/your/recipe
 
There are a few cli parameters you can use to modify runtime behaviour.

 /path/to/your/recipe --pid_path /path/to/directroy/of/pidfiles

=head1 STOP MONITORING

To stop monitoring your services execute the following.

 /path/to/your/recipe --stop [--pid_path /path/to/directroy/of/pidfiles]

=head1 EXPORTED FUNCTIONS

=over 4

=cut

package Moirai;

use strict;
use warnings;

use Moirai::Size;
use Moirai::Process;
use Moirai::Time;
use Moirai::Service;
use Moirai::Logger;
use Moirai::Incident;
use Data::Dumper;

require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT);

our $VERSION = "0.0.1";

@EXPORT = qw(Service Incident Time Size Process say run);

use vars qw(@services $log_file);

my %incidents = ();
my $opts      = {}; 

READ_OPTS: {
   for(my $i=0; $i<@ARGV; $i++) {

      if($ARGV[$i] =~ m/^\-\-([a-z0-9\-_]+)/) {
         my $key = $1; 
         if(! $ARGV[$i+1] || $ARGV[$i+1] =~ m/^\-\-/) {
            $opts->{$key} = 1;                                                                                      
         }   
         else {
            if(exists $opts->{$key}) {
               $opts->{$key} = [ $opts->{$key} ] if (! ref $opts->{$key});

               push(@{$opts->{$key}}, $ARGV[++$i]);
            }   
            else {
               $opts->{$key} = $ARGV[++$i];
            }   
         }   
      }   

   }
}

=item Service

Create a service.

=cut
sub Service {
   my (%service) = @_;
   my $service = Moirai::Service->new(%service);

   push(@services, $service);
}

=item Incident

Create a incident.

=cut
sub Incident {
   my ($package, $file, $line) = (caller);

   if(exists $incidents{"$package-$file-$line"}) {
      $incidents{"$package-$file-$line"}->run;
   }
   else {
      $incidents{"$package-$file-$line"} = Moirai::Incident->new(@_);
      $incidents{"$package-$file-$line"}->run;
   }
}

=item Time

Helper Class to work with Time. See L<Moirai::Time> for more information.

=cut
sub Time {
   return Moirai::Time->new;
}

=item Size

Helper class to work with sizes. See L<Moirai::Size> for more information.

=cut
sub Size {
   return Moirai::Size->new;
}

=item Process

Helper class to work with processes. See L<Moirai::Process> for more information.

=cut
sub Process {
   return Moirai::Process->new;
}

sub say {
   print join(" ", @_) . "\n";
}

sub run {
   if(exists $opts->{stop}) {
      for my $service (@services) {
         $service->stop(%{ $opts });
      }

      exit 0;
   }

   # default pid path
   $opts->{pid_path} ||= "/var/lib";

   # fork starting process
   my $pid = fork;
   unless($pid) {

      # close STD* handles
      close(STDOUT);
      close(STDERR);

      for my $service (@services) {
         $service->run(%{ $opts });
      }

      exit 0;
   }
   else {
      waitpid $pid, 0;
   }
}

=back

=cut

1;
