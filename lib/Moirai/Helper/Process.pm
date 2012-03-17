#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Moirai::Helper::Process;
   
use strict;
use warnings;

require Exporter;
use base qw(Exporter);

use vars qw(@EXPORT);

@EXPORT = qw(ps);

sub ps {
   my @list = qx(ps aux);

   if($? != 0) {
      die("Error running ps aux");
   }
   shift @list;

   my @ret = ();
   for my $line (@list) {
      my ($user, $pid, $cpu, $mem, $vsz, $rss, $tty, $stat, $start, $time, $command) = split(/\s+/, $line, 11);

      push( @ret, {
         user     => $user,
         pid      => $pid,
         cpu      => $cpu,
         mem      => $mem,
         vsz      => $vsz,
         rss      => $rss,
         tty      => $tty,
         stat     => $stat,
         start    => $start,
         time     => $time,
         command  => $command,
      });
   }

   return @ret;
}

1;
