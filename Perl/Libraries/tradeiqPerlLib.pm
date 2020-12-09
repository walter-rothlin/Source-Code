
# START---------------------------------------------------------------------
# Author:       Dmitriy Volfson 
# Description:  Contains common functions and definitions related to Trade IQ
# History:
#  03/09/00  V1.0 Dmitriy Volfson      Initial Version
#  03/23/00  V1.1 Walter Rothlin       Add _dbh functions
#  03/27/00  V1.2 Dmitriy Volfson      Fixed parameters dbDisconnect
#  05/11/00  V1.3 Walter Rothlin       Add GMMSEND and FOBOCA to qHandler List
#  06/02/00  V1.4 Walter Rothlin       Add getValueDateFromSysParam_dbh
#  06/06/00  V1.5 Dmitriy Volfson      Changed checkApplicationStatus
#  06/30/00  V1.6 Walter Rothlin       Bug fix in getValueDateFromSysParam_dbh
#  07/12/00  V1.7 Walter Rothlin       Add setDealsQFirstOfTheDayItem_dbh
#                                          setDealsQLastOfYesterdayItem_dbh
#  07/26/00  V1.8 Walter Rothlin       Changed getLastQueueItemProcessed_dbh
#                                      Add setDealsQMaxItem, setDealsQMaxItem_dbh
#  08/02/00  V1.9 Walter Rothlin       Add GMMSEND_ZH, NY and LN
#  10/19/00  V2.0 Walter Rothlin       Add getNextTradingDayFromSysParam_dbh
#  12/05/00  V2.1 Dmitriy Volfson      Changed validNumberofProcesses for GlsSrv 
#  12/20/00  V2.2 Walter Rothlin       Change "Not used" to "Not_used" for LQEPROCD 
#  02/27/01  V2.3 Walter Rothlin       Added isLastTradingDayOfMonth
#                                            isLastTradingDayOfYear
#                                            isFirstTradingDayOfMonth
#                                            isLastTradingDayOfYear
#                                      and the corresponding _dbh functions
#  04/19/01  V2.4 Walter Rothlin       Added TIQ_Descriptor file functions
#  05/14/01  V2.5 Walter Rothlin       Added getDealLoaderDataString
#  07/02/01  V2.6 Walter Rothlin       Added function used in the cdaTiqLoader
#                                          addToTiqMonitor
#                                          getTiqDealState
#                                          getTiqDealVersion
#  08/31/01  V2.7 Dmitriy Volfson      bug fix in getPosAndLenFromTIQ_DescFile
#  11/01/01  V2.8 Walter Rothlin       Added isTIQ_Version_32_dbh
#                                            isTIQ_Version_25_dbh
#                                            getTIQ_MasterVersionFromDb_dbh
#  11/20/01  V2.9 Walter Rothlin       Added getTiqHolidayCalendarAsHash
#                                            getTiqHolidayCalendarAsHash_dbh
#                                            getTiqHolidayCalendar
#                                            getTiqHolidayCalendar_dbh
#  12/03/01  V2.10 Dmitriy Volfson           fix in AplicationProcessName for NYGMM
#  12/12/01  V2.11 Walter Rothlin       Renamed getNextTradingDayFromSysParam to getNextTradingDayFromSysParamTbl
#                                       Changed  getNextTradingDayFromSysParam to actualy read from eod_control table
#                                       Added getNextTradingDay and getNextTradingDay_dbh which should be used for all new applications
#  02/27/02  V2.12 Walter Rothlin       Moved getDealRecord, getDealRecords into Lib from tradeIQ_RealtimeGmmExtractor.pl
#  03/15/02  V2.13 Walter Rothlin       Changed getDealRecords to be TIQ 3.2 complient
#  05/13/02  V2.14 Walter Rothlin       Mod getTIQ_DescFilename (add location as an parameter)
#  08/08/02  V2.15 Li Yao        	Mod initLqeprocd_dbh (PID should be setup to null) 
#  04/11/02  V2.16 Walter Rothlin      	Added trading book functions 
#                                          showTrdBookTree
#                                          getTrdBkFullNameForId
#                                          getRootTrdBkId
#                                          getParentTrdBkIdForId
#                                          getTrdBkNameForId
#                                          getTrdBkIdsForName
#                                          getChildrenTrdBkIdForId
#                                          getAllTrdBkIdsForId
#  01/22/03  V2.17 Walter Rothlin      	Added getInstanceTypeFromInstanceName
#                                             verifySystemDate, doTest_verifySystemDate
#  07/08/03  V2.18 Walter Rothlin      	Mod trading book functions 
#  09/22/03  V2.19 Walter Rothlin      	Add getFxSpotRates_dbh getFxSpotRates 
#  20/10/03  V2.20 Dmitriy Volfson      added isTIQ_Version_61_dbh, removed 3_2 check in
#                                        getTiqHolidayCalendarAsHash_dbh and getTiqHolidayCalendar_dbh 
#  29/10/03  V2.21 Dmitriy Volfson       modified getNextTradingDayFromSysParam_dbh for 61 
#  30/10/03  V2.22 Amit Bhogaita       modified getLastEodDateFromSysParam_dbh for 61 
#  06/01/04  V2.23 Amit Bhogaita       modified getNextTradingDayFromSysParam_dbh for FT61 to use MIN date
#                                      instead of MAX date to pick up closest next trading date.
#  01/29/04  V2.24 Walter Rothlin      	Add getBranchCodeIdFromBranchCodeName
#  11/09/04  V2.25 Amit Bhogaita       initLqeprocd changed to include column names on insert statement,
#                                      due to change in column order on lqeprocd table between 3.2 and 6.1.
#  11/18/05  V2.26 Walter Rothlin      Changed getTiqHolidayCalendarAsHash_dbh to work for 6.1.8 and higher
#  04/07/06  V2.27 Walter Rothlin      Add getAllTrdBkFoIdsForNames; getAllTrdBkFoIdsForNames_dbh
#  07/04/06  V2.28 Walter Rothlin      Add showMenu_LhCmd
#  08/11/06  V2.29 Walter Rothlin      Removed ZH_GM
#  08/23/06  V2.30 Walter Rothlin      Add getTrdBookTree_dbh,getTrdBkPermission_dbh
#  10/19/06  V2.31 Walter Rothlin      Add getLH_DB_HostForInstance,getPidListFromDB
#  11/15/06  V2.32 Walter Rothlin      Fixed mistake in getTrdBkPermission_dbh
#  11/29/06  V2.33 Walter Rothlin      Changed getTrdBkPermission_dbh (added column TRADING_BOOK_NAME)
#  02/07/07  V2.34 Walter Rothlin      Changed getTrdBkPermission_dbh (users with no entries in trd_book will be returned)
#  02/15/07  V2.35 Walter Rothlin      Added functions for a combined (FX / MM System):getLH_InstanceType, isMM_System, isFX_System, isFX_MM_System
#  02/27/07  V2.36 Walter Rothlin      Fixed getChildrenTrdBkIdForId_dbh for the case ID is empty
#  02/27/07  V2.37 Walter Rothlin      Added functions for a combined (FX / MM System): isOnlyMM_System, isOnlyFX_System, isFXandMM_System
#  03/02/07  V2.38 Walter Rothlin      Added functions for a combined (FX / MM System): getBankCode, getProductGroup, getBankProductGroup, isBankProductGroup
#  03/19/07  V2.39 Walter Rothlin      Used prepareAndExecuteSqlStatement with proper error handling for all trd book functions
#  04/25/07  V2.40 Walter Rothlin      Added ZN (Zurich-North)
#  05/23/07  V2.41 Walter Rothlin      Added mrsExits_dbh
#  12/06/07  V2.42 Walter Rothlin      Added getTiqSystemVersion, isTiqSystemReadOnly
#  02/14/08  V2.43 Walter Rothlin      Changed getLH_DB_HostForInstance
#  03/03/08  V2.44 Amrik Aidan	       Added additional way to read descriptor file.
#  07/22/09  V2.45 Walter Rothlin	     Changes for FT7 implementation in ZH
#  04/23/10  V2.46 Walter Rothlin	     Added getTestLevelFromInstanceAsString 
#  05/07/10  V2.47 Simon Fulcri        Bug fix getTestLevelFromInstanceAsString
#  05/25/10  V2.48 Simon Fulcri        Added getTestLineFromInstanceName    
#  12/08/10  V2.49 Simon Fulcri        Extended setTIQ_Versions function to handle FT version 7.0.10
#  04/12/11  V2.50 Simon Fulcri        Extended setTIQ_Versions function to handle FT version 7.0.11
#  10/17/11  V2.51 Simon Fulcri        Extended setTIQ_Versions function to handle FT version 7.0.14
#  23-Mar-2012  V2.52 Walter Rothlin   Some cosmetics
#  12-JUL-2012  V2.53 Walter Rothlin   Remoevd debug code in getLastTradingDayFromSysParam_dbh
#  06-SEP-2012  V2.54 Walter Rothlin   Renamed setLock to setDbLock (same name used in littlePerlLib.pm)
#  24-SEP-2012  V2.55 Walter Rothlin   showTrdBookTree_dbh error handling enhanced, enhanced to display currencyPairs
#  25-Oct-2013  V2.56 Walter Rothlin   Migrated it to handle FT 7.0.16 (Removed FT 6 versions)
#  16-Oct-2014  V2.57 Walter Rothlin 	Cleanup for leagal parser 
# END----------------------------------------------------------
############################################################################
$tradeiqPerlLibSccsId             = "";
$tradeiqPerlLibLatestVersion      = "V2.57";
############################################################################

package tradeiqPerlLib;

package main;


%AplicationStartScript = (
           "PRINTING"       => "csg_start_tktprint",
           "DEALPUB"        => "csg_start_dealpub",
           "DEALPUBCATCHER" => "csg_start_dealpubCatcher",
           "INSIGHT"        => "csg_start_glsupdate",
           "GLSSERVER"      => "csg_start_glsserver",
           "NYGMM"          => "csg_start_SenderToNY_GMM",
           "NYGMMDEV"       => "csg_start_SenderToNY_GMM_DEV",
           "GMMLN"          => "csg_start_SenderToLN_GMM",
           "GMMZH"          => "csg_start_SenderToZH_GMM",
           "FOBOCA"         => "csg_start_foboca",
           "SYSMONITOR"     => "csg_start_systemMonitor",
);

# Handler Name length: <= 8 

%AplicationLockName = (
           "PRINTING"       => "TKTPRINT",
           "DEALPUB"        => "DEALPUB",
           "DEALPUBCATCHER" => "DEALPUBCATCHER",
           "INSIGHT"        => "CSFB_GLSUPDATE",
           "GLSSERVER"      => "",
           "NYGMM"          => "NYGMM",
           "NYGMMDEV"       => "NYGMMDEV",
           "GMMLNXXX"       => "LNGMM",
           "GMMZHXXX"       => "ZHGMM",
           "FOBOCA"         => "FOBOCA",
);

%AplicationProcessName = (
           "PRINTING"       => "tktprint",
           "DEALPUB"        => "dealpub ",
           "DEALPUBCATCHER" => "dealpubCatcher",
           "INSIGHT"        => "GLSUpdate",
           "GLSSERVER"      => "GLSsrv",
           "NYGMM"          => "tradeIQ_RealtimeGmmExtractor.*NY_GMM[\$,\" \",\t]",
           "NYGMMDEV"       => "tradeIQ_RealtimeGmmExtractor.*NY_GMM_DEV",
           "GMMLNXXX"       => "tradeIQ_RealtimeGmmExtractor.*LN_xxx",
           "GMMZHXXX"       => "tradeIQ_RealtimeGmmExtractor.*ZH_xxx",
           "FOBOCA"         => "foboca_send",
           "SYSMONITOR"     => "systemMonitor",
);

%validNumberofProcesses = (
    "tktprint"       => 3,
    "GLSsrv"         => 2,
    "GLSUpdate"      => 3,
    "dealpub"        => 3,
    "dealpubCatcher" => 3,
    "NYGMM"          => 1,
    "NYGMMDEV"       => 1,
    "GMMLNXXX"       => 1,
    "GMMZHXXX"       => 1,
    "FOBOCA"         => 1,
    "systemMonitor"  => 1,

);

%ProcessesDisplayName = (
   "tktprint"       => "Ticket Printing",
   "GLSsrv"         => "Gls server",
   "GLSUpdate"      => "Gls Update",
   "dealpub"        => "Dealpub",
   "dealpubCatcher" => "Dealpub Catcher",
   "NYGMM"          => "Gmm Extractor (NY Production)",
   "NYGMMDEV"       => "Gmm Extractor (NY Test)",
   "GMMLNXXX"       => "Gmm Extractor (LN)",
   "GMMZHXXX"       => "Gmm Extractor (ZH)",
   "GMMZNXXX"       => "Gmm Extractor (ZH-North)",
   "FOBOCA"         => "FOBOCA Interface",
);

%instanceBU_Mapping = (
   "C"  => "0005",
   "L"  => "0020",
   "H"  => "0021",
);

@QBasedApps    = ("PRINTING","DEALPUB","INSIGHT","NYGMM","NYGMMDEV","GMMLNXXX","GMMZHXXX","FOBOCA");
@QBasedApps    = ("PRINTING","DEALPUB","INSIGHT","NYGMM","NYGMMDEV","FOBOCA");
@NotQBasedApps = ("DEALPUBCATCHER","GLSSERVER", "SYSMONITOR");  
@AppsInDevelopment = ();

@TradeIQApps = (@QBasedApps, @NotQBasedApps);

sub startApplication_old {
  my($appName, $instance) = @_;
  my ($pid)     = `echo $$  2>&1` ;  chop $pid;
  my ($tmpFile) = "/tmp/StartApp.$pid";
  my($script)   = $AplicationStartScript{$appName};
  my ($cmd)     = "$ENV{CSG_GLOBAL_STARTUP}/$script $instance > $tmpFile 2>&1"; 
  system($cmd);
}


sub startApplication {
  my($appName, $instance) = @_;
  my($script)   = $AplicationStartScript{$appName};
  my ($cmd)     = "$ENV{CSG_GLOBAL_STARTUP}/$script $instance > /dev/null 2>&1";
  my $retMsg    = submitUnixJob("", $cmd, "");
}

sub stopApplication {
  my ($app,  $instance) = @_;
  my ($PID)     = checkApplicationStatus($app,  $instance);

  printf("<!-- Stop Process with PID:${PID}\n -->");
  my ($cmd)     = "kill -9 $PID > /dev/null 2>&1 ";
  my $retMsg    = ` $cmd `;
}

sub checkApplicationStatus {
  my ($application,  $instance) = @_;
  my $msg    = "";
  my $retVal = 0;

  my ($procName)     = $AplicationProcessName{$application};
  $msg = `/usr/ucb/ps -auxww | grep '${procName}' | grep -v grep`;

  my @lines          = split ("\n",$msg);
  my $numberOfProcs  = @lines;
  my(@tmpProc)       = getPID($procName,$instance);
  my(@procRecord)    = split(";", $tmpProc[0]);
  my  $Pid = $procRecord[3] ;
  if (($numberOfProcs < $validNumberofProcesses{$procName}) &&
      ($numberOfProcs != 0)) {
      $retVal = 0;
  } else {
      $retVal = $Pid;
  }
  return $retVal;
}
##############################
## DATABASE RELATED
##############################

# all about dealsq
# ================

# get last queueItem
# ------------------
$sql_getMaxQItem =  qq {
   select max(QUEUEITEMID) QUEUEITEMID
   from dealsq
};

sub getDealsQMaxItem {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($maxItem) = getDealsQMaxItem_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return  $maxItem;
}

sub getDealsQMaxItem_dbh {
  my($dbh,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my (@maxItems) = ();
  my($prepared_getMaxQItem) = $dbh->prepare($sql_getMaxQItem);
  @maxItems     = dbExecutePreparedSelectSttmnt($prepared_getMaxQItem);
  if (@maxItems[0]) {
    return @maxItems[0]->{QUEUEITEMID};
  } else {
    return "";
  }
}

sub setDealsQMaxItem {
  my($database,$login,$password,$handlerName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setDealsQMaxItem_dbh($tradeIQ_dbHandler,$handlerName,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
}

sub copyDealsFromCSDealsQToPWDQ {
  my($dbh,$handlerName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);

  my($sql) = qq {
		INSERT into PROCESSWISE_DEALSQ
			SELECT DEALNUM,VERSION,DEALTYPE,SUBTYPE,CURRENTEVENT,DEALSTATE,TRADING_BOOK_FBO_ID_NUM,
				'${handlerName}',ENTITY_FBO_ID_NUM,TIMESTAMP from CS_DEALSQ
			where (DEALNUM,VERSION) not in (select DEALNUM,VERSION from PROCESSWISE_DEALSQ where PROCESS_NAME='${handlerName}') and TIMESTAMP >= (select max(trading_date) from sd_entity)
  };

  sqlExecute_dbh ( $sql, $dbh);
}

sub doNotProcessDeals {
	my($dbh,$handlerName) = @_;
	my($sql) = qq {
		DELETE FROM PROCESSWISE_DEALSQ 
			WHERE PROCESS_NAME='${handlerName}'
	};
	sqlExecute_dbh ($sql, $dbh);
}

sub setDealsQMaxItem_dbh {
	my($dbh,$handlerName,$logfile,$verbal) = @_;
	$verbal     = setDefault($verbal,$TRUE);

	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		doNotProcessDeals($dbh, $handlerName);
	} else {
		my($maxQItem) = getDealsQMaxItem_dbh($dbh,$logfile,$verbal);
		if ($maxQItem ne "") {
		update_lqeprocd_dbh($maxQItem,$handlerName,$dbh);
		}
	}
}

# set/get first queueItem from today
# ----------------------------------
$sql_getFirstQItemOfToday = qq {
     select *
     from  dealsq
     where QUEUEITEMID=(select min(QUEUEITEMID) QUEUEITEMID
       from dealsq
       where TIMESTAMP>=(select valueasdate
                            from sys_parameter
                            where parameterid='SystemDate'))
};

sub getDealsQFirstOfTheDayItem {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($firstItem) = getDealsQFirstOfTheDayItem_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return  $firstItem;
}

sub getDealsQFirstOfTheDayItem_dbh {
  my($dbh,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my (@firstItem) = ();
  my($prepared_getFirstQItemOfToday) = $dbh->prepare($sql_getFirstQItemOfToday);
  @firstItems = dbExecutePreparedSelectSttmnt($prepared_getFirstQItemOfToday);
  if(@firstItems[0]) {
     return @firstItems[0]->{QUEUEITEMID};
  } else {
     return "";
  }
}

sub setDealsQFirstOfTheDayItem {
  my($database,$login,$password,$handlerName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setDealsQFirstOfTheDayItem_dbh($tradeIQ_dbHandler,$handlerName,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
}

sub setDealsQFirstOfTheDayItem_dbh {
	my($dbh,$handlerName,$logfile,$verbal) = @_;
	$verbal     = setDefault($verbal,$TRUE);

	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		copyDealsFromCSDealsQToPWDQ($dbh,$handlerName,$logfile,$verbal);
	} else {
		my($firstQItem) = getDealsQFirstOfTheDayItem_dbh($dbh,$logfile,$verbal);
		if ($firstQItem ne "") {
			update_lqeprocd_dbh($firstQItem,$handlerName,$dbh);
		}
	}
}

# get/set last queueItem from yesterday (or last trading day)
# -----------------------------------------------------------
$sql_getLastQItemOfYesterday = qq {
     select *
     from  dealsq
     where QUEUEITEMID=(select max(QUEUEITEMID) QUEUEITEMID
       from dealsq
       where TIMESTAMP < (select valueasdate
                             from sys_parameter
                             where parameterid='SystemDate'))
};

sub getDealsQLastOfYesterdayItem {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($lastItem) = getDealsQLastOfYesterdayItem_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return  $firstItem;
}

sub getDealsQLastOfYesterdayItem_dbh {
  my($dbh,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my (@lastItem) = ();
  my($prepared_getLastQItemOfYesterday) = $dbh->prepare($sql_getLastQItemOfYesterday);
  @lastItem = dbExecutePreparedSelectSttmnt($prepared_getLastQItemOfYesterday);
  if (@lastItem[0]) {
     return @lastItem[0]->{QUEUEITEMID};
  } else {
     return "";
  }
}

sub setDealsQLastOfYesterdayItem {
  my($database,$login,$password,$handlerName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setDealsQLastOfYesterdayItem_dbh($tradeIQ_dbHandler,$handlerName,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
}

sub setDealsQLastOfYesterdayItem_dbh {
	my($dbh,$handlerName,$logfile,$verbal) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		copyDealsFromCSDealsQToPWDQ($dbh,$handlerName,$logfile,$verbal);
	} else {
		my($lastQItem) = getDealsQLastOfYesterdayItem_dbh($dbh,$logfile,$verbal);
		if ($lastQItem ne "") {
			update_lqeprocd_dbh($lastQItem,$handlerName,$dbh);
		}
	}
}

# get all qhanlers last processed item as a hash
# ----------------------------------------------
$sql_getAllQHandlers = qq {
    SELECT HANDLER_NAME,
           QUEUE_ITEM_ID
    FROM   lqeprocd
};

$sql_getAllQHandlers_70 = qq {
    SELECT process_name HANDLER_NAME,
           0 QUEUE_ITEM_ID
    FROM   queue_handlers
};

sub getQHandlersAsHash {
	my ($database,$login,$password,$logfile,$verbal) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
	my(%allQHanlders) = getQHandlersAsHash_dbh($tradeIQ_dbHandler,$logfile,$verbal);
	dbDisconnect($tradeIQ_dbHandler);
	return  %allQHanlders;
}

sub getQHandlersAsHash_dbh {
	my($dbh,$logfile,$verbal) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	my(@allQHanldersRef) = ();
	my(%allQHanlders)    = ();
	my($prepared_getAllQHandlers);
	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		$prepared_getAllQHandlers = $dbh->prepare($sql_getAllQHandlers_70);
	} else {
		$prepared_getAllQHandlers = $dbh->prepare($sql_getAllQHandlers);
	}
	@allQHanldersRef = dbExecutePreparedSelectSttmnt($prepared_getAllQHandlers);
	my($aQhandler) = "";
	foreach $aQhandler (@allQHanldersRef) {
		%allQHanlders = (%allQHanlders,($aQhandler->{HANDLER_NAME},$aQhandler->{QUEUE_ITEM_ID}));
	}
	return %allQHanlders;
}

# get all qhanlers polling time as a hash
# ---------------------------------------
$sql_getAllQHandlersPollingTime = qq {
    SELECT HANDLER_NAME,
           TIME_INTERVAL
    FROM   lqeprocd
};

$sql_getAllQHandlersPollingTime_70 = qq {
	SELECT process_name HANDLER_NAME , valueasint TIME_INTERVAL
		FROM   queue_handlers,sys_parameter where parameterid='ProcessPollingTime'
};

sub getQHandlersPollingTimeAsHash {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my(%allQHanlders) = getQHandlersPollingTimeAsHash_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return  %allQHanlders;
}

sub getQHandlersPollingTimeAsHash_dbh {
	my($dbh,$logfile,$verbal) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	my(@allQHanldersRef) = ();
	my(%allQHanlders)    = ();
	my($prepared_getAllQHandlersPollingTime) ;

	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		$prepared_getAllQHandlersPollingTime = $dbh->prepare($sql_getAllQHandlersPollingTime_70);
	} else {
		$prepared_getAllQHandlersPollingTime = $dbh->prepare($sql_getAllQHandlersPollingTime);
	}

	@allQHanldersRef = dbExecutePreparedSelectSttmnt($prepared_getAllQHandlersPollingTime);
	my($aQhandler) = "";
	foreach $aQhandler (@allQHanldersRef) {
		%allQHanlders = (%allQHanlders,($aQhandler->{HANDLER_NAME},$aQhandler->{TIME_INTERVAL}));
	}
	return %allQHanlders;
}



# get last processed qItem for a particular handler
# -------------------------------------------------
sub getLastQueueItemProcessed {
  my ($database,$login,$password,$handlerName,$logfile,$verbal,$notSetVal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($lastQItem) = getLastQueueItemProcessed_dbh($tradeIQ_dbHandler,$handlerName,$logfile,$verbal,$notSetVal);
  dbDisconnect($tradeIQ_dbHandler);
  return $lastQItem;
}

sub getLastQueueItemProcessed_dbh {
   my($dbh,$handlerName,$logfile,$verbal,$notSetVal) = @_;
   $verbal    = setDefault($verbal,$TRUE);
   $notSetVal = setDefault($notSetVal,"0");
   my(%allHandlers) = getQHandlersAsHash_dbh($dbh,$logfile,$verbal);
   if (exists($allHandlers{$handlerName})) {
      return $allHandlers{$handlerName};
   } else {
      return $notSetVal;
   }   
}

# get qItems behind for a particular handler
# ------------------------------------------
sub getQueueItemsBehindProcessed {
  my ($database,$login,$password,$handlerName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getQueueItemsBehindProcessed_dbh($tradeIQ_dbHandler,$handlerName,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub getQueueItemsBehindProcessed_dbh {
	my($dbh,$handlerName,$logfile,$verbal) = @_;
	$verbal    = setDefault($verbal,$TRUE);
	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		my (@maxItems) = ();
		$sql = qq {
			select count(*) COUNT from PROCESSWISE_DEALSQ
				WHERE process_name = '${handlerName}'
			};

		my($prepared_sql) = $dbh->prepare($sql);
		@maxItems     = dbExecutePreparedSelectSttmnt($prepared_sql);
		if (@maxItems[0]) {
			return @maxItems[0]->{COUNT};
		} else {
			return "";
		}
	} else {
		return "";
	}
}

# get polling time for a particular handler
# -----------------------------------------
sub getPollingTimeForHandler {
  my ($database,$login,$password,$handlerName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($lastQItem) = getPollingTimeForHandle_dbh($tradeIQ_dbHandler,$handlerName,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $lastQItem;
}

sub getPollingTimeForHandler_dbh {
   my($dbh,$handlerName,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   my(%allHandlers) = getQHandlersPollingTimeAsHash_dbh($dbh,$logfile,$verbal);
   if (exists($allHandlers{$handlerName})) {
      return $allHandlers{$handlerName};
   } else {
      return "";
   }   
}


# get all unprocessed qItem for a particular handler
# --------------------------------------------------
sub getNextQItemsToProcess {
  my ($database,$login,$password,$handlerName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my(@qItems) = ();
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  @qItems = getNextQItemsToProcess_dbh($tradeIQ_dbHandler,$handlerName,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return @qItems;
}

sub getNextQItemsToProcess_dbh {
	my($dbh,$handlerName,$logfile,$verbal) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	my(@qItems) = ();
	my($maxHandlerQItem);
	my($sql_getAllNewQItem);

	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		$sql_getAllNewQItem = qq {
					SELECT 
						DEALNUM, VERSION, DEALTYPE, SUBTYPE, CURRENTEVENT, DEALSTATE, TRADING_BOOK_FBO_ID_NUM, 
						PROCESS_NAME, ENTITY_FBO_ID_NUM, TIMESTAMP, 0 QUEUEITEMID
				 	from PROCESSWISE_DEALSQ
					WHERE process_name = '${handlerName}'
					order by DEALNUM, VERSION
		};
	} else {
		$sql_getAllNewQItem = "";
	}


	my($prepared_getAllNewQItem) = $dbh->prepare($sql_getAllNewQItem);
	@qItems    = dbExecutePreparedSelectSttmnt($prepared_getAllNewQItem);
	return @qItems;
}

# get all process locks as a hash
# -------------------------------
$sql_getAllProcLocks = qq {
    SELECT  *
    FROM   process_locks
};

sub getProcessLocksTableAsHash {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my(%allProcLocks) = getProcessLocksTableAsHash_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return  %allProcLocks;
}

sub getProcessLocksTableAsHash_dbh {
  my($dbh,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my(@allProcLocksRef) = ();
  my(%allProcLocks)    = ();
  my($prepared_getAllProcLocks) = $dbh->prepare($sql_getAllProcLocks);
  @allProcLocksRef = dbExecutePreparedSelectSttmnt($prepared_getAllProcLocks);
  my($aProcLock) = "";
  foreach $aProcLock (@allProcLocksRef) {
      %allProcLocks = (%allProcLocks,($aProcLock->{LOCK_NAME},$aProcLock->{LOCK_PID}));
  }
  return %allProcLocks;
}


# get single lock for a particular handler
# ----------------------------------------
sub getProcessLock {
  my ($database,$login,$password,$handlerName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($lock) = getProcessLock_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $lock;
}


sub getProcessLock_dbh {
  my($dbh,$handlerName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my(@allProcLocksRef) = ();
  my(%allProcLocks)    = ();
  my($prepared_getAllProcLocks) = $dbh->prepare($sql_getAllProcLocks);
  @allProcLocksRef = dbExecutePreparedSelectSttmnt($prepared_getAllProcLocks);
  my($lock) = "";
  my($aProcLock) = "";
  foreach $aProcLock (@allProcLocksRef) {
      if ($aProcLock->{LOCK_NAME} eq $handlerName) {
         $lock = $aProcLock->{LOCK_PID};
      }
  }
  return $lock;
}


# get count of page numbers
# -------------------------
$sql_getCountOfPageNumbers = qq {
    SELECT count(*) COUNT
    FROM   page_numbers
};

sub getCountOfPageNumbers {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($countOfPageNum) = getCountOfPageNumbers_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $countOfPageNum;
}

sub getCountOfPageNumbers_dbh {
  my($dbh,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my(@countOfPageNumers) = ();
  my($prepared_getCountOfPageNumbers) = $dbh->prepare($sql_getCountOfPageNumbers);
  @countOfPageNumers = dbExecutePreparedSelectSttmnt($prepared_getCountOfPageNumbers);
  return @countOfPageNumers[0]->{COUNT};
}

# Updating qhandler tables
# ------------------------
sub update_lqeprocd {
  my ($item_id, $handler_name, $database,$login, $password) = @_;
  my  $sql = qq { update lqeprocd set QUEUE_ITEM_ID=$item_id where HANDLER_NAME=\'$handler_name\' };
  sqlExecute ( $sql, $database,$login, $password);
}

sub update_lqeprocd_dbh {
  my ($item_id, $handler_name, $dbh) = @_;
  my  $sql = qq { update lqeprocd set QUEUE_ITEM_ID=$item_id where HANDLER_NAME=\'$handler_name\' };
  sqlExecute_dbh( $sql, $dbh);
}

sub remove_lock {
  my ($app_name,$database,$login, $password) =@_;
  my ($lock_name) = $AplicationLockName{$app_name};
  my  $sql = qq { delete from process_locks where LOCK_NAME=\'$lock_name\' };
  sqlExecute ( $sql, $database,$login, $password);
}

sub remove_lock_dbh {
  my ($app_name,$dbh) =@_;
  my ($lock_name) = $AplicationLockName{$app_name};
  my  $sql = qq { delete from process_locks where LOCK_NAME=\'$lock_name\' };
  sqlExecute_dbh ( $sql, $dbh);
}

sub removeLockForHandler {
  my ($lock_name,$database,$login, $password) =@_;
  my  $sql = qq { delete from process_locks where LOCK_NAME=\'$lock_name\' };
  sqlExecute ( $sql, $database,$login, $password);
}

sub removeLockForHandler_dbh {
  my ($lock_name,$dbh) =@_;
  my  $sql = qq { delete from process_locks where LOCK_NAME=\'$lock_name\' };
  sqlExecute_dbh ( $sql, $dbh);
}


sub setDbLock {
  my ($lockName,$lockValue,$database,$login, $password) =@_;
  my  $sql = qq { insert into process_locks values(\'$lockName\',\'$lockValue\')};
  sqlExecute($sql,$database,$login,$password);
}

sub setLock_dbh {
  my ($lockName,$lockValue,$dbh) =@_;
  my  $sql = qq { insert into process_locks values(\'$lockName\',\'$lockValue\')};
  sqlExecute_dbh($sql,$dbh);
}

sub trancate_page_numbers {
  my ($database,$login, $password) = @_;
  my  $sql = qq { truncate table page_numbers };
  sqlExecute ( $sql, $database,$login, $password);
}

sub trancate_page_numbers_dbh {
  my ($dbh) = @_;
  my  $sql = qq { truncate table page_numbers };
  sqlExecute_dbh ( $sql, $dbh);
}

$sql_getCountOfPageNumbers = qq {
    SELECT count(*) COUNT
    FROM   page_numbers
};


# get values from sysparameter table
# ==================================

sub getValueDateFromSysParam {
  my ($database,$login,$password,$fieldName,$logfile,$verbal,$dateFormat) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  $dateFormat = setDefault($dateFormat,"YYYYMMDD");
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getValueDateFromSysParam_dbh($tradeIQ_dbHandler,$fieldName,$logfile,$verbal,$dateFormat);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub getValueDateFromSysParam_dbh {
  my($dbh,$fieldName,$logfile,$verbal,$dateFormat) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  $dateFormat = setDefault($dateFormat,"YYYYMMDD");

  my $aSql = "";
  if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
     if(${fieldName} eq "SystemDate") {
        $aSql = qq {
           SELECT TO_CHAR(max(trading_date), '${dateFormat}') VALUEASDATE FROM sd_entity
        };
     } else {
        $aSql = qq {
           SELECT TO_CHAR(valueasdate, '${dateFormat}') VALUEASDATE FROM sys_parameter 
              WHERE parameterid = '${fieldName}'
        };
     }
  } else {
     $aSql = "";
  }
  ## print("getValueDateFromSysParam_dbh --> FieldName:${fieldName}:    sql:${aSql}:\n");
  my $prepared_sql = $dbh->prepare($aSql);
  my @valueDates = dbExecutePreparedSelectSttmnt($prepared_sql);
  return @valueDates[0]->{VALUEASDATE};
}

# get lastEodDate from sysparameter table
sub getLastEodDateFromSysParam {
  my ($database,$login,$password,$logfile,$verbal,$dateFormat) = @_;
  $dateFormat = setDefault($dateFormat,"YYYYMMDD");
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getLastEodDateFromSysParam_dbh($tradeIQ_dbHandler,$logfile,$verbal,$dateFormat);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub getLastEodDateFromSysParam_dbh {
	my($dbh,$logfile,$verbal,$dateFormat) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	$dateFormat = setDefault($dateFormat,"YYYYMMDD");

	my($aSql)  = "";
	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
	$aSql = qq {
		SELECT TO_CHAR(max(last_eod_date), '${dateFormat}') VALUEASDATE FROM eod_details
	};
	} else {
		$aSql = "";
	}

	my($prepared_sql) = $dbh->prepare($aSql);
	my(@valueDates) = dbExecutePreparedSelectSttmnt($prepared_sql);
	return @valueDates[0]->{VALUEASDATE};
}

# get lastTradingDay from sysparameter table
sub getLastTradingDayFromSysParam {
  my ($database,$login,$password,$logfile,$verbal,$dateFormat) = @_;
  $dateFormat = setDefault($dateFormat,"YYYYMMDD");
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getLastTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logfile,$verbal,$dateFormat);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub getLastTradingDayFromSysParam_dbh {
	my($dbh,$logfile,$verbal,$dateFormat) = @_;
	my $paramName = "LastTradingDay";
	$verbal     = setDefault($verbal,$TRUE);
	$dateFormat = setDefault($dateFormat,"YYYYMMDD");
	my $aSql = "";
	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		$aSql = qq {
			SELECT TO_CHAR(max(last_trading_date), '${dateFormat}') VALUEASDATE FROM sd_entity
		};
	} else {
		$aSql = "";
	}
	# addToLogFile("getLastTradingDayFromSysParam_dbh --> sql:${aSql}",$logFileName,$verbal);
	my $prepared_sql = $dbh->prepare($aSql);
	my @valueDates = dbExecutePreparedSelectSttmnt($prepared_sql);
	return @valueDates[0]->{VALUEASDATE};
}


# get systemDate from sysparameter table
sub getSystemDateFromSysParam {
  my ($database,$login,$password,$logfile,$verbal,$dateFormat) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  $dateFormat = setDefault($dateFormat,"YYYYMMDD");
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getSystemDateFromSysParam_dbh($tradeIQ_dbHandler,$logfile,$verbal,$dateFormat);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub getSystemDateFromSysParam_dbh {
  my($dbh,$logfile,$verbal,$dateFormat) = @_;
  my($fieldName) = "SystemDate";
  $verbal     = setDefault($verbal,$TRUE);
  $dateFormat = setDefault($dateFormat,"YYYYMMDD");
  my($retVal) = getValueDateFromSysParam_dbh($dbh,$fieldName,$logfile,$verbal,$dateFormat);
  return $retVal;
}

# get nextTradingDay from sysparameter table
sub getNextTradingDayFromSysParamTbl {
  my ($database,$login,$password,$logfile,$verbal,$dateFormat) = @_;
  $dateFormat = setDefault($dateFormat,"YYYYMMDD");
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getNextTradingDayFromSysParamTbl_dbh($tradeIQ_dbHandler,$logfile,$verbal,$dateFormat);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub getNextTradingDayFromSysParamTbl_dbh {
  my($dbh,$logfile,$verbal,$dateFormat) = @_;
  my($fieldName) = "Tomorrow";
  $verbal     = setDefault($verbal,$TRUE);
  $dateFormat = setDefault($dateFormat,"YYYYMMDD");
  my($retVal) = getValueDateFromSysParam_dbh($dbh,$fieldName,$logfile,$verbal,$dateFormat);
  return $retVal;
}

# get nextTradingDay from eod_control table (had to keep the name to be compatible with the existing applications) 
# Please use for any new application getNextTradingDay and getNextTradingDay_dbh

sub getNextTradingDayFromSysParam {
  my ($database,$login,$password,$logfile,$verbal,$dateFormat) = @_;
  $dateFormat = setDefault($dateFormat,"YYYYMMDD");
  $verbal     = setDefault($verbal,$TRUE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getNextTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logfile,$verbal,$dateFormat);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub getNextTradingDayFromSysParam_dbh {
	my($dbh,$logfile,$verbal,$dateFormat) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	$dateFormat = setDefault($dateFormat,"YYYYMMDD");
  
	my $aSql   = "";

	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		$aSql = qq {
			SELECT TO_CHAR(max(NEXT_TRADING_DATE), '${dateFormat}') VALUEASDATE FROM sd_entity
		};
	} else {
		$aSql = "";
	}

	## print("getNextTradingDayFromSysParam_dbh:    sql:${aSql}:\n");
	my $prepared_sql = $dbh->prepare($aSql);
	my @valueDates   = dbExecutePreparedSelectSttmnt($prepared_sql);
	return @valueDates[0]->{VALUEASDATE};
}

sub getNextTradingDay {
  my ($database,$login,$password,$logfile,$verbal,$dateFormat) = @_;
  return getNextTradingDayFromSysParam($database,$login,$password,$logfile,$verbal,$dateFormat);
}

sub getNextTradingDay_dbh {
  my($dbh,$logfile,$verbal,$dateFormat) = @_;
  return getNextTradingDayFromSysParam_dbh($dbh,$logfile,$verbal,$dateFormat);
}

# verifying the new system date
# -----------------------------
sub doTest_verifySystemDate {
   my($myFullName,$debugThisFct) = @_;
   $debugThisFct = setDefault($debugThisFct,$FALSE);

   my(@smsNumbers) = (
        $testEmailAdr_2." # Walti Geschaeft",
        "email: ".$testEmailAdr_1." # Walti Home",
        $testNatelNr_2_internationalShort."  # Walti Natel",
   );
   @smsNumbers = ();

   # test cases with valid dates
   # ---------------------------
   if (!(verifySystemDate("20030131210000","TEST","20030203","20030203","ZH","",$debugThisFct,@smsNumbers))) {
       print("ERROR: ${myFullName} failed (A)\n");
   }

   if (!(verifySystemDate("20030201013000","TEST","20030203","20030203","ZH","",$debugThisFct,@smsNumbers))) {
       print("ERROR: ${myFullName} failed (B)\n");
   }
   if (!(verifySystemDate("20021231210000","TEST","20030102","20030102","ZH","",$debugThisFct,@smsNumbers))) {
       print("ERROR: ${myFullName} failed (C)\n");
   }
   if (!(verifySystemDate("20030101013000","TEST","20030102","20030102","ZH","",$debugThisFct,@smsNumbers))) {
       print("ERROR: ${myFullName} failed (D)\n");
   }
   if (!(verifySystemDate("20021224210000","TEST","20021226","20021226","ZH","",$debugThisFct,@smsNumbers))) {
       print("ERROR: ${myFullName} failed (E)\n");
   }
   if (!(verifySystemDate("20021225013000","TEST","20021226","20021226","ZH","",$debugThisFct,@smsNumbers))) {
       print("ERROR: ${myFullName} failed (F)\n");
   }
   if (!(verifySystemDate("20021225013000","TEST","20021225","20021225","NY","",$debugThisFct,@smsNumbers))) {
       print("ERROR: ${myFullName} failed (G)\n");
   }


   # test cases with invalid dates
   # -----------------------------
   if (verifySystemDate("20030131210000","TEST","20030204","20030203","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (A-1)\n");
   }
   if (verifySystemDate("20030131210000","TEST","20030204","20030204","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (A-2)\n");
   }

   if (verifySystemDate("20030201013000","TEST","20030204","20030203","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (B-1)\n");
   }
   if (verifySystemDate("20030201013000","TEST","20030204","20030204","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (B-2)\n");
   }

   if (verifySystemDate("20021231210000","TEST","20030101","20030101","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (C-1)\n");
   }
   if (verifySystemDate("20021231210000","TEST","20030101","20030102","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (C-2)\n");
   }
   if (verifySystemDate("20021231210000","TEST","20030103","20030103","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (C-3)\n");
   }

   if (verifySystemDate("20020101013000","TEST","20030101","20030101","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (D-1)\n");
   }
   if (verifySystemDate("20020101013000","TEST","20030101","20030102","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (D-2)\n");
   }
   if (verifySystemDate("20020101013000","TEST","20030103","20030103","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (D-3)\n");
   }

   if (verifySystemDate("20021224210000","TEST","20021225","20021225","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (E-1)\n");
   }
   if (verifySystemDate("20021224210000","TEST","20021224","20021225","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (E-2)\n");
   }
   if (verifySystemDate("20021224210000","TEST","20021227","20021227","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (E-3)\n");
   }

   if (verifySystemDate("20021225013000","TEST","20021225","20021225","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (F-1)\n");
   }
   if (verifySystemDate("20021225013000","TEST","20021224","20021225","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (F-2)\n");
   }
   if (verifySystemDate("20021225013000","TEST","20021227","20021227","ZH","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (F-3)\n");
   }

   if (verifySystemDate("20021225013000","TEST","20021226","20021226","NY","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (G-1)\n");
   }
   if (verifySystemDate("20021225013000","TEST","20021226","20021225","NY","",$debugThisFct,@smsNumbers)) {
       print("ERROR: ${myFullName} failed (G-2)\n");
   }

}

# returns true if the dates are valid
sub verifySystemDate {
   my($nowTimeStamp,$instance,$newSystemDate,$oldNextTradingDate,$cityCode,$logFileName,$verbal,@smsNumbers) = @_;
 
   my $smsNumbersStr = makeQuotedStrFromArray(",","",@smsNumbers);
   my $formatedGmmNextSysDateStr = formatTimeStamp($oldNextTradingDate, "", $TRUE, $FALSE, $LangEnglish);
   my $formatedTiqSysDateStr     = formatTimeStamp($newSystemDate,      "", $TRUE, $FALSE, $LangEnglish);

   my $retVal = $TRUE;

   my $nextWorkingDay  = getNextWorkingDay($nowTimeStamp);
   my $hhmmssTimeStamp = substr($nowTimeStamp,8,6);

   if ($hhmmssTimeStamp < "120000") {
       if (($cityCode eq "ZH") || ($cityCode eq "ZN")) {
          $nextWorkingDay  = getNextWorkingDay(daysAddToYYYYMMDD($nowTimeStamp,-1),"isNotWorkingDayFct_TIQ_ZH");
       } else {
          $nextWorkingDay  = getNextWorkingDay(daysAddToYYYYMMDD($nowTimeStamp,-1));
       }
   } else {
       if (($cityCode eq "ZH") || ($cityCode eq "ZN")) {
          $nextWorkingDay  = getNextWorkingDay($nowTimeStamp,"isNotWorkingDayFct_TIQ_ZH");
       } else {
          $nextWorkingDay  = getNextWorkingDay($nowTimeStamp);
       }

   }

   my $smsMsg = "${instance} at ${nowTimeStamp} GMM NextSys:${formatedGmmNextSysDateStr}  TIQ Sys:${formatedTiqSysDateStr}  nextWorkingDay:${nextWorkingDay}";
   ## addToLogFile("Sent SMS to ${smsNumbersStr}: ${smsMsg}",$logFileName,$verbal);
   ## sendShortMsg($smsMsg,"","",$verbal,@smsNumbers);

   if ($oldNextTradingDate ne $newSystemDate) {
     my $smsMsg = "WARNING (1) ${instance} GMM NextSys:${formatedGmmNextSysDateStr}  TIQ Sys:${formatedTiqSysDateStr}";
     addToLogFile("Sent SMS to ${smsNumbersStr}: ${smsMsg}",$logFileName,$verbal);
     sendShortMsg($smsMsg,"","",$verbal,@smsNumbers);
     $retVal = $FALSE;
   }

   if ($nextWorkingDay ne $newSystemDate) {
     my $smsMsg = "WARNING (2) ${instance} TIQ Sys:${formatedTiqSysDateStr} nextWorkingDay:${nextWorkingDay}";
     addToLogFile("Sent SMS to ${smsNumbersStr}: ${smsMsg}",$logFileName,$verbal);
     sendShortMsg($smsMsg,"","",$verbal,@smsNumbers);
     $retVal = $FALSE;
   }
   return $retVal;
}

sub isNotWorkingDayFct_TIQ_ZH {
  my($yyyymmddStr) = @_;
  my $mmddStr = substr($yyyymmddStr,4,4);
  if (($mmddStr eq "0101") ||
      ($mmddStr eq "1225")) {
      return $TRUE;
  } else {
      return $FALSE;
  }
}

# last of year/month
# ------------------
sub isLastTradingDayOfMonth {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = isLastTradingDayOfMonth_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub isLastTradingDayOfMonth_dbh {
  my($dbh,$logfile,$verbal) = @_;
  my($today)            = getSystemDateFromSysParam_dbh($dbh,$logfile,$verbal);
  my($today_month)      = substr($today,4,2);

  my($tomorrow)         = getNextTradingDayFromSysParam_dbh($dbh,$logfile,$verbal);
  my($tomorrow_month)   = substr($tomorrow,4,2);
  if ($tomorrow_month ne $today_month) {
     return $TRUE;
  } else {
     return $FALSE;
  }
}

sub isLastTradingDayOfYear {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = isLastTradingDayOfYear_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub isLastTradingDayOfYear_dbh {
  my($dbh,$logfile,$verbal) = @_;
  my($today)            = getSystemDateFromSysParam_dbh($dbh,$logfile,$verbal);
  my($today_year)       = substr($today,0,4);

  my($tomorrow)         = getNextTradingDayFromSysParam_dbh($dbh,$logfile,$verbal);
  my($tomorrow_year)    = substr($tomorrow,0,4);
  if ($tomorrow_year ne $today_year) {
     return $TRUE;
  } else {
     return $FALSE;
  }
}

# First of year month
# -------------------
sub isFirstTradingDayOfMonth {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = isFirstTradingDayOfMonth_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub isFirstTradingDayOfMonth_dbh {
  my($dbh,$logfile,$verbal) = @_;
  my($today)            = getSystemDateFromSysParam_dbh($dbh,$logfile,$verbal);
  my($today_month)      = substr($today,4,2);

  my($yesterday)        = getLastTradingDayFromSysParam_dbh($dbh,$logfile,$verbal);
  my($yesterday_month)  = substr($yesterday,4,2);

  if ($yesterday_month ne $today_month) {
     return $TRUE;
  } else {
     return $FALSE;
  }
}

sub isFirstTradingDayOfYear {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = isFirstTradingDayOfYear_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub isFirstTradingDayOfYear_dbh {
  my($dbh,$logfile,$verbal) = @_;
  my($today)            = getSystemDateFromSysParam_dbh($dbh,$logfile,$verbal);
  my($today_year)       = substr($today,0,4);

  my($yesterday)        = getLastTradingDayFromSysParam_dbh($dbh,$logfile,$verbal);
  my($yesterday_year)   = substr($yesterday,0,4);

  if ($yesterday_year ne $today_year) {
     return $TRUE;
  } else {
     return $FALSE;
  }
}

# fuction used for building your own qHandler process
# ===================================================
sub initLqeprocd {
  my ($handler_name,$startVal,$pollingTime,$database,$login, $password) =@_;
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  initLqeprocd_dbh($handler_name,$startVal,$pollingTime,$tradeIQ_dbHandler);
  dbDisconnect($tradeIQ_dbHandler);
}

sub initLqeprocd_dbh {
  my($handler_name,$startVal,$pollingTime,$dbh) =@_;
  my($HANDLER_NAME)    = $handler_name;
  my($INSTANCE_NAME)   = $handler_name;
  my($QUEUE_ITEM_ID)   = $startVal;
  my($SUBTYPE)         = "POLLING";
  my($TIMESTAMP)       = getDateTimeStamp();
  my($TIME_INTERVAL)   = $pollingTime;
  my($PID)             = "";
  my($HOST_NAME)       = getMyUnixHostname();
  my($TRANSACTION_NUM) = "";
  my($RTR_ID)          = "";
  $QUEUE_ITEM_ID       = setDefault($QUEUE_ITEM_ID,"0");

	my $sql =  "";
	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		$sql = qq { insert into queue_handlers
						( PROCESS_NAME )
						values
						( \'$HANDLER_NAME\')
					};
	} else {
		$sql = "";
	}
	sqlExecute_dbh($sql,$dbh);
}

sub prepareQhandler {
   my($dbHandler,$handlerName) = @_;
   my $retStr = "";
   # check if there is a look for such a handler
   my $procLock = getProcessLock_dbh($dbHandler,$handlerName,$logfile,$verbal);
   if ($procLock eq "") {
       setLock_dbh($handlerName,getMyUnixPid(),$dbHandler);
       # may be you need to insert an entry in lqprocsd
       my $lastQItemID  = getLastQueueItemProcessed_dbh($dbHandler,$handlerName,$logfile,$verbal,"NotDefined");
       if ($lastQItemID eq "NotDefined") {
          initLqeprocd_dbh($handlerName,"0",$initPollingTime,$dbHandler); 
       }
   } else {
       $retStr = "Already a process for ${handlerName} is running with PID=${procLock} or\nSQL> delete from process_locks where LOCK_NAME='${handlerName}';";
   }
   return $retStr;
}



# pollingDealsQueue
# -----------------
# That is the main function which polls the dealsQ and calls a user function 
# passing each time a qItem to process. The userFunction returns $TRUE if the 
# item was successfuly processed otherwiese $FALSE
#
# Calling:   pollingDealsQueue($tradeIQ_dbHandler,$handlerName,\&userProcess,$logfile,$verbal); 
#
# sub userProcess {
#    my($dbh,$aRecord) = @_;
#    print "Name: $aRecord->{QUEUEITEMID}\n";
#    if ($aRecord->{QUEUEITEMID} eq "7992040") {
#       return $FALSE;
#    } else {
#      return $TRUE;
#    }
# }

sub markRecordProcessed {
	my($dbh,$handlerName, $qitemid, $deal_num, $dealver) = @_;

	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		my($sql) = qq {
			DELETE from PROCESSWISE_DEALSQ
				WHERE process_name = '${handlerName}' and dealnum=$deal_num and version=$dealver
		};
		sqlExecute_dbh ($sql, $dbh);
	} else {
		update_lqeprocd_dbh($qitemid,$handlerName,$dbh);
	}
}

sub pollingDealsQueue {
    my($dbh,$handlerName,$userFunctionCb,$eventReceiverFct,$allItemsProcFct,$beforeSleepFct,$logfile,$verbal) = @_;
    my $doRunning = $TRUE;
    while ($doRunning) {
     my $event =  "";
     my(@qItems)    = getNextQItemsToProcess_dbh($dbh,$handlerName);
     my $qItemCount = @qItems;
     if ($qItemCount > 0) {
       my($record) = "";
       foreach $record (@qItems ) {
           $event = &$eventReceiverFct();
           if ($event eq "disabled") {
               $qItemCount = 0;
               last;
           } elsif ($event eq "shutdown") {
               $doRunning = $FALSE;
               last;
           }
           addToLogFile(sprintf("-----------> Calling userFunction(%s %s %s)",$record->{QUEUEITEMID},$record->{DEALNUM}, $record->{VERSION}),$logfile,$verbal);
           my($retVal) = &$userFunctionCb($dbh,$record);
           if ($retVal) {
				markRecordProcessed($dbh,$handlerName, $record->{QUEUEITEMID}, $record->{DEALNUM}, $record->{VERSION});
               addToLogFile(sprintf(" --> %s  %s  %s processed\n\n",$record->{QUEUEITEMID},$record->{DEALNUM}, $record->{VERSION}),$logfile,$verbal);
           } else {
               addToLogFile(sprintf(" --> %s  %s  %s failed\n\n",$record->{QUEUEITEMID},$record->{DEALNUM}, $record->{VERSION}),$logfile,$verbal);
               $qItemCount = 0;
               last;
           }
       }
       &$allItemsProcFct();
     }
     if ($qItemCount ==0) {
        $event = &$eventReceiverFct();
        if ($event eq "disabled") {
            addToLogFile("-----------> RTF has been disabled",$logfile,$verbal);
        } elsif ($event eq "shutdown") {
            addToLogFile("-----------> RTF has been shutdown",$logfile,$verbal);
            $doRunning = $FALSE;
        }
        if ($doRunning) {
           my $pollingInterval = setDefault(getPollingTimeForHandler_dbh($tradeIQ_dbHandler,$handlerName,$logfile,$verbal),$initPollingTime);
           &$beforeSleepFct();
           $sleptPeriodes = pollingSleep($pollingInterval,$lineLength,$sleptPeriodes);
        }
     }
  }
  removeLockForHandler_dbh($handlerName,$tradeIQ_dbHandler);
}

sub getDealRecord {
   my($dealType,$dealNum,$outFilename,$tmpOutFilename) = @_;
   my(%dealRecord) = ();
   my $selectStatmentFctName  = "getSqlStatmentFor_${dealType}_${locationCode}_${tiqVersion}";
    
   if (! defined(&$selectStatmentFctName)) {
     $selectStatmentFctName = "getSqlStatmentFor_${dealType}_${tiqVersion}"; 
     if (! defined(&$selectStatmentFctName)) {
        $selectStatmentFctName = "getSqlStatmentFor_${dealType}_${locationCode}"; 
        if (! defined(&$selectStatmentFctName)) {
           $selectStatmentFctName = "getSqlStatmentFor_${dealType}";
        }
     }  
   }
   addToLogFile("----> Use selectFct:${selectStatmentFctName}",$logFileName,$verbal);

   my $postProcessorFctName   = "postProcessorFor_${dealType}";
   my $outputFieldsArrayName  = "outputFields_${dealType}";
   my(@outputFields)          = @$outputFieldsArrayName;

   my($usePostProcFlagName) = "use_${postProcessorFctName}";
   if (!($$usePostProcFlagName)) {
      $postProcessorFctName = "";
   }

   my($whereClause) = "";
   if ($dealNum ne "") {
     $whereClause = "AND (a.Deal_Num IN (${dealNum}))"
   }
   my($selectStatement) = &$selectStatmentFctName($whereClause,$doFilter);
   if ($detailedTrace) {
      addToLogFile(sprintf("selectStatement for ${dealType}:${selectStatement}"),$logFileName,$verbal);
      # addToLogFile(sprintf("output fields for ${dealType}:%s",makeStrFromArray("\|",@outputFields)),$logFileName,$verbal);
      addToLogFile(sprintf("%s...%s",getFileNameOutOfFullName($tmpOutFilename),getFileNameOutOfFullName($outFilename)),$logFileName,$verbal);
   }
   my($countOfRecordsWritten) = sqlToFlatWithPostProcessor_dbh($selectStatement,$postProcessorFctName,$outFilename,$tmpOutFilename,\@outputFields,$FALSE,"","",$logFileName,$detailedTrace,$tradeIQ_dbHandler);
   %dealRecord = getSingleRecInHash($outFilename,"\\|","","","",$FALSE);  
   return %dealRecord;
}

sub getDealRecords {
   my($dealType,$outFilename,$tmpOutFilename,@dealNumbers) = @_;
   my(%dealRecord) = ();

   my $selectStatmentFctName  = "getSqlStatmentFor_${dealType}_${locationCode}_${tiqVersion}";    
   if (! defined(&$selectStatmentFctName)) {
     $selectStatmentFctName = "getSqlStatmentFor_${dealType}_${tiqVersion}"; 
     if (! defined(&$selectStatmentFctName)) {
        $selectStatmentFctName = "getSqlStatmentFor_${dealType}_${locationCode}"; 
        if (! defined(&$selectStatmentFctName)) {
           $selectStatmentFctName = "getSqlStatmentFor_${dealType}";
        }
     }  
   }
   addToLogFile("----> Use selectFct:${selectStatmentFctName}",$logFileName,$verbal);

   my($postProcessorFctName)  = "postProcessorFor_${dealType}";
   my($outputFieldsArrayName) = "outputFields_${dealType}";
   my(@outputFields)          = @$outputFieldsArrayName;

   my($usePostProcFlagName) = "use_${postProcessorFctName}";
   if (!($$usePostProcFlagName)) {
      $postProcessorFctName = "";
   }

   my($whereClause) = makeDealNumWhereClause("a.Deal_Num",@dealNumbers);
   if ($whereClause ne "") {
       $whereClause = "AND (${whereClause})";
   }
   my($selectStatement) = &$selectStatmentFctName($whereClause,$doFilter);
   if ($detailedTrace) {
      addToLogFile(sprintf("selectStatement for ${dealType}:${selectStatement}"),$logFileName,$verbal);
      # addToLogFile(sprintf("output fields for ${dealType}:%s",makeStrFromArray("\|",@outputFields)),$logFileName,$verbal);
      addToLogFile(sprintf("%s...%s",getFileNameOutOfFullName($tmpOutFilename),getFileNameOutOfFullName($outFilename)),$logFileName,$verbal);
   }
   my($countOfRecordsWritten) = sqlToFlatWithPostProcessor_dbh($selectStatement,$postProcessorFctName,$outFilename,$tmpOutFilename,\@outputFields,$FALSE,"","",$logFileName,$detailedTrace,$tradeIQ_dbHandler);
}

# get tiq calendars
# -----------------
$isNameIn_sd_calendar_dates = "";

sub isNameIn_sd_calendar_dates {
  my($dbh) = @_;
  
  if ($isNameIn_sd_calendar_dates eq "") {  
     $isNameIn_sd_calendar_dates = isFieldExistsInTable_dbh($dbh,"SD_CALENDAR_DATES","NAME");
  }
  return $isNameIn_sd_calendar_dates;
}

sub getSqlForGetTiqHolidayCalendar {
  my($dbh,$currency,$year) = @_;
  
  if (isNameIn_sd_calendar_dates($dbh)) {
      return qq {
         SELECT distinct to_char(holiday,'YYYYMMDD') holiday,
                description                 description
         FROM sd_calendar_dates
         WHERE name IN ('${currency}') AND
               to_char(holiday,'YYYY') IN ('${year}')
         ORDER BY holiday
         };
  } else {
      return qq {
         SELECT distinct to_char(holiday,'YYYYMMDD') holiday,
                description                 description
         FROM sd_calendar_dates
         WHERE ccy_cal_fbo_id_num = (select fbo_id_num from sd_ccy_calendar where name IN ('${currency}')) AND
               to_char(holiday,'YYYY') IN ('${year}')
         ORDER BY holiday
         };
  }
}

# returns a hash with the date as a hash key in the formate YYYYMMDD. The value is a description of the holiday.
sub getTiqHolidayCalendarAsHash {
  my($database,$login,$password,$currency,$year,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my $tradeIQ_dbHandler = dbConnect($database,$login,$password,$logfile,$verbal);
  my(%calendarHash) = getTiqHolidayCalendarAsHash_dbh($tradeIQ_dbHandler,$currency,$year,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return  %calendarHash;
}

sub getTiqHolidayCalendarAsHash_dbh {
  my($dbh,$currency,$year,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  $year =~s/,/','/g;
  $currency =~s/,/','/g;
  $currency = uc($currency);

  my $aSelect = getSqlForGetTiqHolidayCalendar($dbh,$currency,$year);
  my(%calendarHash)    = ();
  my(@tiqCalendarRef)  = ();
  my $prepared_getTiqCalendars = $dbh->prepare($aSelect);
  @tiqCalendarRef = dbExecutePreparedSelectSttmnt($prepared_getTiqCalendars);

  foreach my $aCalendarRef (@tiqCalendarRef) {
      %calendarHash = (%calendarHash,($aCalendarRef->{HOLIDAY},$aCalendarRef->{DESCRIPTION}));
  }
  return %calendarHash;
}

# returns a array with the date in the formate YYYYMMDD.
sub getTiqHolidayCalendar {
  my($database,$login,$password,$currency,$year,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my $tradeIQ_dbHandler = dbConnect($database,$login,$password,$logfile,$verbal);
  my(@calendarArray) = getTiqHolidayCalendar_dbh($tradeIQ_dbHandler,$currency,$year,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return @calendarArray;
}

sub getTiqHolidayCalendar_dbh {
  my($dbh,$currency,$year,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  $year =~s/,/','/g;
  $currency =~s/,/','/g;
  $currency = uc($currency);


  my $aSelect = getSqlForGetTiqHolidayCalendar($dbh,$currency,$year);

  my(@calendarArray)    = ();
  my(@tiqCalendarRef)  = ();
  my $prepared_getTiqCalendars = $dbh->prepare($aSelect);
  @tiqCalendarRef = dbExecutePreparedSelectSttmnt($prepared_getTiqCalendars);

  foreach my $aCalendarRef (@tiqCalendarRef) {
     push(@calendarArray,$aCalendarRef->{HOLIDAY});
  }
  return @calendarArray;
}



# get  TIQ version
# ----------------
$tiqMasterVersionStr = "";
$isTiqVersion_70     = "";

$sql_getTIQ_MasterVersion = qq {
     select valueastext
     from  sys_parameter
     where parameterGroup = 'System' AND
           parameterId    = 'SystemMasterVersion'
};

sub getTIQ_VersionStrForLogfile {
  my($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my $tradeIQ_dbHandler = dbConnect($database,$login,$password,$logfile,$verbal);
  my $logVersionStr = getTIQ_VersionStrForLogfile_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return  $logVersionStr;
}

sub getTIQ_VersionStrForLogfile_dbh {
	my($dbh,$logfile,$verbal) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	my $retString = "TIQ Master-Version:".getTIQ_MasterVersionFromDb_dbh($dbh,$logfile,$verbal)."     ";

	if (isTIQ_Version_70_dbh($dbh,$logfile,$verbal)) {
		$retString = "${retString} ---> It is a 7.0 Version";
	} else {
		$retString = "${retString} ---> It is NOT a 7.0 Version";
	}
	return $retString;
}

sub getTIQ_MasterVersionFromDb {
  my($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my $tradeIQ_dbHandler = dbConnect($database,$login,$password,$logfile,$verbal);
  my $tiqVersionStr = getTIQ_MasterVersionFromDb_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return  $tiqVersionStr;
}

sub getTIQ_MasterVersionFromDb_dbh {
  my($dbh,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my (@firstItem) = ();
  my($prepared_getTIQ_MasterVersion) = $dbh->prepare($sql_getTIQ_MasterVersion);
  @versionStr = dbExecutePreparedSelectSttmnt($prepared_getTIQ_MasterVersion);
  if(@versionStr[0]) {
     return @versionStr[0]->{VALUEASTEXT};
  } else {
     return "";
  }
}


sub setTIQ_Versions {
	my($dbh,$logfile,$verbal) = @_;

	# Get the version Only once
	if ($tiqMasterVersionStr eq "") {
		$tiqMasterVersionStr = getTIQ_MasterVersionFromDb_dbh($dbh,$logfile,$verbal);
		addToLogFile(("=====> TIQ Version: ${tiqMasterVersionStr}"),$logfile,$verbal);
	}

	# Set the version variables accordingly
	if (index($tiqMasterVersionStr,"7.0") == 0) {
		$isTiqVersion_70 = $TRUE;
	} else {
		addToLogfileAndNotifyForError("=====>ERROR: ${tiqMasterVersionStr} is an unknow FT version in tiqPerlLib.pm",$logFileName,$verbal);
		exit 1;
	}
}

sub isTIQ_Version_70_dbh {
	my($dbh,$logfile,$verbal) = @_;

	if ($isTiqVersion_70 eq "") {
		setTIQ_Versions($dbh,$logfile,$verbal);
	}
	return $isTiqVersion_70;
}


# Dealloader / Tradeloader descriptor file functions
# --------------------------------------------------
sub getTIQ_DescFilename {
  my($loaderAction,$dealType,$extension,$locationCode) = @_;
  $extension = setDefault($extension,"desc");
  if ($locationCode ne "") {
     $locationCode = "_".uc($locationCode);
  }
  $dealType =~ s/_//g;
  return lc($loaderAction)."${locationCode}_".lc($dealType).".${extension}";
}

# returns a hash where the key is the variable names and values is the data
sub formatDataStringUsingTIQ_DescFile {
   my($dataString,$descFileName) = @_;
   my(%retHash) = ();
   my @varNames = getAllVariableNamesFromTIQ_DescFile($descFileName);
   foreach my $aVarName (@varNames) {
      my($start,$len) = getPosAndLenFromTIQ_DescFile($descFileName,$aVarName);
      %retHash = (%retHash,($aVarName,substr($dataString,$start,$len)));
   }
   return %retHash;
}

# returns a string for the loader data file entry using a hash with the data and a descriptor file to format
sub getDealLoaderDataString {
  my($descFile,%tradeData) = @_;
  my $dataFileEntry = "";

  my(@requiredFields) = getAllVariableNamesFromTIQ_DescFile($descFile);
  foreach my $aRequiredField (@requiredFields) {
     my($startPos,$len) = getPosAndLenFromTIQ_DescFile($descFile,$aRequiredField);
     my $val = $tradeData{$aRequiredField};
     if (length($val) > $len) {
        $val = substr($val,0,$len);
     } else {
        $val = sprintf("%-${len}s",$val);
     }
     if (length($dataFileEntry) <= $startPos + $len) {
        $dataFileEntry = sprintf("%-${startPos}s${val}",$dataFileEntry);
     } else {
        my $firstPart = substr($dataFileEntry,0,$startPos);
        my $lastPart  = substr($dataFileEntry,$startPos + $len,length($dataFileEntry) - $startPos - $len);
        $dataFileEntry = "${firstPart}${val}${lastPart}";
     }
  }
  return $dataFileEntry;
}


sub getAllVariableNamesFromTIQ_DescFile {
   my($descFileName) = @_;
   my(@retList)  = ();
   open(FILE_getAllVariableNamesFromDescFile,$descFileName) || showError(sprintf("Error (getPosAndLenFromTIQ_DescFile): Can't open file:${descFileName}: %s",$!));
   while (defined (my $aLine = <FILE_getAllVariableNamesFromDescFile>)) {
     chomp($aLine);
     $aLine = strip($aLine);
     if (((index($aLine,"F:") == 0) ||
         (index($aLine,"THEN:") == 0))&& 
         (index($aLine,"L:[P:") != -1)) {
	if (index($aLine,"F:") == 0) {
           $aLine = substr($aLine,2,index($aLine,"L:[P:")-2);
	}
	if (index($aLine,"THEN:") == 0) {
           $aLine = substr($aLine,5,index($aLine,"L:[P:")-5);
        }
        $aLine = strip($aLine);
        push(@retList,$aLine);

        ## $aLine =~ s/\s+P:/:/g;
        ## $aLine =~ s/\s+S:/:/g;

        ## my @parts = split(":",$aLine);
        ## $fieldName = strip($parts[1]);
        ## $fieldName =~ s/^F://g;
        ## $fieldName =~ s/\s+D$//g;
        ## push(@retList,$fieldName);
        ## printf("----> fieldName:${fieldName}:\n");
     }
   }
   close(FILE_getAllVariableNamesFromDescFile);
   return (@retList);
}

sub getPosAndLenFromTIQ_DescFile_OLD {
   my($descFileName,$fieldName) = @_;
   my $start = -1;
   my $len   = 0;
   open(FILE_getPosAndLenFromTIQ_DescFile,$descFileName) || showError(sprintf("Error (getPosAndLenFromTIQ_DescFile): Can't open file:${descFileName}: %s",$!));
   while (defined (my $aLine = <FILE_getPosAndLenFromTIQ_DescFile>)) {
     chomp($aLine);
     $aLine = strip($aLine);
     if ((index($aLine,"F:${fieldName}") == 0) ||
         (index($aLine,"THEN:${fieldName}") == 0)) {
        ## old $aLine =~ s/\s+P:/:/g;
        ## old $aLine =~ s/\s+S:/:/g;

        $aLine =~ s/\s+L:\[P:/:/g;
        $aLine =~ s/\s+L:/:/g;


        my @parts = split(":",$aLine);
        $start = strip($parts[2]);
        $len   = strip($parts[3]); 
        $len   = substr($len,0,index($len,"]"));               
        ## printf("----> aLine:${aLine}::%s:%s:\n",$start,$len);
        last;
     }
   }
   close(FILE_getPosAndLenFromTIQ_DescFile);
   return ($start,$len);
}
sub getPosAndLenFromTIQ_DescFile {
   my($descFileName,$fieldName) = @_;
   my $start = -1;
   my $len   = 0;
 
   open(FILE_getPosAndLenFromTIQ_DescFile,$descFileName) || showError(sprintf("Error (getPosAndLenFromTIQ_DescFile): Can't open file:${descFileName}: %s",$!));
   while (defined (my $aLine = <FILE_getPosAndLenFromTIQ_DescFile>)) {
     chomp($aLine);
     $aLine = strip($aLine);
 
     $aLine =~ s/\t/ /g; # replace tabs with spaces
     my $firstSpacePosition = index($aLine,' ' );
 
     my $linePart =  substr($aLine,0, $firstSpacePosition );
 
     if (($linePart eq "F:${fieldName}") ||
         ($linePart eq "THEN:${fieldName}")) {
 
        $aLine =~ s/\s+L:\[P:/:/g;
        $aLine =~ s/\s+L:/:/g;
 
 
        my @parts = split(":",$aLine);
        $start = strip($parts[2]);
        $len   = strip($parts[3]);
        $len   = substr($len,0,index($len,"]"));
        ## printf("----> aLine:${aLine}::%s:%s:\n",$start,$len);
        last;
     }
   }
   close(FILE_getPosAndLenFromTIQ_DescFile);
   return ($start,$len);
}

sub getTiqDealVersion {
  my ($database,$login,$password,$TiqDealNumber,$TiqDealState) = @_;
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password);
  my($retVal) = getTiqDealVersion_dbh($tradeIQ_dbHandler,$TiqDealNumber,$TiqDealState);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub getTiqDealVersion_dbh {
  my($dbh,$TiqDealNumber,$TiqDealState) = @_;
  my(@ResultRef) = ();
  my $DealVersion = "";

  if (($TiqDealNumber ne "") && ($TiqDealState ne "")) {
     $sqlToGetTiqDealVersion = qq {
        select VERSION
        from   ALL_DEALS
        where  DEAL_NUM = $TiqDealNumber
     };
     $preparedsqlToGetTiqDealVersion = $dbh->prepare($sqlToGetTiqDealVersion);
     @ResultRef = dbExecutePreparedSelectSttmnt($preparedsqlToGetTiqDealVersion);
     if (@ResultRef[0]) {
        $DealVersion = @ResultRef[0]->{VERSION};
     }
  } else {
     addToLogFile("getTiqDealVersion:incorrect parameters",$logFileName,$verbal);
  }
  if ($IsTest) {
     addToLogFile("---> Selecting Deal version from deal number/${TiqDealNumber}:${DealVersion}:",$logFileName,$verbal);
  }
  return $DealVersion;
}


sub getTiqDealState {
  my ($database,$login,$password,$TiqDealNumber) = @_;
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password);
  my($retVal) = getTiqDealState_dbh($tradeIQ_dbHandler,$TiqDealNumber);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub getTiqDealState_dbh {
  my($dbh,$TiqDealNumber) = @_;
  my(@ResultRef) = ();
  my $DealState = "";

  if ($TiqDealNumber ne "") {
     my $sqlToGetTiqDealState = qq {
        select DEAL_STATE
        from   ALL_DEALS
        where  DEAL_NUM = $TiqDealNumber
     };
     # need to pause before executing due to tardyness of TIQ
     $loopTimer = pollingSleep(1,80,$loopTimer);
     if ($IsTest) {
        addToLogFile("---> Selecting Deal state from deal number/$TiqDealNumber:\n${sqlToGetTiqDealState}",$logFileName,$verbal);
     }
     $preparedsqlToGetTiqDealState = $dbh->prepare($sqlToGetTiqDealState);
     @ResultRef = dbExecutePreparedSelectSttmnt($preparedsqlToGetTiqDealState);
     if (@ResultRef[0]) {
        $DealState = @ResultRef[0]->{DEAL_STATE};
     }
     if ($IsTest) {
        addToLogFile("---> Selecting Deal state from deal number:${TiqDealNumber}:${DealState}:",$logFileName,$verbal);
     }
  } else {
     addToLogFile("getTiqDealState:incorrect parameters:${dbh}:${TiqDealNumber}:",$logFileName,$verbal);
  }
  return $DealState;
}

sub addToTiqMonitor {
  my ($database,$login,$password,$category,$event,$program,$logFileName,$verbal) = @_;
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password);
  my($retVal) = addToTiqMonitor_dbh($tradeIQ_dbHandler,$password,$category,$event,$program,$logFileName,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $retVal;
}

sub addToTiqMonitor_dbh {
  my($dbh,$category,$event,$program,$logFileName,$verbal) = @_;
  my $servername = `hostname | tr -d "[:space:]"`;

  my $sqlToLogMessage = qq {
       insert into CSG_LOG
        values (sysdate, 1, '${program}', '${category}', '${event}', user, '${servername}')
  };
  if ($IsTest) {
     addToLogFile("---> Update statment used to addToTiqMonitor:\n${sqlToLogMessage}",$logFileName,$verbal);
  }
  $preparedsqlToLogMessage = $dbh->prepare($sqlToLogMessage);
  $preparedsqlToLogMessage->execute;
}

#
# returns $TRUE / $FALSE if mrs exists or not
#
sub mrsExits_dbh {
	my($dbh,$mrsName) = @_;
	$mrsName = strip(uc($mrsName));
	
	my $aSql = qq {
    SELECT count(*) COUNT
    FROM MRS_NAMES where name = '$mrsName'
  };
	my $preparedSql = $dbh->prepare($aSql);
  my @recSet = dbExecutePreparedSelectSttmnt($preparedSql);
  if (@recSet[0]->{COUNT} eq "0") {
  	  return $FALSE;
  } else {
  	  return $TRUE;
  }
}


#
# IN: eodDate: EODYYMMDD
#     ccyX:    i.e. CHF
#
sub setSpotRate_dbh {
	  my($dbh,$eodDate,$ccy1,$ccy2,$bid,$ask,$trace,$logFileName,$verbal)  = @_;
	  
	  my %recordToInsert = (
	     "NAME"       => $eodDate,
	     "CCY1"       => $ccy1,
	     "CCY2"       => $ccy2,
	     "BID_RATE"   => $bid,
	     "OFFER_RATE" => $ask,
	  );
	  my @recordSetData = (\%recordToInsert);
	  
	  my @recordSetKeys = ("NAME","CCY1","CCY2");

	  my %translation = (
	     "NAME"       => "NAME",
	     "CCY1"       => "CCY1",
	     "CCY2"       => "CCY2",
	     "BID_RATE"   => "BID_RATE",
	     "OFFER_RATE" => "OFFER_RATE",
	  );	  

	  my %defaultValus = (
	     "TIMESTAMP"  => getTimeStamp(),
	  );

    my ($countOfInserts,$countOfUpdates) = setDbEntries_dbh($dbh, "MRS_FXSPOT", \@recordSetData, \%translation, \%defaultValus, \@recordSetKeys, $logFileName, $verbal);
}

# access functions for rates
# --------------------------
sub getFxSpotRates {
  my($database,$login,$password,$logfile,$verbal,$Ccy1,$Ccy2,$mrsName) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  $mrsName    = setDefault($mrsName,"MrsName");

  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my(@returnListe) =  getFxSpotRates_dbh($tradeIQ_dbHandler,$logfile,$verbal,$Ccy1,$Ccy2,$mrsName);
  dbDisconnect($tradeIQ_dbHandler); 
  return @returnListe;
}

sub getFxSpotRates_dbh {
  my($dbh,$logfile,$verbal,$Ccy1,$Ccy2,$mrsName) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  $mrsName    = setDefault($mrsName,"MrsName");

  my $aSelectStmt = qq{
     SELECT   BID_RATE
            , OFFER_RATE
     FROM   mrs_fxspot
          , sys_parameter
     WHERE     ccy1 = '${Ccy1}'
           AND ccy2 = '${Ccy2}'
           AND valueastext = name
           AND parameterid = '${mrsName}'
  };

  my(@retListe) = ();
  my(@returnListe) = ();
  my($prepared_aSelectStmt) = $dbh->prepare($aSelectStmt);
  @retListe = dbExecutePreparedSelectSttmnt($prepared_aSelectStmt);

  foreach my $aRateRef (@retListe) {
     $returnListe[0] = $aRateRef->{BID_RATE};
     $returnListe[1] = $aRateRef->{OFFER_RATE};
     $returnListe[2] = ($returnListe[0] + $returnListe[1]) / 2;
     return @returnListe;
  }
  return @returnListe;
}



# access functions for trading book details
# -----------------------------------------
sub getTrdBkPermission {
	my ($database,$login,$password,$logfile,$verbal,$listOfUserIds) = @_;
	my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  return getTrdBkPermission_dbh($tradeIQ_dbHandler,$logfile,$verbal,$listOfUserIds);
  dbDisconnect($tradeIQ_dbHandler); 
}

sub getTrdBkPermission_dbh {
	my ($dbh,$logfile,$verbal,$listOfUserIds) = @_;
  $verbal       = setDefault($verbal,$TRUE);
  
  if ($listOfUserIds ne "") {
  	$listOfUserIds = qq {and
             u.user_name in ($listOfUserIds)
    };
  }
  
  #    SELECT a.user_name,
  #     SUBSTR(a.first_name,   1,   20) name,
  #     SUBSTR(a.surname,   1,   20) surname,
  #     d.name book,
  #     c.is_read READ,
  #     c.is_write WRITE,
  #     is_monitor mon,
  #     c.action
  #   FROM sd_user_data a,
  #     sd_user_group b,
  #     sd_trad_book_perm c,
  #     sd_trading_book d
  #   WHERE a.user_group_fbo_id = b.fbo_id_num
  #    AND a.fbo_id_num         = c.user_fbo_id_num
  #    AND c.parent_fbo_id_num  = d.fbo_id_num
  #    AND a.user_name          = 'a125826'
  #   ORDER BY d.name


   # old Version replaced at Feb 07, 2007
   #           select
   #                u.USER_NAME 			                         PID
   #              , u.SURNAME				                           FAMILY_NAME
   #              , u.FIRST_NAME			                         FIRST_NAME
   #              , u.LOCATION			                           LOCATION
   #              , u.TEAM			                               TEAM
   #              , decode(substr(ug.NAME ,1,3),
   #                 'FO_', 'FRONT OFFICE',
   #                 'MO_', 'MIDDLE OFFICE',
   #                 'BO_', 'BACK OFFICE',
   #                 'SUP', 'SUPPORT',
   #                 'ADM',  'ADMIN')                          USER_GROUP2
   #              , decode(substr(ug.NAME,1,3),   'FO_', 0,
   #              decode(substr(ug.NAME, 1, 3), 'MO_', 1,
   #              decode(substr(ug.NAME, 1, 3), 'BO_', 2,
   #              decode(substr(ug.NAME, 1, 3), 'SUP', 3,
   #              decode(substr(ug.NAME, 1, 3), 'ADM', 4)))))  U_UG_NAME_SORT2
   #              , ug.NAME			                               USER_GROUP_NAME
   #              , to_char(t.ID)			                         TRADING_BOOK_ID
   #              , t.name                                     TRADING_BOOK_NAME
   #              , decode(p.IS_READ,'Y','R','N','!R')         READ_PERMISSION
   #              , decode(p.IS_WRITE,'Y','W','N','!W')        WRITE_PERMISSION
   #           from   
   #                SD_USER_DATA u
   #              , SD_TRAD_BOOK_PERM p
   #              , SD_trading_book t
   #              , SD_USER_GROUP ug
   #              , USER_PASSWORD up
   #           where
   #              p.USER_FBO_ID_NUM = u.FBO_ID_NUM
   #           and
   #              p.PARENT_FBO_ID_NUM = t.FBO_ID_NUM
   #           and
   #              p.ACTION <> 'DLT'
   #           and
   #             u.USER_GROUP_FBO_ID = ug.FBO_ID_NUM
   #           and
   #             u.FBO_ID_NUM = up.USER_FBO_ID
   #           ${listOfUserIds}
   #           order by u.user_name
           
  my $sql_getUserTrdBkPermission = qq {
          select
                u.USER_NAME 			                         PID
              , u.SURNAME				                           FAMILY_NAME
              , u.FIRST_NAME			                         FIRST_NAME
              , u.LOCATION			                           LOCATION
              , u.TEAM			                               TEAM
              , decode(substr(ug.NAME ,1,3),
                 'FO_', 'FRONT OFFICE',
                 'MO_', 'MIDDLE OFFICE',
                 'BO_', 'BACK OFFICE',
                 'SUP', 'SUPPORT',
                 'ADM',  'ADMIN')                          USER_GROUP2
              , decode(substr(ug.NAME,1,3),   'FO_', 0,
              decode(substr(ug.NAME, 1, 3), 'MO_', 1,
              decode(substr(ug.NAME, 1, 3), 'BO_', 2,
              decode(substr(ug.NAME, 1, 3), 'SUP', 3,
              decode(substr(ug.NAME, 1, 3), 'ADM', 4)))))  U_UG_NAME_SORT2
              , ug.NAME			                               USER_GROUP_NAME
              , to_char(t1.ID)			                         TRADING_BOOK_ID
              , t1.name                                     TRADING_BOOK_NAME
              , decode(t1.IS_READ,'Y','R','N','!R')         READ_PERMISSION
              , decode(t1.IS_WRITE,'Y','W','N','!W')        WRITE_PERMISSION
           from   
                SD_USER_DATA u,
                (select * from
                     SD_TRAD_BOOK_PERM p
                   , SD_trading_book t 
                   where
                      p.PARENT_FBO_ID_NUM = t.FBO_ID_NUM
                     and
                      p.ACTION <> 'DLT') t1
              , SD_USER_GROUP ug
              , USER_PASSWORD up
           where
              t1.USER_FBO_ID_NUM (+) = u.FBO_ID_NUM
           and
             u.USER_GROUP_FBO_ID = ug.FBO_ID_NUM
           and
             u.FBO_ID_NUM = up.USER_FBO_ID
           ${listOfUserIds}
           order by u.user_name
         };
 my @allUserTrdBkPermRef = prepareAndExecuteSqlStatement($dbh,$sql_getUserTrdBkPermission,"",$logfile,$verbal);
 return @allUserTrdBkPermRef;
}

sub getTrdBookTree {
  my ($database,$login,$password,$logfile,$verbal,$withTrdId,$rootId) = @_;
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  return getTrdBookTree_dbh($tradeIQ_dbHandler,$logfile,$verbal,$withTrdId,$rootId);
  dbDisconnect($tradeIQ_dbHandler); 
}

sub getTrdBookTree_dbh {
  my ($dbh,$logfile,$verbal,$withTrdId,$rootId) = @_;
  $verbal       = setDefault($verbal,$TRUE);
  $withTrdId    = setDefault($withTrdId,$FALSE);
  $rootId       = setDefault($rootId,getRootTrdBkId_dbh($dbh,$logfile,$verbal));

  my %idNameMapping = ();
  my @structId      = ();

  my @retListSubIds = getAllTrdBkIdsForId_dbh($dbh,$logfile,$verbal,$rootId);
  my @retListIds    = ("${rootId}");
  @retListIds       = concatArray(@retListIds,@retListSubIds);
  
  foreach my $aId (@retListIds) {
     my $aFullName = getTrdBkFullNameForId_dbh($dbh,$logfile,$verbal,$aId);
     if ($withTrdId) {
     	   %idNameMapping = (%idNameMapping,($aId,"${aFullName} (${aId})"));
     } else {
     	   %idNameMapping = (%idNameMapping,($aId,$aFullName));
     }
     ## print("${aFullName}  (${aId})\n");
     push(@structId,$aId);
  }
  return (\%idNameMapping, \@structId);
}

sub showTrdBookTree {
  my($database,$login,$password,$logfile,$verbal,$formatAsTree,$rootId,$includePositions) = @_;
  $verbal       = setDefault($verbal,$TRUE);
  $formatAsTree = setDefault($formatAsTree,$FALSE);
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  showTrdBookTree_dbh($tradeIQ_dbHandler,$logfile,$verbal,$formatAsTree,$rootId,$includePositions);
  dbDisconnect($tradeIQ_dbHandler); 
}

sub showTrdBookTree_dbh {
	my ($dbh,$logfile,$verbal,$formatAsTree,$rootId,$includePositions) = @_;
	$verbal           = setDefault($verbal,$TRUE);
	$formatAsTree     = setDefault($formatAsTree,$FALSE);
	$rootId           = setDefault($rootId,getRootTrdBkId_dbh($dbh,$logfile,$verbal));
	$includePositions = setDefault($includePositions,$FALSE);

	my @retListSubIds = getAllTrdBkIdsForId_dbh($dbh,$logfile,$verbal,$rootId);

	my @retListIds = ("${rootId}");
	my @retListIdsClean = ();
	@retListIds = concatArray(@retListIds,@retListSubIds);
	my @positionList = ();

	# there can be trading books with no id! Filter them out and provide a WARNING
	@retListIdsClean = trimRemoveEmptiesAndCommentsInArray(@retListIds);
	checkForStrangeTrdBooks_dbh($dbh,$logfile,$verbal,$TRUE);

	foreach my $aId (@retListIdsClean) {
		my $aFullName = getTrdBkFullNameForId_dbh($dbh,$logfile,$verbal,$aId);
		if (includePositions) {
			@positionList = getPositionsFromTrdBook_dbh($dbh,$logfile,$verbal,$aId);
		}
		if ($formatAsTree) {
			$aFullName =~ s/\//;;;/g;
			my @nameParts = split(";;;",$aFullName);
			my $anz = @nameParts;
			printf(substr("\t\t\t\t\t\t\t\t\t\t\t\t\t\t",0,$anz-1)."%s (${aId})\n",$nameParts[-1]);
			if ($includePositions) {
				displayArrayEnhanced($TRUE,$TRUE,";;;","",@positionList);
			}
		} else {
			print("--->>>>  ${aFullName}  (${aId})\n");
			if ($includePositions) {
				displayArrayEnhanced($TRUE,$TRUE,";;;","",@positionList);
			}
		}
	}
}


sub checkForStrangeTrdBooks_dbh {
	my($dbh,$logfile,$verbal,$showFaultyEntries) = @_;
	$verbal                = setDefault($verbal,$TRUE);
	$showFaultyEntries     = setDefault($showFaultyEntries,$TRUE);
	
	my $mistakeFound = $FALSE;
	
	my $sql = qq {
		select 
			id,
			name,
			fbo_id_num 
		from sd_trading_book
		where id is null
		};
	my @strangeTrdBookDefinitionsRef = prepareAndExecuteSqlStatement($dbh,$sql,"",$logfile,$verbal);
	foreach my $aRef (@strangeTrdBookDefinitionsRef) {
		$mistakeFound = $TRUE;
		if ($showFaultyEntries) {
			addToLogFile("WARNING: Trading Book Id is empty for: ID:".$aRef->{ID}.":  Name:".$aRef->{NAME}.":  FBO_ID_NUM:".$aRef->{FBO_ID_NUM}.":",$logfile,$verbal);
		}
	} 
	if ($mistakeFound) {
		if ($showFaultyEntries) {
			addToLogFile("Used sql statement:".$sql,$logfile,$verbal);
		}
		return $FALSE;
	} else {
		return $TRUE;
	}
}

sub getTrdBkFullNameForId {
  my ($database,$login,$password,$logfile,$verbal,$trdBkId) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my $aName = "";
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  $aName = getTrdBkFullNameForId_dbh($tradeIQ_dbHandler,$logfile,$verbal,$trdBkId);
  dbDisconnect($tradeIQ_dbHandler);
  return $aName;
}

sub getTrdBkFullNameForId_dbh {
   my($dbh,$logfile,$verbal,$trdBkId) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   my $aName = getTrdBkNameForId_dbh($dbh,$logfile,$verbal,$trdBkId);

   my $parentID = getParentTrdBkIdForId_dbh($dbh,$logfile,$verbal,$trdBkId);
   if ($parentID ne "") {
      $aName = getTrdBkFullNameForId_dbh($dbh,$logfile,$verbal,$parentID)."/${aName}";
   } 
   return $aName;
}


sub getRootTrdBkId {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my $aId = "";
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  $aId = getRootTrdBkId_dbh($tradeIQ_dbHandler,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $aId;
}

sub getRootTrdBkId_dbh {
   my($dbh,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   my (@queryResultRef) = ();

	my $aSqlStmt = qq {
         select ID
         from sd_trading_book
         where PARENT_FBO_ID_NUM = 0
   };

   @queryResultRef = prepareAndExecuteSqlStatement($dbh,$aSqlStmt,"",$logfile,$verbal);
   if (@queryResultRef[0]) {
      return @queryResultRef[0]->{ID};
   } else {
      return "";
   }
}

sub getParentTrdBkIdForId {
	my ($database,$login,$password,$logfile,$verbal,$trdBkId) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	my $aName = "";
	my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
	$aName = getParentTrdBkIdForId_dbh($tradeIQ_dbHandler,$logfile,$verbal,$trdBkId);
	dbDisconnect($tradeIQ_dbHandler);
	return $aName;
}

sub getParentTrdBkIdForId_dbh {
	my($dbh,$logfile,$verbal,$trdBkId) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	my (@queryResultRef) = ();

	my $aSqlStmt = qq {
			select Decode 
					((select parent_fbo_id_num from sd_trading_book where id=${trdBkId}),
						0,
						0,
						(select id from sd_trading_book where fbo_id_num = 
							(select b.parent_fbo_id_num from sd_trading_book b where b.id=${trdBkId})))
								PARENT_BOOK_ID
					from dual
	};

	@queryResultRef = prepareAndExecuteSqlStatement($dbh,$aSqlStmt,"",$logfile,$verbal);
	if (@queryResultRef[0]) {
		#   return @queryResultRef[0]->{PARENT_ID};
		return @queryResultRef[0]->{PARENT_BOOK_ID};
	} else {
		return "";
	}
}


sub getPositionsFromTrdBook_dbh {
	my ($database,$logfile,$verbal,$trdBkId) = @_;
	# addToLogFile("Get Positions for ${trdBkId}",$logfile,$verbal);
	my $sql = qq {
		select 
			trdPositions.ccy_1 CCY_1,
			trdPositions.ccy_2 CCY_2,
			trdPositions.fbo_id_type TYPE,
			trdBook.id ID,
			trdBook.name NAME
		from sd_trading_book trdBook, sd_trad_book_pos_data trdPositions
		where
			trdPositions.trading_book_fbo_id_num = trdBook.fbo_id_num and
			trdBook.id = '${trdBkId}'
		};
	# addToLogFile("sql: ${sql}",$logfile,$verbal);
	my @positionList = prepareAndExecuteSqlStatement($database,$sql,"",$logfile,$verbal);
	my @retList = ();
	foreach my $aRef (@positionList) {
		push(@retList,$aRef->{CCY_1}."/".$aRef->{CCY_2}.":  Type:".$aRef->{TYPE});
	} 
	return @retList;
}

sub getTrdBkNameForId {
  my ($database,$login,$password,$logfile,$verbal,$trdBkId) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my $aName = "";
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  $aName = getTrdBkNameForId_dbh($tradeIQ_dbHandler,$logfile,$verbal,$trdBkId);
  dbDisconnect($tradeIQ_dbHandler);
  return $aName;
}

sub getTrdBkNameForId_dbh {
   my($dbh,$logfile,$verbal,$trdBkId) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   my (@queryResultRef) = ();

   my $aSqlStmt = qq {
         select NAME
         from sd_trading_book
         where ID = ${trdBkId}
   };

   @queryResultRef = prepareAndExecuteSqlStatement($dbh,$aSqlStmt,"",$logfile,$verbal);
   if (@queryResultRef[0]) {
      return @queryResultRef[0]->{NAME};
   } else {
      return "";
   }
}


sub getTrdBkIdsForName {
  my ($database,$login,$password,$logfile,$verbal,$trdBkName) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my (@ids) = ();
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  @ids = getTrdBkIdsForName_dbh($tradeIQ_dbHandler,$logfile,$verbal,$trdBkName);
  dbDisconnect($tradeIQ_dbHandler);
  return @ids;
}

sub getTrdBkIdsForName_dbh {
   my($dbh,$logfile,$verbal,$trdBkName) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   my (@queryResultRef) = ();
   my (@retList) = ();

   my $aSqlStmt = qq {
         select ID
         from sd_trading_book
         where NAME = '${trdBkName}'
   };

   @queryResultRef = prepareAndExecuteSqlStatement($dbh,$aSqlStmt,"",$logfile,$verbal);

   foreach my $aHandlerRef (@queryResultRef) {
      push(@retList,$aHandlerRef->{ID});
   }
   return @retList;
}


sub getChildrenTrdBkIdForId {
  my ($database,$login,$password,$logfile,$verbal,$fathersTrdBkId) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my (@retList) = ();
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  @retList = getChildrenTrdBkIdForId_dbh($tradeIQ_dbHandler,$logfile,$verbal,$fathersTrdBkId);
  dbDisconnect($tradeIQ_dbHandler);
  return @retList;
}

sub getChildrenTrdBkIdForId_dbh {
   my($dbh,$logfile,$verbal,$fathersTrdBkId,$showError) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $showError  = setDefault($showError,$FALSE);
   
   my (@queryResultRef) = ();
   my (@retList) = ();

  if ($fathersTrdBkId ne "") {
   	  my $aSqlStmt = qq {
   		  select a.ID
   		  from sd_trading_book a
   		  where (select b.ID from sd_trading_book b
   				where b.FBO_ID_NUM = a.PARENT_FBO_ID_NUM) = ${fathersTrdBkId}
   		  order by a.ID
     	};
   
      @queryResultRef = prepareAndExecuteSqlStatement($dbh,$aSqlStmt,"",$logfile,$verbal);
   
      foreach my $aHandlerRef (@queryResultRef) {
         push(@retList,$aHandlerRef->{ID});
      }
   } else {
		if ($showError) {
			addToLogFile("ERROR in trading book hierachy: There is a tradingbook with no ID defined! Check with following sql-statement:",$logfile,$verbal);
			addToLogFile("--> select id,name,fbo_id_num from sd_trading_book a where id is null;",$logfile,$verbal);
		}
   }
   return @retList;
}

# returns the ID of all trading books below a certain trading book (father). The father ID is also included. Including all children!
sub getAllTrdBkIdsForId {
  my ($database,$login,$password,$logfile,$verbal,$fathersTrdBkId) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my (@retList) = ();
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  @retList = getAllTrdBkIdsForId_dbh($tradeIQ_dbHandler,$logfile,$verbal,$fathersTrdBkId);
  dbDisconnect($tradeIQ_dbHandler);
  return @retList;
}

sub getAllTrdBkIdsForId_dbh {
   my($dbh,$logfile,$verbal,$fathersTrdBkId) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   
   my (@retList) = ();
   my (@retListLocal) = getChildrenTrdBkIdForId_dbh($dbh,$logfile,$verbal,$fathersTrdBkId);
   my $count = @retListLocal;
   if ($count == 0) {
      return @retList;
   } else {
      foreach my $childId (@retListLocal) {
         push(@retList,$childId);
         my (@retListLocal) = getAllTrdBkIdsForId_dbh($dbh,$logfile,$verbal,$childId);
         @retList = concatArray(@retList,@retListLocal);
      }
   }
   return @retList;
}

# returns the Ids for all the trading book names passed in $trdNamesSepByComma and for all their children. Including all children!
sub getAllTrdBkIdsForNames {
  my ($database,$login,$password,$logfile,$verbal,$trdNamesSepByComma) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my (@retList) = ();
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  @retList = getAllTrdBkIdsForNames_dbh($tradeIQ_dbHandler,$logfile,$verbal,$trdNamesSepByComma);
  dbDisconnect($tradeIQ_dbHandler);
  return @retList;
}

sub getAllTrdBkIdsForNames_dbh {
   my($dbh,$logfile,$verbal,$trdNamesSepByComma) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   my (@retList) = ();

   my(@trdNameList) = split(",",$trdNamesSepByComma);
   foreach my $aTrdName (@trdNameList) {
      my @topIds = getTrdBkIdsForName_dbh($dbh,$logfile,$verbal,$aTrdName);
      my $count = @topIds;
      if ($count < 1) {
         addToLogFile("WARNING in tradeiqPerlLib.pm::getAllTrdBkIdsForNames_dbh():No Ids found for :${aTrdName}:",$logfile,$verbal);
      } elsif ($count > 1) {
         addToLogFile("WARNING in tradeiqPerlLib.pm::getAllTrdBkIdsForNames_dbh():Multible Ids found for :${aTrdName}:",$logfile,$verbal);
      } else {
         push(@retList,$topIds[0]);
         @retList = concatArray(@retList,getAllTrdBkIdsForId_dbh($dbh,$logfile,$verbal,$topIds[0]));
      }
   }

   return makeArrayEntriesDistinct($TRUE,@retList);
}

sub getAllTrdBkFoIdsForNames {
  my ($database,$login,$password,$logfile,$verbal,$trdNamesSepByComma) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my (@retList) = ();
  my($tradeIQ_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  @retList = getAllTrdBkFoIdsForNames_dbh($tradeIQ_dbHandler,$logfile,$verbal,$trdNamesSepByComma);
  dbDisconnect($tradeIQ_dbHandler);
  return @retList;
}

sub getAllTrdBkFoIdsForNames_dbh {
   my($dbh,$logfile,$verbal,$trdNamesSepByComma) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   my (@retList) = ();

   my(@trdIdsList) = getAllTrdBkIdsForNames_dbh($dbh,$logfile,$verbal,$trdNamesSepByComma);
   my $ltrdIdsListAsStr = makeQuotedStrFromArrayElements(",","'","","",@trdIdsList);

   if ($ltrdIdsListAsStr eq "") {
   	return @retList;
   } 
   
   my $aSqlStmt = qq {
	   select FBO_ID_NUM
	   from sd_trading_book 
	   where ID in (${ltrdIdsListAsStr})
   };

   @queryResultRef = prepareAndExecuteSqlStatement($dbh,$aSqlStmt,"",$logfile,$verbal);

   foreach my $aHandlerRef (@queryResultRef) {
      push(@retList,$aHandlerRef->{FBO_ID_NUM});
   }
   

   return makeArrayEntriesDistinct($TRUE,@retList);
}

# Access to User and Privileges in LH 
# -----------------------------------
sub getPidListFromDB {
  my ($database,$login,$password,$whereClause,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my $tradeIQ_dbHandler = dbConnect($database,$login,$password,$logfile,$verbal);
  my @retVal = getPidListFromDB_dbh($tradeIQ_dbHandler,$whereClause,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return  @retVal;
}

sub getPidListFromDB_dbh {
	  my($dbh,$whereClause) = @_;
	  $whereClause     = setDefault($whereClause,"");
	  return  dbBuildArray_dbh($dbh, "SD_USER_DATA", "USER_NAME", $whereClause, $TRUE);
}
############################################################################
# Function based on instance name
############################################################################
$helpText_InstanceNameStructure = qq{
    The instance name has to follow a well defined structur. Possible examples are:
   
      DZHLHMH2
      DNYFTAP1
      PZHLHFC1
      ||||||||
      |||||||+--> Systemversion                  [1: Realtime system 2: Read-Only system 3: Production snapshot]
      ||||||+---> Business Unit                  [C: SKA]
      |||||+----> Product-Type  / Product-Group  [M: MM system, F: FX system, T: Treasury (combined system)]
      |||++-----> Systemtype                     [LH: Lighthouse, FT: Lighthouse]
      |++-------> Location code                  [ZH: Zurich, NY: New York, LN: London, SG: Singapore]
      +---------> Test level                     [P: Production, A: UAT (PTA) T: Test (IT) D: Development (ET)] 
	};

sub showInstanceNameStructure {
	  print("${helpText_InstanceNameStructure}\n");
}

sub doTest_functionsBasedOnInstanceNames {
   my($myFullName,$debugThisFct) = @_;
   $debugThisFct = setDefault($debugThisFct,$FALSE);
   
   # Test getInstanceTypeFromInstanceName
   if (!(getInstanceTypeFromInstanceName("PZHLHFC1") eq $instanceProd)) {
       print("ERROR: ${myFullName} failed (A1)\n");
   }
   if (!(getInstanceTypeFromInstanceName("TZHLHFC1") eq $instanceTest)) {
       print("ERROR: ${myFullName} failed (B1)\n");
   }
   if (!(getInstanceTypeFromInstanceName("DZHLHFC1") eq $instanceTest)) {
       print("ERROR: ${myFullName} failed (C1)\n");
   }
   
   # Test isTiqInstanceProduction
   if (!(isTiqInstanceProduction("PZHLHFC1") == $TRUE)) {
       print("ERROR: ${myFullName} failed (A2)\n");
   }
   if (!(isTiqInstanceProduction("DZHLHFC1") == $FALSE)) {
       print("ERROR: ${myFullName} failed (B2)\n");
   }
   
   # Test isTiqInstanceTest
   if (!(isTiqInstanceTest("PZHLHFC1") == $FALSE)) {
       print("ERROR: ${myFullName} failed (A3)\n");
   }
   if (!(isTiqInstanceTest("DZHLHFC1") == $TRUE)) {
       print("ERROR: ${myFullName} failed (B3)\n");
   }
   
   # Test getTiqTestLevelFromInstance
   if (!(getTiqTestLevelFromInstance("PZHLHFC1") eq "P")) {
       print("ERROR: ${myFullName} failed (A4)\n");
   }
   if (!(getTiqTestLevelFromInstance("TZHLHFC1") eq "T")) {
       print("ERROR: ${myFullName} failed (B4)\n");
   }
   if (!(getTiqTestLevelFromInstance("DZHLHFC1") eq "D")) {
       print("ERROR: ${myFullName} failed (C4)\n");
   }
   
   # Test getLH_InstanceType
   if (!(getLH_InstanceType("PZHLHFC1") eq "F")) {
       print("ERROR: ${myFullName} failed (A6)\n");
   }
   if (!(getLH_InstanceType("TZHLHTI1") eq "T")) {
       print("ERROR: ${myFullName} failed (B6)\n");
   }
   if (!(getLH_InstanceType("DZHLHMC1") eq "M")) {
       print("ERROR: ${myFullName} failed (C6)\n");
   }
   
   # Test isMM_System
   if (!(isMM_System("PZHLHFC1") eq $FALSE)) {
       print("ERROR: ${myFullName} failed (A7)\n");
   }
   if (!(isMM_System("TZHLHTI1") eq $TRUE)) {
       print("ERROR: ${myFullName} failed (B7)\n");
   }
   if (!(isMM_System("DZHLHMC1") eq $TRUE)) {
       print("ERROR: ${myFullName} failed (C7)\n");
   }
   
   # Test isFX_System
   if (!(isFX_System("PZHLHFC1") eq $TRUE)) {
       print("ERROR: ${myFullName} failed (A8)\n");
   }
   if (!(isFX_System("TZHLHTI1") eq $TRUE)) {
       print("ERROR: ${myFullName} failed (B8)\n");
   }
   if (!(isFX_System("DZHLHMC1") eq $FALSE)) {
       print("ERROR: ${myFullName} failed (C8)\n");
   }
   
   # Test isFX_MM_System
   if (!(isFX_MM_System("PZHLHFC1") eq $FALSE)) {
       print("ERROR: ${myFullName} failed (A9)\n");
   }
   if (!(isFX_MM_System("TNYLHTI1") eq $TRUE)) {
       print("ERROR: ${myFullName} failed (B9)\n");
   }
   if (!(isFX_MM_System("DSGLHMC1") eq $FALSE)) {
       print("ERROR: ${myFullName} failed (C9)\n");
   }
   
   # Test getLocationForInstance
   if (!(getLocationForInstance("PZHLHFC1") eq "ZH")) {
       print("ERROR: ${myFullName} failed (A10)\n");
   }
   if (!(getLocationForInstance("TNYLHTI1") eq "NY")) {
       print("ERROR: ${myFullName} failed (B10)\n");
   }
   if (!(getLocationForInstance("DSGLHMC1") eq "SG")) {
       print("ERROR: ${myFullName} failed (C10)\n");
   }
   
   # Test getBusinessCodeForInstance
   if (!(getBusinessCodeForInstance("PZHLHFC1") eq "C")) {
       print("ERROR: ${myFullName} failed (A11)\n");
   }
   if (!(getBusinessCodeForInstance("TNYLHTI1") eq "I")) {
       print("ERROR: ${myFullName} failed (B11)\n");
   }
   if (!(getBusinessCodeForInstance("DSGLHML1") eq "L")) {
       print("ERROR: ${myFullName} failed (C11)\n");
   }
   
   # Test system version
   if (!(getTiqSystemVersion("PZHLHFC1") eq "1")) {
       print("ERROR: ${myFullName} failed (A12)\n");
   }
   
   if (!(getTiqSystemVersion("PZHLHFC3") eq "3")) {
       print("ERROR: ${myFullName} failed (A13)\n");
   }
}

# checking Testlevel
# ------------------
$instanceProd = "PROD";
$instanceTest = "TEST";
sub getInstanceTypeFromInstanceName {
  my($instance) = @_;
  $instance     = setDefault($instance,$ENV{CSG_ENV});
  if (uc(substr($instance,0,1)) eq "P") {
     return $instanceProd;
  } else {
     return $instanceTest;
  }
}

sub isTiqInstanceProduction {
  my($instance) = @_;
  $instance     = setDefault($instance,$ENV{CSG_ENV});
  if (uc(substr($instance,0,1)) eq "P") {
      return $TRUE;
  } else {
  	  return $FALSE;
  }
}

sub isTiqInstanceTest {
  my($instance) = @_;
  $instance     = setDefault($instance,$ENV{CSG_ENV});
  if (uc(substr($instance,0,1)) ne "P") {
      return $TRUE;
  } else {
  	  return $FALSE;
  }
}

sub getTiqTestLevelFromInstance  {
  my($instance) = @_;
  $instance     = setDefault($instance,$ENV{CSG_ENV});
  return uc(substr($instance,0,1));
}

sub getTestLevelFromInstanceAsString {
   my($instance) = @_;
   if ($instance =~ m/^D/) {
   	  $testLevel = "ET";
   	  return $testLevel;
   }
   elsif ($instance =~ m/^T/) {
   	  $testLevel = "IT";
   	  return $testLevel;
   }
   elsif ($instance =~ m/^A/) {
   	  $testLevel = "PTA";
   	  return $testLevel;
   }
   elsif ($instance =~ m/^P/) {
   	  $testLevel = "PROD";
   	  return $testLevel;
   }
}

sub getTestLineFromInstanceName {
  my($instance) = @_;
  if ((substr($instance,7,1) = 1) || (substr($instance,7,1) = 2)) {
     $testLine = "A";
     return $testLine;
  } elsif ((substr($instance,7,1) = 3) || (substr($instance,7,1) = 4)) {
     $testLine = "B";
     return $testLine;
  }	elsif ((substr($instance,7,1) = 5) || (substr($instance,7,1) = 6)) {
     $testLine = "C";
     return $testLine;
  } elsif ((substr($instance,7,1) = 7) || (substr($instance,7,1) = 9)) {
     $testLine = "D";
     return $testLine;
  }      
}

# checking ProductType / ProductGroup
# -----------------------------------
# reads env variable CSG_FX_DB, CSG_MM_DB, CSG_TI_DB, CSG_TS_DB to determ the db server
sub getLH_DB_HostForInstance {
	 my($instance) = @_;
	 $instance     = setDefault($instance,$ENV{CSG_ENV});
	 $instance = uc(strip($instance));

	 my $level   = substr($instance,0,1);
	 my $type    = substr($instance,5,1);
	 my $entity  = substr($instance,6,1);
	 
	 ## my $retVal = $lhDbHostList{"${level}${type}${entity}"};
	 my $retVal = "";
	 if ($type eq "F") {
	 	   $retVal = "FX";
	 } elsif ($type eq "M") {
	 	   $retVal = "MM";
	 } else {
	 	   $retVal = "${type}${entity}";
	 }
   $retVal = $ENV{"CSG_${retVal}_DB"};	 
	 return $retVal;
}

sub getProductGroup {
	 my($instance) = @_;
	 return getLH_InstanceType($instance);
}

sub getLH_InstanceType {
	 my($instance) = @_;
	 $instance     = setDefault($instance,$ENV{CSG_ENV});
	 $instance     = uc(strip($instance));
	 return uc(substr($instance,5,1));	
}

sub isMM_System {
   my($instance) = @_;
   my $systemType = getLH_InstanceType($instance);
	 if (($systemType eq "M") || ($systemType eq "T")) {
	 	  return $TRUE;
	 } else {
	 	  return $FALSE;
	 }
}

sub isOnlyMM_System {
   my($instance) = @_;
   my $systemType = getLH_InstanceType($instance);
	 if ($systemType eq "M") {
	 	  return $TRUE;
	 } else {
	 	  return $FALSE;
	 }
}

sub isFX_System {
   my($instance) = @_;
   my $systemType = getLH_InstanceType($instance);
	 if (($systemType eq "F") || ($systemType eq "T")) {
	 	  return $TRUE;
	 } else {
	 	  return $FALSE;
	 }
}

sub isOnlyFX_System {
   my($instance) = @_;
   my $systemType = getLH_InstanceType($instance);
	 if ($systemType eq "F") {
	 	  return $TRUE;
	 } else {
	 	  return $FALSE;
	 }
}

sub isFX_MM_System {
   my($instance) = @_;
	 if (getLH_InstanceType($instance) eq "T") {
	 	  return $TRUE;
	 } else {
	 	  return $FALSE;
	 }
}

sub isFXandMM_System {
   my($instance) = @_;
   return isFX_MM_System($instance);
}

# get location
# ------------
sub getLocationForInstance {
	 my($instance) = @_;
	 $instance     = setDefault($instance,$ENV{CSG_ENV});
	 $instance = uc(strip($instance));
	 return uc(substr($instance,1,2));
}

# system version
# --------------
sub getTiqSystemVersion {
  my($instance) = @_;
  $instance     = setDefault($instance,$ENV{CSG_ENV});
  return substr($instance,length($instance)-1,1);
}

sub isTiqSystemReadOnly {
  my($instance) = @_;
  $instance     = setDefault($instance,$ENV{CSG_ENV});
  my $systemVersion = getTiqSystemVersion($instance);
  return (($systemVersion eq "2") || ($systemVersion eq "4") || ($systemVersion eq "6") || ($systemVersion eq "8"));
}

# get business code / bank code
# -----------------------------
sub getBankCode {
	 my($instance) = @_;
	 return getBusinessCodeForInstance($instance);
}

sub getBusinessCodeForInstance {
	 my($instance) = @_;
	 $instance     = setDefault($instance,$ENV{CSG_ENV});
	 $instance = uc(strip($instance));
	 return uc(substr($instance,6,1));
}

# combined functions
# ------------------
sub getBankProductGroup {
   my($instance) = @_;
   return getProductGroup($instance).getBankCode($instance);
}

sub isBankProductGroup {
   my($bankProduct,$instance) = @_;
   if (uc($bankProduct) eq getBankProductGroup($instance)) {
   	  return $TRUE;
   } else {
   	  return $FALSE;
   }
}
############################################################################
# Single select function
############################################################################
sub getBranchCodeIdFromBranchCodeName {
  my ($database,$login,$password,$branchName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  
  my $tradeIQ_dbHandler = dbConnect($database,$login,$password,$logfile,$verbal);
  my $branchCodeId = getBranchCodeIdFromBranchCodeName_dbh($tradeIQ_dbHandler,$branchName,$logfile,$verbal);
  dbDisconnect($tradeIQ_dbHandler);
  return $branchCodeId;
}

sub getBranchCodeIdFromBranchCodeName_dbh {
  my($dbh,$branchName,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
 
  my $sql_getBranchCodeIdFromBranchCodeName = qq {
     select fbo_id_num
     from  sd_entity
     where name = '${branchName}'
  };
  my (@firstItem) = ();
  my $prepared_getBranchCodeIdFromBranchCodeName = $dbh->prepare($sql_getBranchCodeIdFromBranchCodeName);
  my @resSet = dbExecutePreparedSelectSttmnt($prepared_getBranchCodeIdFromBranchCodeName);
  return $resSet[0]->{FBO_ID_NUM};
}

sub showMenu_LhCmd {
	
	 my %menu = (
     "1: Show helpfull LH commands (execPerlFct showHelpfullLhCmd)"  => "showHelpfullLhCmd;halt",
   );
   createAsciiMenuAndPerformActions("0: Exit","Following LH-Commands are defined:","\nSelect",%menu);
}

sub showHelpfullLhCmd {
	my $helpText = qq{
    Tradingbook Tree:          execPerlFct showTrdBookTree PZHLHMC1.tszrh.csfb.com lhowner lhowner
    Crypted Password:          getPassword -m listAll
                               getPassword userName [systemName]
    Load-Balancing Monitor:    \$IQ_APPSERVER_USER_HOST_SCRIPT
    Command on all App-Server: execAppServerCmd.ksh "nslist ; rtr show fac"
    Test-Level:                execPerlFct isTiqInstanceProduction [instanceName]     if instanceName not specified ==> \$CSG_ENV
                               execPerlFct getTiqTestLevelFromInstance [instanceName] if instanceName not specified ==> \$CSG_ENV
                               execPerlFct isMM_System [instanceName]                 if instanceName not specified ==> \$CSG_ENV
                               execPerlFct showInstanceNameStructure
		
	};
	print("\n\n".unterstreichen("LH commands")."\n${helpText}");
}
1;
