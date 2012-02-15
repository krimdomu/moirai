#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Moirai::Service;
   
use strict;
use warnings;

use Data::Dumper;
use POSIX ":sys_wait_h";

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   # default user and group
   $self->{user}  ||= "daemon";
   $self->{group} ||= "daemon";

   unless($self->{name}) {
      die("You have to specify a name for your service.");
   }

   return $self;
}

sub run {
   my ($self, %option) = @_;

   my $pid = fork;
   unless($pid) {
      # write pid file for worker
      my $pid_file_name = $self->{name};
      $pid_file_name =~ s/[\s\/\\]/_/gms;

      open(my $fh, ">", $option{pid_path} . "/$pid_file_name.pid") or die($!);
      print $fh $$;
      close($fh);
      $self->_monitor->run;
      exit 0;
   }
   elsif($pid) {
      waitpid ($pid, &WNOHANG);
   }
}

sub stop {
   my ($self, %option) = @_;

   my $pid_file_name = $self->{name};
   $pid_file_name =~ s/[\s\/\\]/_/gms;

   my $pid_path = $option{pid_path} || "/var/lib";
   my $pid = eval { local(@ARGV, $/) = ("$pid_path/$pid_file_name.pid"); <>; };
   chomp $pid;

   if(kill 9, $pid) {
      unlink("$pid_path/$pid_file_name.pid");
      return 1;
   }

}

sub _monitor {
   my ($self) = @_;
   return $self->{monitor};
}

1;
