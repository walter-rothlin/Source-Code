
# $Header: /app/TIT/data/repositories/FT/plain_daily_production/interfaces/GMM/common/wssCommonLib.pm,v 1.2 2009/04/29 16:55:02 msrivino Exp $

# @(#)wssCommonLib.pm	1.2 08/23/07 20:39:03 /app/ft/build/tools/cgi/common/SCCS/s.wssCommonLib.pm

#
# START---------------------------------------------------------------------
# Author:        Dmitriy Volfson 

# Description:   Contains some common function used in number of WSS related applications  
#
# File Name: wssCommonLib.pm      
#
# History:
# 01/06/2000    V1.0  Dmitriy Volfson    Initial Version
# 03/30/2000    V1.1  Dmitriy Volfson    added getCoaDate, WSS_FIXED_INDEXES  
# 09/07/2000    V1.2  Walter Rothlin     added DEAL_TYPES for SECURITY 
# 11/01/2000    V1.3  Dmitriy Volfson    added getTradingDate  
# 01/03/2001    V1.4  Dmitriy Volfson    added isCoaInProgress, isCoaInProgress_dbh
# 01/18/2001    V1.5  Dmitriy Volfson    fixed sql in isCoaInProgress 
# 02/28/2001    V1.6  Dmitriy Volfson    added  wssIsLastTradingDayOfMonth,
#                                               wssIsFirstTradingDayOfMonth 
#                                               and corresponding _dbh fcts
# 05/21/2001	V1.7  Farah Nasim	 added a where clause in all the data function
#					 for wss_gdp_site, set default value and added
#					 gdpSite as an in parameter.
# 07/02/2001   V1.8 Dmitriy Volfson      getNextAreaDate now takes optional today's date
# 07/02/2001   V1.9 Dmitriy Volfson      added getWssDbLogin
# 12/06/2002   V1.10 Dmitriy Volfson     added cityLeadArea hash, modified getNextAreaDate
# 11/11/2002   V1.11 Dmitriy Volfson     added FRAA FRAL 
# 12/23/2002   V1.12 Dmitriy Volfson     removed FRAA FRAL 
# 01/30/03     V1.13 Dmitriy Volfson     added swap deal types CCBR and CCBP 
# 07/02/03     V1.14 Dmitriy Volfson     new wss db name 
# END-----------------------------------------------------------------------



################################################ DEAL TYPES ###################
#######################################

$WSS_CALL_DEAL_TYPES = "'CLD', 'CLL','DMCLD'"; 

$WSS_LOAN_DEPOSIT_DEAL_TYPES = "'LOAN', 'JMLND', 'DMLND','ACTLN','IDLND','ILOAN','YULND', 'ACTDP', 'DEP', 'DMDEP', 'FID','IDDEP', 'IDEP', 'JMDEP', 'YUDEP', 'EGD', 'FXL','FXA', 'DMFID'";

$WSS_SWAP_DEAL_TYPES = "'SWP', 'SWR', 'CCR','CCP', 'OISWR', 'OISWP','CCBR','CCBP'";

$WSS_FRA_DEAL_TYPES = "'FRS' , 'FRP'";

##################
## REPOS #########
##################
$WSS_MM_REPO_DEAL_TYPES = "'CCREP','CCREV'";
$WSS_SC_REPO_DEAL_TYPES = "'OREP', 'IREP','REP','REV','IREV','OREV'";
$WSS_REPO_DEAL_TYPES    = "$WSS_MM_REPO_DEAL_TYPES,$WSS_SC_REPO_DEAL_TYPES"; 

################
## SECURITIES ##
################
$WSS_MM_SECURITY_DEAL_TYPES = "'CDI', 'CDP'";
### Old changed by WR 09/07/00 $WSS_SC_SECURITY_DEAL_TYPES = "'ACGB','ACTB','ADB', 'JGB', 'JGFB','JGTB', 'NZGB','US','USTB','JDGB','UATB','SAGB'";
$WSS_SC_SECURITY_DEAL_TYPES = "'ACGB','ACTB','ADB','BRZTB','BUND','BUTB','CAN','CCN','CETE','CLTB','CLUF','CSFR2','CSFRN','CZK1','CZK2','CZK3','EUACK','EUEA','GKO','HKGB','HKTN','HUNG','HUTB','IBRD','JDGB','JGB','JGFB','JGTB','KOREA','KOREQ','LTN','LVTB','MF','NZBB','NZCD','NZGB','NZTB','OFZ','PLFR2','PLFRN','POLGB','POLTB','R_GKO','SAGB','SLOPN','S_GKO','TDAE','THBD','THNCD','UATB','UKTB','USTB'";
$WSS_SECURITY_DEAL_TYPES = "$WSS_MM_SECURITY_DEAL_TYPES, $WSS_SC_SECURITY_DEAL_TYPES";


########################
## RATE INDEXES #######
#######################
$WSS_FIXED_INDEXES_STR = "'MM' ,'MT', 'MZ'";
@WSS_FIXED_INDEXES     = ("MM" ,"MT", "MZ");


##############################
####  OTHER ##################
##############################

%cityLeadArea = (

      "SY" => "S1CTRL",   # uses Singapore 
      "S1" => "S1CTRL",
      "SH" => "S1CTRL",
      "H1" => "S1CTRL",
      "T1" => "T1CTRL",
      "L1" => "L1CTRL",
);

sub getPrevAreaDate {
  my($city,$gdpSite) = @_;
  $gdpSite = setDefault($gdpSite,"GFX");
  my ($sql) = "";
  my ($FileName) = "${TmpDir}/${CITY}PrevAreaDateFile${TODAY}.tmp";
  my (@PrevAreaDates) =();
  my ($PrevAreaDate) ="";
 
  $sql = qq {
 
    SELECT  MAX(PREV_AREA_DATE) PREV_AREA_DATE
    FROM  AREAS
    WHERE AREA_CITY_CODE='${city}'
    AND WSS_GDP_SITE = '${gdpSite}'
  };
 
 
 
  $msg =  sqlToFlat($sql,$FileName,$db,$login,$password);
 
  if ( $msg != $TRUE ) {
    print "$msg\n";
  }
 
  @PrevAreaDates = getColumnValues ($FileName,"\\|","PREV_AREA_DATE","","","");
  $PrevAreaDate = $PrevAreaDates[0];
 
  return $PrevAreaDate;
}


sub getCoaDate {
  my($city, $db, $login, $password, $LogFile, $verbal, $format, $gdpSite ) = @_;
  $gdpSite = setDefault($gdpSite,"GFX");
  my $dbh = dbConnect ($db, $login, $password,  $LogFile, $verbal);
  my $coaDate =  getCoaDate_dbh($city, $dbh,  $LogFile, $verbal,$format, $gdpSite);  
  dbDisconnect ($dbh);

  return $coaDate;
}

sub getTradingDate {
  my($city, $db, $login, $password, $LogFile, $verbal, $format, $gdpSite) = @_;
  $gdpSite = setDefault($gdpSite,"GFX"); 
  my $dbh = dbConnect ($db, $login, $password,  $LogFile, $verbal);
  my $tradingDate =  getTradingDate_dbh($city, $dbh,  $LogFile, $verbal,$format, $gdpSite);
  dbDisconnect ($dbh);
 
  return $tradingDate;
}


sub getNextAreaDate {
  my($city, $db, $login, $password, $LogFile, $verbal, $format, $gdpSite, $today) = @_;
  
  $gdpSite = setDefault($gdpSite,"GFX");

  if ($format eq "") {
    $format = "DD-MON-RRRR";
  }
  my $dbh = dbConnect ($db, $login, $password,  $LogFile, $verbal);
  my $coaDate =  getNextAreaDate_dbh($city, $dbh,  $LogFile, $verbal, $format, $gdpSite, $today);
  dbDisconnect ($dbh);
 
  return $coaDate;

}

sub getNextAreaDate_dbh {
  my($city, $dbh, $LogFile, $verbal, $format, $gdpSite, $today) = @_;
  $gdpSite = setDefault($gdpSite,"GFX");

  if ($format eq "") {
    $format = "DD-MON-RRRR";
  }

  my $additionalSql = "";
  if ($today ne "") {
   $additionalSql = "AND coa_status_table.COA_FROM_DATE =  '$today'";
  }

  my $leadArea = $cityLeadArea{$city};

  if ($leadArea eq "") {
   $leadArea = "${city}CTRL";
  }
  
  my $sql = qq {

    select to_char(max(COA_TO_DATE), '${format}') COA_TO_DATE
    from  coa_status_table
    where coa_status_table.lead_area = '${leadArea}'
    and   coa_status_table.wss_gdp_site = '${gdpSite}'
    $additionalSql

  };


  addToLogFile( "$sql ", $LogFile, $verbal);
  my $sth = $dbh->prepare($sql);
 
  my  @records = dbExecutePreparedSelectSttmnt($sth);
 
 
  my $record = $records[0];
 
  my $coaDate = $record->{COA_TO_DATE};
 
  return  $coaDate;

}

sub getCoaDate_dbh {
  my($city, $dbh, $LogFile, $verbal, $format, $gdpSite) = @_;
  $gdpSite = setDefault($gdpSite,"GFX");
  $verbal = setDefault( $verbal, $FALSE);

  if ($format eq "") {
    $format = "DD-MON-RRRR";
  }

  my $sql = qq {
       select to_char(max(COA_FROM_DATE), '${format}') COA_FROM_DATE  
       from  coa_status_table, 
             areas
       where coa_status_table.area_unit = areas.area_unit and
             areas.AREA_CITY_code='${city}' AND
             coa_status = 'Y' AND
	     coa_status_table.wss_gdp_site = '${gdpSite}' AND
	     coa_status_table.wss_gdp_site = areas.wss_gdp_site

    };

  addToLogFile( "Getting coaDate ", $LogFile, $verbal);
  addToLogFile( " $sql  ", $LogFile, $verbal);

  my $sth = $dbh->prepare($sql); 

  my  @records = dbExecutePreparedSelectSttmnt($sth);


  my $record = $records[0]; 

   my $coaDate = $record->{COA_FROM_DATE};

   return  $coaDate;

}

sub getTradingDate_dbh {
  my($city, $dbh, $LogFile, $verbal, $format, $gdpSite) = @_;

  $gdpSite = setDefault($gdpSite,"GFX");
 
  if ($format eq "") {
    $format = "DD-MON-RRRR";
  }
 
  my $sql = qq {
       select to_char(max(COA_TO_DATE), '${format}') COA_TO_DATE
       from  coa_status_table,
             areas
       where coa_status_table.area_unit = areas.area_unit and
             areas.AREA_CITY_code='${city}' AND
             coa_status = 'Y' AND
             coa_status_table.wss_gdp_site = '${gdpSite}' AND
             coa_status_table.wss_gdp_site = areas.wss_gdp_site
    };
 
  my $sth = $dbh->prepare($sql);
 
  my  @records = dbExecutePreparedSelectSttmnt($sth);
 
 
  my $record = $records[0];
 
  my $tradingDate = $record->{COA_TO_DATE};
 
  return  $tradingDate;
 
}

sub isCoaInProgress {
  my($city, $db, $login, $password, $LogFile, $verbal, $gdpSite) = @_;
  $gdpSite = setDefault($gdpSite,"GFX");


  my $dbh = dbConnect ($db, $login, $password,  $LogFile, $verbal);
  my $NumberOfAreasNotClosed =  isCoaInProgress_dbh($city, $dbh,  $LogFile, $verbal);
  dbDisconnect ($dbh);
 
  return $NumberOfAreasNotClosed;


}


sub isCoaInProgress_dbh {
  my($city, $dbh, $LogFile, $verbal, $gdpSite) = @_;
  $gdpSite = setDefault($gdpSite,"GFX");

  return 0;

  my $sql = qq {
   select count (distinct coa_status_table.area_unit) NUMBER_OF_AREAS_NOT_CLOSED
       from  coa_status_table
       where coa_status_table.area_unit in 
                    (select distinct areas.area_unit
                     from areas
                     where areas.AREA_CITY_code='${city}'
		     and   areas.wss_gdp_site = '${gdpSite}') 
        AND coa_status_table.coa_status is null AND
            coa_status_table.wss_gdp_site = '${gdpSite}' 
 
  };
  my $sth = $dbh->prepare($sql);
 
  my  @records = dbExecutePreparedSelectSttmnt($sth);
 
 
  my $record = $records[0];
 
  my $NumberOfAreasNotClosed = $record->{NUMBER_OF_AREAS_NOT_CLOSED};
 
  return  $NumberOfAreasNotClosed;

}




sub wssIsFirstTradingDayOfMonth {
  my ($city,$database,$login,$password,$logfile,$verbal, $gdpSite) = @_;
  $gdpSite = setDefault($gdpSite,"GFX");
  my($dbh) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = wssIsFirstTradingDayOfMonth_dbh($city,$dbh,$logfile,$verbal, $gdpSite);
  dbDisconnect($dbh);
  return $retVal;
}

sub wssIsFirstTradingDayOfMonth_dbh {
  my($city,$dbh,$logfile,$verbal, $gdpSite) = @_;
  $gdpSite = setDefault($gdpSite,"GFX");
  my($today)            = getTradingDate_dbh($city,$dbh,$logfile,$verbal,"YYYYMMDD", $gdpSite);
  my($today_month)      = substr($today,3,3);
 
  my($yesterday)        = getCoaDate_dbh($city,$dbh,$logfile,$verbal, "YYYYMMDD",$gdpSite);
  my($yesterday_month)  = substr($yesterday,3,3);
 
  if ($yesterday_month ne $today_month) {
     return $TRUE;
  } else {
     return $FALSE;
  }
}
sub  wssIsLastTradingDayOfMonth {
  my ($city,$database,$login,$password,$logfile,$verbal, $gdpSite) = @_;
  $gdpSite = setDefault($gdpSite,"GFX");
  my($dbh) = dbConnect($database,$login,$password,$logfile,$verbal);
  my($retVal) = wssIsLastTradingDayOfMonth_dbh($city,$dbh,$logfile,$verbal, $gdpSite);
  dbDisconnect($dbh);
  return $retVal;
}
 
sub wssIsLastTradingDayOfMonth_dbh  {
  my($city, $dbh, $LogFile, $verbal, $gdpSite) = @_;
  $gdpSite = setDefault($gdpSite,"GFX"); 
  my($today) = getTradingDate_dbh($city,$dbh,$logfile,$verbal, "YYYYMMDD", $gdpSite);
 
  my($today_month)      = substr($today,4,2);
  my ($today_year)     = substr($today,0,4);
  my $lastWorkingDate  =  getLastWorkingDayInMonth($today_year,$today_month);
 
 
  if ($today eq  $lastWorkingDate) {
    return $TRUE;
  } else {
   return $FALSE;
  }
}

sub getWssDbLogin {
 my ($db) = ""; 
 my ($login) = "";
 my ($password) = "";
 
 $db       = "plngfx02.world"; 
 $login    = "ord_user";
 $password = "br00klyn";


  return ($db,$login,$password);   
}
return 1;

