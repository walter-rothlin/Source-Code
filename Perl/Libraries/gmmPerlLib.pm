
# $Header: /app/TIT/data/repositories/FT/plain_daily_production/interfaces/GMM/common/gmmPerlLib.pm,v 1.6 2010/09/07 14:17:41 sfulcri Exp $

# START---------------------------------------------------------------------
# Author:       Walter Rothlin 
# Description:  Contains common functions and definitions related to GmmDb
# History:
#  07/17/00  V1.0 Walter Rothlin      Initial Version
#  09/15/00  V1.1 Walter Rothlin      Add NY_GMM_UAT
#  11/03/00  V1.2 Dmitriy Volfson     Bug fix in parseGmmDataFltFilename 
#  11/10/00  V1.3 Walter Rothlin      Add getEUR_ConversionRates_dbh
#  12/05/00  V1.4 Walter Rothlin      Add getCpyIdHash_FromDescAndIntExt
#                                         getCpyId_FromDescAndIntExt
#  01/03/01  V1.5 Walter Rothlin      Bug fix (Missing () around the OR in makeDealNumWhereClause)
#  01/05/01  V1.6 Walter Rothlin      Add control to gmmDbControl webtool
#  01/12/01  V1.7 Walter Rothlin      Add NY_GMM_1 and NY_GMM_2
#  01/17/01  V1.8 Walter Rothlin      Move db maintenance at the end of gmmEod
#  02/12/01  V1.9 Walter Rothlin      NY_GMM points to NY_GMM_1 (30)
#  04/30/01  V2.01 Walter Rothlin     Add table GMM_MRS_SECURITY_PRICES to the purge in gmmEod
#  06/19/01  V2.02 Walter Rothlin     Add new gmm tables
#  06/29/01  V2.03 Walter Rothlin     Add event fct PurgeDbTable
#  08/10/01  V2.04 Dmitriy Volfson    Add gmmFeedFor_FixingRisk_Mgmt.pl to the gmmEod
#  08/27/01  V2.05 Dmitriy Volfson    Added isGmmLastTradingDayOfMonth,isGmmLastTradingDayOfTheQuarter,isGmmLastTradingDayOfYear,
#                                     isGmmFirstTradingDayOfMonth,isGmmFirstTradingDayOfTheQuarter,isGmmFirstTradingDayOfYear and 
#                                          corresponding dbh  functions
#  08/28/01  V2.06 Dmitriy Volfson    functions to get jobs which run POST/PRE EOD 
#                                     and changed gmmEod to use functions above
#  09/28/01  V2.07 Dmitriy Volfson    added NY_GMM_DV1 
#  09/10/01  V2.08 Dmitriy Volfson    added setGmmEodProcessStartTime,setGmmEodProcessFinishTime,gmmIsEodPartFinished 
#  09/13/01  V2.09 Dmitriy Volfson    added gmmEodGetControlArgs, gmmEodReportError
#                                     GmmEod check for the status of gmmPreEod 
#  01/22/02  V2.10 Dmitriy Volfson    addGmmFileInfoHeader, getGmmFileInfoHeader, getGmmTableRecCount_dbh
#  01/24/02  V2.11 Dmitriy Volfson    Add Purge GMM_CURRENCY table
#  01/29/02  V2.12 Walter Rothlin     Add franchise table structure to getGmmTableRecCount_dbh
#  02/07/02  V2.13 Dmitriy Volfson    modified parseGmmDataFltFilename
#  02/27/02  V2.14 Dmitriy Volfson    addtitional info stored and retrieved from gmm_control 
#  03/06/02  V2.15 Walter Rothlin     removed code for old franchise tables 
#                                        sub franchiseDeleteFromTbl_dbh
#                                        sub franchisePurgeTbl_dbh
#                                        sub purgeFranchiseTables_dbh
#                                        sub getAllFranchiseSystemDates_dbh
#                                        @franchiseTables
#  04/08/02  V2.16 Walter Rothlin     Changed getGmmDbLogin to accept a privilege
#  04/24/02  V2.17 Swati P. Munshi    Changed dbInstance for GMM_DEV and GMM_UAT 
#  05/21/02  V2.18 Walter Rothlin     Add EVH_PROCESSING
#  03/15/03  V2.19 Walter Rothlin     Add ZH_GMM 
#  08/04/03  V2.20 Walter Rothlin     Add ZH_GMM_DEV
#  08/29/03  V2.21 Ash Rao            Modified NY_GMM_DV2 from dnygmmd1 to dnygmmd4
#  09/04/03  V2.22 Walter Rothlin     Modified GmmEod that the Archive/Purge can be also done at the end of preGmmEod
#  10/09/03  V2.23 Ash Rao	          Add NY_GMM_TS1 
#  11/06/03  V2.24 Ash Rao            Add NY_GMM_UT2 - for US GAAP UAT 
#  02/10/04  V2.25 Walter Rothlin     Removed gmmowner for ZH_GMM and NY_GMM_DEV for Heartbeat sender
#  03/04/04  V2.26 Ash Rao	          Add SG_GMM_DEV dnygmmd2_nys31d-076
#  04/01/04  V2.27 Walter Rothlin     Add analyseGmmExtractorEodLogFile
#  06/15/06  V2.28 Ash Rao            Added modification for ZH NewArrivals load - using partition tables
#  08/11/06  V2.29 Walter Rothlin     Removed ZH_GMM
#  04/25/07  V2.30 Walter Rothlin     Added ZN (Zurich-North)
#  04/26/07  V2.31 Reshma Vyas        Added table GMM_RISK_EVENTS to my(@otherTblToPurge) in sub gmmArchiveAndPurge
#  06/25/09  V2.32 Walter Rothlin     Added EU loaction code
#  07/13/09  V2.33 Walter Rothlin     Reusing ZN for EUROM and Removed EU
#  03/26/10  V2.34 Walter Rothlin     Changed NY_GMM_DEV
#  09/01/10  V2.35 Meena Gupta        Changed DNYGMMD1
# END-----------------------------------------------------------------------
############################################################################
# Do not make any local changes to the code. It will be overwritten by the
# next release. Please submit a change request to Walter.Rothlin@csfb.com
############################################################################
$gmmPerlLibSccsId             = "@(#)gmmPerlLib.pm	1.12 08/23/07 20:39:04";
$gmmPerlLibLatestVersion      = "V2.34";
############################################################################

package gmmPerlLib;

package main;


# Global definitions used in GMM DB
# =================================

@gmmExtractedProductsTbl = (
   "GMM_LOANS_DEPOSITS",
   "GMM_LOAN_DEPO_CASH_FLOW",
   "GMM_FRA",
   "GMM_REPO",
   "GMM_FX_ARB",
   "GMM_FUTURE",
   "GMM_HEDGED_FUTURE",
   "GMM_OPTION",
   "GMM_HEDGED_OPTION",
   "GMM_SECURITIES",
   "GMM_SEC_CASH_FLOW",
   "GMM_CALLS",
   "GMM_SWAPS",
   "GMM_SWAPS_CASH_FLOW",
   "GMM_FUTURE_SETTLE",
   "GMM_OPTION_SETTLE",
   "GMM_CALL_CHANGE",
   "GMM_SEC_HOLDING",
   "GMM_FX_HOLDING",
   "GMM_FX_HOLDING_ELEMS",
   "GMM_SEC_DEFINITION",
   "GMM_CASH_DEAL",

);

@gmmExtractedProductsHistoryTbl = (
    "HIST_GMM_LOANS_DEPOSITS",
    "HIST_GMM_LOAN_DEPO_CF",
    "HIST_GMM_FRA",
    "HIST_GMM_REPO",
    "HIST_GMM_FX_ARB",
    "HIST_GMM_FUTURE",
    "HIST_GMM_HEDGED_FUTURE",
    "HIST_GMM_OPTION",
    "HIST_GMM_HEDGED_OPTION",
    "HIST_GMM_SECURITIES",
    "HIST_GMM_SEC_CASH_FLOW",
    "HIST_GMM_CALLS",
    "HIST_GMM_SWAPS",
    "HIST_GMM_SWAPS_CASH_FLOW",
    "HIST_GMM_FUTURE_SETTLE",
    "HIST_GMM_OPTION_SETTLE",
    "HIST_GMM_CALL_CHANGE",
    "HIST_GMM_SEC_HOLDING",
    "HIST_GMM_FX_HOLDING",
    "HIST_GMM_FX_HOLDING_ELEMS",
    "HIST_GMM_SEC_DEFINITION",
    "HIST_GMM_CASH_DEAL",
);

@gmmMrsTables = (
   "GMM_REFERENCE_RATE_VALUES",
   "GMM_MRS_FXSPOT",
   "GMM_MRS_FXSWAP",
   "GMM_MRS_INTRATES",
   "GMM_MRS_FUTPRICES",
   "GMM_MRS_SECURITY_PRICES",
);

@gmmExtractedRatesTbl = (
   "GMM_COUNTERPARTY",
   "GMM_TRADING_BOOKS",
   "GMM_CURRENCY",
   "GMM_EOD_PROCESS",
   "GMM_RISK_EVENTS",
   "GMM_CALENDARS",
   "GMM_REVAL",
   "GMM_REFERENCE_RATE_VALUES",
   "GMM_MRS_FXSPOT",
   "GMM_MRS_FXSWAP",
   "GMM_MRS_INTRATES",
   "GMM_MRS_FUTPRICES",
   "GMM_MRS_SECURITY_PRICES",
);
@gmmExtractedEodProductsTbl = (
   "ESTATE_GMM_LOANS_DEPOSITS",
   "ESTATE_GMM_FRA",
   "ESTATE_GMM_REPO",
   "ESTATE_GMM_FX_ARB",
   "ESTATE_GMM_FUTURE",
   "ESTATE_GMM_OPTION",
   "ESTATE_GMM_SECURITIES",
   "ESTATE_GMM_CALLS",
   "ESTATE_GMM_SWAPS",
);

@allGmmGdB = (
   "NY_GMM_DEV",
   "NY_GMM_UAT",
   "NY_GMM",
   "NY_GMM_B",
   "NY_GMM_DR",
   "NY_GMM_1",
   "NY_GMM_2",
   "NY_GMM_DV1",
   "NY_GMM_DV2",
   "NY_GMM_UT1",
   "NY_GMM_UT2",
   "DNYGMMD1",
   "QNYGMMD1",
   "NY_GMM_TS1",
   "SG_GMM_DEV",
);

@allGmmTrdSystem = (
   "TIQ",
   "WSS",
);

@allGmmCities = (
   "NY",
   "LN",
   "SG",
   "ZH",
   "ZN",  # EUROM
);

@allGmmTableGroubs = (
   "Product",
   "Product_1",
   "Product_2",
   "Product_3",
   "History_1",
   "History_2",
   "History_3",
   "EodState",
   "Other",
);


$cDispalyTableDesc       = "showTblDesc";
$cWebActionDoDisableRTF  = "doDisableRTF";
$cWebActionDoShutdownRTF = "doShutdownRTF";
$cWebActionDoEnableRTF   = "doEnableRTF";
$cWebActionDoDisableEVH  = "doDisableEVH";
$cWebActionDoShutdownEVH = "doShutdownEVH";
$cWebActionDoEnableEVH   = "doEnableEVH";


%gmmDbConections = (
   "NY_GMM"     => "PNYGMMD1_pnygmmd1.fir.fbc.com",
   "NY_GMM_A"   => "PNYGMMD1_nys01d5003a.fir.fbc.com",
   "NY_GMM_B"   => "PNYGMMD1_nys01d5003b.fir.fbc.com",
   "NY_GMM_DR"  => "PNYGMMD1_pns01d5003.fi.csfb.com",
   "NY_GMM_2"   => "pnygmmd1_nys61d034.fir.fbc.com",
   "NY_GMM_DEV" => "DNYGMMD1_nys31d5002.fir.fbc.com",
   "SG_GMM_DEV" => "dnygmmd2_nys31d076.fir.fbc.com",
   "NY_GMM_DV1" => "dnygmmd3_nys31d076.fir.fbc.com",
   "NY_GMM_DV2" => "dnygmmd4_nys01d048.fir.fbc.com",
   "NY_GMM_UT1" => "qnygmmd1_nys91d5802.fir.fbc.com",
   "NY_GMM_UT2" => "qnygmmd2_nys91d5801.fir.fbc.com",
   "DNYGMMD1"   => "DNYGMMD1_nys31d5002.fir.fbc.com",
   "QNYGMMD1"   => "QNYGMMD1_nys91d5003.fir.fbc.com",
   "NY_GMM_TS1" => "cnygmmd1_nys01d048.fir.fbc.com",
);


## e.g. ($db,$login,$password) = getGmmDbLogin("NY_GMM","ReadOnly");
## Possible $PrivStr [ReadOnly,InsertUpdateDelete]
sub getGmmDbLogin {
   my($dbInstance,$privStr) = @_;

   $privStr        = setDefault($privStr,"InsertUpdateDelete");
   my $db          = $ENV{GMM_DB};
   my $login       = $ENV{GMM_DB_USER};
   my $password    = $ENV{GMM_DB_PASSWORD};

   if ($db eq "") {
     if (exists($gmmDbConections{$dbInstance})) {
         $db = $gmmDbConections{$dbInstance};
     } else {
         $db =  $dbInstance;
     }

     if (uc($privStr) eq uc("ReadOnly")) {
         $login        = "gmmreader";
         $password     = getFtpLoginPassword($login,$db);
     } elsif (uc($privStr) eq uc("InsertUpdateDelete")) {
         $login        = "gmmwriter";
         $password     = getFtpLoginPassword($login,$db);
     } elsif (uc($privStr) eq uc("ROOT")) {
         $login        = "gmmowner";
         $password     = getFtpLoginPassword($login,$db);
     } else {
         $login        = "gmmreader";
         $password     = getFtpLoginPassword($login,$db);
     }
   }
   ## print("getGmmDbLogin: Asking for :${dbInstance}/${$privStr}:\n");
   ## print("db:${db}:\n");
   ## print("login:${login}:\n");
   ## print("password:${password}:\n\n");

   my(@retList) = ($db,$login,$password);
   return @retList;
}

sub getGmmDbLoginForHeartBeat {
   my($dbInstance) = @_;
   my($db,$login,$password) = getGmmDbLogin($dbInstance,"");

   $login        = "gmmwriter";
   $password     = getFtpLoginPassword($login,$db);   
   my(@retList) = ($db,$login,$password);
   return @retList;
}

sub getGmmDbLoginString {
   my($dbInstance,$privStr) = @_;
   $privStr     = setDefault($privStr,"InsertUpdateDelete");
   my($db,$login,$password) = getGmmDbLogin($dbInstance,$privStr);
   my($retStr) = "${login}/${password}\@${db}";
   return $retStr;
}

sub getDoFilter {
   my($locationCode,$gmmDbAbriv)   = @_;
   if (($locationCode eq "ZH") &&
       (index($gmmDbAbriv,"ZH") != 0)) {
         return $TRUE;
   } elsif (($locationCode eq "ZN") &&
       (index($gmmDbAbriv,"ZH") != 0)) {
         return $TRUE;
   } else {
         return $FALSE;
   }
}

# returns date, cityCode, tradingSystem and tablename from a flt filename
# e.g.
# $filename = "$RunS/GmmGdb/IncommingData/20000912_LN_GMM_LOANS_DEPOSITS.flt";
# my($date,$city,$tradingSystem,$table) = parseGmmDataFltFilename($filename);
# printf("${date}=20000912\n");
# printf("${city}=LN\n");
# printf("${tradingSystem}=TIQ\n");
# printf("${table}=GMM_LOANS_DEPOSITS\n");
#
# $filename = "$RunS/GmmGdb/IncommingData/20000912_LN_WSS_GMM_LOANS_DEPOSITS.flt";
# my($date,$city,$tradingSystem,$table) = parseGmmDataFltFilename($filename);
# printf("${date}=20000912\n");
# printf("${city}=LN\n");
# printf("${tradingSystem}=WSS\n");
# printf("${table}=GMM_LOANS_DEPOSITS\n");
#
# $filename = "$RunS/GmmGdb/IncommingData/20000912_LN_WSS_ESTATE_GMM_LOANS_DEPOSITS.flt";
# my($date,$city,$tradingSystem,$table) = parseGmmDataFltFilename($filename);
# printf("${date}=20000912\n");
# printf("${city}=LN\n");
# printf("${tradingSystem}=WSS\n");
# printf("${table}=ESTATE_GMM_LOANS_DEPOSITS\n");
#
sub parseGmmDataFltFilename {
   my($aFilename) = @_;
   my $baseFilename = getFilenameWithoutExtension(getFileNameOutOfFullName($aFilename));
   my @fileInfo = split("_",$baseFilename);
   my $date  = $fileInfo[0];
   my $city  = $fileInfo[1];
   my $tradingSystem = "TIQ";
   my $startIndex    = 2;
   if (($fileInfo[2] eq "GMM") || ($fileInfo[2] eq "ESTATE")) {
      $startIndex = 2;
      $tradingSystem = "TIQ";
   } else {
      $startIndex = 3;
 
      if ($fileInfo[2] =~ /PACK/ ) {
        $tradingSystem = "TIQ";
      } elsif ($fileInfo[3] =~ /PACK/) {
         $tradingSystem =  $fileInfo[2];
         $startIndex = 4; 
      } else {
        $tradingSystem = $fileInfo[2];
      }
   }
   my $table = "";
 
   my $lastPart =$fileInfo [ @fileInfo - 1];
 
 
  if (!($baseFilename =~ /GMM/)) {
     $table =$lastPart;
     $tradingSystem = "TIQ";
 
  } else {
 
   for (my $i = $startIndex; $i < @fileInfo ; $i++) {
      my $namePart = $fileInfo[$i];
      if ($table eq "") {
         $table = $namePart;
      } else {
         $table = "${table}_${namePart}";
      }
   }
 }
   return ($date,$city,$tradingSystem,$table);
}

# $filename = "$RunS/GmmGdb/IncommingData/EventFrom_20000912080812_LN_TIQ.flt";
# my($timestamp,$city,$tradingSystem) = parseGmmEventFilename($filename);
# printf("${timestamp}=20000912080812\n");
# printf("${city}=LN\n");
# printf("${tradingSystem}=TIQ\n");
sub parseGmmEventFilename {
   my($aFilename) = @_;
   my $baseFilename = getFilenameWithoutExtension(getFileNameOutOfFullName($aFilename));
   my @fileInfo = split("_",$baseFilename);
   my $eventTag       = $fileInfo[0];
   my $timstamp       = $fileInfo[1];
   my $cityCode       = $fileInfo[2];
   my $tradingSystem  = $fileInfo[3];

   if ($eventTag ne "EventFrom") {
      $timstamp       = "";
      $cityCode       = "";
      $tradingSystem  = "";
   }
   return ($timstamp,$cityCode,$tradingSystem);
}


# Function to access GMM_CURRENCY
# -------------------------------
sub getEUR_ConversionRates {
  my ($database,$login,$password,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my(%dealNum) = ();
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  %convRate = getEUR_ConversionRates_dbh($gmm_dbHandler,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return %convRate;
}

sub getEUR_ConversionRates_dbh {
   my($dbh,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   my(%convRate) = ();
   my(@queryResultRef) = ();
   my($sql_getAllDealNum) = qq {
         select CCY_CODE,
                CONV_RATE 
         from GMM_CURRENCY
         where PARENT_CCY='EUR'
         order by CCY_CODE
   };
   my($sth) = $dbh->prepare($sql_getAllDealNum);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($aHandlerRef) = "";
   foreach $aHandlerRef (@queryResultRef) {
      %convRate = (%convRate,($aHandlerRef->{CCY_CODE},$aHandlerRef->{CONV_RATE}));
   }
   return %convRate;
}

# get all deal numbers for a given product, system_date and city_code
# -------------------------------------------------------------------
sub getDealNumberFor_Product_SystemDate_CityCode {
  my ($database,$login,$password,$product,$systemDate,$cityCode,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my(@dealNum) = ();
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  @dealNum = getDealNumberFor_Product_SystemDate_CityCode_dbh($gmm_dbHandler,$product,$systemDate,$cityCode,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return @dealNum;
}

sub getDealNumberFor_Product_SystemDate_CityCode_dbh {
   my($dbh,$product,$systemDate,$cityCode,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   my(@dealNum) = ();
   my(@queryResultRef) = ();
   my($sql_getAllDealNum) = qq {
         select Deal_Number 
         from ${product}
         where SYSTEM_DATE = to_date(${systemDate},'YYYYMMDD') AND
               CITY_CODE   = '${cityCode}'
         order by Deal_Number
   };
   my($sth) = $dbh->prepare($sql_getAllDealNum);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($aHandlerRef) = "";
   foreach $aHandlerRef (@queryResultRef) {
      push(@dealNum,$aHandlerRef->{DEAL_NUMBER});
   }
   return @dealNum;
}

# Functions for getting data from FAS_CUST_TYPE
# ---------------------------------------------
sub getAllCpyTypeDescriptionFromGmmCpyType_dbh {
   my($dbh,$cityCode,$tradingSystem,$logfile,$verbal) = @_;
   $verbal        = setDefault($verbal,$TRUE);
   $tradingSystem = setDefault($tradingSystem,"TIQ");
      
   my(%cpyTypeDesc) = ();
   my(@queryResultRef) = ();
   my($sql) = qq {
         select CUST_TYPE_CODE,
                CUST_TYPE_DESCRIPTION
         from FAS_CUST_TYPE
         where TRADING_SYSTEM= '${tradingSystem}' AND
               CITY_CODE     = '${cityCode}'
         order by CUST_TYPE_CODE
   };
   my($sth) = $dbh->prepare($sql);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($aHandlerRef) = "";
   foreach $aHandlerRef (@queryResultRef) {
      %cpyTypeDesc = (%cpyTypeDesc,($aHandlerRef->{CUST_TYPE_CODE},$aHandlerRef->{CUST_TYPE_DESCRIPTION}));
   }
   return %cpyTypeDesc;

}

sub getInternalCustomersFromGmmCpyType_dbh {
   my($dbh,$cityCode,$tradingSystem,$logfile,$verbal) = @_;
   $verbal        = setDefault($verbal,$TRUE);
   $tradingSystem = setDefault($tradingSystem,"TIQ");

   my(@internalCust) = ();
   my(@queryResultRef) = ();
   my($sql) = qq {
         select CUST_TYPE_CODE 
         from FAS_CUST_TYPE
         where TRADING_SYSTEM= '${tradingSystem}' AND
               CITY_CODE     = '${cityCode}' AND 
               INTERNAL_EXTERNAL_FLAG = 'I'
         order by CUST_TYPE_CODE
   };
   my($sth) = $dbh->prepare($sql);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($aHandlerRef) = "";
   foreach $aHandlerRef (@queryResultRef) {
      push(@internalCust,$aHandlerRef->{CUST_TYPE_CODE});
   }
   return @internalCust;
}

sub getAndSaveCpyTypeInfo_dbh {
   my($dbh,$cityCode,$tradingSystem,$filename,$logfile,$verbal) = @_;
   $verbal        = setDefault($verbal,$TRUE);
   $tradingSystem = setDefault($tradingSystem,"TIQ");

   my($sql) = qq {
         select CUST_TYPE_CODE,
                CUST_TYPE_DESCRIPTION,
                INTERNAL_EXTERNAL_FLAG 
         from FAS_CUST_TYPE
         where TRADING_SYSTEM= '${tradingSystem}' AND
               CITY_CODE     = '${cityCode}'
         order by CUST_TYPE_CODE
   };
   sqlToFlat_dbh($sql,$filename,$dbh);
   addToLogFile(sprintf("--> Saved cpy-types details in ${filename}"),$logfile,$verbal);
}

sub getCpyIdHash_FromDescAndIntExt {
   my($filename,$cityCode,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);   
   my(%cpyIdFromDescAndIntExt) = ();

   my @records = getAllMatchesFromFltFileAsHashes($filename,"\\|","","");
   foreach my $record(@records) {
      my $newKey = sprintf("%s__%s",$record->{CUST_TYPE_DESCRIPTION},$record->{INTERNAL_EXTERNAL_FLAG});
      %cpyIdFromDescAndIntExt = (%cpyIdFromDescAndIntExt,($newKey,$record->{CUST_TYPE_CODE}));
   }
   addToLogFile(sprintf("--> Init cpyIdFromDescAndIntExt reading ${filename}"),$logfile,$verbal);
   return %cpyIdFromDescAndIntExt;
}

sub getCpyId_FromDescAndIntExt {
  my($cpyDesc,$intExt,$notFoundVal_1,$notFoundVal_2,%aHash) = @_;
  my $retStr = "";
  my $key = sprintf("%s__%s",$cpyDesc,$intExt);
  if (($cpyDesc eq "") || ($intExt eq "")) {
     $retStr = $notFoundVal_1;
  } else {
     $retStr = getValueFromHash($key,$notFoundVal_2,$FALSE,%aHash);
  }
  ### printf(":${cpyDesc}__${intExt}: --> :${retStr}\n");
  return $retStr;
}

sub getAllCpyTypeDescriptionFromGmmCpyType {
   my($filename,$cityCode,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);   
   my(%cpyTypeDesc) = ();

   my @records = getAllMatchesFromFltFileAsHashes($filename,"\\|","","");
   foreach my $record(@records) {
      %cpyTypeDesc = (%cpyTypeDesc,($record->{CUST_TYPE_CODE},$record->{CUST_TYPE_DESCRIPTION}));
   }
   addToLogFile(sprintf("--> Init cpy-types descriptions reading ${filename}"),$logfile,$verbal);
   return %cpyTypeDesc;
}

sub getInternalCustomersFromGmmCpyType {
   my($filename,$cityCode,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   my(@internalCust) = ();
   my @records = getAllMatchesFromFltFileAsHashes($filename,"\\|","INTERNAL_EXTERNAL_FLAG=I","");
   foreach my $record(@records) {
      push(@internalCust,$record->{CUST_TYPE_CODE});
   }
   addToLogFile(sprintf("--> Init cpy-types Internal reading ${filename}"),$logfile,$verbal);
   return @internalCust;
}


# Functions to handle with ROW counts
# -----------------------------------

# functions returns a HTML table with TABLES/SYSTEM_DATE and the row counts
sub getGMMRowCountsAsHTML_Tbl_dhb {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$cgiName,@tables) = @_;
   my @sysDates = getUnionOfGmmSystemDatesFromProductTbl_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logFile,$verbal,@tables);
   my($aTable) = "";
   printf("<TABLE border=1 cellpadding=5 cellspacing=0>\n <TR><TD>&nbsp;</TD>\n");
   my($aDate) = "";
   printf("      <TD bgcolor='Lime'><font size=-1><CENTER>Total</TD>\n");
   foreach $aDate (reverse (@sysDates)) {
      my $datStr = formatTimeStamp($aDate,"US",$TRUE,$FALSE,$LangEnglish);
      $datStr =~ s/,/\<BR\>/g;
      printf("      <TD bgcolor='Yellow'><font size=-1><CENTER>${datStr}</TD>\n");
   }
   printf("  </TR>\n");
   foreach $aTable (sort (@tables)) {
       my($url) = addCgiParameterInUrl($cgiName,"reqTable=${aTable}");
       printf(" <TR><TD bgcolor='Yellow'><A HREF=\"${url}\">${aTable}</A></TD>\n");
       my($aSystemDate) = "";
       my($countsStr) = "";
       my($totCount)  = 0;
       foreach $aSystemDate (reverse (@sysDates)) {
          $count = getGmmRowCount_dbh($dbh,$aTable,$cityCode,$tradingSystem,$legalEntity,$aSystemDate,$logFile,$verbal);
          $countsStr = "${countsStr}     <TD><font size=-1>${count}</TD>\n";
          $totCount += $count;
       }
       printf("     <TD bgcolor='Lime'><font size=-1>${totCount}</TD>\n");
       printf("${countsStr}");
       printf("  </TR>\n");
   }
   printf("</TABLE>\n");
}


sub getGMMSystemDatesCount_dbAbv {
   my($dbAbv) = @_;
   $dbAbv          = uc(setDefault($dbAbv,"NY_GMM"));

   print("getGMMSystemDatesCount_dbAbv....\n");
   my @tables = (@gmmExtractedProductsTbl,@gmmMrsTables,@gmmExtractedRatesTbl,@gmmExtractedProductsHistoryTbl,@gmmExtractedEodProductsTbl);

   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   foreach my $aTable (@tables) {
     printf("--> %12s different system-dates for ${aTable} \n",getGmmCountOfSysDates_dbh($gmm_dbHandler,$aTable,"",$logfile,$verbal));
   }
   dbDisconnect($gmm_dbHandler);
   print("getGMMSystemDatesCount_dbAbv....done\n");

   print("For more details on a particular table use:\n");
   print("    execPerlFct getGMMSystemDatesCountForTablePerCity_dbAbv NY_GMM tableName\n");
}

sub getGMMSystemDatesCountForTablePerCity_dbAbv {
   my($dbAbv,$aTable) = @_;
   $dbAbv          = uc(setDefault($dbAbv,"NY_GMM"));
   ## my(@cities) = ("NY","LN","ZH");  # Changed by WR at April 25th, 2007
   my @cities  = @allGmmCities;

   print("getGMMSystemDatesCount_dbAbv....\n");
   my @tables = (@gmmExtractedProductsTbl,@gmmMrsTables,@gmmExtractedRatesTbl,@gmmExtractedProductsHistoryTbl,@gmmExtractedEodProductsTbl);

   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   print("Row-Count for ${aTable} per city\n");
   foreach my $aCity (@cities) {
     printf("--> %12s: different system-dates for ${aCity}:\n",getGmmCountOfSysDates_dbh($gmm_dbHandler,$aTable,$aCity,$logfile,$verbal));
   }
   dbDisconnect($gmm_dbHandler);
   print("getGMMSystemDatesCount_dbAbv....done\n");
}

# functions returns table with TABLES/SYSTEM_DATE and the row counts
#
# tableSet = [products, mrs, rates, histo, eod, all]
sub getGMMRowCountsTbl_dbAbv {
   my($dbAbv,$cityCode,$tableSet,$tradingSystem,$legalEntity) = @_;
   $tableSet          = uc(setDefault($tableSet,"ALL"));
   $tradingSystem     = setDefault($tradingSystem,"TIQ");
   $legalEntity       = setDefault($legalEntity  ,"CSFB");

   my @tables = ($tableSet);

   if ($tableSet eq "PRODUCTS") {
       @tables = @gmmExtractedProductsTbl;
   } elsif ($tableSet eq "MRS") {
       @tables = @gmmMrsTables;
   } elsif ($tableSet eq "RATES") {
       @tables = @gmmExtractedRatesTbl;
   } elsif ($tableSet eq "HISTO") {
       @tables = @gmmExtractedProductsHistoryTbl;
   } elsif ($tableSet eq "EOD") {
       @tables = @gmmExtractedEodProductsTbl;
   } elsif ($tableSet eq "ALL") {
       @tables = (@gmmExtractedProductsTbl,@gmmMrsTables,@gmmExtractedRatesTbl,@gmmExtractedProductsHistoryTbl,@gmmExtractedEodProductsTbl);
   }

   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);


   my @sysDates = getUnionOfGmmSystemDatesFromProductTbl_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logFile,$verbal,@tables);
   my($aTable) = "";
   printf("Counts for $dbAbv,$cityCode,$tradingSystem,$legalEntity\n");
   my $aDate = "";
   foreach $aDate (reverse (@sysDates)) {
      my $datStr = formatTimeStamp($aDate,"US",$FALSE,$FALSE,$LangEnglish);
      printf("%12s",$datStr);
   }
   printf("\n");
   my $aTable = "";
   foreach $aTable (sort (@tables)) {
       my($url) = addCgiParameterInUrl($cgiName,"reqTable=${aTable}");
       my($aSystemDate) = "";
       my($countsStr) = "";
       my($totCount)  = 0;
       foreach $aSystemDate (reverse (@sysDates)) {
          $count = getGmmRowCount_dbh($gmm_dbHandler,$aTable,$cityCode,$tradingSystem,$legalEntity,$aSystemDate,$logFile,$verbal);
          $countsStr = sprintf("${countsStr}%12s",$count);
          $totCount += $count;
       }
       print("${countsStr}");
       print("  ${aTable} (${totCount})");
       print("\n");
   }
   printf("\n");
   dbDisconnect($gmm_dbHandler);
}


# functions to return row counts for a single table and a given SYSTEM_DATE
sub getGmmRowCount {
  my ($database,$login,$password,$table,$cityCode,$tradingSystem,$legalEntity,$systemDate,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my $count = getGmmRowCount_dbh($gmm_dbHandler,$table,$cityCode,$tradingSystem,$legalEntity,$systemDate,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $count;
}

sub getGmmRowCount_dbh {
   my($dbh,$table,$cityCode,$tradingSystem,$legalEntity,$systemDate,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($locWhereClause) = makeWhereClauseOutOf_City_TrSys_LegEnt_SysDate($cityCode,$tradingSystem,$legalEntity,$systemDate);
   my($aSql) = qq {
         select count(*) COUNT
         from ${table}
         $locWhereClause
   };
   ### printf("aSql:\n${aSql}\n");
   my($sth) = $dbh->prepare($aSql);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   if (@queryResultRef[0]) {
      return @queryResultRef[0]->{COUNT};
   } else {
      return "";
   }
}


sub getGmmCountOfSysDates_dbh {
   my($dbh,$table,$city_code,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   my $whereClause = "";
   if ($city_code ne "") {
        $whereClause = "where CITY_CODE=\'$city_code\'";
   }

   my (@queryResultRef) = ();
   my($aSql) = qq {
         select count(distinct system_date) COUNT
         from ${table} $whereClause
   };
   ### printf("aSql:\n${aSql}\n");
   my($sth) = $dbh->prepare($aSql);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   if (@queryResultRef[0]) {
      return @queryResultRef[0]->{COUNT};
   } else {
      return "";
   }
}



# get deal-type using GMM_ALL_DEALS
# ---------------------------------
sub getGmmDealTypeFromALL_DEALS {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$systemDate,$dealNumber,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my $dealType = getGmmDealTypeFromALL_DEALS_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$systemDate,$dealNumber,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $dealType;
}

sub getGmmDealTypeFromALL_DEALS_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$systemDate,$dealNumber,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();

   ### it is not in GMM_ALL_DEALS               LEGAL_ENTITY   = '${legalEntity}'                  AND

   my($aSql) = qq {
         select DEAL_TYPE
         from GMM_ALL_DEALS
         where CITY_CODE      = '${cityCode}'                     AND
               TRADING_SYSTEM = '${tradingSystem}'                AND
               SYSTEM_DATE    = to_date(${systemDate},'YYYYMMDD') AND
               DEAL_NUMBER    = '${dealNumber}'
   };
   my($sth) = $dbh->prepare($aSql);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   if (@queryResultRef[0]) {
      return @queryResultRef[0]->{DEAL_TYPE};
   } else {
      return "";
   }
}

sub getGmmDealRecord {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$systemDate,$dealNumber,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my %aDealRec = ggetGmmDealRecord_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$systemDate,$dealNumber,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return %aDealRec;
}

sub getGmmDealRecord_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$systemDate,$dealNumber,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   my %aDealRec = ();

   my($dealType) = getGmmDealTypeFromALL_DEALS_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$systemDate,$dealNumber,$logfile,$verbal);
   my($dealTbl)  = getGmmTableFromForGivenDealType($dealType);
   if ($dealTbl ne "") {
      my @queryResultRef = ();
      my($aSql) = qq {
         select *
         from ${dealTbl}
         where CITY_CODE      = '${cityCode}'                     AND
               LEGAL_ENTITY   = '${legalEntity}'                  AND
               TRADING_SYSTEM = '${tradingSystem}'                AND
               SYSTEM_DATE    = to_date(${systemDate},'YYYYMMDD') AND
               DEAL_NUMBER    = '${dealNumber}'
      };
     if ($dealTbl ne "") {
       my($sth) = $dbh->prepare($aSql);
       @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
       if (@queryResultRef[0]) {
          my $aHashRef = @queryResultRef[0];
          %aDealRec = %$aHashRef;
       }
     }
   } else {
       %aDealRec = (
          "ERROR:" => "Deal-Type :${dealType}: not found in mapping table. Add to gmmPerlLib.pm in fct getGmmTableFromForGivenDealType",   
       );
   }
   return %aDealRec;
}

sub getGmmTableFromForGivenDealType {
    my($dealType) = @_;
    if ($dealType eq "CALLD") {
        return "GMM_CALLS";
    } elsif (($dealType eq "DEPO") ||
             ($dealType eq "LOAN") ||
             ($dealType eq "TERM") ||
             ($dealType eq "CMLOAN")){
        return "GMM_LOANS_DEPOSITS";
    } elsif ($dealType eq "FRA") {
        return "GMM_FRA";
    } elsif ($dealType eq "FUTURE") {
        return "GMM_FUTURE";
    } elsif ($dealType eq "REPO") {
        return "GMM_REPO";
    } elsif ($dealType eq "FXARB") {
        return "GMM_FX_ARB";
    } elsif ($dealType eq "OPTION") {
        return "GMM_OPTION";
    } elsif ($dealType eq "SECBS") {
        return "GMM_SECURITIES";
    } elsif ($dealType eq "CFDEAL") {
        return "GMM_SWAPS";
    } else {
        return "";
    }
}


# Functions to get the SYSTEM_DATE out of product tables
# ------------------------------------------------------

# returns the union of all system_dates for a list of tables
sub getUnionOfGmmSystemDatesFromProductTbl {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,@tables) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my @systemDates = getUnionOfGmmSystemDatesFromProductTbl_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,@tables);
  dbDisconnect($gmm_dbHandler);
  return @systemDates;
}

sub getUnionOfGmmSystemDatesFromProductTbl_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,@tables) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   my @retVals = ();
   my $aTbl    = "";
   foreach $aTbl (@tables) {
      my @sysDates = getAllGmmSystemDatesFromProductTbl_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,$aTbl);
      ## printf("SystemDates in ${aTbl}\n");
      ## displayArray(@sysDates);
      @retVals = (@retVals, @sysDates);
   }
   my @distList = makeArrayEntriesDistinct($TRUE,@retVals);
   ## printf("Made it distinct....\n");
   ## displayArray(@distList);
   return (sort @distList);
 }


# selects all system_dates from a product table
sub getAllGmmSystemDatesFromProductTbl {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,$table) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my @systemDates = getAllGmmSystemDatesFromProductTbl_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,$table);
  dbDisconnect($gmm_dbHandler);
  return @systemDates;
}

sub getAllGmmSystemDatesFromProductTbl_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,$table) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($locWhereClause) = makeWhereClauseOutOf_City_TrSys_LegEnt_SysDate($cityCode,$tradingSystem,$legalEntity);
   my($aSql) = qq {
         select distinct to_char(SYSTEM_DATE,'YYYYMMDD') SYSTEM_DATE
         from ${table}
         $locWhereClause order by SYSTEM_DATE
   };
   ## printf("aSql:\n${aSql}\n");
   my($sth) = $dbh->prepare($aSql);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($aRef) = "";
   my @retVals = ();
   foreach $aRef (@queryResultRef) {
      push(@retVals,$aRef->{SYSTEM_DATE});
   }
   return @retVals;
 }

sub makeDealNumWhereClause {
   my($fieldName,@dealNum) = @_;
   my($retStr)     = "";
   my $count       = @dealNum;
   my $y           = 0;
   my $isVeryFirst = $TRUE;
   my $isFirst     = $TRUE;

   for(my $i =0;$i < $count; $i++){
     if ($y > 7) {
        $y = 0;
     }

     if ($y eq  "0") {
         if ($isVeryFirst) {
            $retStr = "${fieldName} in (";
            $isVeryFirst = $FALSE;
         } else {
            $retStr = "${retStr}) OR\n${fieldName} in (";
         }
         $isFirst = $TRUE;
     }
     if ($isFirst) {
        $retStr = sprintf("${retStr}%s",$dealNum[$i]);
        $isFirst = $FALSE;
     } else {
        $retStr = sprintf("${retStr},%s",$dealNum[$i]);
     }
     $y++;
   }

   if ($retStr ne "") {
      $retStr = "${retStr})";
      if (index($retStr," OR") != -1) {
         $retStr = "(${retStr})";
      }
   }
   return $retStr;
}

sub makeWhereClauseOutOf_City_TrSys_LegEnt_SysDate {
    my($cityCode,$tradingSystem,$legalEntity,$systemDate) = @_;
    my($whereClause) = "";
    if ($cityCode ne "") {
        $whereClause = "CITY_CODE = '${cityCode}' ";
    }
   
    if ($tradingSystem ne "") {
        if ($whereClause eq "") {
            $whereClause = "TRADING_SYSTEM = '${tradingSystem}' ";
        } else {
            $whereClause = "${whereClause} AND TRADING_SYSTEM = '${tradingSystem}' ";
        }
    }

    if ($legalEntity ne "") {
        if ($whereClause eq "") {
            $whereClause = "LEGAL_ENTITY  = '${legalEntity}' ";
        } else {
            $whereClause = "${whereClause} AND LEGAL_ENTITY = '${legalEntity}' ";
        }
    }

    if ($systemDate ne "") {
        if ($whereClause eq "") {
            $whereClause = "SYSTEM_DATE = to_date(${systemDate},'YYYYMMDD') ";
        } else {
            $whereClause = "${whereClause} AND SYSTEM_DATE = to_date(${systemDate},'YYYYMMDD') ";
        }
    }


    if ($whereClause ne "") {
       $whereClause = "where ${whereClause}";
    }
    return $whereClause;
}

# access methods for GMM_CONTROL
# ==============================
sub getGmmControlDate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my %controlRec = getGmmControlDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return @aRecRefArr;
}

sub getGmmControlDate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($aSql) = qq {
         select CITY_CODE,
                TRADING_SYSTEM,
                to_char(SYSTEM_DATE,'YYYYMMDD')                  SYSTEM_DATE,
                to_char(LAST_TRADING_DATE,'YYYYMMDD')            LAST_TRADING_DATE,
                to_char(LAST_EOD_DATE,'YYYYMMDD')                LAST_EOD_DATE,
                to_char(NEXT_TRADING_DATE,'YYYYMMDD')            NEXT_TRADING_DATE,
                to_char(LAST_ARCHIVING_DATE,'YYYYMMDDHH24MISS')  LAST_ARCHIVING_DATE,
                to_char(LAST_PURGING_DATE,'YYYYMMDDHH24MISS')    LAST_PURGING_DATE,
                to_char(RTF_LASTUPDATE,'YYYYMMDDHH24MISS')       RTF_LASTUPDATE,
                RTF_BEHIND,
                KEEP_DAYS,
                KEEP_HISTORY_DAYS,
                RTF_STATUS,
                to_char(EVH_LASTUPDATE,'YYYYMMDDHH24MISS')       EVH_LASTUPDATE,
                EVH_STATUS,
                RTF_EVENT_SENDER,
                to_char(RTF_EVENT_TIME,'YYYYMMDDHH24MISS') RTF_EVENT_TIME,
                EVH_EVENT_SENDER,
                to_char(EVH_EVENT_TIME,'YYYYMMDDHH24MISS') EVH_EVENT_TIME,
                EVH_PROCESSING
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($aSql);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my $countOfRec = @queryResultRef;
   my %controlRec = ();
   if ($countOfRec == 0) {
       %controlRec = ("ERROR","No Control record found for cityCode:${cityCode}: tradingSystem:${tradingSystem}: legalEntity:${legalEntity}");
   } elsif ($countOfRec == 1) {
       my($aHashRef) = $queryResultRef[0];
       %controlRec = (%controlRec,("CITY_CODE",            $aHashRef->{"CITY_CODE"}));
       %controlRec = (%controlRec,("TRADING_SYSTEM",       $aHashRef->{"TRADING_SYSTEM"}));
       %controlRec = (%controlRec,("SYSTEM_DATE",          $aHashRef->{"SYSTEM_DATE"}));
       %controlRec = (%controlRec,("LAST_TRADING_DATE",    $aHashRef->{"LAST_TRADING_DATE"}));
       %controlRec = (%controlRec,("LAST_EOD_DATE",        $aHashRef->{"LAST_EOD_DATE"}));
       %controlRec = (%controlRec,("NEXT_TRADING_DATE",    $aHashRef->{"NEXT_TRADING_DATE"}));
       %controlRec = (%controlRec,("LAST_ARCHIVING_DATE",  $aHashRef->{"LAST_ARCHIVING_DATE"}));
       %controlRec = (%controlRec,("LAST_PURGING_DATE",    $aHashRef->{"LAST_PURGING_DATE"}));
       %controlRec = (%controlRec,("KEEP_DAYS",            $aHashRef->{"KEEP_DAYS"}));
       %controlRec = (%controlRec,("KEEP_HISTORY_DAYS",    $aHashRef->{"KEEP_HISTORY_DAYS"}));
       %controlRec = (%controlRec,("RTF_STATUS",           $aHashRef->{"RTF_STATUS"}));
       %controlRec = (%controlRec,("RTF_LASTUPDATE",       $aHashRef->{"RTF_LASTUPDATE"}));
       %controlRec = (%controlRec,("RTF_BEHIND",           $aHashRef->{"RTF_BEHIND"}));
       %controlRec = (%controlRec,("EVH_LASTUPDATE",       $aHashRef->{"EVH_LASTUPDATE"}));
       %controlRec = (%controlRec,("EVH_STATUS",           $aHashRef->{"EVH_STATUS"}));
       %controlRec = (%controlRec,("RTF_EVENT_SENDER",     $aHashRef->{"RTF_EVENT_SENDER"}));
       %controlRec = (%controlRec,("RTF_EVENT_TIME",       $aHashRef->{"RTF_EVENT_TIME"}));
       %controlRec = (%controlRec,("EVH_EVENT_SENDER",     $aHashRef->{"EVH_EVENT_SENDER"}));
       %controlRec = (%controlRec,("EVH_EVENT_TIME",       $aHashRef->{"EVH_EVENT_TIME"}));
       %controlRec = (%controlRec,("EVH_PROCESSING",       $aHashRef->{"EVH_PROCESSING"}));

   } else {
       %controlRec = ("ERROR","${countOfRec} control records found for cityCode:${cityCode}: tradingSystem:${tradingSystem}: legalEntity:${legalEntity}");
   }

   return %controlRec; 
}

sub getAllCity_TradingSystems {
  my ($database,$login,$password,,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my (@queryResultRef) = ();

  @queryResultRef = getAllCity_TradingSystems_dbh($gmm_dbHandler,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
   return @queryResultRef;
}

sub getAllCity_TradingSystems_dbh {
   my($dbh,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select  DISTINCT CITY_CODE,
                 TRADING_SYSTEM 
         from GMM_CONTROL
         where LEGAL_ENTITY   = '${legalEntity}'
         order by TRADING_SYSTEM
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   return @queryResultRef;
}

# system date for a particular location from the control table
# ------------------------------------------------------------
sub getGmmSystemDate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($systemDate) = getGmmSystemDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $systemDate;
}

sub getGmmSystemDate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($sql_getSystemDate) = qq {
         select to_char(SYSTEM_DATE,'YYYYMMDD') SYSTEM_DATE
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($sql_getSystemDate);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   if (@queryResultRef[0]) {
      return @queryResultRef[0]->{SYSTEM_DATE};
   } else {
      return "";
   }
}


sub setGmmSystemDate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$systemDate,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setGmmSystemDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$systemDate,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
}

sub setGmmSystemDate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$systemDate,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my($sth)    = $dbh->prepare("BEGIN gmm_control_parameters_pkg.setSystemDate(:SYSTEM_DATE, :TRADING_SYSTEM, :LEGAL_ENTITY, :CITY_CODE); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->bind_param(":SYSTEM_DATE",    $systemDate);
   $sth->execute();
}

sub setGmmSystemDates {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$lastTradingDate,$systemDate,$nextTradingDate,$lastEodDate,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setGmmSystemDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$lastTradingDate,$systemDate,$nextTradingDate,$lastEodDate,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
}

sub setGmmSystemDates_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$lastTradingDate,$systemDate,$nextTradingDate,$lastEodDate,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   ### printf("CITY_CODE:${cityCode}:\n");
   ### printf("TRADING_SYSTEM:${tradingSystem}:\n");
   ### printf("LEGAL_ENTITY:${legalEntity}:\n");
   ### printf("LAST_TRADING_DATE:${lastTradingDate}:\n");
   ### printf("SYSTEM_DATE:${systemDate}:\n");
   ### printf("NEXT_TRADING_DATE:${nextTradingDate}:\n");
   ### printf("LAST_EOD_DATE:${lastEodDate}:\n");

   my($sth)    = $dbh->prepare("BEGIN gmm_control_parameters_pkg.setSystemDate(:LAST_TRADING_DATE, :SYSTEM_DATE, :NEXT_TRADING_DATE, :LAST_EOD_DATE, :TRADING_SYSTEM, :LEGAL_ENTITY, :CITY_CODE); END;");
   $sth->bind_param(":CITY_CODE",            $cityCode);
   $sth->bind_param(":TRADING_SYSTEM",       $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",         $legalEntity);
   $sth->bind_param(":LAST_TRADING_DATE",    $lastTradingDate);
   $sth->bind_param(":SYSTEM_DATE",          $systemDate);
   $sth->bind_param(":NEXT_TRADING_DATE",    $nextTradingDate);
   $sth->bind_param(":LAST_EOD_DATE",        $lastEodDate);
   $sth->execute();
}

sub getGmmLastTradingDate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($systemDate) = getGmmLastTradingDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $systemDate;
}

sub getGmmLastTradingDate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($sql_getSystemDate) = qq {
         select to_char(LAST_TRADING_DATE,'YYYYMMDD') LAST_TRADING_DATE
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($sql_getSystemDate);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   if (@queryResultRef[0]) {
      return @queryResultRef[0]->{LAST_TRADING_DATE};
   } else {
      return "";
   }
}

sub getGmmNextTradingDate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($systemDate) = getGmmNextTradingDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $systemDate;
}

sub getGmmNextTradingDate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($sql_getSystemDate) = qq {
         select to_char(NEXT_TRADING_DATE,'YYYYMMDD') NEXT_TRADING_DATE
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($sql_getSystemDate);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   if (@queryResultRef[0]) {
      return @queryResultRef[0]->{NEXT_TRADING_DATE};
   } else {
      return "";
   }
}

sub getGmmLastEodDate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($systemDate) = getGmmLastEodDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $systemDate;
}

sub getGmmLastEodDate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($sql_getSystemDate) = qq {
         select to_char(LAST_EOD_DATE,'YYYYMMDD') LAST_EOD_DATE
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($sql_getSystemDate);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   if (@queryResultRef[0]) {
      return @queryResultRef[0]->{LAST_EOD_DATE};
   } else {
      return "";
   }
}

sub isGmmLastTradingDayOfMonth {
  my  ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) =  isGmmLastTradingDayOfMonth_dbh ($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
 
}
sub isGmmLastTradingDayOfMonth_dbh {
  my ($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
 
  my($today)            = getGmmSystemDate_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($today_month)      = substr($today,4,2);
 
  my($tomorrow)         = getGmmNextTradingDate_dbh($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($tomorrow_month)   = substr($tomorrow,4,2);
  if ($tomorrow_month ne $today_month) {
     return $TRUE;
  } else {
     return $FALSE;
  }
 
}

sub isGmmLastTradingDayOfTheQuarter {
  my  ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) =  isGmmLastTradingDayOfTheQuarter_dbh ($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
 
}
 
sub isGmmLastTradingDayOfTheQuarter_dbh {
  my ($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
 
  my($today)            = getGmmSystemDate_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($today_month)      = substr($today,4,2);
 
  if ($today_month != 3 || $today_month != 6 || $today_month != 9 ||  $today_month != 12   ) {
    return $FALSE;
  } esle  {
    return  isGmmLastTradingDayOfMonth_dbh ($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  }
 
}

sub isGmmLastTradingDayOfYear {
  my  ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) =  isGmmLastTradingDayOfYear_dbh ($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
 
 
}
 
sub isGmmLastTradingDayOfYear_dbh {
   my ($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
 
  my($today)            = getGmmSystemDate_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($today_year)       = substr($today,0,4);
 
  my($tomorrow)         = getGmmNextTradingDate_dbh($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($tomorrow_year)    = substr($tomorrow,0,4);
 
  if ($tomorrow_year ne $today_year) {
     return $TRUE;
  } else {
     return $FALSE;
  }
 
}

sub isGmmFirstTradingDayOfMonth {
  my  ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) =  isGmmFirstTradingDayOfMonth_dbh ($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
 
}
 
sub isGmmFirstTradingDayOfMonth_dbh {
  my ($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
 
  my($today)            = getGmmSystemDate_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($today_month)      = substr($today,4,2);
 
  my($yesterday)        = getGmmLastTradingDate_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($yesterday_month)  = substr($yesterday,4,2);
 
  if ($yesterday_month ne $today_month) {
     return $TRUE;
  } else {
     return $FALSE;
  }
}

sub isGmmFirstTradingDayOfTheQuarter {
  my  ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) =  isGmmFirstTradingDayOfTheQuarter_dbh ($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
 
}
 
sub isGmmFirstTradingDayOfTheQuarter_dbh  {
  my ($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
 
  my($today)            = getGmmSystemDate_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($today_month)      = substr($today,4,2);
 
  if ($today_month != 3 || $today_month != 6 || $today_month != 9 ||  $today_month != 12   ) {
    return $FALSE;
  } esle  {
    return isGmmFirstTradingDayOfMonth_dbh  ($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  }
 
}
sub isGmmFirstTradingDayOfYear {
  my  ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) =  isGmmFirstTradingDayOfYear_dbh ($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
 
 
}
 
sub isGmmFirstTradingDayOfYear_dbh {
  my ($dbh, $cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
 
 
  my($today)            = getGmmSystemDate_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($today_year)       = substr($today,0,4);
 
  my($yesterday)        = getGmmLastTradingDate_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  my($yesterday_year)   = substr($yesterday,0,4);
 
  if ($yesterday_year ne $today_year) {
     return $TRUE;
  } else {
     return $FALSE;
  }
 
}


# RTF control methods
# -------------------
sub isGmmRTF_status {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$testStatus,$maxWaitTime,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = isGmmRTF_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$testStatus,$maxWaitTime,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
}

sub isGmmRTF_status_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$testStatus,$maxWaitTime,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   $maxWaitTime= setDefault($maxWaitTime,"0");

   my $startTime = getTimeStamp();
   my $doTrying  = $TRUE;
   while ($doTrying) {
     my $aTime = getTimeStamp();
     my $waitTime = secDiff_YYYYMMDDhhmmss($aTime,$startTime,0);
     ### printf("startTime:${startTime}:  aTime:${aTime}:  waitTime:${waitTime}: \n");
     if ($waitTime > $maxWaitTime) {
        return $FALSE;
     } else {
        my $RTF_Status = getGmmRTF_status_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
        ### printf("RTF_Status:${RTF_Status}: \n");
        if ($RTF_Status eq $testStatus) {
           return $TRUE;
        } else {
           sleep(2);
        }
     }
   }  
}

sub getGmmRTF_status {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getGmmRTF_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
}

sub getGmmRTF_status_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($sql_getSystemDate) = qq {
         select RTF_STATUS
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($sql_getSystemDate);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{RTF_STATUS};
   }
   return $retStr;
}

sub setGmmRTF_status {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$newStatus,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setGmmRTF_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$newStatus,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
}

sub setGmmRTF_status_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$newStatus,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my $servername = `hostname | tr -d "[:space:]"`;
   my $appName = getFileNameOutOfFullName ( $0);
   my $senderInfo = sprintf("User->%s;Server->%s;App->%s;", getUserId(), $servername, $appName);
  

   my($sth)    = $dbh->prepare("BEGIN gmm_control_parameters_pkg.set_rtf_status_proc(:TRADING_SYSTEM, :LEGAL_ENTITY, :CITY_CODE, :RTF_STATUS, :RTF_EVENT_SENDER); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->bind_param(":RTF_STATUS",     $newStatus);
   $sth->bind_param(":RTF_EVENT_SENDER",     $senderInfo);
   $sth->execute();
}

sub getGmmRTF_LastUpdate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getGmmRTF_LastUpdate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
}

sub getGmmRTF_LastUpdate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select to_char(RTF_LASTUPDATE,'YYYYMMDDHH24MISS') RTF_LASTUPDATE
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{RTF_LASTUPDATE};
   }
   return $retStr;
}

sub setGmmRTF_LastUpdate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setGmmRTF_LastUpdate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
}

sub setGmmRTF_LastUpdate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my($sth)    = $dbh->prepare("BEGIN gmm_control_parameters_pkg.set_rtf_last_update_proc(:TRADING_SYSTEM, :LEGAL_ENTITY, :CITY_CODE); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->execute();
}

sub getGmmRTF_Behind {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getGmmRTF_Behind_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
}

sub getGmmRTF_Behind_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select RTF_BEHIND 
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{RTF_BEHIND};
   }
   return $retStr;
}

sub setGmmRTF_Behind {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$newValue,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setGmmRTF_Behind_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$newValue,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
}

sub setGmmRTF_Behind_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$newValue,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");

   my($sth)    = $dbh->prepare("BEGIN gmm_control_parameters_pkg.set_rtf_behind_proc(:TRADING_SYSTEM, :LEGAL_ENTITY, :CITY_CODE, :RTF_BEHIND); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->bind_param(":RTF_BEHIND",     $newValue);
   $sth->execute();
}


# EVH control methods
# -------------------
#
# in all functions if $tradingSystem eq "" the it checks if there are entries for WSS or TIQ. If there are both entries there
# it allways takes TIQ.
sub getTrdSystemForEVH_dbh {
   my($dbh,$cityCode,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   my (@queryResultRef) = ();
   my($sql_getSystemDate) = qq {
         select DISTINCT TRADING_SYSTEM
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($sql_getSystemDate);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";
   my $count = @queryResultRef;
   if ($count == 1) {
      $retStr = @queryResultRef[0]->{TRADING_SYSTEM};
   } else {
      $retStr = "TIQ";
   }
   return $retStr;

}

sub isGmmEVH_status {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$testStatus,$maxWaitTime,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = isGmmEVH_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$testStatus,$maxWaitTime,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
}

sub isGmmEVH_status_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$testStatus,$maxWaitTime,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   $maxWaitTime= setDefault($maxWaitTime,"0");

   my $startTime = getTimeStamp();
   my $doTrying  = $TRUE;
   while ($doTrying) {
     my $aTime = getTimeStamp();
     my $waitTime = secDiff_YYYYMMDDhhmmss($aTime,$startTime,0);
     ### printf("startTime:${startTime}:  aTime:${aTime}:  waitTime:${waitTime}: \n");
     if ($waitTime > $maxWaitTime) {
        return $FALSE;
     } else {
        my $EVH_Status = getGmmEVH_status_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
        ### printf("EVH_Status:${EVH_Status}: \n");
        if ($EVH_Status eq $testStatus) {
           return $TRUE;
        } else {
           sleep(2);
        }
     }
   }  
}

sub getGmmEVH_status {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getGmmEVH_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
}

# uses getTrdSystemForEVH_dbh
sub getGmmEVH_status_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal        = setDefault($verbal,$TRUE);
   $legalEntity   = setDefault($legalEntity,"CSFB");
   $tradingSystem = setDefault($tradingSystem,getTrdSystemForEVH_dbh($dbh,$cityCode,$legalEntity,$logfile,$verbal));

   my (@queryResultRef) = ();
   my($sql_getSystemDate) = qq {
         select EVH_STATUS
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($sql_getSystemDate);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{EVH_STATUS};
   }
   return $retStr;
}

sub setGmmEVH_status {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$newStatus,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setGmmEVH_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$newStatus,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
}

sub setGmmEVH_status_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$newStatus,$logfile,$verbal) = @_;
   $verbal        = setDefault($verbal,$TRUE);
   $legalEntity   = setDefault($legalEntity,"CSFB");
   $tradingSystem = setDefault($tradingSystem,getTrdSystemForEVH_dbh($dbh,$cityCode,$legalEntity,$logfile,$verbal));

   my $servername = `hostname | tr -d "[:space:]"`;
   my $appName = getFileNameOutOfFullName ( $0);
   my $senderInfo = sprintf("User->%s;Server->%s;App->%s;", getUserId(), $servername, $appName);

   my($sth)    = $dbh->prepare("BEGIN gmm_control_parameters_pkg.set_evh_status_proc(:TRADING_SYSTEM, :LEGAL_ENTITY, :CITY_CODE, :EVH_STATUS, :EVH_EVENT_SENDER); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->bind_param(":EVH_STATUS",     $newStatus);
   $sth->bind_param(":EVH_EVENT_SENDER", $senderInfo); 
   $sth->execute();
}

sub getGmmEVH_LastUpdate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getGmmEVH_LastUpdate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
}

sub getGmmEVH_LastUpdate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal        = setDefault($verbal,$TRUE);
   $legalEntity   = setDefault($legalEntity,"CSFB");
   $tradingSystem = setDefault($tradingSystem,getTrdSystemForEVH_dbh($dbh,$cityCode,$legalEntity,$logfile,$verbal));

   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select to_char(EVH_LASTUPDATE,'YYYYMMDDHH24MISS') EVH_LASTUPDATE
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{EVH_LASTUPDATE};
   }
   return $retStr;
}

sub setGmmEVH_LastUpdate {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setGmmEVH_LastUpdate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
}

sub setGmmEVH_LastUpdate_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal        = setDefault($verbal,$TRUE);
   $legalEntity   = setDefault($legalEntity,"CSFB");
   $tradingSystem = setDefault($tradingSystem,getTrdSystemForEVH_dbh($dbh,$cityCode,$legalEntity,$logfile,$verbal));

   my($sth)    = $dbh->prepare("BEGIN gmm_control_parameters_pkg.set_evh_last_update_proc(:TRADING_SYSTEM, :LEGAL_ENTITY, :CITY_CODE); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->execute();
}

sub getGmmEVH_Processing {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = getGmmEVH_Processing_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
}

sub getGmmEVH_Processing_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal        = setDefault($verbal,$TRUE);
   $legalEntity   = setDefault($legalEntity,"CSFB");
   $tradingSystem = setDefault($tradingSystem,getTrdSystemForEVH_dbh($dbh,$cityCode,$legalEntity,$logfile,$verbal));

   my (@queryResultRef) = ();
   my($aSqlStmt) = qq {
         select EVH_PROCESSING EVH_PROCESSING
         from GMM_CONTROL
         where CITY_CODE      = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'
   };
   my($sth) = $dbh->prepare($aSqlStmt);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($retStr) = "";

   if (@queryResultRef[0]) {
      $retStr = @queryResultRef[0]->{EVH_PROCESSING};
   }
   return $retStr;
}

sub setGmmEVH_Processing {
  my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$eventToProcess,$logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  setGmmEVH_Processing_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$eventToProcess,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
}

sub setGmmEVH_Processing_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$eventToProcess,$logfile,$verbal) = @_;
   $verbal        = setDefault($verbal,$TRUE);
   $legalEntity   = setDefault($legalEntity,"CSFB");
   $tradingSystem = setDefault($tradingSystem,getTrdSystemForEVH_dbh($dbh,$cityCode,$legalEntity,$logfile,$verbal));

   my  $sql = qq { update GMM_CONTROL
              set EVH_PROCESSING=\'${eventToProcess}\'
              where
               TRADING_SYSTEM=\'$tradingSystem\'
               AND CITY_CODE = \'$cityCode\'
               AND LEGAL_ENTITY =\'$legalEntity\'
   };
   ### printf("sql:\n${sql}:\n");
   
   sqlExecute_dbh($sql,$dbh);  
}

# Archiving and Purging functions
# ===============================
sub gmmArchiveProductsTbl {
   my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmArchiveProductsTbl_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

sub gmmArchiveProductsTbl_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   addToLogFile("Archiving Products-Tables for ${legalEntity} ${tradingSystem} ${cityCode}",$logfile,$verbal);

   my($sth)    = $dbh->prepare("BEGIN gmm_archive_tables_pkg.generate_archive_proc(:TRADING_SYSTEM, :LEGAL_ENTITY, :CITY_CODE); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->execute();
   addToLogFile("Archiving finished",$logfile,$verbal);
}

sub gmmPurgeProductsHistoryTbl {
   my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmPurgeProductsHistoryTbl_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

sub gmmPurgeProductsHistoryTbl_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   addToLogFile("Purging History-Tables for ${legalEntity} ${tradingSystem} ${cityCode} ",$logfile,$verbal);

   my($sth)    = $dbh->prepare("BEGIN gmm_purge_hist_tab_pkg.generate_purge_proc(:TRADING_SYSTEM, :LEGAL_ENTITY, :CITY_CODE); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->execute();
   addToLogFile("Purging finished",$logfile,$verbal);
}

sub gmmPurgeTbl {
   my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$systemDate,$table,$logfile,$verbal) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmPurgeTbl_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$systemDate,$table,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

sub gmmPurgeTbl_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$systemDate,$table,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   addToLogFile("Purging $table for ${legalEntity} ${tradingSystem} ${cityCode} keep <= ${systemDate}",$logfile,$verbal);
   my($aSql) = qq {
         delete 
         from $table
         where CITY_CODE      = '${cityCode}'      AND
               TRADING_SYSTEM = '${tradingSystem}' AND
               LEGAL_ENTITY   = '${legalEntity}'   AND
               SYSTEM_DATE    < to_date(${systemDate},'YYYYMMDD')
   };
   my($sth) = $dbh->prepare($aSql);
   $sth->execute();
   dbCommit($dbh);
   addToLogFile("Purging finished",$logfile,$verbal);
}


sub gmmPurgeMrsTables {
   my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmPurgeMrsTables_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

sub gmmPurgeMrsTables_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   gmmPurgeTables_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal,@gmmMrsTables);
}

sub gmmPurgeCpyTables {
   my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmPurgeCpyTables_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

sub gmmPurgeCpyTables_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   my @tables = (
       "GMM_COUNTERPARTY",
   );
   gmmPurgeTables_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal,@tables);
}


sub gmmPurgeRevalTable {
   my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmPurgeRevalTable_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

sub gmmPurgeRevalTable_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   my @tables = (
       "GMM_REVAL",
   );
   gmmPurgeTables_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal,@tables);
}

sub gmmPurgeTrdBooksTable {
   my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmPurgeTrdBooksTable_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

sub gmmPurgeTrdBooksTable_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   my @tables = (
       "GMM_TRADING_BOOKS",
   );
   gmmPurgeTables_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal,@tables);
}

sub gmmCurrencyTable {
   my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmCurrencyTable_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

sub gmmCurrencyTable_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal) = @_;
   my @tables = (
       "GMM_CURRENCY",
   );
   gmmPurgeTables_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal,@tables);
}


sub gmmPurgeTables {
   my ($database,$login,$password,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal,@tables) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmPurgeTables_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal,@tables);
   dbDisconnect($gmm_dbHandler);
}

sub gmmPurgeTables_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$keepDays,$logfile,$verbal,@tables) = @_;

   $verbal      = setDefault($verbal,$TRUE);
   $legalEntity = setDefault($legalEntity,"CSFB");
   my $tblStr   = makeStrFromArray(",",@tables);
   my @allDates = getUnionOfGmmSystemDatesFromProductTbl_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,@tables);
   ### displayArray(@allDates);
   my $countOfDates = @allDates;
   my $iDate = $countOfDates - $keepDays;
   if ($iDate >= 0) {
        my $systemDate = $allDates[$iDate];
        addToLogFile("Purging tables (${tblStr}) older than ${systemDate}. Keep ${keepDays} days!",$logfile,$verbal);
        my $aTblName   = "";
        foreach $aTblName (@tables) {
           gmmPurgeTbl_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$systemDate,$aTblName,$logfile,$verbal);
        }
   } else {
       addToLogFile("Tables (${tblStr}) already purged keeping ${keepDays} days",$logfile,$verbal);
   }
}

sub gmmDeleteFromTbl {
   my ($database,$login,$password,$cityCode,$tradingSystem,$systemDate,$table,$logfile,$verbal) = @_;
   my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
   gmmDeleteFromTbl_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$systemDate,$table,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

sub gmmDeleteFromTbl_dbh {
   my($dbh,$cityCode,$tradingSystem,$systemDate,$table,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   addToLogFile("   ---> Delete from $table where ${systemDate} and ${cityCode}/${tradingSystem}",$logfile,$verbal);
if(( $locationCode eq "ZH" and $table eq "GMM_REVAL") or ($locationCode eq "ZH" and $table eq "GMM_COUNTERPARTY")  or ($locationCode eq "ZH" and $table eq "GMM_RISK_EVENTS"))
{
$string2="GMMOWNER.";
$table1=$string2.$table;
$string1="_PAR_PK4";
$constrnt=$table.$string1;
my($aSql)    = qq{
            ALTER  TABLE $table1 DISABLE CONSTRAINT  $constrnt};
            my($sth) = $dbh->prepare($aSql);
             $sth->execute();
          addToLogFile("  Disabled Constraint",$logFile,$verbal);
my($aSql1)=qq{ ALTER TABLE  $table1  TRUNCATE PARTITION Q1_ZURICH DROP STORAGE};
my($s1th) = $dbh->prepare($aSql1);
        $s1th->execute();
           addToLogFile("  Truncated Partition",$logFile,$verbal);
my($aSql2)=qq { ALTER TABLE  $table1  ENABLE    CONSTRAINT   $constrnt};
my($s2th) = $dbh->prepare($aSql2);
             $s2th->execute();
          addToLogFile("  Enabled Constraint",$logFile,$verbal);
                 }
else 
{
   my($aSql) = qq {
        delete     from $table
    where SYSTEM_DATE= to_date(${systemDate},'YYYYMMDD') AND
            CITY_CODE  = '${cityCode}' AND
               TRADING_SYSTEM = '${tradingSystem}'
                };
my($sth) = $dbh->prepare($aSql);
   $sth->execute();
   addToLogFile("   ---> Deleting finished",$logfile,$verbal);
}
 
}



# Event processor
# ---------------
# 
## $action        = qq {
##       SetSytemDate(\"20000715\");
##       GetSytemDate();
##       SetSytemDate(\"20000805\");
##       GetSytemDate();
## };
## $action        = "CheckRTF_enabled();EnableRTF();CheckRTF_enabled();DisableRTF();CheckRTF_enabled()";
## $action        = "SetSytemDate(\"\");GetSytemDate();";
## $action        = "TestFunction(\"Hallo Walti\");";
sub processGmmEvent {
  my($gmmDbAbrev,$legalEntity,$tradingSystem,$cityCode,$logfile,$verbal,$actions) = @_;
  my($gmm_db,$gmm_login,$gmm_password) = getGmmDbLogin($gmmDbAbrev);
  addToLogFile("calling processGmmEvent(${gmmDbAbrev},${legalEntity},${tradingSystem},${cityCode}) ...",$logfile,$verbal);
  my($gmm_dbHandler) = dbConnect($gmm_db,$gmm_login,$gmm_password,$logfile,$verbal);

  $actions =~ s/\n/;/g;
  my(@actionList) = split(";",$actions);
  @actionList = trimAndRemoveEmptiesInArray(@actionList);

  my($singleAction) = "";
  foreach $singleAction (@actionList) {
    addToLogFile("Execute action:${singleAction}:",$logfile,$verbal);
    my($fctName) = refCallGetFunctionName($singleAction);
    my($parameterString) = refCallGetParameterStringFromCall($singleAction);
    my(@parameter) = parse_csv($parameterString);

    if ($fctName eq "SetSytemDate") {
       my($systemDate_param) = $parameter[0];
       if ($systemDate_param eq "") {
         $systemDate_param = getTimeStamp();
         $systemDate_param = substr($systemDate_param,0,8);
         addToLogFile("--> Set systemDate_param to TODAY:${systemDate_param}:",$logfile,$verbal);
       }
       setGmmSystemDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$systemDate_param,$logfile,$verbal);
       
    } elsif ($fctName eq "SetSytemDates") {
       my($lastTradingDate_param) = $parameter[0];
       my($systemDate_param)      = $parameter[1];
       my($nextTradingDate_param) = $parameter[2];
       my($lastEodDate_param)     = $parameter[3];
       if ($systemDate_param eq "") {
         $systemDate_param = getTimeStamp();
         $systemDate_param = substr($systemDate_param,0,8);
         addToLogFile("--> Set systemDate_param to TODAY:${systemDate_param}:",$logfile,$verbal);
       }
       setGmmSystemDates_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$lastTradingDate_param,$systemDate_param,$nextTradingDate_param,$lastEodDate_param,$logfile,$verbal);
       
    } elsif ($fctName eq "PurgeDbTable") {
       my($dbTableName)      = $parameter[0];
       my($sqlWhereClause)   = $parameter[1];
       deleteDbEntries_dbh($gmm_dbHandler,$dbTableName,$sqlWhereClause);
       
    } elsif ($fctName eq "GetSytemDate") {
       my($lastTradingDate) = getGmmLastTradingDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
       my($systemDate)      = getGmmSystemDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
       my($nextTradingDate) = getGmmNextTradingDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
       my($lastEodDate)     = getGmmLastEodDate_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
       addToLogFile("--> lastTradingDate :${lastTradingDate}:",$logfile,$verbal);
       addToLogFile("--> lastEodDate     :${lastEodDate}:",$logfile,$verbal);
       addToLogFile("--> systemDate      :${systemDate}:",$logfile,$verbal);
       addToLogFile("--> nextTradingDate :${nextTradingDate}:",$logfile,$verbal);

    } elsif ($fctName eq "DisableRTF") {
       setGmmRTF_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,"doDisable",$logfile,$verbal);
       
    } elsif ($fctName eq "EnableRTF") {
       setGmmRTF_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,"doEnable",$logfile,$verbal);
       
    } elsif ($fctName eq "ShutdownRTF") {
       setGmmRTF_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,"doShutdown",$logfile,$verbal);
       
    } elsif ($fctName eq "StartupRTF") {
       setGmmRTF_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,"doStartup",$logfile,$verbal);
       
    } elsif ($fctName eq "startGmmEod") {
       my $legalEntity   = $parameter[0];
       my $tradingSystem = $parameter[1];
       my $cityCode      = $parameter[2];
       gmmEod($gmm_dbHandler,$legalEntity,$tradingSystem,$cityCode,$gmmDbAbrev,$logfile,$verbal);

    } elsif ($fctName eq "startGmmPreEod") {
       my $legalEntity   = $parameter[0];
       my $tradingSystem = $parameter[1];
       my $cityCode      = $parameter[2];
       gmmPreEod($gmm_dbHandler,$legalEntity,$tradingSystem,$cityCode,$gmmDbAbrev,$logfile,$verbal);       
    } elsif ($fctName eq "CheckRTF_status") {
       my($rtfStatus) = getGmmRTF_status_dbh($gmm_dbHandler,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
       addToLogFile("--> rtfStatus:${rtfStatus}:",$logfile,$verbal);

    } else {
       addToLogFile("Calling function:${singleAction}:",$logfile,$verbal);
       callFunction($singleAction);
    }

  }
  dbDisconnect($gmm_dbHandler);
  addToLogFile("finished processGmmEvent(${gmmDbAbrev},${legalEntity},${tradingSystem},${cityCode}) ...",$logfile,$verbal);
}

# Event sender
# ------------
# 
## $action = qq { SetSytemDate("");
##                GetSytemDate(); };
## 
## $ownFct = qq {
## sub TestFunction {
##   my(\$str) = @_;
##   printf("str:\${str}\\n");
## }
## };
## 
## sendEventToGmm("CSFB","TIQ","NY",$FALSE,"",$action,$ownFct,$logfile,$verbal);
sub sendEventToGmm {
  my($legalEntity,$tradingSystem,$cityCode,$asBatchJob,$filePath,$actions,$ownFct,$logfile,$verbal) = @_;
  $asBatchJob = setDefault($asBatchJob,$FALSE);
  my($asBatchJobStr) = "";
  if ($asBatchJob) {
    $asBatchJobStr = "_Batch";
  }
  if (($filePath ne "") && (!($filePath =~ /\/$/))) {
      $filePath = "${filePath}/";
  }
  $actions =~ s/\"/\\"/g;
  my($eventFileName) = sprintf("EventFrom_%s_${cityCode}_${tradingSystem}${asBatchJobStr}.flt",getTimeStamp());
  my(%transList) = (
     "{ev_generatedAt}"   => sprintf("Generated by sendEventToGmm at %s",formatTimeStamp(getTimeStamp(),"US",$TRUE,$TRUE,$LangEnglish)),
     "{ev_myName}"        => $eventFileName,
     "{ev_legalEntity}"   => $legalEntity,
     "{ev_cityCode}"      => $cityCode,
     "{ev_tradingSystem}" => $tradingSystem,
     "{ev_action}"        => $actions,
     "{ev_ownFct}"        => $ownFct,
  );
  serializeTransTab("${filePath}${eventFileName}",%transList);
  return "${filePath}${eventFileName}";
}



# gmm EoD functions
# =================
sub gmmArchiveAndPurge {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,$deltaKeepDays) = @_;
   $deltaKeepDays    = setDefault($deltaKeepDays,"0");
    

   # Archiving and purging
   # ---------------------
   gmmArchiveProductsTbl_dbh     ($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
   gmmPurgeProductsHistoryTbl_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
   gmmPurgeMrsTables_dbh         ($dbh,$cityCode,$tradingSystem,$legalEntity,6 - $deltaKeepDays,$logfile,$verbal);
   gmmPurgeCpyTables_dbh         ($dbh,$cityCode,$tradingSystem,$legalEntity,2 - $deltaKeepDays,$logfile,$verbal);
   gmmPurgeRevalTable_dbh        ($dbh,$cityCode,$tradingSystem,$legalEntity,2 - $deltaKeepDays,$logfile,$verbal);
   gmmPurgeTrdBooksTable_dbh     ($dbh,$cityCode,$tradingSystem,$legalEntity,2 - $deltaKeepDays,$logfile,$verbal);
   gmmCurrencyTable_dbh          ($dbh,$cityCode,$tradingSystem,$legalEntity,2 - $deltaKeepDays,$logfile,$verbal);
 

   my(@otherTblToPurge) = (
     "GMM_EOD_PROCESS",
     "GMM_CALENDARS",
     "GMM_RISK_EVENTS",
   );
   gmmPurgeTables_dbh            ($dbh,$cityCode,$tradingSystem,$legalEntity,2 - $deltaKeepDays,$logfile,$verbal,@otherTblToPurge);

}

sub gmmEod_dbAbv {
   my($dbAbv,$cityCode,$dbPriv,$legalEntity,$tradingSystem,$logfile,$verbal) = @_;
   $dbPriv         = setDefault($dbPriv,"InsertUpdateDelete");
   $legalEntity    = setDefault($legalEntity,"CSFB");
   $tradingSystem  = setDefault($tradingSystem,"TIQ");
   $cityCode       = setDefault($cityCode,"NY");
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLogin($dbAbv,$dbPriv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);
   gmmEod($gmm_dbHandler,$legalEntity,$tradingSystem,$cityCode,$dbAbv,$logfile,$verbal);
   dbDisconnect($gmm_dbHandler);
}

 sub gmmEod {
   my($dbh,$legalEntity,$tradingSystem,$cityCode,$gmmDbAbrev,$logfile,$verbal) = @_;
   my $commandName = "";
   addToLogFile("--> gmmEod(${legalEntity},${tradingSystem},${cityCode},${gmmDbAbrev})...",$logfile,$verbal);


   # check if gmmPreEod is finished
   addToLogFile("Checking if gmmPreEod is finished",$logfile,$verbal);

   my $eodPart = "PRE";
   my $systemDate = ""; # default todays 

   my $finished = gmmIsEodPartFinished_dbh ($dbh, $cityCode,$tradingSystem, $eodPart, $systemDate, $logfile,$verbal);

   while ($finished ne $TRUE) {
 
     my %gmmArgs = gmmEodGetControlArgs($gmmDbAbrev,$cityCode);
     my $retryTimeOut = $gmmArgs{Arg8};
 
 
     $msg  = qq  {
       GmmEod started but PreEod is not finished !!!
       This process is going to wait specified time interval of $retryTimeOut seconds  and retry !!!
       Once preEod problem is resolved GmmEod will continue
       Check Logs and GMM_PROCESS_TABLE
       This message is automatically generated !!!
     };
 
 
     gmmEodReportError ($msg, $gmmDbAbbrev, $cityCode,$tradingSystem, $logfile,$verbal);
 
     addToLogFile($msg ,$logfile,$verbal);
     sleep ($retryTimeOut);
 
     $finished = gmmIsEodPartFinished_dbh ($dbh, $cityCode,$tradingSystem, $eodPart, $systemDate, $logfile,$verbal);
   }

   my @preEodJobs  = getListOfJobsToRunBeforeGmmEod($gmmDbAbrev,$cityCode);
   my @PostEodJobs = getListOfJobsToRunAfterGmmEod($gmmDbAbrev,$cityCode);
   if (!(foundInArray("ArchiveAndPurge",@preEodJobs))) {
     gmmArchiveAndPurge($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,0);
   }

   # call FAS Update
   # ---------------
   fasEod_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
   updateFasLinkGrpDeals_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);
   updateFasLinkGrp_dbh     ($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);

   # calling after eod programms 


   foreach $commandName (@PostEodJobs) {
     if ($commandName eq "ArchiveAndPurge") {
        addToLogFile("ArchiveAndPurge already done",$logfile,$verbal);
     } else {
        if (isUNIX_CommandExist($command)) {
           my $systemCall = "${commandName} ${cityCode} ${gmmDbAbrev} ${tradingSystem}";
           addToLogFile("----> Starting: ${systemCall}",$logfile,$verbal);
           $msg = `${systemCall} 2>&1`;
           addToLogFile("----> Ending  : ${systemCall}",$logfile,$verbal);
           addToLogFile("----> Ending  (retVal) : ${msg}",$logfile,$verbal);
        } else {
           addToLogFile("ERROR: Command not found (${command})",$logfile,$verbal);
        }
     }
   }
   addToLogFile("--> gmmEod(${legalEntity},${tradingSystem},${cityCode},${gmmDbAbrev}) ending",$logfile,$verbal);
}

sub gmmPreEod {
  my($dbh,$legalEntity,$tradingSystem,$cityCode,$gmmDbAbrev,$logfile,$verbal) = @_;
  my $commandName = "";
  addToLogFile("--> gmmPreEod(${legalEntity},${tradingSystem},${cityCode},${gmmDbAbrev})",$logfile,$verbal);

  my @preEodJobs = getListOfJobsToRunBeforeGmmEod($gmmDbAbrev,$cityCode);

  foreach $commandName (@preEodJobs) {
     if ($commandName eq "ArchiveAndPurge") {
        addToLogFile("----> Starting:ArchiveAndPurge",$logfile,$verbal);
        gmmArchiveAndPurge($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal,1);
        addToLogFile("----> Ending  :ArchiveAndPurge",$logfile,$verbal);
     } else {
        if (isUNIX_CommandExist($command)) {
           my $systemCall = "${commandName} ${cityCode} ${gmmDbAbrev} ${tradingSystem}";
           addToLogFile("----> Starting: ${systemCall}",$logfile,$verbal);
           $msg = `${systemCall} 2>&1`;
           addToLogFile("----> Ending  : ${systemCall}",$logfile,$verbal);
           addToLogFile("----> Ending  (retVal) : ${msg}",$logfile,$verbal);
        } else {
           addToLogFile("ERROR: Command not found (${command})",$logfile,$verbal);
        }
     } 
  }
}

sub getListOfJobsToRunAfterGmmEod {
   my ($gmmDbAbrev,$cityCode) = @_;
   my (@PostEodjobs) = getListOfJobsToRunBeforeOrAfterGmmEod($gmmDbAbrev,$cityCode,"POST");
   return @PostEodjobs;
}
 
sub getListOfJobsToRunBeforeGmmEod {
  my ($gmmDbAbrev,$cityCode) = @_;
  my (@PreEodjobs) = getListOfJobsToRunBeforeOrAfterGmmEod($gmmDbAbrev,$cityCode,"PRE");
  return @PreEodjobs; 
}

sub getListOfJobsToRunBeforeOrAfterGmmEod {
  my ($gmmDbAbbrev,$cityCode, $mode) = @_;
  my (@jobs) = ();
  my %APP_INFO= gmmEodGetControlArgs($gmmDbAbbrev,$cityCode);
  if ($mode eq "POST") {
      @jobs = setListFromCommonControl($APP_INFO{Arg6});
  } elsif ($mode eq "PRE") {
      @jobs = setListFromCommonControl($APP_INFO{Arg7});
  }
  return @jobs;
}



sub setGmmEodProcessStartTime {
  my  ($database,$login,$password,$cityCode,$tradingSystem,$processName, $type, $systemDate, $logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) =  setGmmEodProcessStartTime_dbh ($gmm_dbHandler,$cityCode,$tradingSystem,$processName, $type, $systemDate,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
 
 
}
 
sub setGmmEodProcessStartTime_dbh {
  my ($dbh, $cityCode,$tradingSystem,$processName, $type, $systemDate, $logfile,$verbal) = @_;
 
  my  $sql = qq { insert into GMM_EOD_PROCESS
              (SYSTEM_DATE,TRADING_SYSTEM ,CITY_CODE, LEGAL_ENTITY, PROCESS_NAME,TYPE, START_TIME )
              values(to_date ($systemDate,\'YYYYMMDD\'),\'$tradingSystem\',\'$cityCode\',\'CSFB\',\'$processName\',\'$type\', sysdate)
  };
  sqlExecute_dbh($sql,$dbh);
}

sub setGmmEodProcessFinishTime {
  my  ($database,$login,$password,$cityCode,$tradingSystem,$processName, $type, $systemDate, $logfile,$verbal) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) =  setGmmEodProcessFinishTime_dbh ($gmm_dbHandler,$cityCode,$tradingSystem,$processName, $type, $systemDate,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
 
 
}
 
sub setGmmEodProcessFinishTime_dbh {
  my ($dbh, $cityCode,$tradingSystem,$processName, $type, $systemDate, $logfile,$verbal) = @_;
 
  my  $sql = qq { update GMM_EOD_PROCESS
              set FINISH_TIME=sysdate
              where
              to_char (SYSTEM_DATE,\'YYYYMMDD\')= \'$systemDate\'
               AND TRADING_SYSTEM=\'$tradingSystem\'
               AND CITY_CODE = \'$cityCode\'
               AND PROCESS_NAME =\'$processName\'
               AND TYPE =\'$type\'
               AND LEGAL_ENTITY = \'CSFB\'
 
  };
  sqlExecute_dbh($sql,$dbh);
}
sub gmmIsEodPartFinished {
   my ($database,$login,$password,$cityCode,$tradingSystem, $eodPart, $systemDate,  $logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
  my($gmm_dbHandler) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) =  gmmIsEodPartFinished_dbh ($gmm_dbHandler,$cityCode,$tradingSystem, $eodPart, $systemDate,$logfile,$verbal);
  dbDisconnect($gmm_dbHandler);
  return $retVal;
 
}

sub doTest_gmmEodProcessAccess {
   my($myFullName,$debugThisFct,$dbAbv,$dbPriv) = @_;
   $dbAbv          = setDefault($dbAbv,"NY_GMM");
   $dbPriv         = setDefault($dbPriv,"InsertUpdateDelete");
   $debugThisFct   = setDefault($debugThisFct,$FALSE);

   if ($debugThisFct) {
     my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLogin($dbAbv,$dbPriv);
     my($gmm_dbHandler) = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);
   

     setGmmEodProcessStartTime_dbh($gmm_dbHandler, "ZH","TIQ","TEST_CASE", "TEST", "19600805", $logfile,$verbal);
     if (gmmIsEodPartFinished_dbh($gmm_dbHandler, "ZH","TIQ", "TEST", "19600805", $logfile,$verbal)) {
       print("Some EodPart for TEST are not finished. That is an ERROR!!!!!!\n");
     }
     setGmmEodProcessFinishTime_dbh($gmm_dbHandler, "ZH","TIQ","TEST_CASE","TEST", "19600805", $logfile,$verbal);
     if (gmmIsEodPartFinished_dbh($gmm_dbHandler, "ZH","TIQ", "TEST", "19600805", $logfile,$verbal)) {
       print("Some EodPart for TEST are not finished. that is o.k.\n");
     }

     dbDisconnect($gmm_dbHandler);
   }
}

sub gmmIsEodPartFinished_dbh {
  my ($dbh, $cityCode,$tradingSystem, $eodPart, $systemDate, $logfile,$verbal) = @_;

  if ($systemDate eq "") {
    $systemDate = getGmmSystemDate_dbh($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal);

  }
 
  my $sql = qq { select count (PROCESS_NAME) NUMBER_OF_UNFINISHED
                 from GMM_EOD_PROCESS
                 where FINISH_TIME is null
                       AND TYPE = '$eodPart'
                       AND TRADING_SYSTEM=\'$tradingSystem\'
                       AND CITY_CODE = \'$cityCode\'
                       AND to_char (SYSTEM_DATE,\'YYYYMMDD\')= \'$systemDate\'
                       AND LEGAL_ENTITY = \'CSFB\'
 
    };
 
 
  my $sth = $dbh->prepare($sql);
  my  @records = dbExecutePreparedSelectSttmnt($sth);
  my $record = $records[0];
  my $numberOfUnfinishedProcesses = $record->{NUMBER_OF_UNFINISHED};
 
 
  if ($numberOfUnfinishedProcesses  > 0) {
    return $FALSE;
  } else {
     return $TRUE;
  }
 
 
}

# FAS functions
# =============
sub fasEod_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   addToLogFile("FAS Eod for ${legalEntity} ${tradingSystem} ${cityCode} ",$logfile,$verbal);
   addToLogFile("   ---> Call stored procedure:fas_eod",$logfile,$verbal);
   my($sth)    = $dbh->prepare("BEGIN fas_eod_pkg.fas_eod(:CITY_CODE, :TRADING_SYSTEM, :LEGAL_ENTITY); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->execute();

   addToLogFile("   ---> Call stored procedure:UpdateDealValue",$logfile,$verbal);
   $sth = $dbh->prepare("BEGIN fas_link_grp_deals_update_pkg.UpdateDealValue(:CITY_CODE, :TRADING_SYSTEM, :LEGAL_ENTITY); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->execute();

   addToLogFile("FAS Eod finished",$logfile,$verbal);
}

sub updateFasLinkGrpDeals_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   addToLogFile("Updating FAS linkGroupDeals for ${legalEntity} ${tradingSystem} ${cityCode} ",$logfile,$verbal);
   my($sth)    = $dbh->prepare("BEGIN fas_link_grp_deals_update_pkg.fas_link_grp_deals_update(:CITY_CODE, :TRADING_SYSTEM, :LEGAL_ENTITY); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->bind_param(":LEGAL_ENTITY",   $legalEntity);
   $sth->execute();
   addToLogFile("Updating FAS finished",$logfile,$verbal);
}

sub updateFasLinkGrp_dbh {
   my($dbh,$cityCode,$tradingSystem,$legalEntity,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);
   $legalEntity= setDefault($legalEntity,"CSFB");
   addToLogFile("Updating FAS linkGroup for ${legalEntity} ${tradingSystem} ${cityCode} ",$logfile,$verbal);
   my($sth)    = $dbh->prepare("BEGIN fas_link_grp_update_pkg.fas_link_grp_update(:CITY_CODE, :TRADING_SYSTEM); END;");
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":TRADING_SYSTEM", $tradingSystem);
   $sth->execute();
   addToLogFile("Updating FAS linkGroup finished",$logfile,$verbal);
}

sub updateFAS_Tables {
   my($dbh,$cityCode,$tradingSystem,$dealType,$dealNumber,$dealState,$event,$logFile,$verbal) = @_;
   my($procString) = "BEGIN :retVal := fas_upload_pkg.fas_update_deal(:trdSystem, :cityCode, :dealType, :dealNumber, :dealState, :event); END;";
   ### my($procString) = "BEGIN :retVal := fas_upload_pkg.fas_update_deal(:trdSystem, :cityCode, :dealType, :dealNumber); END;";
   addToLogFile("Call Stored-Procedure: (${procString})",$logFile,$verbal);
   addToLogFile("      Parameters: cityCode   :${cityCode}:"      ,$logFile,$verbal);
   addToLogFile("                  trdSystem  :${tradingSystem}:" ,$logFile,$verbal);
   addToLogFile("                  dealType   :${dealType}:"      ,$logFile,$verbal);
   addToLogFile("                  dealNumber :${dealNumber}:"    ,$logFile,$verbal);
   addToLogFile("                  dealState  :${dealState}:"     ,$logFile,$verbal);
   addToLogFile("                  event      :${event}:"         ,$logFile,$verbal);


   my($sth) = $dbh->prepare($procString);
   if ($DBI::err) {
     addToLogFile("ERROR in updateFAS: Failed to prepare ${procString}",$logFile,$TRUE);
   }
   addToLogFile("Executinging....",$logFileName,$verbal);
   $sth->bind_param(":cityCode"   ,$cityCode);
   $sth->bind_param(":trdSystem"  ,$tradingSystem);
   $sth->bind_param(":dealType"   ,$dealType);
   $sth->bind_param(":dealNumber" ,$dealNumber);
   $sth->bind_param(":dealState"  ,$dealState);
   $sth->bind_param(":event"      ,$event);
   my($retVal)  = "";
   $sth->bind_param_inout(":retVal" ,\$retVal, 100);

   $sth->execute();
   if ($DBI::err) {
      addToLogFile("ERROR in updateFAS: Failed to execute ${procString}",$logFile,$TRUE);
      addToLogFile("      Parameters: cityCode   :${cityCode}:"      ,$logFile,$TRUE);
      addToLogFile("                  trdSystem  :${tradingSystem}:" ,$logFile,$TRUE);
      addToLogFile("                  dealType   :${dealType}:"      ,$logFile,$TRUE);
      addToLogFile("                  dealNumber :${dealNumber}:"    ,$logFile,$TRUE);
      addToLogFile("                  dealState  :${dealState}:"     ,$logFile,$TRUE);
      addToLogFile("                  event      :${event}:"         ,$logFile,$TRUE);
   }
   return $retVal;
}



# returns arguments set for gmm from commonControl
sub gmmEodGetControlArgs {
  my ($gmmDbAbbrev,$cityCode) = @_;

  getCommonControlViaHttpGetForZH_nodes($commonControlUrl,$commonControlFile,$httpGetCommonControlSupport,"WARNING: ${myOnlyName} in ${gmmEodGetControlArgs} / ${gmmDbAbbrev} / ${locationCode} / ${startUpWith} / ${envLocation}",$logFileName,$FALSE);

  my $commonControlFile = "$ENV{RunS}/Common/Control/commonControl.flt";
  if (!(isFileExists($commonControlFile))) {
     $commonControlFile = $ENV{CSG_COMMON_CONTROL_DIR}."/commonControl.flt";
  }
  my $entryName = "gmmgdbNewArrivals";
 
  my %APP_INFO= getSingleRecInHash($commonControlFile,"\\|","","AppName=${entryName}:${gmmDbAbbrev} AND LocationCode=${cityCode}","","");

  return %APP_INFO; 
}

sub gmmEodReportError {
  my ($msg, $gmmDbAbbrev, $cityCode,$tradingSystem, $logfile,$verbal ) = @_;

  $verbal = $verbal || $TRUE;

  my %GmmArgs =  gmmEodGetControlArgs ($gmmDbAbbrev,$cityCode);
  
  my $notifyEmailAdr = $GmmArgs {notifyEmailAdr};

 
  my $doSendMail  =  $GmmArgs {"SendData"}; 


  if (uc($doSendMail) eq "YES") {
     addToLogFile("Sending E-mail to $notifyEmailAdr",$logfile,$verbal);

     $subject = "GMM EOD PROBLEM !!! ";
     sendMailwithAttachments($fromAdr,$notifyEmailAdr,$subject,$msg);

  } else {
    addToLogFile("E-mail disabled",$logfile,$verbal);
  }

  

}

# adds header to the file
#<FileInfo>:RecCount->200;Produced->2001102556; .......  other fields</FileInfo>;
#
sub addGmmFileInfoHeader {
  my($fileName, $infoFieldsHashRef, $optionalFieldOrderRef, $tmpFileName) = @_;
 
  my (@fieldOrder) = @$optionalFieldOrderRef;
  my (%infoFileds) = %$infoFieldsHashRef;
 
  my $infoHeader = "#<FileInfo>";
 
 
  if ($tmpFileName eq "") {
    $tmpFilePath = getPathNameOutOfFullName ($fileName);
    $tmpFileNameShort = getFileNameOutOfFullName($fileName) . "_gmmfileinfoTMP";
 
    if ($tmpFilePath eq "") {
      $tmpFileName = $tmpFileNameShort;
    } else {
      $tmpFileName = sprintf("%s/%s", $tmpFilePath, $tmpFileNameShort);
    }
  }
 
  open (OUTPUT, "> $tmpFileName ") || die "can't open file: $tmpFileName $!\n";
 
  if( $#fieldOrder != -1) {
     foreach $field (@fieldOrder) {
       $infoHeader = $infoHeader . $field . "->" . $infoFileds{$field} . ";";
       delete ($infoFileds{$field});
     }
  }
 
 
  # all other fields
  foreach $field (sort keys %infoFileds) {
     $infoHeader = $infoHeader . $field . "->" . $infoFileds{$field} . ";";
  }
 
  $infoHeader = $infoHeader . "</FileInfo>" ;
 
  print OUTPUT "${infoHeader}\n";
  close(OUTPUT);
 
  system("cat $fileName >> $tmpFileName");
  system("mv  $tmpFileName $fileName");
 
}

sub getGmmFileInfoHeader {
  my ($fileName) = @_;
  my (@infoLines) = `grep \"<FileInfo>\" $fileName`;
  my ($infoLine) = $infoLines[0];
 
  my %fileInfoHash = ();
 
  $infoLine =~ s/#//g;
  $infoLine =~ s/<FileInfo>//g;
  $infoLine =~ s/<\/FileInfo>//g;
  $infoLine = strip ($infoLine);
 
  my (@fieldsKeyValuePairs) = split (";",$infoLine);
 
  foreach $pair (@fieldsKeyValuePairs) {
    @splitpair = split ("->", $pair);
    $fileInfoHash{$splitpair[0]}=$splitpair[1];
  }
 
  return %fileInfoHash;
 
 
}

sub getGmmTableRecCount_dbh {
  my ($gmm_dbHandler,$table,$city,$tradingSystem, $systemDate, $logfile,$verbal) = @_;

  my $sql = qq {
    select count (*) REC_COUNT 
    from  $table
    where Trading_System = '$tradingSystem' AND 
          City_Code='$city' AND 
          System_Date = to_date($systemDate, 'YYYYMMDD') 
  };

  if ((uc($table) eq "TERM") || 
      (uc($table) eq "CALL") || 
      (uc($table) eq "REPO") || 
      (uc($table) eq "SECURITY")) {
      
       my $branchCode = getBranchCode_CityShortName($city);
       $sql = qq {
         select count (*) REC_COUNT 
         from  $table
         where Branch   ='$branchCode' AND 
               Sys_Date = to_date($systemDate, 'YYYYMMDD') 
       };

  }

  addToLogFile (" sql  $sql ",$logfile,$verbal);

  my($prepared) = $gmm_dbHandler->prepare($sql);
  @result     = dbExecutePreparedSelectSttmnt($prepared);
 
 
  return @result[0]->{REC_COUNT} ;
}


# -------------------------
# appcSendHeartBeat
# -------------------------
sub appcSendHeartBeat_dbh {
   my ($dbh, $node, $locInstance, $location, $applicationGroup, $applicationName, $logfile, $verbal) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($cityCode,$locationCode),"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");
   
   my $retVal = "";
### printf("Calling appcSendHeartBeat_dbh...\n");
### printf("node:${node}:\n");
### printf("locInstance:${locInstance}:\n");
### printf("cityCode:${cityCode}:\n");
### printf("applicationGroup:${applicationGroup}:\n");
### printf("applicationName:${applicationName}:\n");



   # inserts/updates for $key 
   my $sth = $dbh->prepare("BEGIN gmm_application_control_pkg.setTimeStamp(:NODE_NAME, :INSTANCE, :CITY_CODE, :APP_GROUP, :APP_NAME); END;")
          ||  ($retVal = "Failed to Prepare Sttmnt:  $DBI::errstr");
   $sth->bind_param(":NODE_NAME",      $node);
   $sth->bind_param(":INSTANCE",       $locInstance);
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":APP_GROUP",      $applicationGroup);
   $sth->bind_param(":APP_NAME",       $applicationName);
   $sth->execute()
          ||  ($retVal = "${retVal} Failed to Execute Sttmnt:  $DBI::errstr");

   if ($retVal ne "") {
     addToLogFile("ERROR: ${retVal}Failed to Execute Sttmnt:  $DBI::errstr", $LogFile, $verbal)  ;
   }
   return $retVal;
}

sub appcSendHeartBeat_dbAbv {
   my($dbAbv, $dbPriv, $node, $instance, $location, $applicationGroup, $applicationName, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   my $retVal = appcSendHeartBeat_dbh($gmm_dbHandler, $node, $instance, $location, $applicationGroup, $applicationName, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
   return $retVal;
}

# -------------------------
# appcDeleteHeartBeat
# -------------------------
sub appcDeleteHeartBeat_dbh {
   my ($dbh, $node, $locInstance, $location, $applicationGroup, $applicationName, $logfile, $verbal) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($cityCode,$locationCode),"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");

# printf("Calling appcSendHeartBeat_dbh...\n");
# printf("node:${node}:\n");
# printf("locInstance:${locInstance}:\n");
# printf("cityCode:${cityCode}:\n");
# printf("applicationGroup:${applicationGroup}:\n");
# printf("applicationName:${applicationName}:\n");



   # inserts/updates for $key 
   my $sth = $dbh->prepare("BEGIN gmm_application_control_pkg.deleteTimeStamp(:NODE_NAME, :INSTANCE, :CITY_CODE, :APP_GROUP, :APP_NAME); END;");
   $sth->bind_param(":NODE_NAME",      $node);
   $sth->bind_param(":INSTANCE",       $locInstance);
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":APP_GROUP",      $applicationGroup);
   $sth->bind_param(":APP_NAME",       $applicationName);
   $sth->execute();
}

sub appcDeleteHeartBeat_dbAbv {
   my($dbAbv, $dbPriv, $node, $instance, $location, $applicationGroup, $applicationName, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   appcDeleteHeartBeat_dbh($gmm_dbHandler, $node, $instance, $location, $applicationGroup, $applicationName, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
}

# -------------------------
# appcGetLastHeartBeat
# -------------------------
sub appcGetLastHeartBeat_dbh {
   my ($dbh, $node, $locInstance, $location, $applicationGroup, $applicationName, $logfile, $verbal) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($cityCode,$locationCode),"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");

   my $retVal = "";
   my(@queryResultRef) = ();
   my $aSql = qq {
         select to_char(LAST_HEART_BEAT,'YYYYMMDDHH24MISS') LAST_HEART_BEAT
         from GMM_APPLICATION_CONTROL
         where NODE_NAME           = '${node}' AND
               INSTANCE            = '${locInstance}' AND
               CITY_CODE           = '${cityCode}' AND
               APPLICATION_GROUP   = '${applicationGroup}' AND
               APPLICATION_NAME    = '${applicationName}'
   };

   my $sth = $dbh->prepare($aSql);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($aHandlerRef) = "";
   foreach $aHandlerRef (@queryResultRef) {
      $retVal = $aHandlerRef->{LAST_HEART_BEAT};
   }
   return $retVal;
}

sub appcGetLastHeartBeat_dbAbv {
   my($dbAbv, $dbPriv, $node, $locInstance, $location, $applicationGroup, $applicationName, $logfile, $verbal) = @_;
   my $retVal = "";
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   $retVal = appcGetLastHeartBeat_dbh($gmm_dbHandler, $node, $locInstance, $location, $applicationGroup, $applicationName, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
   return $retVal;
}

# -------------------------
# appcStatusUpdate
# -------------------------
sub appcStatusUpdate_dbh {
   my ($dbh, $node, $instance, $location, $applicationGroup, $applicationName, $statusMsg) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($cityCode,$locationCode),"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");

   # inserts/updates for $key 
   my $sth = $dbh->prepare("BEGIN gmm_application_control_pkg.updateStatus(:NODE_NAME, :INSTANCE, :CITY_CODE, :APP_GROUP, :APP_NAME, :NEW_STAT); END;");
   $sth->bind_param(":NODE_NAME",      $node);
   $sth->bind_param(":INSTANCE",       $locInstance);
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":APP_GROUP",      $applicationGroup);
   $sth->bind_param(":APP_NAME",       $applicationName);
   $sth->bind_param(":NEW_STAT",       $statusMsg);
   $sth->execute();
}

sub appcStatusUpdate_dbAbv {
   my($dbAbv, $dbPriv, $node, $instance, $location, $applicationGroup, $applicationName, $statusMsg, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   appcStatusUpdate_dbh($gmm_dbHandler, $node, $instance, $location, $applicationGroup, $applicationName, $statusMsg, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
}


# -------------------------
# appcExceptionStatusUpdate
# -------------------------
sub appcExceptionStatusUpdate_dbh {
   my ($dbh, $node, $instance, $location, $applicationGroup, $applicationName, $statusMsg) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($cityCode,$locationCode),"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");

   # inserts/updates for $key 
   my $sth = $dbh->prepare("BEGIN gmm_application_control_pkg.updateExceptionStatus(:NODE_NAME, :INSTANCE, :CITY_CODE, :APP_GROUP, :APP_NAME, :NEW_STAT); END;");
   $sth->bind_param(":NODE_NAME",      $node);
   $sth->bind_param(":INSTANCE",       $locInstance);
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":APP_GROUP",      $applicationGroup);
   $sth->bind_param(":APP_NAME",       $applicationName);
   $sth->bind_param(":NEW_STAT",       $statusMsg);
   $sth->execute();
}

sub appcExceptionStatusUpdate_dbAbv {
   my($dbAbv, $dbPriv, $node, $instance, $location, $applicationGroup, $applicationName, $statusMsg, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   appcExceptionStatusUpdate_dbh($gmm_dbHandler, $node, $instance, $location, $applicationGroup, $applicationName, $statusMsg, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
}

# -------------------------
# appcUpdateAlarmSent
# -------------------------
sub appcUpdateAlarmSent_dbh {
   my ($dbh, $node, $locInstance, $cityCode, $applicationGroup, $applicationName, $newVal) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault($locInstance,"NotDef");
   $cityCode             = setDefault($cityCode,"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");


   # inserts/updates for $key 
   my $sth = $dbh->prepare("BEGIN gmm_application_control_pkg.updateAlarmSent(:NODE_NAME, :INSTANCE, :CITY_CODE, :APP_GROUP, :APP_NAME, :NEW_VAL); END;");
   $sth->bind_param(":NODE_NAME",      $node);
   $sth->bind_param(":INSTANCE",       $locInstance);
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":APP_GROUP",      $applicationGroup);
   $sth->bind_param(":APP_NAME",       $applicationName);
   $sth->bind_param(":NEW_VAL",        $newVal);
   $sth->execute();
}

sub appcUpdateAlarmSent_dbAbv {
   my($dbAbv, $dbPriv, $node, $instance, $location, $applicationGroup, $applicationName, $newVal, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   appcUpdateAlarmSent_dbh($gmm_dbHandler, $node, $instance, $location, $applicationGroup, $applicationName, $newVal, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
}

# -------------------------
# appcInitStatus
# -------------------------
sub appcInitStatus_dbh {
   my ($dbh, $node, $instance, $location, $applicationGroup, $applicationName, $initMsg) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($cityCode,$locationCode),"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");
   $initMsg              = setDefault($initMsg,"");

   # inserts/updates for $key 
   my $sth = $dbh->prepare("BEGIN gmm_application_control_pkg.initStatus(:NODE_NAME, :INSTANCE, :CITY_CODE, :APP_GROUP, :APP_NAME, :INIT_MSG); END;");
   $sth->bind_param(":NODE_NAME",      $node);
   $sth->bind_param(":INSTANCE",       $locInstance);
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":APP_GROUP",      $applicationGroup);
   $sth->bind_param(":APP_NAME",       $applicationName);
   $sth->bind_param(":INIT_MSG",       $initMsg);
   $sth->execute();
}

sub appcInitStatus_dbAbv {
   my($dbAbv, $dbPriv, $node, $instance, $location, $applicationGroup, $applicationName, $initMsg, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   appcInitStatus_dbh($gmm_dbHandler, $node, $instance, $location, $applicationGroup, $applicationName, $initMsg, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
}

# -------------------------
# appcInitExceptionStatus
# -------------------------
sub appcInitExceptionStatus_dbh {
   my ($dbh, $node, $instance, $location, $applicationGroup, $applicationName, $initMsg) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($cityCode,$locationCode),"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");
   $initMsg              = setDefault($initMsg,"");
   ### print("node:${node}: instance:${instance}: location:${location}: applicationGroup:${applicationGroup}: applicationName:${applicationName}:\n");

   # inserts/updates for $key 
   my $sth = $dbh->prepare("BEGIN gmm_application_control_pkg.initExceptionStatus(:NODE_NAME, :INSTANCE, :CITY_CODE, :APP_GROUP, :APP_NAME, :INIT_MSG); END;");
   $sth->bind_param(":NODE_NAME",      $node);
   $sth->bind_param(":INSTANCE",       $locInstance);
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":APP_GROUP",      $applicationGroup);
   $sth->bind_param(":APP_NAME",       $applicationName);
   $sth->bind_param(":INIT_MSG",       $initMsg);
   $sth->execute();
}

sub appcInitExceptionStatus_dbAbv {
   my($dbAbv, $dbPriv, $node, $instance, $location, $applicationGroup, $applicationName, $initMsg, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   ### print("gmm_db_1:${gmm_db_1}: gmm_login_1:${gmm_login_1}: gmm_password_1:${gmm_password_1}:\n");
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$TRUE);

   appcInitExceptionStatus_dbh($gmm_dbHandler, $node, $instance, $location, $applicationGroup, $applicationName, $initMsg, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
}

# -------------------------
# appcGetField
# -------------------------
sub appcGetField_dbh {
   my ($dbh, $node, $locInstance, $location, $applicationGroup, $applicationName, $dbFieldName, $logfile, $verbal) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($location,$locationCode),"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");

   if ($dbFieldName eq "") { return ""; }

   my $retVal = "";
   my(@queryResultRef) = ();
   my $aSql = qq {
         select ${dbFieldName} A_VALUE
         from GMM_APPLICATION_CONTROL
         where NODE_NAME           = '${node}' AND
               INSTANCE            = '${locInstance}' AND
               CITY_CODE           = '${cityCode}' AND
               APPLICATION_GROUP   = '${applicationGroup}' AND
               APPLICATION_NAME    = '${applicationName}'
   };

   my $sth = $dbh->prepare($aSql);
   @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
   my($aHandlerRef) = "";
   foreach $aHandlerRef (@queryResultRef) {
      $retVal = $aHandlerRef->{A_VALUE};
   }
   return $retVal;
}

sub appcGetField_dbAbv {
   my($dbAbv, $dbPriv, $node, $instance, $location, $applicationGroup, $applicationName, $dbFieldName, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);
   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   my $retVal = appcGetField_dbh($gmm_dbHandler, $node, $instance, $location, $applicationGroup, $applicationName, $dbFieldName, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
   return $retVal;
}


# -------------------------
# appcGetAppCount
# -------------------------
sub appcGetAppCount_dbh {
   my ($dbh, $node, $instance, $location, $applicationGroup, $applicationName) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($cityCode,$locationCode),"NotDef");
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");

   # inserts/updates for $key 
   my $sth = $dbh->prepare("BEGIN :retVal := gmm_application_control_pkg.getRowsForAppKey(:NODE_NAME, :INSTANCE, :CITY_CODE, :APP_GROUP, :APP_NAME); END;");
   $sth->bind_param(":NODE_NAME",      $node);
   $sth->bind_param(":INSTANCE",       $locInstance);
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":APP_GROUP",      $applicationGroup);
   $sth->bind_param(":APP_NAME",       $applicationName);
   my $retVal = "";
   $sth->bind_param_inout(":retVal" ,\$retVal, 100);
   $sth->execute();
   return $retVal;
}


sub appcGetAppCount_dbAbv {
   my($dbAbv, $dbPriv, $node, $instance, $location, $applicationGroup, $applicationName, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);

   ## printf("dbAbv         :${dbAbv}:\n");
   ## printf("dbPriv        :${dbPriv}:\n");
   ## printf("gmm_db_1      :${gmm_db_1}:\n");
   ## printf("gmm_login_1   :${gmm_login_1}:\n");
   ## printf("gmm_password_1:${gmm_password_1}:\n");

   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   my $retVal = appcGetAppCount_dbh($gmm_dbHandler, $node, $instance, $location, $applicationGroup, $applicationName, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
   return $retVal;
}


# -------------------------
# appcUpdateFieldsForAnApplication
# -------------------------
sub appcUpdateFieldsForAnApplication_dbh {
   my ($dbh, $node,$instance,$location,$applicationGroup,$applicationName,$lastHeartBeat,$lastStatus,$statusHistory,$expectedStartTime,$expectedEndTime,
       $exceptionStatus,$alarmList1,$alarmList2,$alarmSent,$problemOwner,$comments,$lastModBy,$lastModAt) = @_;
   $verbal               = setDefault($verbal,$TRUE);
   $node                 = setDefault($node,getMyUnixHostname());
   $locInstance          = setDefault(setDefault($locInstance,$instance),"NotDef");
   $cityCode             = setDefault(setDefault($location,$cityCode),"NotDef");   # beide Variablen getauscht. Web-tool hat nicht funktioniert 20030321
   $applicationGroup     = setDefault($applicationGroup,"NotDef");
   $applicationName      = setDefault($applicationName,"NotDef");

# printf("applicationName   :${applicationName}:<BR>\n");
# printf("lastHeartBeat     :${lastHeartBeat}:<BR>\n");
# printf("lastStatus        :${lastStatus}:<BR>\n");
# printf("statusHistory     :${statusHistory}:<BR>\n");
# printf("expectedStartTime :${expectedStartTime}:<BR>\n");
# printf("expectedEndTime   :${expectedEndTime}:<BR>\n");
# printf("exceptionStatus   :${exceptionStatus}:<BR>\n");
# printf("alarmList1        :${alarmList1}:<BR>\n");
# printf("alarmList2        :${alarmList2}:<BR>\n");
# printf("alarmSent         :${alarmSent}:<BR>\n");
# printf("problemOwner      :${problemOwner}:<BR>\n");
# printf("comments          :${comments}:<BR>\n");
# printf("lastModBy         :${lastModBy}:<BR>\n");
# printf("lastModAt         :${lastModAt}:<BR>\n");

   # inserts/updates for $key 
   my $sth = $dbh->prepare("BEGIN gmm_application_control_pkg.updateFieldsForAnApplication(:NODE_NAME, :INSTANCE, :CITY_CODE, :APP_GROUP, :APP_NAME, :LAST_HEART_BEAT, :LAST_STATUS, :STAT_HIST, :EXP_START, :EXP_END, :EXCEPT_STAT, :ALRAM1, :ALARM2, :ALARMSENT, :PROBLEM_OWNER, :COMMENTS, :LAST_MOD_BY, :LAST_MOD_AT); END;");
   $sth->bind_param(":NODE_NAME",      $node);
   $sth->bind_param(":INSTANCE",       $locInstance);
   $sth->bind_param(":CITY_CODE",      $cityCode);
   $sth->bind_param(":APP_GROUP",      $applicationGroup);
   $sth->bind_param(":APP_NAME",       $applicationName);
   $sth->bind_param(":LAST_HEART_BEAT",$lastHeartBeat);
   $sth->bind_param(":LAST_STATUS",    $lastStatus);
   $sth->bind_param(":STAT_HIST",      $statusHistory);
   $sth->bind_param(":EXP_START",      $expectedStartTime);
   $sth->bind_param(":EXP_END",        $expectedEndTime);
   $sth->bind_param(":EXCEPT_STAT",    $exceptionStatus);
   $sth->bind_param(":ALRAM1",         $alarmList1);
   $sth->bind_param(":ALARM2",         $alarmList2);
   $sth->bind_param(":ALARMSENT",      $alarmSent);
   $sth->bind_param(":PROBLEM_OWNER",  $problemOwner);
   $sth->bind_param(":COMMENTS",       $comments);
   $sth->bind_param(":LAST_MOD_BY",    $lastModBy);
   $sth->bind_param(":LAST_MOD_AT",    $lastModAt);
   $sth->execute();
}


sub appcUpdateFieldsForAnApplication_dbAbv {
   my($dbAbv, $dbPriv, $node,$instance,$location,$applicationGroup,$applicationName,$lastHeartBeat,$lastStatus,$statusHistory,$expectedStartTime,$expectedEndTime,$exceptionStatus,$alarmList1,$alarmList2,$alarmSent,$problemOwner,$comments,$lastModBy,$lastModAt, $logfile, $verbal) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);

   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   appcUpdateFieldsForAnApplication_dbh($gmm_dbHandler, $node,$instance,$location,$applicationGroup,$applicationName,$lastHeartBeat,$lastStatus,$statusHistory,$expectedStartTime,$expectedEndTime,$exceptionStatus,$alarmList1,$alarmList2,$alarmSent,$problemOwner,$comments,$lastModBy,$lastModAt, $logfile, $verbal);
   dbDisconnect($gmm_dbHandler);
}


# -------------------------
# appcDeleteAnApplication
# -------------------------
sub appcDeleteAnApplication_dbh {
   my ($dbh,$hashKey) = @_;
   my($aSql) = qq {
         delete 
         from GMM_APPLICATION_CONTROL
         where HASH      = '${hashKey}'
   };
   my($sth) = $dbh->prepare($aSql);
   $sth->execute();
   dbCommit($dbh);

}


sub appcDeleteAnApplication_dbAbv {
   my($dbAbv, $dbPriv, $hashKey) = @_;
   my($gmm_db_1,$gmm_login_1,$gmm_password_1) = getGmmDbLoginForHeartBeat($dbAbv);

   my $gmm_dbHandler = dbConnect($gmm_db_1,$gmm_login_1,$gmm_password_1,$logfile,$verbal);

   appcDeleteAnApplication_dbh($gmm_dbHandler, $hashKey);
   dbDisconnect($gmm_dbHandler);
}


# -------------------------
# appcPrepareFlatFile
# -------------------------
sub appcPrepareFlatFile_dbh {
  my($dbh,$filename,$LogFile) = @_;
  my $select = qq { 
    SELECT
     HASH,
     NODE_NAME,
     INSTANCE,
     CITY_CODE,
     APPLICATION_GROUP,                 
     APPLICATION_NAME,                          
     to_char(LAST_HEART_BEAT,'YYYYMMDDHH24MISS') LAST_HEART_BEAT,
     LAST_STATUS,
     STATUS_HISTORY,
     PROBLEM_OWNER,
     COMMENTS,
     ALARM_LIST_1,
     ALARM_LIST_2,
     ALARM_SENT,
     EXPECTED_START_TIME,
     EXPECTED_END_TIME,
     EXCEPTION_STATUS,
     LAST_MOD_BY,
     to_char(LAST_MOD_AT,'YYYYMMDDHH24MISS') LAST_MOD_AT
    from GMM_APPLICATION_CONTROL
    order by CITY_CODE
  }; 
 sqlToFlat_dbh($select,$filename,$dbh, $LogFile,$FALSE);
}

# -------------------------
# appc Test function
# -------------------------
sub test_appcSendHeartBeat {
   my($appcDbAbriv) = @_;
   $appcDbAbriv = setDefault($appcDbAbriv,"NY_GMM_DEV");
   $appcDbPriv  = "";

   my $node     = "N";
   my $instance = "CNYLHMM2";
   my $location = "ZHXX";
   my $appGrp   = "Test2";
   my $appName  = "AN";
   my $appName2  = "AN2";

   printf("--> TEST Status appcDbAbriv:${appcDbAbriv}:  appcDbPriv:${appcDbPriv}:\n");
   appcInitExceptionStatus_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"Init");
   my $aStatus     = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"EXCEPTION_STATUS");
   printf("After init: EXCEPTION_STATUS:${aStatus}\n");

   appcExceptionStatusUpdate_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"Hallo ROOOOOOOOOOTHLIN");
   my $aStatus     = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"EXCEPTION_STATUS");
   printf("After sending Hallo ROOOOOOOOOOTHLIN: EXCEPTION_STATUS:${aStatus}\n");
 return;

   printf("----> TEST of Application-Control functions\n");
   appcUpdateFieldsForAnApplication_dbAbv($appcDbAbriv, $appcDbPriv, $node,$instance,$location,$appGrp,$appName2,"19600805120030","wwwww","lllll","","Mo-Fr:0730","ExceptionStatus","Walter.rothlin\@csfb.com","Walter.rothlin\@csfb.com","Alarmiert!!!","ProblemOwner34567890123456789","No comments","wrothlin","19601111111111", $logfile, $verbal);
   appcUpdateAlarmSent_dbAbv             ($appcDbAbriv, $appcDbPriv, $node,$instance,$location,$appGrp,$appName2,"ALARM ALARM");


   printf("--> TEST rowCount\n");
   my $rowCount = appcGetAppCount_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName);
   printf("rowCount:${rowCount}:\n");

   printf("--> TEST Heart beat\n");
   my $aHeartBeat = appcGetLastHeartBeat_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName);
   printf("Last Heartbeat:${aHeartBeat}\n");
   printf("Sending a new Heartbeat\n");
   appcSendHeartBeat_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName);
   $aHeartBeat = appcGetLastHeartBeat_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName);
   printf("Last Heartbeat:${aHeartBeat}\n");

   printf("--> TEST rowCount\n");
   my $rowCount = appcGetAppCount_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName);
   printf("rowCount:${rowCount}:\n");


   printf("--> TEST Status\n");
   appcInitStatus_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"Init");
   my $aStatus     = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"LAST_STATUS");
   my $aStatusHist = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"STATUS_HISTORY");
   printf("After init: LAST_STATUS:${aStatus}   STATUS_HISTORY:${aStatusHist}\n");

   appcStatusUpdate_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"Hallo ROOOOOOOOOOTHLIN");
   my $aStatus     = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"LAST_STATUS");
   my $aStatusHist = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"STATUS_HISTORY");
   printf("After sending Hallo ROOOOOOOOOOTHLIN: LAST_STATUS:${aStatus}   STATUS_HISTORY:${aStatusHist}\n");

   appcStatusUpdate_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"Hallo ROOOOOOOOOOTHLIN");
   my $aStatus     = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"LAST_STATUS");
   my $aStatusHist = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"STATUS_HISTORY");
   printf("After sending Hallo ROOOOOOOOOOTHLIN: LAST_STATUS:${aStatus}   STATUS_HISTORY:${aStatusHist}\n");

   appcStatusUpdate_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"Hallo ROOOOOOOOOOTHLIN");
   my $aStatus     = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"LAST_STATUS");
   my $aStatusHist = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"STATUS_HISTORY");
   printf("After sending Hallo ROOOOOOOOOOTHLIN: LAST_STATUS:${aStatus}   STATUS_HISTORY:${aStatusHist}\n");

   appcStatusUpdate_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"Walti xxxxxxxxxxx");
   my $aStatus     = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"LAST_STATUS");
   my $aStatusHist = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"STATUS_HISTORY");
   printf("After sending Walti xxxxxxxxxxx: LAST_STATUS:${aStatus}   STATUS_HISTORY:${aStatusHist}\n");

   appcInitStatus_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName);
   my $aStatus     = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"LAST_STATUS");
   my $aStatusHist = appcGetField_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName,"STATUS_HISTORY");
   printf("After init: LAST_STATUS:${aStatus}   STATUS_HISTORY:${aStatusHist}\n");

   printf("Clearing Heartbeat\n");
   appcDeleteHeartBeat_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName);
   $aHeartBeat = appcGetLastHeartBeat_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName);
   printf("Last Heartbeat after clearing:${aHeartBeat}\n");

   appcInitStatus_dbAbv($appcDbAbriv,$appcDbPriv,$node,$instance,$location,$appGrp,$appName2,"Init");

}


sub analyseGmmExtractorEodLogFile {
  my($logFileName) = @_;
  my @logLines = readFile($logFileName);
  my @retLines = ();

  foreach my $aLine (@logLines) {
    my $printIt = $FALSE;
    if (index($aLine,"My Process-ID") > -1) {
       $printIt = $TRUE;
    }

    if (index($aLine,"-->GMM_") > -1) {
       $printIt = $TRUE;
    }

    if (index($aLine,"WARNING:") > -1) {
       $printIt = $TRUE;
    }

    if (index($aLine,"ERROR:") > -1) {
       $printIt = $TRUE;
    }

    if (index($aLine,"Ftp node:") > -1) {
       $printIt = $TRUE;
    }

    if (index($aLine,"  --> Put") > -1) {
       $printIt = $TRUE;
    }

    if (index($aLine,"Heartbeat") > -1) {
       $printIt = $TRUE;
    }


    if ($printIt) {
      push(@retLines,$aLine);
    }
  }

  writeArrayToFile(setNewFilenameExtension($logFileName,"ana"),$FALSE,@retLines);

  return @retLines

}

sub showMenu_analyseGmmExtractorEodLogFile {
   print("This function analyses the tiqGmmExtractorEod log-file\n");
   
   my $loc = createAsciiMenu("","","","ZH","ZN","LN","NY","SG");
   my $logDir = "${CSG_DATA}gpac/GMM_Scratch";
   my $logFileName = "";

   if ($loc eq "1") {
      $logDir = "/app/ft/logs/PZHLHMC2/gpac";
      $logFileName = readln("Log-Filename","${logDir}/GmmExtractorEod_07Apr-0412.log");
   } else {
      $logFileName = readln("Log-Filename","${logDir}/tradeIQ_GmmExtractorEod_20040330043406.log");
   }

   
   analyseGmmExtractorEodLogFile($logFileName);
}

1;
