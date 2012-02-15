#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Moirai::Logger;
   
use strict;
use warnings;

use Sys::Syslog;
my $log_fh;
our $debug = 0;

sub import {
   eval {
      openlog("moirai", "ndelay,pid", "local0");
   };
}

sub info {
   my ($msg) = @_;
   syslog("info", $msg);
}

sub debug {
   my ($msg) = @_;
   return unless $debug;

   syslog("debug", $msg);
}

END {
   eval {
      closelog();
   };
};

1;
