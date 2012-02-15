#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
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

sub Service {
   my (%service) = @_;
   my $service = Moirai::Service->new(%service);

   push(@services, $service);
}

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

sub Time {
   return Moirai::Time->new;
}

sub Size {
   return Moirai::Size->new;
}

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

1;
