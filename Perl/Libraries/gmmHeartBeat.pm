
# $Header: /app/TIT/data/repositories/FT/plain_daily_production/interfaces/GMM/common/gmmHeartBeat.pm,v 1.2 2009/04/29 16:55:02 msrivino Exp $

# @(#)gmmHeartBeat.pm	1.2 08/23/07 20:39:03 /app/ft/build/tools/cgi/common/SCCS/s.gmmHeartBeat.pm

# START---------------------------------------------------------------------
# Author:       Siebert Kruger 
# Description:  Contains the functions for gmm heart beat sending (gmm application control)
#
# History:
#  01/10/03  V1.0 Siebert Kruger      Initial Version
#  02/04/03  V1.1 Siebert Kruger      Changed to work with modified HeartBeat (v1.1)
# END-----------------------------------------------------------------------
############################################################################
# Do not make any local changes to the code. It will be overwritten by the
# next release. Please submit a change request to Siebert.Kruger@csfb.com
############################################################################
$gmmHeartBeatSccsId             = "@(#)gmmHeartBeat.pm	1.2 08/23/07 20:39:03 /app/ft/build/tools/cgi/common/SCCS/s.gmmHeartBeat.pm";
$gmmHeartBeatLatestVersion      = "V1.1";
############################################################################

package main;

$appcDbAbriv           = "NY_GMM";
$heartBeatTimeInterval = 10; 
$bSend                 = $TRUE;
$hbLogfileName         = "";
$hbVerbal              = "";
$hbNode                = "";
$hbLocInstance         = "";
$hbCityCode            = "";
$hbApplicationGroup    = "";
$hbApplicationName     = "";


# return value must be 0 for success
# any other value indicates the PID of the new process
sub gmmStartHeartBeat {
  my ($node, $instance, $location, $applicationGroup, $applicationName, $logfile, $verbal) = @_;
  $node                 = setDefault($node,getMyUnixFullHostname());
  $locInstance          = setDefault($locInstance,$instance);
  $cityCode             = setDefault($cityCode,$location);
  $applicationGroup     = setDefault($applicationGroup,"");
  $applicationName      = setDefault($applicationName,"");
  $verbal               = setDefault($verbal,$TRUE);
  $hbLogfileName        = $logfile;
  $hbVerbal             = $verbal;
  $hbNode               = $node;
  $hbLocInstance        = $locInstance;
  $hbCityCode           = $cityCode;
  $hbApplicationGroup   = $applicationGroup;
  $hbApplicationName    = $applicationName;
  $appcExitCode = 0;

  addToLogFile("Starting heartbeat sender for ${node}, ${locInstance}, ${cityCode}, ${applicationGroup}, ${applicationName}",$logfile,$verbal);
  appcStatusUpdate_dbAbv($appcDbAbriv,$appcDbPriv,$node,$locInstance,$cityCode,$applicationGroup,$applicationName,"Started logfile:${logfile}", $logfile, $FALSE);
  appcInitExceptionStatus_dbAbv($appcDbAbriv,$appcDbPriv,$node,$locInstance,$cityCode,$applicationGroup,$applicationName,"", $logfile, $FALSE);
  my $retVal = startHeartBeat(\&gmmSignalStopSending, \&gmmSendHB, $heartBeatTimeInterval, "",$node, $locInstance, $cityCode, $applicationGroup, $applicationName, $logfile, $verbal);
  
  return $retVal;
}
 
# callback function to send HearBbeat to the gmm database
 sub gmmSendHB {
  my ($nDelay, $nCharToPrint, $node, $instance, $location, $applicationGroup, $applicationName, $logfile, $verbal) = @_; 
  $bSend = $TRUE;

  my($gmmDb,$gmmDbLogin,$gmmDbPassword) = getGmmDbLoginForHeartBeat($appcDbAbriv);
  my($hbDbHandler) = dbConnect($gmmDb,$gmmDbLogin,$gmmDbPassword,"",$TRUE,$TRUE);
  addToLogFile("Heartbeat sender ($$) has started for ${node}, ${instance}, ${location}, ${applicationGroup}, ${applicationName}",$logfile,$verbal);
  appcStatusUpdate_dbh($hbDbHandler,$node,$instance,$location,$applicationGroup,$applicationName,"HeartBeat started", $logfile, $FALSE);
  my $hbcounter = 0;
  while ($bSend == $TRUE) {
      if ($nCharToPrint ne "") {
        print("${nCharToPrint}\n");
      }
      ### print("Going to send HB  ${hbcounter}...\n");
      my $retVal = appcSendHeartBeat_dbh($hbDbHandler,$node,$instance,$location,$applicationGroup,$applicationName, $logfile, $FALSE);
      ### if ($retVal eq "") {
      ###    print(".... HB  ${hbcounter} sent\n");
      ### } else {
      ###    print(".... HB  ${hbcounter} could not be sent\n${retVal}");
      ### }
      $hbcounter++;
      sleep $nDelay;
      
      if (isParentAlive() == $FALSE)
      {
	      # main process died. The HeartBeat should be stopped
	      print "*** Exception: The main program has died!!!***\n";
	      gmmSignalStopSending(-1);
      }
      
  }
  addToLogFile("Heartbeat sender ($$) has stopped for ${node}, ${instance}, ${location}, ${applicationGroup}, ${applicationName}",$logfile,$verbal);
  if ($appcExitCode == 0) {
     appcStatusUpdate_dbh($hbDbHandler,$node,$instance,$location,$applicationGroup,$applicationName,"HeartBeat stopped", $logfile, $FALSE);
  }
  dbDisconnect($hbDbHandler);
}

# callback function to be executed when the main program indicates to stop sending the HeartBeat
sub gmmSignalStopSending {
  my($exitCode) = @_;
  $appcExitCode = $exitCode;
  $bSend = $FALSE;
  if ($exitCode != 0) {
     addToLogFile("ERROR:Application stopped with error on ${hbNode}, ${hbLocInstance}, ${hbCityCode}, ${hbApplicationGroup}, ${hbApplicationName}",$hbLogfileName,$hbVerbal);
     appcStatusUpdate_dbAbv($appcDbAbriv,$appcDbPriv,$hbNode,$hbLocInstance,$hbCityCode,$hbApplicationGroup,$hbApplicationName,"ERROR: Application stopped with ret code ${exitCode}", $hbLogfileName, $FALSE);
     appcExceptionStatusUpdate_dbAbv($appcDbAbriv,$appcDbPriv,$hbNode,$hbLocInstance,$hbCityCode,$hbApplicationGroup,$hbApplicationName,"ERROR: Application crashed", $hbLogfileName, $FALSE);
  }
}

sub gmmStopHeartBeat {
  my ($node, $instance, $location, $applicationGroup, $applicationName, $errorFound, $logfile, $verbal) = @_;
  addToLogFile("Stopping heartbeat sender for ${node}, ${instance}, ${location}, ${applicationGroup}, ${applicationName}",$logfile,$verbal);
  $node                 = setDefault($node,getMyUnixFullHostname());
  $locInstance          = setDefault($locInstance,$instance);
  $cityCode             = setDefault($cityCode,$locationCode);
  $applicationGroup     = setDefault($applicationGroup,"");
  $applicationName      = setDefault($applicationName,"");
  $verbal               = setDefault($verbal,$TRUE);
  stopHeartBeat();
  sleep 5;
  if ($errorFound) {
      appcStatusUpdate_dbAbv   ($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$applicationGroup,$applicationName,"ERROR: Application finished with a problem", $logfile, $FALSE);
  } else {
      appcStatusUpdate_dbAbv   ($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$applicationGroup,$applicationName,"Finished", $logfile, $FALSE);
      appcDeleteHeartBeat_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$applicationGroup,$applicationName, $logfile, $FALSE);
  }
}

# To determine whether the HeartBeat sender is still active and working
sub gmmIsHeartBeatSenderAlive {
  return isHeartBeatSenderAlive();
}

return 1; 
