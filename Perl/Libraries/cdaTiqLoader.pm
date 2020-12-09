
package main;	#has to be "main"

# $Header: /app/TIT/data/repositories/FT/plain_daily_production/interfaces/GMM/common/cdaTiqLoader.pm,v 1.2 2009/04/29 16:55:02 msrivino Exp $

# @(#)cdaTiqLoader.pm	1.5 09/11/08 11:14:35 /app/ft/build/tools/cgi/common/SCCS/s.cdaTiqLoader.pm

#
# START---------------------------------------------------------------------
# Author:        Walter Rothlin
# Description:   Contains some common function used for cdaTiqLoaders  
#
#
#
# History:
# 06/07/01    V1.0  Walter Rothlin    Initial Version
# 07/02/01    V1.1  Walter Rothlin    Add cdaTblCleanup
# 07/27/01    V1.2  Walter Rothlin    Changed that ${xxx} can be used in commonControl entries
#                                     Add getLatestDayWithDataFromCdaMsgIn_dbh
# 11/30/01    V1.3  Dmitriy Volfson   Replaced nyweb1.fi.csb.com with gmm.app.csfb.net
# 04/22/02    V1.4  Walter Rothlin    Fix bug with wrong link in e-mail
# 05/13/02    V1.5  Walter Rothlin    Add mapping table for loader file
#                                     Add site specific desc files for dealloader
#                                     Add site specific desc files for dealloader
# 02/10/04    V1.6  Dmitriy Volfson   Changed email URL
# 08/27/07    V1.7  Walter Rothlin    Added CVS header
# 08/28/07    V1.8  Walter Rothlin    Just a test for CVS migration
# 09/11/08    V1.9  Wale   Ashish     Made changes to merge the code with FT7.
# END-----------------------------------------------------------------------
#
############################################################################
# Do not make any local changes to the code. It will be overwritten by the
# next release. Please submit a change request to Walter.Rothlin@csfb.com
############################################################################
$cdaTiqLoaderSccsId             = "@(#)cdaTiqLoader.pm	1.5 09/11/08 11:14:35";
$cdaTiqLoaderLatestVersion      = "V1.9";
############################################################################


# some definitions used by the web monitor
# ----------------------------------------
$cWebActionDoDisableCdaLoader  = "DoDisableLoader";
$cWebActionDoEnableCdaLoader   = "DoEnableLoader";
$cWebActionDoShutdownCdaLoader = "DoShutdownLoader";

$cWebActionDoDisableCdaSubscriber  = "DoDisableSubscriber";
$cWebActionDoEnableCdaSubscriber   = "DoEnableSubscriber";
$cWebActionDoShutdownCdaSubscriber = "DoShutdownSubscriber";


# picks up a filed in a string (should go in a library)
sub getFieldFromText {
  my($SplitChar,$FieldPosition,$LongString) = @_;
  return getFieldFromString($SplitChar,$FieldPosition,$LongString,"");
}

sub changeText {
  my($wholeText,$oldText,$newText) = @_;
  my $posStart    = index($wholeText,$oldText);
  my $startOfText = substr($wholeText,0,$posStart);
  my $endOfText   = substr($wholeText,$posStart + length($oldText), length($wholeText) - $posStart - length($oldText));
  return "${startOfText}${newText}${endOfText}";
}

sub getLatestDayWithDataFromCdaMsgIn_dbh {
   my($dbh,$foSysId,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   my $whereClause = "";
   if ($foSysId ne "") {
     $whereClause = "where FO_PUB_SYS_C = '${foSysId}'";
   }
   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
    SELECT
     max(to_char(RECV_TIMESTAMP,'YYYYMMDD'))         RECV_DATE
     from CDA_MESSAGE_IN ${whereClause}
   };
   printf("<!-- aSqlStmt:${aSqlStmt}: -->\n");
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{RECV_DATE};
   }
   return $retStr;
}


sub prepareSomeSqlStatemens {
  my($dbh) = @_;
  my $sqlForGetNewDeals = qq {
         select CDA_TRN_SEQ_ID,
                DEAL_TYPE,
                RECV_TIMESTAMP,
                FO_PUB_SYS_C,
                FO_INTRL_ID,
                FO_INTRL_VERS_ID,
                LOADER_ACTION,
                DESCRIPTOR_FILE,
                FORMAT_TYPE,
                FORMATTED_DATA                       
         from  CDA_MESSAGE_IN
         where MESSAGE_STATE = 'PEND' ${optionalWhereClause}
         order by CDA_TRN_SEQ_ID
  };
  #  if ($IsTest) { print("sqlForGetNewDeals:${sqlForGetNewDeals}:\n"); }
  $preparedSqlForGetNewDeals = $dbh->prepare($sqlForGetNewDeals);

  my $sqlForGetFailedDeals = qq {
         select CDA_TRN_SEQ_ID,
                DEAL_TYPE,
                RECV_TIMESTAMP,
                FO_PUB_SYS_C,
                FO_INTRL_ID,
                FO_INTRL_VERS_ID,
                LOADER_ACTION,
                DESCRIPTOR_FILE,
                FORMAT_TYPE,
                FORMATTED_DATA                       
         from  CDA_MESSAGE_IN
         where MESSAGE_STATE = 'FAIL' ${optionalWhereClause}
         order by CDA_TRN_SEQ_ID
  };
  #  if ($IsTest) { print("sqlForGetFailedDeals:${sqlForGetFailedDeals}:\n"); }
  $preparedSqlForGetFailedDeals = $dbh->prepare($sqlForGetFailedDeals);

  my $sqlForCountsOfFailed = qq {
         select count(*) COUNT                       
         from  CDA_MESSAGE_IN
         where MESSAGE_STATE = 'FAIL' ${optionalWhereClause}
  };
  #  if ($IsTest) { print("sqlForCountsOfFailed:${sqlForCountsOfFailed}:\n"); }
  $preparedSqlForCountsOfFailed = $dbh->prepare($sqlForCountsOfFailed);

}

# Functions used for event handling
# ---------------------------------
sub getSubscriberState_dbh {
   my($dbh,$sourceSystemName,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select SUBSCRIBER_STATUS
         from CDA_MESSAGE_CONTROL
         where FO_PUB_SYS_C = '${sourceSystemName}'
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{SUBSCRIBER_STATUS};
   }
   return $retStr;
}


sub getLoaderState_dbh {
   my($dbh,$sourceSystemName,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select LOADER_STATUS
         from CDA_MESSAGE_CONTROL
         where FO_PUB_SYS_C = '${sourceSystemName}'
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{LOADER_STATUS};
   }
   return $retStr;
}

sub setLoaderState_dbh {
   my($dbh,$sourceSystemName,$newState,$logfile,$verbal) = @_;
   my($aUpdateStmt) = qq {
         update CDA_MESSAGE_CONTROL
         set LOADER_STATUS='${newState}'
         where FO_PUB_SYS_C = '${sourceSystemName}'
   };
   sqlExecute_dbh($aUpdateStmt,$dbh);
}

sub setSubscriberState_dbh {
   my($dbh,$sourceSystemName,$newState,$logfile,$verbal) = @_;
   my($aUpdateStmt) = qq {
         update CDA_MESSAGE_CONTROL
         set SUBSCRIBER_STATUS='${newState}'
         where FO_PUB_SYS_C = '${sourceSystemName}'
   };
   sqlExecute_dbh($aUpdateStmt,$dbh);
}


sub getSubscriberLastUpdate_dbh {
   my($dbh,$sourceSystemName,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select to_char(SUBSCRIBER_LASTUPDATE,'YYYYMMDDHH24MISS') SUBSCRIBER_LASTUPDATE
         from CDA_MESSAGE_CONTROL
         where FO_PUB_SYS_C = '${sourceSystemName}'
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{SUBSCRIBER_LASTUPDATE};
   }
   return $retStr;
}

sub getLoaderLastUpdate_dbh {
   my($dbh,$sourceSystemName,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select to_char(LOADER_LASTUPDATE,'YYYYMMDDHH24MISS') LOADER_LASTUPDATE
         from CDA_MESSAGE_CONTROL
         where FO_PUB_SYS_C = '${sourceSystemName}'
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{LOADER_LASTUPDATE};
   }
   return $retStr;
}

sub setLoaderLastUpdate_dbh {
   my($dbh,$sourceSystemName,$newTimeStamp,$logfile,$verbal) = @_;
   my($aUpdateStmt) = qq {
         update CDA_MESSAGE_CONTROL
         set LOADER_LASTUPDATE=TO_DATE('${newTimeStamp}','YYYYMMDDHH24MISS')
         where FO_PUB_SYS_C = '${sourceSystemName}'
   };
   sqlExecute_dbh($aUpdateStmt,$dbh);
}

sub getAllFoSystemId_dbh {
   my($dbh,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select FO_PUB_SYS_C
         from CDA_MESSAGE_CONTROL
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my(@retList) = ();
   foreach my $aHandlerRef (@queryResultRef) {
      my $aFoSys = $aHandlerRef->{FO_PUB_SYS_C};
      push(@retList,$aFoSys);
   }
   return @retList;
}

sub checkEventAndSetLoaderStatus {
  my($dbh,$sourceSystemName,$logfile,$verbal) = @_;
  setLoaderLastUpdate_dbh($dbh,$sourceSystemName,getTimeStamp(),$logfile,$verbal);
  my $oldState = getLoaderState_dbh($dbh,$sourceSystemName,$logfile,$verbal);
  if (($oldState eq "isRunning") ||
      ($oldState eq "doEnable")) {
      setLoaderState_dbh($dbh,$sourceSystemName,"isRunning",$logFileName,$verbal);
      return $TRUE;
  } elsif (($oldState eq "doShutdown") ||
           ($oldState eq "isShutdown"))  {
      setLoaderState_dbh($dbh,$sourceSystemName,"isShutdown",$logFileName,$verbal);
      addToLogFile("--> Received stopMe event",$logFileName,$verbal);
      return $FALSE;
  } elsif (($oldState eq "doDisable") ||
           ($oldState eq "isDisable")) {
      setLoaderState_dbh($dbh,$sourceSystemName,"isDisabled",$logFileName,$verbal);
      return $TRUE;
  }
  return $TRUE;
}


sub mainCdaPollingLoop {
  my($inTestMode) = @_;
  $inTestMode = setDefault($inTestMode,$FALSE);

  addToLogFile("---> Main started",$logFileName,$verbal);

  # connecting to TIQ db
  # --------------------
  $tradeIQ_dbHandler  = dbConnect($db,$dbUser,$dbPassword,"",$TRUE,$TRUE);
  addToLogFile("Connected to ${db} using ${dbUser}",$logFileName,$verbal);

  if ($mode eq "stopMe") {
     addToLogFile("--> Sending stopMe event",$logFileName,$verbal);
     setLoaderState_dbh($tradeIQ_dbHandler,$sourceSystemName,"doShutdown",$logFileName,$verbal);
     return;
  } elsif ($mode eq "enableMe") {
     addToLogFile("--> Sending enableMe event",$logFileName,$verbal);
     setLoaderState_dbh($tradeIQ_dbHandler,$sourceSystemName,"doEnable",$logFileName,$verbal);
     return;
  } elsif ($mode eq "disableMe") {
     addToLogFile("--> Sending disableMe event",$logFileName,$verbal);
     setLoaderState_dbh($tradeIQ_dbHandler,$sourceSystemName,"doDisable",$logFileName,$verbal);
     return;
  }

  readingCommonControlFile();
  $doRunning = checkEventAndSetLoaderStatus($tradeIQ_dbHandler,$sourceSystemName,$logFileName,$verbal);
  cdaTblCleanup($tradeIQ_dbHandler,$cdaTblKeepDays);
  if ($IsTest) {
     addToLogFile("---> Runs in test-mode",$logFileName,$verbal);
  }

  # prepare some sql statements
  # ---------------------------
  prepareSomeSqlStatemens($tradeIQ_dbHandler);

  if ($inTestMode) {
      ####  parseReplaceLogfileAndUpdateCdaTbl($tradeIQ_dbHandler,"${TmpDir}/FUT_OPT_BUY_SELL_REPLACE_106188.log");
      checkForNewDealsAndSendThem($tradeIQ_dbHandler);
  } else {
      # Polling for new deals and process them
      # --------------------------------------
      if ($doRunning) {
        do {
           if (getLoaderState_dbh($tradeIQ_dbHandler,$sourceSystemName,$logfile,$verbal) eq "isDisabled") {
               addToLogFile("---> Is disabled",$logFileName,$verbal);
           } else {
               checkForNewDealsAndSendThem($tradeIQ_dbHandler);
           }
           if ($readingCommonControlInEveryLoop) {
              readingCommonControlFile();
              prepareSomeSqlStatemens($tradeIQ_dbHandler);
           }
           $doRunning = checkEventAndSetLoaderStatus($tradeIQ_dbHandler,$sourceSystemName,$logFileName,$verbal);
           if ($doRunning) {
              $triedPeriodes = pollingSleep($pollingInterval,80,$triedPeriodes);
           }
        } until (!($doRunning));
      } else {
         addToLogFile("There is an event telling me to stop processing",$logFileName,$verbal);
      }
  }
  # close db connection
  # -------------------
  dbDisconnect($tradeIQ_dbHandler);
  addToLogFile("Connection to TIQ closed",$logFileName,$verbal);
}

sub useAnOtherDataFile {
  my($dealType,$loaderAction,$descFileDir,$foreignSystem) = @_;
  if (($dealType       eq $oldDealType)     &&
      ($loaderAction   eq $oldLoaderAction) &&
      ($descFileDir    eq $olddescFileDir)  &&
      ($foreignSystem  eq $oldExtSystem)) {
      return $FALSE;
  } else {
      $oldDealType     = $dealType;
      $oldLoaderAction = $loaderAction;
      $olddescFileDir  = $descFileDir;
      $oldExtSystem    = $foreignSystem;
      return $TRUE;
  }
}

# returns count of FAILED trades in cda_message_in
sub getCountOfFailedTrade {
   my $countOfFails = "";
   my(@queryResultRef) = dbExecutePreparedSelectSttmnt($preparedSqlForCountsOfFailed);
   if (@queryResultRef[0]) {
      $countOfFails = @queryResultRef[0]->{COUNT};
      # send e-mail notification
      if ($countOfFails > 0 ) {
         sendEmailAlertForTiqLoader($countOfFails);
      }
   } else {
      $countOfFails = "";
      $lastFaildEmailNotificationSent = "";
   }
   return $countOfFails;
}

sub sendDataFile {
  my($dbh,$dataFile,$dealType,$loaderAction,$descFileDir) = @_;
  my $logFile = setNewFilenameExtension($dataFile,"log");
  my $dumpFile = setNewFilenameExtension($dataFile,"dump");

  if ($IsTest) {
    printf("Sending ${dataFile}\n");
    printf("  using dealType:${dealType}:\n");
    printf("  using loaderAction:${loaderAction}:\n");
  }
  if (-s $dataFile) {
     addToLogFile(sprintf("---> Sending (${dealType}/${loaderAction}) %s",getFileNameOutOfFullName($dataFile)),$logFileName,$verbal);  

     if ($IsTest) {
        my $descFile = $descFileDir.getTIQ_DescFilename($loaderAction,$dealType,"desc");
        my @lines    = readFile($dataFile);
        my $countOfRecords = @lines;
        printf("      ====================\n");
        printf(" ---> Start of FileContent   Count of record(s):${countOfRecords}\n");
        printf("      ====================\n");

        foreach my $aLine (@lines) {
           printf("Data-String:\n");
           printf("============\n");
           printf("${aLine}\n\n");

           printf("Formatted:\n");
           printf("==========\n");
           my %hashOutOfDataFile = formatDataStringUsingTIQ_DescFile($aLine,$descFile);
           displayHashTable(%hashOutOfDataFile);
           printf("\n\n");
        }
        printf("      ==================\n");
        printf(" ---> End of FileContent  Count of record(s):${countOfRecords}\n");
        printf("      ==================\n");
     }     

     if (-e $logFile) {
        `rm -f ${logFile}`;
        if ($IsTest) {
           addToLogFile("Removing old log file:${logFile}:",$logFileName,$verbal);
        }
     }
     if (-e $dumpFile) {
        `rm -f ${dumpFile}`;
        if ($IsTest) {
           addToLogFile("Removing old dump file:${dumpFile}:",$logFileName,$verbal);
        }
     }

     my $dealloaderCall = "${dealLoaderPath}cdaDealLoader ${dataFile} ${dealType} ${loaderAction} ${logFile} ${dumpFile} ${descFileDir}";
     if ($IsTest) {
        addToLogFile("Dealloader Call:\n${dealloaderCall}:",$logFileName,$verbal); 
     }
     my $retVal = `${dealloaderCall} 1>${dataFile}.cdaDealLoader 2>&1`;
     if ($IsTest) {
     	addToLogFile("\n${dealloaderCall}\nretVal:${retVal}",$logFileName,$verbal);
     }

     if (-s $logFile) {
        parseDealLoaderLogfileAndUpdateCdaTbl($dbh,$logFile);
     } else {
        addToLogFile(sprintf("---> Log file does not exist or is empty (${dealType}/${loaderAction} %s",getFileNameOutOfFullName($dataFile)),$logFileName,$verbal);
        addToLogFile("---> Tradedealloader probably asserted",$logFileName,$verbal);
        return;
     }
  } else {
     addToLogFile(sprintf("---> File missing to send (${dealType}/${loaderAction} %s",getFileNameOutOfFullName($dataFile)),$logFileName,$verbal);
  }
}


# Handling common control file
# ----------------------------
sub readingCommonControlFile {
  if ($locationCode eq "ZH") {
     getCommonControlViaHttpGet($commonControlUrl,$commonControlFile,$gmmdbSupport,"Error: ${myOnlyName} / ${locationCode}",$logFileName,$verbal);
  }

  $entryFound = setCommonVariablesFromControlFileForApplicationName($commonControlFile,"AppName=${myOnlyName}",$locationCode,$instance,$FALSE);
  if (!($entryFound)) {   
     addToLogFile("ERROR:No record for :${myOnlyName}: found",$logFileName,$verbal);
     addToLogFile("ERROR:Check file:${commonControlFile}:",$logFileName,$verbal);
     exit 1;
  }

  if($IsTest) {
     $debug = $TRUE;
     ### displayHashTable(%APP_INFO);
  }

  $pollingInterval                 = setIntegerFromCommonControl($APP_INFO{"Arg1"},120);
  $descFilePath                    = setStringFromCommonControl($APP_INFO{"Arg2"},$ENV{"CSG_APP"}."/dealload");
  $dataFilePath                    = setStringFromCommonControl($APP_INFO{"Arg3"},$TmpDir);
  $dealLoaderPath                  = setStringFromCommonControl($APP_INFO{"Arg4"},"");
  $readingCommonControlInEveryLoop = setBooleanFromCommonControl($APP_INFO{"Arg5"});
  %descFieldMappingHash            = setHashFromCommonControl($APP_INFO{"Arg6"});
  $singleUpdate                    = setBooleanFromCommonControl($APP_INFO{"Arg7"});
  @productsToLoad                  = setListFromCommonControl($APP_INFO{"Arg8"});
  @extSystemToProc                 = setListFromCommonControl($APP_INFO{"Arg9"});
  $fieldNameToStoreSqNo            = setStringFromCommonControl($APP_INFO{"Arg10"},"LBS_FIELD_8");
  $cdaTblKeepDays                  = setIntegerFromCommonControl($APP_INFO{"Arg11"},14);
  $doRunning                       = $TRUE;

  if (!($descFilePath =~ /\/$/)) {
     $descFilePath = "${descFilePath}/";
  }

  if (!($dataFilePath =~ /\/$/)) {
    $dataFilePath = "${dataFilePath}/";
    if (!(-e $dataFilePath)) {
       mkUnixDir($dataFilePath,"/");
    }
  }

  if ($dealLoaderPath eq "") {
     $dealLoaderPath = "";
  } elsif (!($dealLoaderPath =~ /\/$/)) {
     $dealLoaderPath = "${dealLoaderPath}/";
  }

  # set optional Where clause
  # -------------------------
  $optionalWhereClause = "";

  my $countOfProducts = @productsToLoad;
  my $dealTypeWhereClause = "";
  if ($countOfProducts > 0) {
     @productsToLoad = processEachElementInArray("addSingleQuotesToString",@productsToLoad);
     $dealTypeWhereClause = makeStrFromArray(",",@productsToLoad);
     $dealTypeWhereClause = " AND DEAL_TYPE in (${dealTypeWhereClause})";
  } else {
     $dealTypeWhereClause = "";
  }
  $optionalWhereClause = $dealTypeWhereClause;

  my $countOfExtSysToLoad = @extSystemToProc;
  if ($countOfExtSysToLoad > 0) {
     @extSystemToProc = processEachElementInArray("addSingleQuotesToString",@extSystemToProc);
     $extSysWhereClause = makeStrFromArray(",",@extSystemToProc);
     $extSysWhereClause = " AND FO_PUB_SYS_C in (${extSysWhereClause})";
  } else {
     $extSysWhereClause = "";
  }
  $optionalWhereClause = "${optionalWhereClause} ${extSysWhereClause}";

}

##########################################################
# Logfile parsing functions                              #
##########################################################
sub getMessageFromLog {
  my $logFile = @_;
  my $errorText = "";

  if (-s "${logFile}.cdaDealLoader") {
     $errorText = `grep "Assertion failed" ${logFile}.cdaDealLoader | cut -d: -f2-`
  } else {
     $errorText = "Unable to locate error message"
  }

  return $errorText;
}


sub parseDealLoaderLogfileAndUpdateCdaTbl {
  my($dbh,$logFile) = @_;
  addToLogFile("---> TradeData processed! Check ${logFile}",$logFileName,$verbal);

  if (index($logFile,"COMPLETE") != -1) {
     parseCompleteLogfileAndUpdateCdaTbl($dbh,$logFile);
  } elsif (index($logFile,"INSERT") != -1) {
     parseCompleteLogfileAndUpdateCdaTbl($dbh,$logFile);
  } elsif (index($logFile,"DELETE") != -1) {
     parseDeleteLogfileAndUpdateCdaTbl($dbh,$logFile);
  } elsif (index($logFile,"REPLACE") != -1) {
     parseReplaceLogfileAndUpdateCdaTbl($dbh,$logFile);
  } elsif (index($logFile,"UPDATE") != -1) {
     parseUpdateLogfileAndUpdateCdaTbl($dbh,$logFile);
  } else {
     addToLogFile("---> Unknown deal action:${logFile}:\n",$logFileName,$verbal);
  }
}

# for a complete
# --------------
sub parseCompleteLogfileAndUpdateCdaTbl {
  my($tradeIQ_dbHandler,$logFile) = @_;
  my $sequenceNumber = "";
  my $errorMsg = "";
  my $tiqDealNumber = "";
  my $tiqVersion = "1";
  my (@lines) = readFile($logFile);
  foreach my $aLine (@lines) {
    if ($FALSE) {
       printf("LINE:${aLine}\n");
    }
    if (index($aLine,"id = ${fieldNameToStoreSqNo}") != -1) {
       my $SeqNumber = getSeqNrFromLogfileEntry($tradeIQ_dbHandler,$aLine);
       if ($IsTest) { addToLogFile("Got sequenceNumber:${SeqNumber}",$logFileName,$verbal); }
       if ($sequenceNumber ne "") {
          if ($sequenceNumber ne $SeqNumber) {
             processCompleteCdaTbl($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
          } else {
             if ($errorMsg eq "") {
                $errorMsg = getMessageFromLog($logFile);
             }
             failedToLoadTrade($tradeIQ_dbHandler,$sequenceNumber,$errorMsg);
          }
       }
       $sequenceNumber = $SeqNumber;
       $tiqDealNumber = "";
       $tiqVersion = "";
       $errorMsg = "";
    } elsif (index($aLine,"FieldStatusMessage:") != -1) {
       if ($aLine ne "FieldStatusMessage: ") {
          $errorMsg = substr($aLine,20,40);
       }
       if ($IsTest) {
          addToLogFile("Got FieldStatusMessage:${errorMsg}",$logFileName,$verbal);
       }
    } elsif (index($aLine,"Deal entered") != -1) {
       $tiqDealNumber = getFieldFromText(" ",2,$aLine);  
       if ($IsTest) {
           addToLogFile("Got Deal entered:${tiqDealNumber}",$logFileName,$verbal);
       }
    } elsif (index($aLine,"Deal not entered") != -1) {
       if ($errorMsg eq "") {
          $errorMsg = $aLine;
          if ($IsTest) {
             addToLogFile("Got Deal not entered:${aLine}",$logFileName,$verbal);
          }
       }
    }
  } # end of for
  processCompleteCdaTbl($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
}

sub processCompleteCdaTbl {
  my($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg) = @_;
  if ($IsTest) {
     addToLogFile("processCompleteCdaTbl:${tradeIQ_dbHandler}:${sequenceNumber}:${tiqDealNumber}:${tiqVersion}:${errorMsg}:");
  }
  if ($sequenceNumber ne "") {
      if ($tiqDealNumber ne "") {
        if ($tiqVersion eq "") {
           my $tiqDealState = getTiqDealState_dbh($tradeIQ_dbHandler,$tiqDealNumber);
           $tiqVersion = getTiqDealVersion_dbh($tradeIQ_dbHandler,$tiqDealNumber,$tiqDealState);
        }
        succesfullyLoadedTrade($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
     } else {
        if ($errorMsg eq "") {
           $errorMsg = "Failed to locate deal number/error text in logfile";
        }
        failedToLoadTrade($tradeIQ_dbHandler,$sequenceNumber,$errorMsg);
     }
  }
}

# for a delete
# ------------
sub parseDeleteLogfileAndUpdateCdaTbl {
 my($tradeIQ_dbHandler,$logFile) = @_;
  my $sequenceNumber = "";
  my $errorMsg = "";
  my $tiqDealNumber = "";
  my $tiqDealType = "";
  my $tiqDealState = "";
  my $tiqVersion = "";
  my (@lines) = readFile($logFile);
 
  my $SeqNumber = ""; 
  foreach my $aLine (@lines) {
    if (index($aLine,"id = ${fieldNameToStoreSqNo}") != -1) {
       $SeqNumber = getSeqNrFromLogfileEntry($tradeIQ_dbHandler,$aLine);
       if ($IsTest) {
          addToLogFile("Got sequenceNumber from logfile:${SeqNumber}",$logFileName,$verbal);
       }
     } elsif (index($aLine,"id = DEAL_NUMBER") != -1) {
       $tiqDealNumber = getFieldFromText(" ",6,$aLine);
       if ($IsTest) {
          addToLogFile("Got deal number from logfile:${tiqDealNumber}",$logFileName,$verbal);
          addToLogFile("Calling processDeleteCdaTbl($tradeIQ_dbHandler, $SeqNumber, $tiqDealNumber ,...) ", $logFileName,$verbal);
       }
       processDeleteCdaTbl($tradeIQ_dbHandler,$SeqNumber,$tiqDealNumber,$tiqVersion,$errorMsg); 
    }
  } 
}

sub processDeleteCdaTbl {
  my($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg) = @_;
  $errorMsg             = setDefault($errorMsg,"Sucessfully deleted");

  if ($IsTest) {
     addToLogFile("processDeleteCdaTbl:${tradeIQ_dbHandler}:${sequenceNumber}:${tiqDealNumber}:${tiqVersion}:${errorMsg}:",$logFileName,$verbal);
  }
  if ($sequenceNumber ne "") {
     if ($tiqDealNumber ne "") {
        my $tiqDealState = getTiqDealState_dbh($tradeIQ_dbHandler,$tiqDealNumber);
        if (($tiqDealState ne "DLTD") && ($tiqDealState ne "MTDL")) {
          $errorMsg = "Deal state is not deleted:${tiqDealState}";
          if ($IsTest) {
             addToLogFile("$tiqDealNumber deal state is $tiqDealState",$logFileName ,$verbal);
           }
           failedToLoadTrade($tradeIQ_dbHandler,$sequenceNumber,$errorMsg);
        } else {
           if ($tiqVersion eq "") {
              $tiqVersion = getTiqDealVersion_dbh($tradeIQ_dbHandler,$tiqDealNumber,$tiqDealState);
           }
           succesfullyLoadedTrade($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
           if ($doUpdateOriginalDealWhenDelete) {
              updateDeletedTrade($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$errorMsg);
           }
        }
     } else {
        if ($errorMsg eq "") {
           $errorMsg = "Failed to locate deal number/error text in logfile";
        }
        failedToLoadTrade($tradeIQ_dbHandler,$sequenceNumber,$errorMsg);
     }
  }
}

sub updateDeletedTrade {
  my($dbh,$sequenzNumber,$tiqDealNumber,$reason) = @_;

  if (!($doUpdateOriginalDealWhenDelete)) {
    printf("Called updateDeletedTrade(sequenzNumber=${sequenzNumber}, tiqDealNumber=${tiqDealNumber})\n");
    return;
  }

  $reason = setDefault($reason,"Deleted by ${sequenzNumber}");

  if (($tiqDealNumber ne "") && ($sequenzNumber ne "")) {
     my $sqlToUpdateDeletedDeal = qq {
        update  CDA_MESSAGE_IN
           set  TIQ_DEAL_STATE = 'DLTD',
                MESSAGE_STATE  = 'DLTD',
                ERROR_MESG     = substr('$reason',0,40)
          where FO_INTRL_ID = (select FO_INTRL_ID from CDA_MESSAGE_IN where CDA_TRN_SEQ_ID = $sequenzNumber)
          and   MESSAGE_STATE = 'LOAD'
          and   LOADER_ACTION IN ('INSERT','COMPLETE','REPLACE')
     };
     if ($IsTest) {
        addToLogFile("---> Update statment used:\n${sqlToUpdateDeletedDeal}",$logFileName,$verbal);
     }
     $preparedsqlToUpdateDeletedDeal = $dbh->prepare($sqlToUpdateDeletedDeal);
     $preparedsqlToUpdateDeletedDeal->execute;
  } else {
     addToLogFile("updateDeletedTrade:incorrect parameters:${dbh}:${sequenzNumber}:${tiqDealNumber}:${reason}:",$logFileName,$verbal);
  }
}

# for a replace
# -------------
sub parseReplaceLogfileAndUpdateCdaTbl {
  my($tradeIQ_dbHandler,$logFile) = @_;
  my $sequenceNumber   = "";
  my $errorMsg         = "";
  my $tiqDealNumber    = "";
  my $tiqDealType      = "";
  my $tiqVersion       = "";
  my $oldTiqDealNumber = "";
  my (@lines)          = readFile($logFile);
  foreach my $aLine (@lines) {
    if ($FALSE) {
       printf("LINE:${aLine}\n");
    }
    if (index($aLine,"id = ${fieldNameToStoreSqNo}") != -1) {
       my $SeqNumber = getSeqNrFromLogfileEntry($tradeIQ_dbHandler,$aLine);
       if ($IsTest) {
          addToLogFile("Got sequenceNumber:${SeqNumber}\n",$logFileName,$verbal);
       }
       if ($sequenceNumber ne "") {
          if ($sequenceNumber ne $SeqNumber) {
             processDeleteCdaTbl($tradeIQ_dbHandler,$sequenceNumber,$oldTiqDealNumber,$tiqVersion,$errorMsg);
             processCompleteCdaTbl($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
             #processReplaceCdaTbl($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
          } else {
             if ($errorMsg eq "") {
                $errorMsg = getMessageFromLog($logFile);
             }
             failedToLoadTrade($tradeIQ_dbHandler,$sequenceNumber,$errorMsg);
          }
       }
       $sequenceNumber = $SeqNumber;
       $errorMsg = "";
       $tiqDealNumber = "";
       $tiqVersion = "";
       $oldTiqDealNumber = "";
    } elsif (index($aLine,"id = DEAL_NUMBER") != -1) {
       $oldTiqDealNumber = getFieldFromText(" ",6,$aLine);
       if ($IsTest) {
          addToLogFile("Got Replaced Deal Number:${oldTiqDealNumber}",$logFileName,$verbal);
       }
    } elsif (index($aLine,"id = DEAL_TYPE") != -1) {
       $tiqDealType = getFieldFromText(" ",6,$aLine);
       if ($IsTest) {
          addToLogFile("Got deal type:${tiqDealType}",$logFileName,$verbal);
       }
    } elsif (index($aLine,"FieldStatusMessage:") != -1) {
       if ($aLine ne "FieldStatusMessage: ") {
          $errorMsg = substr($aLine,20,40);
       }
       if ($IsTest) {
          addToLogFile("Got FieldStatusMessage:${errorMsg}",$logFileName,$verbal);
       }
    } elsif (index($aLine,"Deal entered") != -1) {
       $tiqDealNumber = getFieldFromText(" ",2,$aLine);  
       $oldTiqDealNumber = getFieldFromText(" ",6,$aLine);
       $errorMsg = "Replaced ${oldTiqDealNumber} by ${tiqDealNumber}";
       if ($IsTest) {
          addToLogFile("Got Deal entered:${tiqDealNumber}",$logFileName,$verbal);
          addToLogFile("Got Replaced Deal Number:${oldTiqDealNumber}",$logFileName,$verbal);
       }
    } elsif (index($aLine,"Deal not entered") != -1) {
       if ($errorMsg eq "") {
          $errorMsg = $aLine;
          if ($IsTest) {
            addToLogFile("Got Deal not entered:${aLine}",$logFileName,$verbal);
          }
       }
    }
  }
  processDeleteCdaTbl($tradeIQ_dbHandler,$sequenceNumber,$oldTiqDealNumber,$tiqVersion,$errorMsg);
  processCompleteCdaTbl($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
}

# for Updates
# -----------
sub parseUpdateLogfileAndUpdateCdaTbl {
  my($tradeIQ_dbHandler,$logFile) = @_;
  my $sequenceNumber = "";
  my $errorMsg = "";
  my $tiqDealNumber = "";
  my $tiqDealType = "";
  my (@lines) = readFile($logFile);
  foreach my $aLine (@lines) {
    if (index($aLine,"id = ${fieldNameToStoreSqNo}") != -1) {
       my $SeqNumber = getSeqNrFromLogfileEntry($tradeIQ_dbHandler,$aLine);
       if ($IsTest) {
          addToLogFile("Got sequenceNumber:${SeqNumber}:",$logFileName,$verbal);
       }
       if ($sequenceNumber ne "") {
          if ($sequenceNumber ne $SeqNumber) {
             processUpdateCdaTbl($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
          } else {
             if ($errorMsg eq "") {
                $errorMsg = getMessageFromLog($logFile);
             }
             failedToLoadTrade($tradeIQ_dbHandler,$sequenceNumber,$errorMsg);
          }
       }
       $sequenceNumber = $SeqNumber;
       $errorMsg = "";
       $tiqDealNumber = "";
       $tiqVersion = "";
       if ($IsTest) {
          addToLogFile("Got sequenceNumber:${sequenceNumber}:",$logFileName,$verbal);
       }
    } elsif (index($aLine,"id = DEAL_TYPE") != -1) {
       $tiqDealType = getFieldFromText(" ",6,$aLine);
       if ($IsTest) {
          addToLogFile("Got deal type:${tiqDealType}",$logFileName,$verbal);
       }
    } elsif (index($aLine,"FieldStatusMessage:") != -1) {
       if ($aLine ne "FieldStatusMessage: ") {
          $errorMsg = substr($aLine,20,40);
       }
       if ($IsTest) {
          addToLogFile("Got FieldStatusMessage:${errorMsg}",$logFileName,$verbal);
       }
    } elsif (index($aLine,"Deal entered") != -1) {
       $tiqDealNumber = getFieldFromText(" ",2,$aLine);  
       if ($IsTest) {
      addToLogFile("Got Deal entered:${tiqDealNumber}:",$logFileName,$verbal);
       }
    } elsif (index($aLine,"Deal not entered") != -1) {
       if ($errorMsg eq "") {
          $errorMsg = $aLine;
      if ($IsTest) {
             addToLogFile("Got Deal not entered:${aLine}",$logFileName,$verbal);
      }
       }
    }
  }
  processUpdateCdaTbl($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
}

sub processUpdateCdaTbl {
  my($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg) = @_;
  if ($IsTest) {
     addToLogFile("processUpdateCdaTbl:${tradeIQ_dbHandler}:${sequenceNumber}:${tiqDealNumber}:${tiqVersion}:${errorMsg}:");
  }
  if ($sequenceNumber ne "") {
     if ($tiqDealNumber ne "") {
        my $tiqDealState = getTiqDealState_dbh($tradeIQ_dbHandler,$tiqDealNumber);
        if ($tiqVersion eq "") {
           $tiqVersion = getTiqDealVersion_dbh($tradeIQ_dbHandler,$tiqDealNumber,$tiqDealState);
        }
        $errorMsg = "Deal was updated by ${sequenceNumber}";
        succesfullyLoadedTrade($tradeIQ_dbHandler,$sequenceNumber,$tiqDealNumber,$tiqVersion,$errorMsg);
     } else {
        if ($errorMsg eq "") {
           $errorMsg = "Failed to locate deal number/error text in logfile";
        }
        failedToLoadTrade($tradeIQ_dbHandler,$sequenceNumber,$errorMsg);
     }
  }
}

##################################################################
# Functions to write back the update state into cda_message_in
##################################################################
sub succesfullyLoadedTrade {
  my($dbh,$sequenzNumber,$tiqDealNumber,$tiqVersion,$reason) = @_;
  $reason = setDefault($reason,"Sucessfully loaded");

  if (index($reason,"\"") != -1) {
     $reason = substr($reason,index($reason,"\""));
  }

  if ($tiqVersion eq "") {
     if ($IsTest) {
        addToLogFile("Defaulting TIQ version to 1:${sequenzNumber}:${tiqDealNumber}:${reason}:",$logFileName,$verbal);
     }
     $tiqVersion = 1;
  }
  if (($tiqDealNumber ne "") && ($tiqVersion ne "") && ($sequenzNumber ne "")) {
     my $sqlToUpdateDeals = qq {
         update  CDA_MESSAGE_IN
         set        TIQ_DEAL_NUM   = ${tiqDealNumber},
                    TIQ_VERSION    = ${tiqVersion},
                    TIQ_DEAL_STATE = (select DEAL_STATE from ALL_DEALS where DEAL_NUM = ${tiqDealNumber} and VERSION = ${tiqVersion}),
                    LOAD_TIMESTAMP = sysdate,
                    MESSAGE_STATE  = 'LOAD',
                    ERROR_MESG     = substr('$reason',0,40)
         where      CDA_TRN_SEQ_ID = ${sequenzNumber}
     };
     if ($IsTest) {
        addToLogFile("---> Update statment used:\n${sqlToUpdateDeals}",$logFileName,$verbal);
     }
     $preparedSqlToUpdateDeals = $dbh->prepare($sqlToUpdateDeals);
     $preparedSqlToUpdateDeals->execute;
  } else {
    addToLogFile("succesfullyLoadedTrade:incorrect parameters:${dbh}:${sequenzNumber}:${tiqDealNumber}:${tiqVersion}:${reason}:",$logFileName,$verbal);
  }
}

#sub failedToLoadTrade {
#  my($dbh,$sequenzNumber,$reason) = @_;
#  if ($sequenzNumber ne "") {
#     my $sqlToUpdateDeals = qq {
#            update  CDA_MESSAGE_IN
#                   set ERROR_MESG     = substr('${reason}',0,40),
#                       LOAD_TIMESTAMP = sysdate,
#                       MESSAGE_STATE  = 'FAIL'
#            where CDA_TRN_SEQ_ID = ${sequenzNumber}
#     };
#     if ($IsTest) {
#       addToLogFile("---> Update statment used:\n${sqlToUpdateDeals}",$logFileName,$verbal);
#     }
#     $preparedSqlToUpdateDeals = $dbh->prepare($sqlToUpdateDeals);
#     $preparedSqlToUpdateDeals->execute;
#  } else {
#     addToLogFile("failedToLoadTrade:incorrect parameters:${dbh}:${sequenzNumber}:${reason}:",$logFileName,$verbal);
#  }
#}

sub failedToLoadTrade {
  my($dbh,$sequenzNumber,$reason) = @_;
  if ($sequenzNumber ne "") {
#     while (index(${reason},"'") != -1) {
#	reason = substr(${reason},0,index(${reason},"'") ) . substr(${reason},index(${reason},"'") + 1, length(${reason}) - index(${reason},"'") );
#	}
     $reason =~ s/'//g;
     my $sqlToUpdateDeals = qq {
            update  CDA_MESSAGE_IN
                   set ERROR_MESG     = substr('${reason}',0,40),
                       LOAD_TIMESTAMP = sysdate,
                       MESSAGE_STATE  = 'FAIL'
            where CDA_TRN_SEQ_ID = ${sequenzNumber}
     };
     if ($IsTest) {
       addToLogFile("---> Update statment used:\n${sqlToUpdateDeals}",$logFileName,$verbal);
     }
     $preparedSqlToUpdateDeals = $dbh->prepare($sqlToUpdateDeals);
     $preparedSqlToUpdateDeals->execute;
     addToTiqMonitor_dbh($dbh,"Failed ${sequenzNumber}",$reason,$myOnlyName,$logFileName,$verbal);
  } else {
     addToLogFile("failedToLoadTrade:incorrect parameters:${dbh}:${sequenzNumber}:${reason}:",$logFileName,$verbal);
  }
}
    
sub getFormatedFailedTradesString {
   my(@queryResultRef) = ();
   my $retMsg = "";
   @queryResultRef = dbExecutePreparedSelectSttmnt($preparedSqlForGetFailedDeals);
   foreach my $aFailedTradeRef (@queryResultRef) {
     my $formatedDataStr = $aFailedTradeRef->{FORMATTED_DATA};
     if ($aFailedTradeRef->{FORMAT_TYPE} eq "FLT") {
         my %dealData = formatFltDataString($formatedDataStr);
         $formatedDataStr = hashTableToStr($TRUE,%dealData);
         $formatedDataStr =~ s/\n/\n                             /g;
     } elsif($aFailedTradeRef->{FORMAT_TYPE} eq "LIQ") {
         my $descFileDir    = $aFailedTradeRef->{DESCRIPTOR_FILE} || "LOANIQ";
         my $extension      = "";
         my $descFile       =  getTIQ_DescFilename ($aFailedTradeRef->{LOADER_ACTION},$aFailedTradeRef->{DEAL_TYPE},$extension) ;
         my $fullFileName   = "$ENV{CSG_APP}/dealload/${descFileDir}/${descFile}";
         my %dealData       =  formatDataStringUsingTIQ_DescFile($formatedDataStr,$fullFileName);
         $formatedDataStr   = hashTableToStr($TRUE,%dealData);
         $formatedDataStr   =~ s/\n/\n                             /g;
     }

     $retMsg = qq {$retMsg
           CDA_TRN_SEQ_ID:   $aFailedTradeRef->{CDA_TRN_SEQ_ID}
           DEAL_TYPE:        $aFailedTradeRef->{DEAL_TYPE}
           RECV_TIMESTAMP:   $aFailedTradeRef->{RECV_TIMESTAMP}
           FO_PUB_SYS_C:     $aFailedTradeRef->{FO_PUB_SYS_C}
           FO_INTRL_ID:      $aFailedTradeRef->{FO_INTRL_ID}
           FO_INTRL_VERS_ID: $aFailedTradeRef->{FO_INTRL_VERS_ID}
           LOADER_ACTION:    $aFailedTradeRef->{LOADER_ACTION}
           DESCRIPTOR_FILE:  $aFailedTradeRef->{DESCRIPTOR_FILE}
           FORMAT_TYPE:      $aFailedTradeRef->{FORMAT_TYPE}
           FORMATTED_DATA:   $formatedDataStr
                     
      };                  

   } 
   return $retMsg;
}


sub sendEmailAlertForTiqLoader {
  my($countOfFails,$msg,$subject,@filesToSend) = @_;

  my $timeNow = getTimeStamp();

  if ($doSendMail) {
    if (($lastFaildEmailNotificationSent eq "") || (secDiff_YYYYMMDDhhmmss($timeNow,$lastFaildEmailNotificationSent) > 10*60)) {
      my $hostName   = getMyUnixHostname();
      my $hostnameNo = getFieldFromString("-",1,$hostName,"");

      if ($msg eq "") {
         $msg = qq {
           ${receiverName}
           There are ${countOfFails} failed trades in the cda_message_in table.

           Therefore ${myOnlyName} has to wait for fixing these problems.
 
           Check out http://gmmit.csfb.net/cgi-bin/tmsmsg_cgi?dest=${hostName}&cmd=inputDealsQMonitor&Instance=pnylhmm1&TargetNode=${hostName}

           Best regards

           Failed Trade(s):


         };
      }

      my $formatedTradeStr = getFormatedFailedTradesString();
      $msg = "${msg}${formatedTradeStr}";

      if ($subject eq "") {
         $subject = "ERROR in ${myOnlyName}"
      }

      my $filesToEmail = makeStrFromArray(",",@filesToSend);
      $lastFaildEmailNotificationSent = $timeNow;
      sendMailwithAttachments($fromAdr,$toAdr,$subject,$msg,$filesToEmail,$ccAdr,$bccAdr);
    }
  }
}

sub cdaTblCleanup {
  my($dbh,$keepDays) = @_;
  my $sqlToPurgeOldData = qq {
         delete from CDA_MESSAGE_IN
         where  MESSAGE_STATE <> 'PEND' ${optionalWhereClause}
         and    LOAD_TIMESTAMP < (sysdate - $keepDays)
  };
  if ($IsTest) {
     addToLogFile("sqlToPurgeOldData:${sqlToPurgeOldData}:",$logFileName,$verbal); 
  }
  my $preparedSqlToPurgeOldData = $dbh->prepare($sqlToPurgeOldData);
  $preparedSqlToPurgeOldData->execute;
}

return 1;
