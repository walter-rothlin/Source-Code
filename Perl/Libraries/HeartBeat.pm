
# $Header: /app/TIT/data/repositories/FT/plain_daily_production/interfaces/GMM/common/HeartBeat.pm,v 1.2 2009/04/29 16:55:02 msrivino Exp $

# @(#)HeartBeat.pm	1.2 08/23/07 20:39:04 /app/ft/build/tools/cgi/common/SCCS/s.HeartBeat.pm


# START---------------------------------------------------------------------
# Author:       Siebert Kruger 
# Description:  To send a HeartBeat to a parent process for as long as the
#               parent (main) process is alive - or until instructed otherwise.
#
# Usage example:
#  if (startHeartBeat(3) > 0) {
#       mainProgram;
#       if (!isHeartBeatSenderAlive) { print "HB Sender died\n" }
#       somemoremainProgram;
#       stopHeartBeat(); # if the main program died the HB can detect that
#                        # the main program does not live and terminate itself
#                        # after indicating that the main program died unexpectedly
#     }
#
#
# History:
#  01/10/03  V1.0 Siebert Kruger      Initial Version
#  02/04/03  V1.1 Siebert Kruger      Changed the HB to be the child process
#                                     and removed reaping of child process.
# END-----------------------------------------------------------------------
############################################################################
# Do not make any local changes to the code. It will be overwritten by the
# next release. Please submit a change request to Siebert.Kruger@csfb.com
############################################################################
$HeartBeatSccsId             = "@(#)HeartBeat.pm	1.2 08/23/07 20:39:04";
$HeartBeatLatestVersion      = "V1.1";
############################################################################
 
package main;
use POSIX qw(:sys_wait_h);

$TRUE  = 1;
$FALSE = 0;
$nPid  = 0;
$callbackHeartBeatStopSendingSignal;
 
sub startHeartBeat {
  my ($callbackHeartBeatStopSending, $callbackHeartBeatWriter, @callbackParam) = @_;
  $nPid = 0;
  $callbackHeartBeatStopSendingSignal = $callbackHeartBeatStopSending;

  if ($nPid = fork()) {
   # parent process
    print "Parent (main) is: $$ and child (HB) is: $nPid.\n";
  } else {
    # child process
    setHandlersChild();
    die "cannot fork: $!" unless defined $nPid;
    $nPid = 0;
    &$callbackHeartBeatWriter(@callbackParam);
  }
  return $nPid;}
 
sub stopHeartBeat {
  # only the parent should send this and only when the child is alive.
  my $returnCode = $FALSE;
  if ($nPid > 0) {
     # print "process $$ sends a USR1 signal to $nPid\n";
     kill USR1 => $nPid;
     $returnCode = $TRUE;
  } else {
     print "This process does not have an associated heartbeat to stop.\n";
  }
  return $returnCode;
}
 
sub isHeartBeatSenderAlive {
  return (kill 0 => $nPid) ? $TRUE : $FALSE;
}

sub isParentAlive {
   return getppid() == 1 ? $FALSE : $TRUE;
}

sub handler_Default {
  setHandlersChild();
  my $signame = shift;
  die "Somebody sent me $$ a SIG$signame";
}

sub handler_USR1 {
  &$callbackHeartBeatStopSendingSignal(0);
}

sub setHandlersChild {
  # $SIG{INT}       = \&handler_Default; to enable catching Ctrl+C
  $SIG{USR1}      = \&handler_USR1;
  $SIG{EXIT}      = \&handler_Default;
  $SIG{HUP}       = \&handler_Default;
  $SIG{QUIT}      = \&handler_Default;
  $SIG{ABRT}      = \&handler_Default;
  $SIG{KILL}      = \&handler_Default;
  $SIG{SYS}       = \&handler_Default;
  $SIG{TERM}      = \&handler_Default;
  $SIG{PWR}       = \&handler_Default;
  $SIG{STOP}      = \&handler_Default;
}

return 1;
