package main;	#has to be "main"

#
# START---------------------------------------------------------------------
# Author:        Walter Rothlin
# Description:   Contains some common function used at CSFB  
#
#
# Calling:       csfbPerlLib.pm
#
# History:
# 01/13/99    V1.0  Walter Rothlin    Initial Version
# 01/19/99    V1.1  Walter Rotlhin    Add Callback functions
# 01/21/99    V1.2  Walter Rothlin    Add more functions
# 01/28/99    V1.3  Walter Rothlin    Put some more function into
# 02/01/99    V1.4  Walter Rothlin    split common part into littlePerlLib.pm
# 03/18/99    V1.5  Walter Rothlin    Add LH functions to the lib
# 03/22/99    V1.6  Dmitriy Volfson   Add functions for LH web status page
# 03/23/99    V1.61 Walter Rothlin    Bug fixes in the nodeSelector code 
# 03/29/99    V1.62 Dmitriy Volfson   Added dynamic button to InstanceNode Selector 
# 04/06/99    V1.63 Dmitriy Volfson   Added dynamic MasterEmail link 
# 04/08/99    V1.63 Dmitriy Volfson   Added addSelectorForm, commented out print Content-type
# 04/19/99    V1.64 Dmitriy Volfson   functions ftpGetFiles, ftpPutFiles, GeneratePreviousOrForwardDates
#                                     moved here from littlePerlLib.pm
# 04/30/99    V1.7  Dmitriy Volfson   modification for Instance Selector 
# 05/10/99    V1.8  Dmitriy Volfson   modified tblHeader function
# 09/02/99    V1.9  Walter Rothlin    cb for selectHashInFltFile get a reference
# 09/02/99    V1.10 Dmitriy Volfson   added gmmitHeader and gmmitTail
# 09/03/99    V1.11 Walter Rothlin    add sourceEnvironment
#                                     add some common definitions for all application 
# 09/08/99    V1.12 Dmitriy Volfson   changed Data variable to "../ft/Data"
# 09/09/99    V1.13 Walter Rothlin    add ftpFilePutOrGet
# 09/10/99    V1.14 Walter Rothlin    add Pop-Up menus to the cgi-local applications
# 09/14/99    V1.15 Walter Rothlin    move SSI to html
# 10/12/99    V1.16 Dmitriy Volfson   changed ftpPutFiles in such way that it can handle multiple Ftp Destinations 
#                                     old ftpPutFile rename to ftpPutFilesSingleNode
# 10/12/99    V1.17 Dmitriy Volfson   modified createNodeSelector 
# 10/21/99    V1.18 Dmitriy Volfson   added displaySelectObject to create html Select Object 
#                                     modified ftpFilePutOrGet function
# 10/26/99    V1.19 Dmitriy Volfson   change in sourceEnvironment to export local enviroment
# 10/26/99    V1.20 Dmitriy Volfson   added function sqlToFlat
# 10/28/99    V1.21 Dmitriy Volfson   added function sqlExecute
# 12/30/99    V1.22 Walter Rothlin    add common mapping tables
# 01/04/00    V1.23 Dmitriy Volfson   added mappings fro WSS city codes
# 01/05/00    V1.24 Dmitriy Volfson   added log functions
# 01/06/00    V1.25 Walter Rothlin    moved log functions to littlePerlLib
# 01/06/00    V1.26 Dmitriy Volfson   added getAndSetArguments 
# 01/20/00    V1.26 Dmitriy Volfson   added %month_number hash
# 02/04/00    V1.27 Walter Rothlin    moved %month_number to littlePerlLib
#                                     add gmmitNotAuthorizedHeader
# 02/10/00    V1.28 Dmitriy Volfson   added sqlConnect, sqlDisconnect,sqlPrepareSttmn,sqlExecutreSttmnt
# 03/21/00    V1.29 Dmitriy Volfson   added dbExecutePreparedSelectSttmnt 
# 03/24/00    V1.30 Walter Rothlin    changed dB functions 
# 04/24/00    V1.31 Walter Rothlin    ftp password encryption
# 04/25/00    V1.32 Walter Rothlin    bug fix
# 04/28/00    V1.33 Dmitriy Volfson   added  dbLoadFile and dbLoadFile_dbh 
# 04/28/00    V1.34 Walter Rothlin    added  sqlToFlatWithPostProcessor_dbh
#                                            sqlToFlatWithPostProcessor
# 05/02/00    V1.35 Walter Rothlin    changed sqlToFlatWithPostProcessor
# 05/05/00    V1.36 Dmitriy Volfson   changed sqlToFlatWithPostProcessor
# 05/06/00    V1.37 Walter Rothlin    added setCommonVariablesFromControlFile
# 05/17/00    V1.38 Walter Rothlin    changed dbLoadFile_dbh (error handling)
# 05/17/00    V1.39 Walter Rothlin    changed error handling for ftpPutFiles
# 05/31/00    V1.40 Walter Rothlin    add NotifyEmailOnError
#                                         addExtractorHeader
#                                         deleteDbEntries_dbh
# 06/06/00    V1.41 Dmitriy Volfson   added funcions to check disk space
# 06/14/00    V1.42 Walter Rothlin    changed setCommonVariablesFromControlFile
#                                       to handle multiple ftp nodes
# 06/21/00    V1.43 Walter Rothlin    added dbTablesExists
# 06/23/00    V1.44 Walter Rothlin    removed @ at beginning of db name in dbConnect
# 07/03/00    V1.45 Walter Rothlin    made var local in NotifyEmailOnError
# 07/05/00    V1.46 Walter Rothlin    added getDbUser_PasswordFromEnv
# 07/06/00    V1.47 Walter Rothlin    fixed numeric null in dbUpdateRecord_dbh
# 07/12/00    V1.48 Walter Rothlin    bug fix (escape ') in dbUpdateRecord_dbh
# 08/16/00    V1.49 Walter Rothlin    bug fix in displayRecordCausedError
# 08/21/00    V1.50 Walter Rothlin    Add getDbTableDescribtion
#					                      setBooleanFromCommonControl
#                                         setListFromCommonControl
# 09/06/00    V1.51 Walter Rothlin    Changed sqlToFlt to use dbConnect
#                                     Add executeSqlScript
# 09/12/00    V1.52 Walter Rothlin    removed $fldValue =~ s/\'/''/g; in
#                                         dbUpdateRecord,
#                                         dbUpdateRecords,
#                                         dbLoadFile_dbh
#                                     Changed sqlToFlat_dbh to replace \n with " " or <BR>
# 10/24/00    V1.53 Walter Rothlin    Mod getFtpLoginFileDecryptedFilename
# 11/10/00    V1.54 Walter Rothlin    Mod dbTablesExists_dbh (accept lower case table names)
# 11/15/00    V1.55 Dmitriy Volfson   modified dbConnect, added dbExecuteSqlCommand
# 11/15/00    V1.56 Walter Rothlin    Add getCommonControlViaHttpGet
# 04/17/00    V1.57 Walter Rothlin    Mod setCommonVariablesFromControlFile 
# 05/03/01    V1.58 Dmitriy Volfson   added L1 mapping to %branchCode_wssCityShortName    
# 05/24/00    V1.59 Walter Rothlin    Add ftpCreateDirAndPutFiles
#                                         ftpCreateDir
#                                     Mod setCommonVariablesFromControlFile to use multiple line ftp definitions
#                                         and to handle action tags in ftpDirs
# 05/29/01    V1.60 Dmitriy Volfson   Mod displaySelectObject to take multiple selected values
# 05/31/01    V1.61 Walter Rothlin    Add setCommonVariablesFromControlFileForApplicationName 
# 06/11/01    V1.62 Dmitriy Volfson   replaced solweb with gmm.app.csfb.net 
# 06/19/01    V1.63 Walter Rothlin    Add variables for dynamic count of Args in commoncontrol 
# 07/02/01    V1.64 Dmitriy Volfson   changes in InstanceSelector to take the full node name from the list
# 08/20/01    V1.65 Dmitriy Volfson   changes print current time in gmmItHeader 
# 09/07/01    V1.66 Walter Rothlin    Add ftpCreateDailySubDir
# 09/13/01    V1.67 Walter Rothlin    Add ftpUseFileNameMappingTable
#                                     Add getInsightCityCode_CityShortName
#                                     Add getCityShortName_insightCityCode
# 09/26/01    V1.68 Walter Rothlin    Changed ftpCreateDailySubDir ftpUseFileNameMappingTable
# 09/27/01    V1.69 Walter Rothlin    Changed ftpCreateDirAndPutFilesWithActionParameter to handle "RemoveHeaderLines"
# 10/24/01    V1.70 Walter Rothlin    Changed setListFromCommonControl
# 11/18/01    V1.71 Walter Rothlin    Changed setListFromCommonControl
# 11/28/01    V1.72 Walter Rothlin    Changed ftpCreateDirAndPutFilesWithActionParameter to handle "ConvertToExcel"
# 11/30/01    V1.73 Dmitriy Volfson   replaced nyweb1.fi.csfb.com with gmm.app.csfb.net
# 02/13/02    V1.74 Dmitriy Volfson   gpacLoadBasisTagMappings gpacMapBasisTag 
# 02/27/02    V1.75 Dmitriy Volfson   added getUserId 
# 04/30/02    V1.76 Dmitriy Volfson   modified default machine to be nys01d-010 fro node selector 
# 05/13/02    V1.77 Walter Rothlin    Add setHashFromCommonControl
# 05/16/03    V1.78 Dmitriy Volfson   Changed ftpCreateDirAndPutFilesWithActionParameter to return correct erro msg
# 05/30/02    V1.79 Dmitriy Volfson   added dbBuildArray_dbh 
# 07/22/02    V1.80 Walter Rothlin    ftp->quit added to ftpCreateDirAndPutFilesWithActionParameter
# 09/06/02    V1.81 Walter Rothlin    Changed addExtractorHeader_1 (added new parameter)
# 11/27/02    V1.82 Dmitry Volfson    Introduced variable cgiLocalDir and changed sourceEnvironment 
# 11/27/02    V1.83 Dmitry Volfson    isNewWebServer 
# 12/05/02    V1.84 Walter Rothlin    Added retry mechanism in ftp functions 
# 12/12/02    V1.85 Walter Rothlin    Redirected ftp print to log file (addLogFile) and increased the ftp retries from 5 to 10
# 01/17/03    V1.86 Walter Rothlin    Add sendSMS, sendShortMsg
# 02/13/03    V1.87 Walter Rothlin    Add getAlertListFromPasswordFile
# 05/21/03    V1.88 Siebert Kruger    Changed getCommonControlViaHttpGet to handle a zero length file correctly.
# 05/22/03    V1.89 Walter Rothlin    Add isZH_Node
# 06/03/03    V1.90 Walter Rothlin    Changed from gmm.app.csfb.net to gmmit.csfb.net
# 06/25/03    V1.91 Walter Rothlin    Changed ftpCreateDirAndPutFilesWithActionParameter to have different filters for different destinations
# 06/30/03    V1.92 Walter Rothlin    Add showMenu_sendShortMsg
# 07/14/03    V1.93 Walter Rothlin    Mod sqlToFlat to handle ";" as separator
# 09/22/03    V1.94 Dmitry Volfson    modified gpacMapBasisTag 
# 10/27/03    V1.95 Dmitry Volfson    added $ftpTimeOut 
#                                     modified ftpGetFiles,ftpPutFilesSingleNode, 
#                                     ftpCreateDirAndPutFilesWithActionParamete
# 01/23/04    V1.96 Walter Rothlin    Add sendShortMsgFromHash,showMenu_sendGeburiNotifications
# 02/16/04    V1.97 Walter Rothlin    Add createSqlLoaderDescFile, createSqlLoaderDescFile_dbh
# 03/13/04    V1.98 Walter Rothlin    Changed ftpCreateDirAndPutFiles (eliminated side effect; Saved global variable)
# 09/30/04    V1.99 Walter Rothlin    Add getRowCountFromTbl, getRowCountFromTbl_dbh
# 11/18/05    V2.00 Walter Rothlin    Add getFieldNamesFromTbl, isFieldExistsInTable
# 12/06/05    V2.01 Dmitriy Volfson   modified isNewWebServer due to another server upgrade
# 06/21/05    V2.02 Dmitriy Volfson   Change by Ash -- Modified the SQL*Loader control file to take 14 character date from YYMMDDHH24MISS to YYYYMMDDHH24MISS.
# 12/29/05    V2.03 Walter Rothlin    Moved SMS function from csfbPerlLib.pm to littlePerlLib.pm
#                                     Changed SMS function to handle the credit-suisse.com SMS gateway
# 03/14/06    V2.04 Dmitriy Volfson   Change by Ash -- Modified the SQL*Loader control file to take 14 character date from YYMMDDHH24MISS to YYYYMMDDHH24MISS.
# 04/18/06    V2.05 Dmitriy Volfson   modified gpacMapBasisTag 
# 05/09/06    V2.06 Walter Rothlin    Extended getFtpLoginPassword to deal with test levels (compatible with older version)
# 09/19/06    V2.07 Walter Rothlin    Added fct to use the TUM (Treasury User Management) web-service
# 09/25/06    V2.08 Walter Rothlin    Added more TUM web-service URLs
# 10/07/06    V2.09 Walter Rothlin    TUM URL changed to production
# 10/18/06    V2.10 Walter Rothlin    Added getGmmSccsVersions,getFieldsFromDB_dbh
# 10/24/06    V2.11 Walter Rothlin    Changed ftpCreateDirAndPutFilesWithActionParameter to handle compression
# 11/27/06    V2.12 Walter Rothlin    Changed getNameValuePairsFromTUM to handle UNICODe characters
# 02/06/07    V2.13 Walter Rothlin    Added ftpGetFilesWithDestination derived from ftpGetFiles
# 03/14/07    V2.14 Walter Rothlin    Changed getUserRecFromTUM replaced my $response = $userAgent->request(POST 'http://zus10a-1805.tszrh.csfb.com:7072/ws/getUserProfile',
# 03/19/07    V2.15 Walter Rothlin    Added prepareAndExecuteSqlStatement with proper error handling
# 04/05/07    V2.16 Walter Rothlin    Fixed bug in getFtpLoginPassword
# 04/13/07    V2.17 Walter Rothlin    Refactured getFtpLoginPassword
# 04/13/07    V2.18 Walter Rothlin    Fixed bug in getFtpLoginPassword
# 04/25/07    V2.19 Walter Rothlin    Added ZN (Zurich-North)
# 05/17/07    V2.20 Walter Rothlin    Changed dbUpdateRecords_dbh
# 05/18/07    V2.21 Walter Rothlin    Changed insertDbEntries_dbh, setDbEntries_dbh
# 08/27/07    V2.22 Walter Rothlin    Added CVS header
# 03/11/08    V2.23 Ash Rao           Increased the rejected records from 10 to 1000
# 05/26/08    V2.24 Walter Rothlin    Fixed problem with ftp (ASCII / BIN depending on mime type)
#                                        - Add ftpSetMode
#                                        - Changed ftpCreateDirAndPutFilesWithActionParameter
# 01/16/09    V2.25 Ash Rao           Reduced the number of ftp tries ftpMaxTriesAfterError from 10 to 1
# 03/16/09    V2.26 Walter Rothlin    Fixed problem with removing decrypted file
# 06/25/09    V2.27 Walter Rothlin    Added EU loaction code
# 07/13/09    V2.28 Walter Rothlin    Reusing ZN for EUROM and Removed EU
# 08/19/09    V2.29 Walter Rothlin    Implemented crypted password with local files
# 11/27/09    V2.30 Walter Rothlin    Support of ftps and filebroker
# 01/04/10    V2.31 Walter Rothlin    Bug fix in ftps and filebroker (ftp mode issue)
# 08/27/10    V2.32 Meena Gupta       Added sendFilesToFileBrokerSetDestDir and sendFileToFileBrokerSetDestDir with Destination directory for ftps.
#            			        	  Updated countOfCommonControlArguments from 19 to 30.	
#            				          Increased the rejected records from 10 to 50 in dbLoadFile_dbh
# 09/13/10    V2.33 Simon Fulcri      Merged NY and ZH version
# 09/17/10    V2.34 Simon Fulcri      Added new TUM server settings
# 21/10/10    V2.35 Simon Fulcri      Extended %initialTUM_Record with country key
# 10-Jan-2012 V2.36 Walter Rothlin    Added CL to isLocationCodeManagedInZH
# 19-Mar-2012 V2.37 Walter Rothlin    Added ColumnFilter
# 18-Oct-2012 V2.38 Walter Rothlin    Mod setCommonVariablesFromControlFile to handle comments and empty lines in ftp definitions (server, dir, userId and password)
# 13-Dec-2012 V2.39 Walter Rothlin    Mod sendFileToFileBrokerSetDestDir
# 14-Dec-2012 V2.40 Walter Rothlin    Mod sendFileToFileBrokerSetDestDir (added trace mode)
# 17-Dec-2012 V2.41 Walter Rothlin    Mod sendFileToFileBrokerSetDestDir (if no dest name specified don't call script with -f)
# 04_Jan-2013 V2.42 Walter Rothlin    Add getPassword wrapper
# 04_Feb-2013 V2.43 Walter Rothlin    Add selectToFltString_dbh, selectToFltString
# 07_Feb-2013 V2.44 Walter Rothlin    Added dbPackageExists, dbPackageExists_dbh
# 14-Aug-2013 V2.45 Walter Rothlin    Improved log for sqlToFlatWithPostProcessor_dbh
# 17-Apr-2014 V2.46 Walter Rothlin    Added lhGetConfig, lhActivateComponentVersion
# 09-May-2014 V2.47 Walter Rothlin    Added addPassword, delPassword, modPassword
# 25-Jun-2014 V2.48 Walter Rothlin    CommonControl Migration (prepared to change commonControlUrl via FT ZH Config)
# 10-Jul-2014 V2.49 Walter Rothlin    Added FILECOPY
# 16-Jul-2014 V2.50 Walter Rothlin    Added Thread package
# 20-AUG-2014 V2.51 Walter Rothlin    Added getFullEnvName,  lhGetParameterValue
# 27-Aug-2014 V2.52 Walter Rothlin		More new functions for FT-11
# 12-Sep-2014 V2.53 Walter Rothlin		Extended lhGetConfig
# 19-Sep-2014 V2.54 Walter Rothlin		Extended decryptFtpLoginPasswordFile to use a new FT_11 password file
# 16-Oct-2014 V2.55 Walter Rothlin 		Cleanup for leagal parser 
# 23-Oct-2014 V2.56 Walter Rothlin 		Modified getCommonControlViaHttpGetForZH_nodes
# 29-Oct-2014 V2.57 Walter Rothlin 		Modified /cs/ft to /cs/lh
# 20-Nov-2014 V2.58 Walter Rothlin 		lhGetConfig DB-Access
# 17-Dec-2014 V2.59 Walter Rothlin 		Added showActivatedVersions
# 07-Jan-2015 V2.60 Walter Rothlin 		Modified getConfigDetailsFromMappingTbl used cmp_cfg.version_to_num(CODE_VERSION)  <= cmp_cfg.version_to_num
# 13-Jan-2015 V2.61 Walter Rothlin 		Modified lhGetconfig to handle templates in DB as CLOB
# 19-Jan-2015 V2.62 Walter Rothlin 		Added interactiv mode to showActivatedVersions
# 20-Jan-2015 V2.63 Walter Rothlin 		Added showComponentVersionsInStore......
# 02-Feb-2015 V2.64 Walter Rothlin 		Bug fixing for library move to utilities
# 17-Feb-2015 V2.65 Walter Rothlin 		Added deployActivateRelease ....
# 09-Mar-2015 V2.66 Walter Rothlin 		Added release a realease functions ....
# 23-Mar-2015 V2.67 Walter Rothlin 		Enhanced getConfigDB_Details and added doTest_getConfigDB_Details
# 18-Jun-2015 V2.68 Walter Rothlin 		Added getEnvironmentsForArtifactActivation
# 31-Jul-2015 V2.69 Walter Rothlin 		Changed getConfigDB_Details. No checking expirydate anymore
# 03-Sep-2015 V2.70 Walter Rothlin 		Bugfixes, Simplifications and changed Nolio interface
# 09-Sep-2015 V2.71 Walter Rothlin 		Cosmetics
# 14-Dec-2015 V2.72 Walter Rothlin 		Built in wishes from the team
# 17-Dec-2015 V2.73 Walter Rothlin		Implemented new requirements for lhManageComponents
# 12-Feb-2016 V2.74 Walter Rothlin		Added functions for Artifacte DB maintenance and lhCloud cleanup
#										Added 	getCandidatesToDeleteInArtifactStore
#												deleteArtifactBycompVersion
#												writeBackCompVersionActivate
#												renameRelease
# 23-Mar-2016 V2.75 Walter Rothlin		Added functions cryptVersionCompare
# 23-May-2016 V2.76 Walter Rothlin		Added menu_eMailMode, sendCS_Email
# 08-Jun-2016 V2.77 Walter Rothlin		Added getReleaseLogPath, getReleaseLogBasePath, getReleaseLogPathForEnv, getActivationLogFileName, lhDplyAct
# 30-Jun-2016 V2.78 Walter Rothlin		Mod getReleaseLogPath
# 08-May-2016 V2.79 Walter Rothlin		Changed for $skipComponentActivationScript
# 12-Oct-2017 V2.80 Walter Rothlin		Added BD in isPrivUserLogedIn() for spezial people
# 26-Jan-2018 V2.81 Walter Rothlin      Added remove of an instance (e.g. LHS_A on ET)  removeAnEnv()
# END-----------------------------------------------------------------------
#
############################################################################
$csfbPerlLibSccsId             = "";
$csfbPerlLibLatestVersion      = "V2.81";
############################################################################
use DBI;
use DBD::Oracle qw(:ora_types);
use File::Copy;
use LWP::UserAgent;
use HTTP::Request::Common;
use Thread;

############################################################################
# Data definitions
############################################################################
$CgiBin   = "XXXcgiBinXXX";
$CgiLocal = "XXXcgiLocalXXX";

$gmmitWebMaster              = "walter.rothlin\@credit-suisse.com";
$gpacWebMaster               = "walter.rothlin\@credit-suisse.com";
$gmmdbWebMaster              = "walter.rothlin\@credit-suisse.com";
$lhGpacExtractorSupport      = "walter.rothlin\@credit-suisse.com";
$wssGpacExtractorSupport     = "walter.rothlin\@credit-suisse.com";
$gmmdbSupport                = "walter.rothlin\@credit-suisse.com";
$gmmdbSupportProduction      = "walter.rothlin\@credit-suisse.com";
$gmmdbSupportTest            = "walter.rothlin\@credit-suisse.com";
$httpGetCommonControlSupport = "walter.rothlin\@credit-suisse.com";

$defaultRemoteNode = "nys01d-032";
$defaultInstance   = "CNYLHMM2";

# variables which will be overwritten for a cgiLocal application
# --------------------------------------------------------------
$dataPath         = "../lighthouse/Data";
$nodeInstanceTbl  = "${dataPath}/nodeInstanceTbl.flt";
$passwordFile     = "${dataPath}/password.flt";
$fullLocalPasswordFileName = $ENV{"RunS"}."/CgiData/password.flt";


$ssiDirPath       = "../../html/gmmit/SSI";

$cgiLocalDir      = "/app/tools/cgi-local";

$imagePath        = "http://gmmit.csfb.net/gmmit/images";          
$goButton         = "$imagePath/go.gif";
$gifDelete        = "$imagePath/delDoc.gif";
$gifModify        = "$imagePath/write.gif";
$gifDetail        = "$imagePath/detail.gif";
$logoGif          = "$imagePath/logo.gif";
$fuOv_0Gif        = "$imagePath/funOv_0.gif";
$fuOv_1Gif        = "$imagePath/funOv_1.gif";


# Definitions for access control and password file
# ------------------------------------------------
$passwdSepChar     = "\\|";
$userIdFiName      = "UserId";
$passwordFiName    = "Password";
$privFiName        = "Privilege";
$useServerLogin    = $TRUE;
$privSep           = "&";

my($unameStr)   = `uname -a`;
$unameStr       =~ s/\s/-/g;
my(@nodeParts)  = split("-",$unameStr);
$nodeNo         = $nodeParts[2];

$cgiPathCommon  = "http://gmmit.csfb.net/cgi-bin/lighthouse";
$htmlPathCommon = "http://gmmit.csfb.net";
$cgiPath        = "${cgiPathCommon}_${nodeNo}/dispatch?rCmd=";

# RegExs
# ------
$releaseName_RegEx = "^(LH ZH|LH SG|TFR|TEST) - (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \\d{4}( - [0-9])?\$";

#########################
# ftp functions variables
##########################
$ftpTimeOut=120;  # in seconds

############################################################################
# Misc csfb specific functions (use some cs specific infrastructure) 
############################################################################
sub isZH_Node {
  my $domainName = uc(getMyUnixDomainname());
  if (index($domainName,"SZRH") == 1) {
     return $TRUE;
  } else {
     return $FALSE;
  }
}

sub isLocationCodeManagedInZH {
  	my($loc)        =  @_;
  	if (($loc eq "ZH") || ($loc eq "ZN")  || ($loc eq "CL")) {
  	    return $TRUE;
     } else {
        return $FALSE;
     }
}


############################################################################
# Functions used in cgi-local applications 
############################################################################
sub sourceEnvironment {
  my($instance)        =  @_;
  my($retMsg)          = "";
  my(@envNameValPair)  = `${cgiLocalDir}/cgiStarter $instance ${cgiLocalDir}/getWholeEnv.pl 2>&1`;
  my(%retVal)          = ();
  my($nameValPair)     = "";  
  foreach $nameValPair (@envNameValPair) {
      my(@oneNameValPair) = split("=",$nameValPair);
      my($envVal) = $oneNameValPair[1];
      $envVal =~ s/\n//g;
      $envVal =~ s/(\s+$)//;
      $envVal =~ s/(^\s+)//;
      $ENV{$oneNameValPair[0]} = $envVal; # set external enviroment
      %retVal = (%retVal,($oneNameValPair[0],$envVal));
  }
  return %retVal;
}

sub initApplicationEnvironment {
   my($applicationType,$instance)        =  @_;
   if ($applicationType ne $CgiBin) {
       %ENVIRONMENT   = sourceEnvironment($instance);
       ### displayHashTableHTML(%ENVIRONMENT);
       $dataPath         = sprintf("%s/CgiData",$ENVIRONMENT{"RunS"});
       $nodeInstanceTbl  = "${dataPath}/nodeInstanceTbl.flt";
       $passwordFile     = "${dataPath}/password.flt";
       ## $ssiDirPath       = "SSI";
	   $ssiDirPath       = "../html/SSI";
       $WssGpacControlPath   = sprintf("%s/WssGpac/Control",$ENVIRONMENT{"RunS"});
   }
}

sub isNewWebServer { # for migration
  #my $servertype = $ENV{SERVER_SOFTWARE} ;

  #if ( ($servertype =~  /iPlanet/)) {
  # return $TRUE;
  #} else {
  # return $FALSE;
  #}
	return $TRUE;

}

############################################################################
# Functions which are used for selecting a LH node and instance 
############################################################################
sub createNodeSelector {
  my($scriptName, $buttonName,  $buttonImg, $FormName) = @_;
  $targetNode = getParam("TargetNode","nys01d-010");
  $instance   = getParam("Instance","");
  writeDebugMsg(sprintf ("TargetNode:%s:<BR>\n",$targetNode));
  writeDebugMsg(sprintf ("Instance  :%s:<BR>\n",$instance));
  InstanceSelector($nodeInstanceTbl,$targetNode,$instance,$scriptName, $buttonName, $buttonImg, $FormName);
}

# mkInstanceArray()                                     insert array elements
sub mkInstanceArray() {
   my($recCount, $refRecord, $refUserParam) = @_;
   my(%aRecord) = derefHref($refRecord);
   #printf("  nameList[$recCount]=\"%s, %s\";\n",$aRecord{"Instance"},$aRecord{"Machine"});
   printf("  nameList[$recCount]=\"%s\";\n",$aRecord{"Machine"});
   printf("  InstanceList[$recCount]=\"%s\";\n",$aRecord{"Instance"});
}

sub mkInitTarget {
  my($file) = @_ ;
  my(@Targets)=();
  my($count)=0;
 
  print("function init_target(theform, SelectedTarget){\n");
  print("  TargetList = new Array();\n");
  @Targets = getColumnValues($file,"\\|","Machine","","",$TRUE);
  foreach $fieldName (@Targets){
     printf("  TargetList[$count]=\"%s\";\n",$fieldName);
     $count++;
  }
print <<func;
 
  for(i=0;i<TargetList.length;i++){
    TargetName=TargetList[i];
    theform.TargetNode.options[i]= new Option(TargetName,TargetName);
  }
  theform.TargetNode.length=TargetList.length;
  if(SelectedTarget == ""){
    theform.TargetNode.options[0].selected=1;
  }
  else{
    for(i=0;i<TargetList.length;i++){
      if( theform.TargetNode.options[i].value==SelectedTarget){
        theform.TargetNode.options[i].selected=1;
      }
    }
  }
}
func
 
}
 
sub addSelectorForm{
 my($remoteCmd,$buttonName, $buttonImg, $formName) = @_;
 my($IsImg)= 0;
 if($buttonImg ne ""){
  $IsImg=1;
}
 
 if($buttonName eq ""){
  $buttonName = "Submit";
 }

 if($formName eq ""){
   $formName = "TargetSelector"
  }
 
print("<FORM NAME =\"$formName\">");

print <<form; 
<TABLE>
<TR><TH>Machine</TH><TH>Instance</TH></TR>
<TR><TD>
 <SELECT NAME="TargetNode" onchange="change_target(this.form, this.options[this.selectedIndex].value)" SIZE=1 >
 <OPTION VALUE="nys01d-030">nys01d-030
 <OPTION VALUE="nys01d-031">nys01d-031
 <OPTION VALUE="nys01d-031">nys01d-031
 <OPTION VALUE="nys01d-031">nys01d-031
 <OPTION VALUE="nys01d-031">nys01d-031
</SELECT>
</TD>
 
<TD>
<SELECT name="Instance" size=1>
 <OPTION VALUE="dnylhmm1" SIZE=8>dnylhmm1
 <OPTION VALUE="dnylhmm1" SIZE=8>dnylhmm1
 <OPTION VALUE="dnylhmm1" SIZE=8>dnylhmm1
 <OPTION VALUE="dnylhmm1" SIZE=8>dnylhmm1
 <OPTION VALUE="dnylhmm1" SIZE=8>dnylhmm1
</SELECT>
</TD>
form
if($IsImg == 0){
  print("<TD> <INPUT TYPE=BUTTON  VALUE=\"$buttonName\" onClick=Submit(this.form,\"$remoteCmd\")>\n");
}
else {
  print("<TD> <A href = \"javascript:Submit(document.$formName,\'$remoteCmd\' );\"onmouseover=window.status=\'$buttonName\'; return true\" > <IMG SRC=$buttonImg  border=0></A>"
);
}
print("</TD> </TR> </TABLE> \n");
 
if (isDebug() ) {
  print("<INPUT TYPE=TEXT NAME=\"ActionStr\" SIZE=50>");
  print("HiddenFld1<INPUT TYPE=TEXT NAME=\"HiddenFld1\" SIZE=50>");
}
else {
  print("<INPUT TYPE=HIDDEN NAME=\"ActionStr\" SIZE=50>");
  print("<INPUT TYPE=HIDDEN NAME=\"HiddenFld1\" SIZE=50>");
}
 
print("</FORM>");
print("<SCRIPT>  init(document.$formName); </SCRIPT>");
 
 
}







#  InstanceSelector                    adds mashine - instance selection tool
sub InstanceSelector {
 my($Datafile,$initTarget, $initInstance, $cmdStr, $buttonName, $buttonImg,$formName) = @_;
 my($IsImg)= 0;

 if($buttonImg ne ""){
  $IsImg=1;
}

 if($buttonName eq ""){
  $buttonName = "Submit";
 }

 if($formName eq ""){
   $formName = "TargetSelector";
 }
  
 print("<script language=\"JavaScript\">\n");
 print("<!-- Hide Script from older Browsers.\n");
 
 print("function init(theform) \n\{");
 print(" var SelectedTarget= \"$initTarget\";\n");
 print("  var SelectedInstance= \"$initInstance\";\n");
 print("  init_target(theform, SelectedTarget);\n");
 print("  if (SelectedTarget == \"\"){\n");
 #print("  SelectedTarget=document.TargetSelector.TargetNode.options[0].value \n }\n");
 print("  SelectedTarget=document.$formName.TargetNode.options[0].value \n }\n");
 print("  init_instance(theform, SelectedTarget, SelectedInstance);\n\}\n");

 print("function init_instance(theform, SelectedTarget,SelectedInstance)\{\n");
 print("  nameList =  new Array();\n");
 print("  InstanceList =  new Array();\n");
 selectHashInFltFile($Datafile,"\\|","","","",\&mkInstanceArray,"","");
 print(" change_target(theform, SelectedTarget,SelectedInstance);\n");
 print("\}\n");
 
 mkInitTarget($Datafile);
 
print <<javaScript;

function change_target(theform, new_targetName,SelectedInstance)
{
  var targ_len;
  var  ListName;
  var  newOption = new Option;
  var  countnew =0;
 
  for(i=0;i < nameList.length;i++){
    targ_len =  nameList[i].length;
    ListName =  nameList[i];
    if( ListName == new_targetName){
      new_name=InstanceList[i];
      newOption[countnew++]= new Option(new_name,new_name);
    }
  }
 
  for (i = 0; i < countnew; i++){
    theform.Instance.options[i]=newOption[i];
  }
  theform.Instance.options.length=countnew;
 
  if(!SelectedInstance || (SelectedInstance == \"\") ){
    theform.Instance.options.selectedIndex=0;
  }
  else {
    for (i = 0; i < theform.Instance.options.length;i++){
       if(theform.Instance.options[i].value==SelectedInstance){
         theform.Instance.options.selectedIndex=i;
         break;
        }
     }
  }
}

javaScript

my $submitFctEndLine = "";
if( isDebug ()) {
 $submitFctEndLine = "// theform.submit();";
}
else {
 $submitFctEndLine ="  theform.submit();";
}

if (isNewWebServer () ) {
print <<javaScript;
function Submit(form, cmdStr)
{
  theform = form;
  var Action ="/cgi-bin/tmsmsg_cgi?dest=";
  var SelectedInd=theform.TargetNode.selectedIndex;
  var target = theform.TargetNode.options[SelectedInd].value;
  var targlength = target.length;
  Action +=target;
  Action+="&cmd=";
  Action +=cmdStr;
  theform.method="POST";
  theform.action=Action;
  theform.ActionStr.value=Action;
  $submitFctEndLine 
}
javaScript
} else {
  print <<javaScript;
function Submit(form, cmdStr)
{
  theform = form;
  var Action ="/cgi-bin/lighthouse_";
  var SelectedInd=theform.TargetNode.selectedIndex;
  var target = theform.TargetNode.options[SelectedInd].value;
  var targlength = target.length;
  Action +=target;
  Action +="/dispatch";
  Action+="?rCmd=";
  Action +=cmdStr;
  theform.method="POST";
  theform.action=Action;
  theform.ActionStr.value=Action;
  $submitFctEndLine
}
javaScript

} 
print <<javaScript;
//End the hiding here. -->
</SCRIPT>
javaScript

#********call addform here
 addSelectorForm($cmdStr,$buttonName, $buttonImg, $formName); 
 
}


############################################################################
# Common functions to used in the LH Web-Control
############################################################################
sub getPID {
  my($procName,$instance) = @_;
  my(@retList) = ();
  my($retVal)  = "";
  if ($instance eq "") {
     $retVal = `/usr/ucb/ps -auxww | grep '${procName}' | grep -v grep | grep -v miniApp 2>&1`;
  } else {
### printf ("procName (getPID):${procName}:\n");
     $retVal = `/usr/ucb/ps -auxww | grep '${procName}' | grep -v grep | grep -v miniApp | grep $instance 2>&1`;
  }
  my(@lines) = split("\n",$retVal);
  my($aLine) = "";
  foreach $aLine (@lines) {
     $aLine =~ s/\s+/;/g;
### printf ("Line (${procName}):%s\n",$aLine);
     writeDebugMsg(sprintf ("Line:%s",$aLine));
     my(@lineParts) = split(";",$aLine);
	 my($user) = $lineParts[0];
	 my($pid)  = $lineParts[1];
	 my($uptimePos) = 0;
	 my($uptime)    = "";
	 my($procName)  = "";
	 my($error)     = $FALSE;
	 if ($lineParts[6] eq "S") {
	     $uptimePos = 7;
	 } elsif ($lineParts[5] eq "S") {
	     $uptimePos = 6;
	 } else {
	    writeDebugMsg(sprintf ("Unknown Format<BR>\n"));
		$error = $TRUE;
	 }
	 
	 if ($lineParts[$uptimePos] =~ /^[A-Za-z]/) {
	    $uptime = sprintf("%s %s",$lineParts[$uptimePos],$lineParts[$uptimePos+1]);
		$uptimePos++;
	 } else {
	    $uptime = $lineParts[$uptimePos];
	 }
	 $procName = $lineParts[$uptimePos + 3];
	 $procName =~ s/\./\//g;
	 my(@procNameParts) = split("/",$procName);
	 if ($procNameParts[1] ne "") {
	    my($len) = 0;   $len = @procNameParts;
		$procName = $procNameParts[$len - 2];
	    writeDebugMsg(sprintf ("Modify procName:%s:\n",$procName));
	 }
     writeDebugMsg(sprintf ("User:%s   PID:%s  Name:%s   Uptime:%s\n",$user,$pid,$procName,$uptime));
	 if (!$error) {
	   push(@retList,sprintf("${procName};${user};${uptime};${pid}"));
	 }
  }
  return @retList;
}

sub displayStatusLine {
  my($aStatusLine) = @_;
  my($linePart)    = "";
  my(@lineParts)   = split(";",$aStatusLine);
  printf("<TR>\n");
  foreach $linePart (@lineParts) {
	  printf("  <TD>${linePart}</TD>\n");
  }
  printf("</TR>\n");
}

sub displayStatusLines {
  my(@aStatusLines) = @_;
  my($aStatusLine)    = "";
  foreach $aStatusLine (@aStatusLines) {
	  displayStatusLine($aStatusLine);
  }
}

sub csfbDisplayError {
  displayError($msg);
}
############################################################################
# Often Used HTML Headers and trailors
############################################################################
sub csfbHtmlHeader {
  my($title,$subTitle) = @_;
  printf ("<HTML>\n");
  printf ("<HEAD>\n");
  printf (" <TITLE>%s</TITLE>\n",$title);
  printf (" <!-- Uses %s-->\n",getLibDescription());
  printf (" <!-- Uses %s-->\n",getAnyDescription("csfbPerlLib"));
  printf ("</HEAD>\n");
	    
print <<htmlHeader;
<BODY bgcolor="#FFFFFF" text="#000000" link="#0099CC" vlink="#0099CC" alink="#0099CC">
<P>
<A HREF="http://ny_webserv2.fir.fbc.com/listings/menu.map" TARGET="_top">
<IMG SRC="http://ny_webserv2.fir.fbc.com/gifs/globalgif/menu.toolbar.gif" alt="Menu Toolbar" border="0" width="613" height="57" ismap></A>&nbsp;
</P>
<HR>
htmlHeader
printf ("<CENTER><P><font size=\"5\" face=\"Arial\">%s %s</font></P>\n",$title,$subTitle);
}


sub simpleHtmlHeader {
  my($title,$subTitle,$showTitleForDetailView) = @_;
  $showTitleForDetailView = setDefault($showTitleForDetailView,$FALSE);

  printf ("<HTML>\n");
  printf ("<HEAD>\n");
  printf (" <TITLE>%s</TITLE>\n",$title);
  printf (" <!-- Uses %s-->\n",getLibDescription());
  printf (" <!-- Uses %s-->\n",getAnyDescription("csfbPerlLib"));
  if ($showTitleForDetailView) {
     printf ("<CENTER><P><font size=\"5\" face=\"Arial\">%s</font></P>\n",$subTitle);
  }
}

sub lhHtmlHeader {
  my($title,$subTitle) = @_;
  printf ("<HTML>\n");
  printf ("<HEAD>\n");
  printf (" <TITLE>%s</TITLE>\n",$title);
  printf (" <!-- Uses %s-->\n",getLibDescription());
  printf (" <!-- Uses %s-->\n",getAnyDescription("csfbPerlLib"));
  print <<jsHeader;  
  <SCRIPT language="Javascript">
<!--
var testVar = 0;

function initTitleBar() {
  devStatMsg = "Lighthouse & GPac Management tool"

   normal   = new MakeArray(1)
   over     = new MakeArray(1)
   statMsg  = new MakeArray(1)

   normal[0].src =  "${fuOv_0Gif}";
   over[0].src   = "${fuOv_1Gif}";
   statMsg[0]    = "Goto function overview"
}

function MakeArray(n) {
   this.length = n
   for (var i = 0; i<n; i++) {
       this[i] = new Image()
   }
   return this
}

function msover(num) {
   document.images[num+1].src = over[num].src 
   window.status = statMsg[num];
}

function msout(num) {
   document.images[num+1].src = normal[num].src
   window.status = devStatMsg;
}

//-->
</SCRIPT>
jsHeader

  
  printf ("</HEAD>\n");
	    
print <<lhHeader;
<BODY bgcolor="#FFFFFF" text="#000000" link="#0099CC" vlink="#0099CC" alink="#0099CC">
<SCRIPT>initTitleBar()</SCRIPT>

<P>
<IMG SRC="${logoGif}" alt="Menu Toolbar" border="0">
<A HREF="${cgiPathCommon}/index.pl" onmouseover="msover(0); return true" onmouseout="msout(0)"><IMG SRC="${fuOv_0Gif}" border="0"></A>
</P>
<HR>
lhHeader
printf ("<CENTER><P><font size=\"5\" face=\"Arial\">%s %s</font></P>\n",$title,$subTitle);
}


sub csfbHtmlTail {
my($MasterEmail) = @_;
if($MasterEmail eq ""){
  $MasterEmail = $gmmitWebMaster;
}
print <<htmlTail;

<HR>
</center>
<FONT size="2" face="Arial"><b>
<A HREF="http://ny_webserv2.fir.fbc.com/corporate/mmfx/" TARGET="_top">[MM/FX Home]</A>
<A HREF="http://intranet.csfb.com/lighthouse/gpac/entry.shtml" TARGET="_top">[GPac Index]</A>
</b></font>
<P>
 <i><Font size=2>Please send comments to <A HREF="mailto:$MasterEmail">Pagemaster</A>.<br></font></i>
</P>
</BODY>
</HTML>
htmlTail
}


sub lhHtmlTail {
my($MasterEmail)=@_;
if($MasterEmail eq ""){
  $MasterEmail = $gmmitWebMaster;
}
print <<lhTail;

<HR>
</CENTER>
<Font size=2>Please send comments to <A HREF="mailto:$MasterEmail">Pagemaster</A>.<br></font>
</BODY>
</HTML>
lhTail
}

sub tblHeader {
  my($locHtmlTitle,$locHtmlSubTitle) = @_;
  $locHtmlTitle    = setDefault($locHtmlTitle   ,$htmlTitle);
  $locHtmlSubTitle = setDefault($locHtmlSubTitle,$htmlSubTitle);
  $action  = getParam("Action","");
  if ($action ne "ShowDetail") {
   simpleHtmlHeader ($locHtmlTitle,$locHtmlSubTitle); 
    #lhHtmlHeader($locHtmlTitle,$locHtmlSubTitle);
    #addJSshowPage();
    #addJScommon();
  }
}

sub tblTail {
  my($MasterEmail)=@_;
 
  if ($action ne "ShowDetail") {
    lhHtmlTail($MasterEmail);
  } else {
    htmlTail();
  }
}
sub gmmitHeader {
  my($title,$subTitle,$showTitleForDetailView,$ssiPath) = @_;
  
  if ($ssiPath ne "") {
     $ssiDirPath =  $ssiPath;
  } 

  $action  = getParam("Action","");
  $showTitleForDetailView = setDefault($showTitleForDetailView,$FALSE);

  if (($action ne "ShowDetail") &&
      ($action ne "ForUploadingDb") &&
      ($action ne "UploadDb")) {
    printf ("<HTML>\n");
    printf ("<HEAD>\n");
    printf (" <TITLE>%s</TITLE>\n",$title);
    printf ("  <!-- Time now is %s -->\n", formatTimeStamp(getTimeStamp()));
    printf (" <!-- Uses %s-->\n",getLibDescription());
    printf (" <!-- Uses %s-->\n",getAnyDescription("csfbPerlLib"));
    printf (" <!-- Uses %s-->\n",getAnyDescription("tradeiqPerlLib"));
    readFile("${ssiDirPath}/menuDefinitionHead.inc",1,-1,$TRUE);
    readFile("${ssiDirPath}/bodyDefinition.inc",1,-1,$TRUE);
    readFile("${ssiDirPath}/menuDefinition.inc",1,-1,$TRUE);
	if ($subTitle ne "") {
	   printf ("<CENTER><H2>${subTitle}</H2>\n");
	}
  } else {
      simpleHtmlHeader($title,$subTitle,$showTitleForDetailView);
  }
}

sub gmmitNotAuthorizedHeader {
  my($title,$subTitle,$showTitleForDetailView) = @_;

  $action  = getParam("Action","");
  $showTitleForDetailView = setDefault($showTitleForDetailView,$FALSE);

  if (($action ne "ShowDetail") &&
      ($action ne "ForUploadingDb") &&
      ($action ne "UploadDb")) {
    printf ("<HTML>\n");
    printf ("<HEAD>\n");
    printf (" <TITLE>%s</TITLE>\n",$title);
    printf (" <!-- Uses %s-->\n",getLibDescription());
    printf (" <!-- Uses %s-->\n",getAnyDescription("csfbPerlLib"));
    printf (" <!-- Uses %s-->\n",getAnyDescription("tradeiqPerlLib"));
    readFile("${ssiDirPath}/menuDefinitionHead.inc",1,-1,$TRUE);
    readFile("${ssiDirPath}/bodyDefinition.inc",1,-1,$TRUE);
    readFile("${ssiDirPath}/menuDefinition.inc",1,-1,$TRUE);
	if ($subTitle ne "") {
	   printf ("<CENTER><H2>${subTitle}</H2>\n");
	}
  } else {
      simpleHtmlHeader($title,$subTitle,$showTitleForDetailView);
  }
  printf ("Only authorized user are allowed to enter!<BR>");
  printf ("If you need access to that page please contact the <A HREF=\"mailto:${gmmitWebMaster}\">Webmaster</A><BR><BR>");
  printf (" <FORM> <INPUT TYPE=BUTTON  VALUE=\"Back\" onClick=window.history.back()></FORM>\n");

}


sub gmmitTail {
  my($MasterEmail, $ssiPath) = @_;

  if ($ssiPath ne "") {
     $ssiDirPath =  $ssiPath;
 
   }

  $action  = getParam("Action","");
  if (($action ne "ShowDetail") &&
      ($action ne "ForUploadingDb") &&
      ($action ne "UploadDb")) {
     readFile("${ssiDirPath}/endHtmlDefinition.inc",1,-1,$TRUE);
  } else {
     htmlTail();
  }
}

############################################################################
# Function for Time and Date
############################################################################
%month_number = %monatNamesAbrevToNrE;
 
################################
# GeneratePreviousOrForwardDates                Uses Time::localtime, Time::Local 
############################### 
sub GeneratePreviousOrForwardDates{             # generates dates from 'start date'
  my($year,$month, $day, $offset) =@_;          # backwards if offset is negative
  my(@dates) =();                               # Start date is passed as YY ,MM, DD
  use Time::localtime;                          # returns an array of dates in format YYYYMMDD
  use Time::Local;
 
   $decreasing = 0;
 
  if($offset < 0){
   $offset = -$offset;
   $decreasing = 1;
  }
 
  for($count=0;$count <= $offset;$count++){
    $TIME = timelocal("","","",$day, $month, $year);
    if($decreasing == 1) {
      $TIME -= 60*60*24*$count;
    }
    else  {
       $TIME += 60*60*24*$count;
    }
    $tm= localtime($TIME) ;
    $NewDate = sprintf("%04d%02d%02d",$tm->year + 1900,$tm->mon+1,$tm->mday);
    $dates[$count] =   $NewDate;
  }
    return @dates;
}

###############################################
# Ftp functions  
###############################################
sub formatFtpDestination {
  my($ftpNodeLoc) = @_;
  my($retStr)     = $ftpNodeLoc;
  if (ref($ftpNodeLoc) eq 'ARRAY') {
      $retStr = makeStrFromArray(";",@$ftpNodeLoc);
  }
  return $retStr;
}

use Net::FTP;

sub ftpGetFiles {   # new ftp function
  my($remoteNode,$ftpUser,$ftpPwd,$remoteDir,@files) = @_;
  my($aFile) = "";
  my ($errFound) = $FALSE;
  my ($retMsg)   = "";

  print("Starting ftp!\n");
  $ftp = Net::FTP->new($remoteNode, Timeout=>$ftpTimeOut) or $errFound=$TRUE;
  if ($errFound)
  {
    $retMsg = "Can't connect: to $remoteNode $!";
    print  "${retMsg}\n";
    return "${retMsg}\n" ;
  }

  $ftp->login($ftpUser, $ftpPwd) or $errFound=$TRUE;
  if ($errFound)
  {
    $retMsg = "Can't login: to $remoteNode $!";
    print  "${retMsg}\n";
    return "${retMsg}\n" ;
  }

  $ftp->cwd($remoteDir) or $errFound=$TRUE;

  if ($errFound)
  {
    $retMsg = "Can't cd $remoteDir $! ";
    print  "${retMsg}\n";
    return "${retMsg}\n" ;
  }

  foreach $aFile (@files) {
    print("Getting $aFile\n");
    $ftp->get($aFile) or  $errFound=$TRUE;

     if ($errFound)
     {
       $errFound = $FALSE;
       $retMsg = "Can't get file $aFile $!";
       print  "${retMsg}\n";
     }

  }
  print("Done ftp!\n");
}

sub ftpGetFilesWithDestination {
  my($remoteNode,$ftpUser,$ftpPwd,$remoteDir,$destinationDir,$logFileName,$verbal,@files) = @_;
  my $errFound = $FALSE;
  my $retMsg   = "";

  $ftp = Net::FTP->new($remoteNode, Timeout=>$ftpTimeOut) or $errFound=$TRUE;
  if ($errFound) {
    $retMsg = "Can't connect: to $remoteNode $!";
    return "${retMsg}\n" ;
  }

  $ftp->login($ftpUser, $ftpPwd) or $errFound=$TRUE;
  if ($errFound) {
    $retMsg = "Can't login: to $remoteNode $!";
    return "${retMsg}\n" ;
  }

  $ftp->cwd($remoteDir) or $errFound=$TRUE;

  if ($errFound) {
    $retMsg = "Can't cd $remoteDir $! ";
    return "${retMsg}\n" ;
  }

  foreach my $aFile (@files) {
  	my $destFileName = "${destinationDir}/${aFile}";
    addToLogFile("  --> Getting new :${aFile}: -> :${destFileName}",$logFileName,$verbal);
    $ftp->get($aFile,$destFileName) or  $errFound=$TRUE;

    if ($errFound) {
       $errFound = $FALSE;
       $retMsg = "Can't get file $aFile $!";
       return "${retMsg}\n" ;
    }
  }
  return "";
}
 
sub ftpPutFilesSingleNode {   # new ftp function
  my($remoteNode,$ftpUser,$ftpPwd,$remoteDir,@files) = @_;
  my($aFile) = "";

  my ($errFound) = $FALSE;
  my ($retMsg)   = "";

  print("Starting ftp!\n");
  $ftp = Net::FTP->new($remoteNode, Timeout=>$ftpTimeOut) or $errFound=$TRUE;
  if ($errFound)
  {
    $retMsg = "Can't connect: to $remoteNode $!";
    print  "${retMsg}\n";
    return "${retMsg}\n" ;
  }

  $ftp->login($ftpUser, $ftpPwd) or $errFound=$TRUE;
  if ($errFound)
  {
    $retMsg = "Can't login: to $remoteNode $!";
    print  "${retMsg}\n";
    return "${retMsg}\n" ;
  }

  $ftp->cwd($remoteDir) or $errFound=$TRUE;

  if ($errFound)
  {
    $retMsg = "Can't cd $remoteDir $! ";
    print  "${retMsg}\n";
    return "${retMsg}\n" ;
  }

  foreach $aFile (@files) {
     print("Put $aFile\n");
     ftpSetMode($aFile,$ftp,$FALSE);
     $ftp->put($aFile) or $errFound=$TRUE;

     if ($errFound) # print error and try next file
     {
       $errFound = $FALSE;
       $retMsg = "Can't put file $aFile $!";
       print  "${retMsg}\n";
     }
 
  }

  $ftp->quit;
  print("Done ftp!\n");
}


sub ftpPutFiles {
  my($remoteNode,$ftpUser,$ftpPwd,$remoteDir,@files) = @_;
  return ftpCreateDirAndPutFiles($remoteNode,$ftpUser,$ftpPwd,$remoteDir,"",@files);
}

# That functions is similar to ftpPutFiles but processes "actions". This actions can be defined
# in commonControl on the ftpDir entries. If you define e.g. as an action "ftpCreateDailySubDir" than you need 
# to implement an function in your application with the following signature:
#
sub ftpCreateDailySubDir {
  my($mode,$remoteNode,$ftpUser,$remoteDir,$aFile,$ftpActionParameters) = @_;
  if ($mode eq "getFileName") {
      return removeFieldFromString("_",0,removeFieldFromString("_",0,getFileNameOutOfFullName($aFile),"NOT_FOUND"),"NOT_FOUND");
  } elsif ($mode eq "getDirName") {
      if ($ftpRemoteDailyDir ne "") {
         return $ftpRemoteDailyDir;
      } else {
         return getFieldFromString("_",0,getFileNameOutOfFullName($aFile),"NOT_FOUND");
      }
  } else {
     return "";
  }
}

sub ftpUseFileNameMappingTable {
  my($mode,$remoteNode,$ftpUser,$remoteDir,$aFile,$ftpActionParameters) = @_;
  my(@parameterList) = split(" ",$ftpActionParameters);
  if ($mode eq "getFileName") {
      # reading mapping table
      my %mappingHash = convertArrayMappingTblToHashMappingTbl("-->",setListFromCommonControl($APP_INFO{$parameterList[0]}));
      my $remoteFilename = $mappingHash{getFileNameOutOfFullName($aFile)};
      if ($remoteFilename eq "") {
         if ($parameterList[2] eq "UseLocalFileNameAsDefaultForRemoteFileName") {
             return getFileNameOutOfFullName($aFile);
         } else {
             return "DoNotFtpThatFile";
         }
      } else {
         return $remoteFilename;
      }
  } elsif ($mode eq "getDirName") {
      if ($parameterList[1] eq "CreateDailyDir") {
         return $ftpRemoteDailyDir;
      } else {
         return "";
      }
  } else {
     return "";
  }
}

sub ftpCreateDirAndPutFiles {
  my($remoteNode,$ftpUser,$ftpPwd,$remoteDir,$ftpAction,@files) = @_;

  # saved global variable
  my $ftpActionParametersSave = $ftpActionParameters;

  if (ref($remoteNode) ne 'ARRAY') {
     $ftpActionParameters = "";
  } else {
     my(@ftpActionParametersEmtyArray) = ();
     $ftpActionParameters =  \@ftpActionParametersEmtyArray;
  }
  my $retVal = ftpCreateDirAndPutFilesWithActionParameter($remoteNode,$ftpUser,$ftpPwd,$remoteDir,$ftpAction,$ftpActionParameters,@files);

  # restored global variable
  $ftpActionParameters = $ftpActionParametersSave;
  return $retVal
}

# possible value in the commonControl
#
# ./ ftpUseFileNameMappingTable Arg10 CreateDailyDir NotUseLocalFileNameAsDefaultForRemoteFileName RemoveHeaderLines
# ./ ftpUseFileNameMappingTable Arg7 NotUseLocalFileNameAsDefaultForRemoteFileName RemoveHeaderLines
# ./ ftpCreateDailySubDir RemoveHeaderLines
#
# Example of Arg10:
# ${gmmLastTradingDate}_ZH_buc_fra1.flt --> Filter:Arg9 lf2gctfs${gmmLastTradingDate}_filtered.data ==> lf2gctfs${gmmLastTradingDate}_filtered.data_done
# ${gmmLastTradingDate}_ZH_buc_fra1.flt --> ColumnFilter:Arg19 lf2gctfs${gmmLastTradingDate}_filtered.data ==> lf2gctfs${gmmLastTradingDate}_filtered.data_done
# ${gmmLastTradingDate}_ZH_buc_fra1.flt --> Compress:lf2gctfs${gmmLastTradingDate}.data.gz ==> lf2gctfs${gmmLastTradingDate}.gz.data_done
#
# Example of Arg9:
# select * from FILE where TRADING_BOOK=FRAFUT OR TRADING_BOOK=FRA
#
# Example of Arg19:
# buc_commloan  : !(dealer_code, branch_code)
# buc_swap1     : deal_state, deal_start_date

$ftpMaxTriesAfterError = 10;
$ftpWaitTimeForNextTryAfterError =300;


	 
sub isFtpModeBin {
   my($filename,$verbal) = @_;
   $verbal = setDefault($verbal,$FALSE);

   my @bin_Mode = (
	    "gz",
	    "gif",
	    "pdf",
	    "jpeg",
	    "tar",
   );
   my $extension = lc(getFileNameExtension($filename));
   if (foundInArray($extension,@bin_Mode)) {
   	   return $TRUE;
   } else {
   	   return $FALSE;
   }
}

sub ftpSetMode {
	 my($filename,$ftpHandle,$verbal) = @_;
	 $verbal = setDefault($verbal,$FALSE);
	 
   if (isFtpModeBin($filename,$verbal)) {
       $ftpHandle->type("I");
       if ($verbal) { print("Filename is:${filename} Set transfer mode to bin\n"); };
   } else {
       $ftpHandle->type("A");
       if ($verbal) { print("Filename is:${filename} Set transfer mode to ascii\n"); };
	 }
}

sub ftpCreateDirAndPutFilesWithActionParameter {
  my($remoteNode,$ftpUser,$ftpPwd,$remoteDir,$ftpAction,$ftpActionParameters,@files) = @_;
  $ftpCreateDirAndPutFiles_doDebug = $FALSE;
  my $aFile  = "";
  my $retStr = "";

  if (ref($remoteNode) ne 'ARRAY') {
    if (($ftpAction eq "ConvertToExcel") || 
        ($ftpAction eq "RemoveHeaderLines") || 
        ($ftpAction eq "RemoveHeaderLine")) {
      $ftpActionParameters = $ftpAction;
      $ftpAction = "";
    }

    if ($ftpCreateDirAndPutFiles_doDebug) {
       printf("\n\nremoteNode:${remoteNode}:\n");
       printf("ftpUser:${ftpUser}:\n");
       printf("ftpPwd:${ftpPwd}:\n");
       printf("remoteDir:${remoteDir}:\n");
       printf("ftpAction:${ftpAction}:\n");
       printf("ftpActionParameters:${ftpActionParameters}:\n");
       printf("files to ftp....\n");
       displayArray(@files);
    }

	my $transferMedia = "ftp";
	
	# check if Filebroker is used!
	if (index(strip(uc($remoteNode)),$filebrokerMarker) ne -1) {
    	$countOfProc = "";
    	$remoteNode = strip(uc($remoteNode));
    	$filebrokerDir = $remoteDir;
    	if (index($remoteNode,":") > 0) {
    		($remoteNode,$countOfProc) = split(":",$remoteNode);
    	}
		$transferMedia = $filebrokerMarker;
	}

	# check if Filecopy is used!
	if (index(strip(uc($remoteNode)),$filecopyMarker) ne -1) {
    	$countOfProc = "";
    	$remoteNode = strip(uc($remoteNode));
    	$filebrokerDir = $remoteDir;
    	if (index($remoteNode,":") > 0) {
    		($remoteNode,$countOfProc) = split(":",$remoteNode);
    	}
		$transferMedia = $filecopyMarker;
	}

	my $localFtpErrorMsg = "";
	my $ftpErrorTries = 0;
	my $triesLeft = $ftpMaxTriesAfterError;
	my $ftp = "";
	### if (index(strip(uc($remoteNode)),$filebrokerMarker) eq -1)	{
	if ($transferMedia eq "ftp")	{
        do {
          $localFtpErrorMsg = "";
          $ftp = Net::FTP->new($remoteNode, Timeout=>$ftpTimeOut)    or $localFtpErrorMsg = "Can't connect to :${remoteNode}: $@";
          if ($localFtpErrorMsg eq "") { 
            $ftp->login($ftpUser, $ftpPwd)       or $localFtpErrorMsg = "Couldn't login using (${ftpUser}/${ftpPwd}) $!";
    
            if ($localFtpErrorMsg eq "") {
              $ftp->cwd($remoteDir)                or $localFtpErrorMsg = "Couldn't change to directory :${remoteDir}: $!";
            }
            
          }
          $ftpErrorTries++;
          if ($localFtpErrorMsg ne "") { 
             $triesLeft = $ftpMaxTriesAfterError - $ftpErrorTries;
             my $errorMsgLocal = "Problem in ftp to ${remoteNode}! Wait ${ftpWaitTimeForNextTryAfterError}s for next try. ${triesLeft} tries left";
             if ($triesLeft <= 0) {
                $errorMsgLocal = "Problem in ftp which could not be resolved by waiting";
                addToLogFile("ERROR: ${localFtpErrorMsg}",getLogfileName(),$verbal);
                addToLogFile("ERROR: ${errorMsgLocal}",getLogfileName(),$verbal);
             } else {
                addToLogFile("WARNING: ${localFtpErrorMsg}",getLogfileName(),$verbal);
                addToLogFile("WARNING: ${errorMsgLocal}",getLogfileName(),$verbal);
             }
             if ($triesLeft > 0) {
                sleep($ftpWaitTimeForNextTryAfterError);
             }
          }
    
        } until (($triesLeft <= 0) || ($localFtpErrorMsg eq ""));
        if ($localFtpErrorMsg ne "") {
           return addToLogfileAndNotifyForError($localFtpErrorMsg);
        }
        if ($ftpErrorTries > 1) {
           addToLogFile("Problem in ftp could be resolved by waiting",getLogfileName(),$verbal);
        }



        if ($ftpAction ne "") {
           my $dirName = &$ftpAction("getDirName",$remoteNode,$ftpUser,$remoteDir,"",$ftpActionParameters);
           if ($dirName ne "") {
             my $retVal = $ftp->mkdir($dirName, $FALSE);
             $ftp->cwd($dirName);
           }
        }
        if (!$FtpSilent ) {
           addToLogFile("   ",getLogfileName(),$verbal);
           addToLogFile("Ftp node:${remoteNode}:  ftpAction:${ftpAction}:",getLogfileName(),$verbal);
           addToLogFile("FtpDir:".$ftp->pwd().":",getLogfileName(),$verbal);
        }
    }

    my $aDestName      = "";
    my $aFinalDestName = "";
    my $fileToFtp      = $aFile;
    my $filterStr      = "";
    my $doCompress     = $FALSE;
    my $j = 0;
    if ($remoteNode eq $filebrokerMarker) {
      	if (!$FtpSilent ) {
           addToLogFile("   ",getLogfileName(),$verbal);
           addToLogFile("Ftp node:${filebrokerMarker}:  ftpAction:${ftpAction}:",getLogfileName(),$verbal);
        }
    } 
    if ($remoteNode eq $filebcopyMarker) {
      	if (!$FtpSilent ) {
           addToLogFile("   ",getLogfileName(),$verbal);
           addToLogFile("Filesystem copy:${filecopyMarker}:  ftpAction:${ftpAction}:",getLogfileName(),$verbal);
        }
    } 
    my @sourceFileList           = ();
    my @destinationFileList      = ();
    my @finalDestinationFileList = ();
    
    foreach $aFile (@files) {
	  my $filterType  = "";
      $aDestName      = "";
      $aFinalDestName = "";
      $fileToFtp      = $aFile;
      $filterStr      = "";
      $doCompress     = $FALSE;
      
      if ($ftpAction ne "") {
         $aDestName = &$ftpAction("getFileName",$remoteNode,$ftpUser,$remoteDir,$aFile,$ftpActionParameters);
         my(@destFiles) = split("==>",$aDestName);
         $aDestName      = strip($destFiles[0]);
         if (index($aDestName,"Filter:") == 0 ) {
		    $filterType = "Filter:";
            $aDestName = strip(substr($aDestName,length("Filter:")));
            my @parts = split(" ",$aDestName);
            $filterStr = $APP_INFO{$parts[0]};
            $filterStr =~ s/\<BR\>/ /g;     
            $aDestName = $parts[1];
         } elsif (index($aDestName,"ColumnFilter:") == 0 ) {
		 	$filterType = "ColumnFilter:";
            $aDestName = strip(substr($aDestName,length("ColumnFilter:")));
            my @parts = split(" ",$aDestName);
            $filterStr = $APP_INFO{$parts[0]};     
            $aDestName = $parts[1];
         } elsif (index($aDestName,"Compress:") == 0 ) {
		 	$filterType = "Compress:";
            $aDestName = strip(substr($aDestName,length("Compress:")));
            $doCompress     = $TRUE;
         } 
         $aFinalDestName = strip($destFiles[1]);
      }

      # check if flt files has to be filtered before it is ftp to destination     
      if ($filterStr ne "") {
        if ((!$FtpSilent) && ($aDestName ne "DoNotFtpThatFile")) {
           addToLogFile("   ---> Filter ${aFile}!",getLogfileName(),$verbal);
        }
        $fileToFtp = "${aFile}_filteredXXXX";

        my $whereClause = "";
        my $sortedBy    = "";
        my $distinct    = $FALSE;
        my(@columns)    = ();

        if ($filterType eq "Filter:") {
		   ($distinct,$whereClause,$sortedBy,@columns) = getParametersFromSelectString($filterStr);
			selectFromFltToOtherFlt($aFile,$fileToFtp,"",$whereClause,$sortedBy,$distinct,@columns);
		} elsif ($filterType eq "ColumnFilter:") {
		    # print("\n\nfilterTypexxx:${filterType}:\n");
			my $filterEntry = "";
			my @fileHeaderList = getTableHeaderAsArray($aFile);
		    @columns = setListFromCommonControlRemoveComments($filterStr,$TRUE);
			my $fileNamePattern = getFilenameWithoutExtension(getFileNameOutOfFullName($aFile));
			$fileNamePattern = substr($fileNamePattern,12,length($fileNamePattern));
			@columns = selectFromArray($fileNamePattern,$TRUE,@columns);
			my $countII = @columns;
			if ($countII != 1) {
			   print("csfbPerlLib Warning (ftpCreateDirAndPutFilesWithActionParameter):${countII} != 0 :\n");
			}
			my $columnsNotToInclude = $FALSE;
			if ($countII gt 0) {
				$filterEntry = $columns[0];
				my(@parts) = split(":",$filterEntry);
				$filterEntry = strip($parts[1]);
				if ($filterEntry =~ /^!\(/) {
				   $columnsNotToInclude =  $TRUE;
				   $filterEntry = substr($filterEntry,2,length($filterEntry) - 3);
				   # print("filterEntry:${filterEntry}:\n");
				   @columns = trimArray(split(",",$filterEntry));
				   addToLogFile("   ---> Exclude columns: ${filterEntry}",getLogfileName(),$verbal);
				   # print("fileHeaderList\n");
				   # displayArray(@fileHeaderList);
				   # print("columns\n");
				   # displayArray(@columns);
				   my @tmpList = getExclutionOfArrays(\@fileHeaderList,\@columns);
				   # print("tmpList\n");
				   # displayArray(@tmpList);
				   @columns = @tmpList;
				} else {
				   @columns = trimArray(split(",",$filterEntry));
				   addToLogFile("   ---> Only columns: ${filterEntry}",getLogfileName(),$verbal);
				}
			}
			# print("columns\n");
			# displayArray(@columns);
		    selectFromFltToOtherFlt($aFile,$fileToFtp,"","","",$distinct,@columns);
		    # print("Columnfilter!!!!\n");
		}
        $aFile = $fileToFtp;
      }

      # check if flt file has to be converted in an xls (TAB separated file)
      if (index($ftpActionParameters,"ConvertToExcel") != -1) {
        if ((!$FtpSilent) && ($aDestName ne "DoNotFtpThatFile")) {
           addToLogFile("  --> Convert to Excel (TAB separated) file",getLogfileName(),$verbal);
        }
        convertFLT_to_XLS($aFile,setNewFilenameExtension($aFile,"xls"));
        $aFile = setNewFilenameExtension($aFile,"xls");
        $fileToFtp = $aFile;
      }

      # check if header has to be removed
      if (index($ftpActionParameters,"RemoveHeaderLines") != -1) {
        if ((!$FtpSilent) && ($aDestName ne "DoNotFtpThatFile")) {
           addToLogFile("  --> Remove Header Lines",getLogfileName(),$verbal);
        }
        $fileToFtp = "${aFile}_NoHead";
        writeArrayToFile($fileToFtp,$FALSE,readFile($aFile,3));
      } elsif (index($ftpActionParameters,"RemoveHeaderLine") != -1) {
        if ((!$FtpSilent) && ($aDestName ne "DoNotFtpThatFile")) {
           addToLogFile("  --> Remove Header Line",getLogfileName(),$verbal);
        }
        $fileToFtp = "${aFile}_NoHead";
        writeArrayToFile($fileToFtp,$FALSE,readFile($aFile,2));
      } 


      if (!$FtpSilent ) {
        if ($aDestName eq "DoNotFtpThatFile") {
           addToLogFile("  --> Not ftp ".getFileNameOutOfFullName($aFile)."! It is set to DoNotFtpThatFile",getLogfileName(),$verbal);
        }
      }

      if ($doCompress) {
      	 addToLogFile("  --> Compress ${fileToFtp}",getLogfileName(),$verbal);
      	 my $orgFilename = $fileToFtp;
      	 `cp ${orgFilename} ${orgFilename}_backup`; 
         $fileToFtp = compressBigFile($fileToFtp,"0",getLogfileName(),$verbal);
         `mv ${orgFilename}_backup ${orgFilename} `; 
      }      
      
      if ($aDestName eq "DoNotFtpThatFile") {
      	  addToLogFile("  --> ".getFileNameOutOfFullName($aFile)."! was not ftp because it was set to DoNotFtpThatFile",getLogfileName(),$verbal);
      } else {
      	  push(@sourceFileList,           $fileToFtp);
      	  push(@destinationFileList,      $aDestName);
      	  push(@finalDestinationFileList, $aFinalDestName);
      }
      $j++;
    } # end of for loop through file list

#    displayArray(@sourceFileList);           print("\n");
#    displayArray(@destinationFileList);      print("\n");
#    displayArray(@finalDestinationFileList); print("\n");
#    
#    halt();

	if ($remoteNode eq $filebrokerMarker) {
		addToLogFile("  --> Use ${countOfProc} multi-tasks to send files to filebroker",getLogfileName(),$verbal);
		my @sourceFileListParameter = ();
		my $countOfFiles = @sourceFileList;
		for (my $i =0; $i < $countOfFiles; $i++) {
			my $tempFinalDestName = "";
			if ($finalDestinationFileList[$i] ne "") {
				$tempFinalDestName = $finalDestinationFileList[$i];
			} elsif ($destinationFileList[$i] ne "") {
				$tempFinalDestName = $destinationFileList[$i];
			}
			if ($tempFinalDestName ne "") {
				push(@sourceFileListParameter,$sourceFileList[$i]."==>".$tempFinalDestName);
			} else {
				push(@sourceFileListParameter,$sourceFileList[$i]);
			}
		}
		sendFilesToFileBroker($countOfProc,\@sourceFileListParameter,getLogfileName(),$verbal);
	} elsif (($remoteNode eq $filecopyMarker)) {
		addToLogFile("  --> Regular filecopy!!!",getLogfileName(),$verbal);
		my $remoteSubDirName = &$ftpAction("getDirName",$remoteNode,$ftpUser,$remoteDir,"",$ftpActionParameters);
		my @sourceFileListParameter = ();
		my $countOfFiles = @sourceFileList;
		my $unixCmd = "";
		if ($remoteSubDirName ne "") {
			addToLogFile("CreateDir:${remoteSubDirName}: in :${remoteDir}:",getLogfileName(),$verbal);
			mkUnixDir($remoteSubDirName,$remoteDir);
			$remoteSubDirName = $remoteSubDirName."/";
		}
		$remoteDir = "${remoteDir}/${remoteSubDirName}";
		
		addToLogFile("Filecopy to:${remoteDir}",getLogfileName(),$verbal);
		# addToLogFile("--->ftpAction:${ftpAction}:",getLogfileName(),$verbal);
		# addToLogFile("--->ftpActionParameters:${ftpActionParameters}:",getLogfileName(),$verbal);
		# addToLogFile("--->finalDestinationFile:${finalDestinationFile}:",getLogfileName(),$verbal);
		# addToLogFile("--->remoteSubDirName:${remoteSubDirName}:",getLogfileName(),$verbal);
		for (my $i =0; $i < $countOfFiles; $i++) {
			my $aFtpActions = $FtpActions[$i];
			my $aFtpActionParameters = $FtpActionParameters[$i];

			my $tempFinalDestName = "";
			if ($finalDestinationFileList[$i] ne "") {
				$tempFinalDestName = $finalDestinationFileList[$i];
			} elsif ($destinationFileList[$i] ne "") {
				$tempFinalDestName = $destinationFileList[$i];
			}
			if ($tempFinalDestName ne "") {
				$unixCmd = "cp ".$sourceFileList[$i]." ${remoteDir}".$tempFinalDestName;
			} else {
				$unixCmd = "cp ".$sourceFileList[$i]." ${remoteDir}".$sourceFileList[$i];
			}
			
			addToLogFile("-->${unixCmd}",getLogfileName(),$verbal);
			my $retMsg = `${unixCmd}`;
			if ($retMsg ne "") {
				addToLogFile("WARNING:${retMsg}",getLogfileName(),$verbal);
			}
		}
		addToLogFile("   ",getLogfileName(),$verbal);
	} else {
		my $errorMsg = transferFilesViaFtp(\@sourceFileList,\@destinationFileList,\@finalDestinationFileList,$ftpMaxTriesAfterError,$ftpWaitTimeForNextTryAfterError,$ftp,getLogfileName(),$verbal);
		$ftp->quit or return addToLogfileAndNotifyForError("Couldn't close ftp connection: $!");
	}
 } else {
	my(@FtpNodes)              = derefAref($remoteNode);
	my(@FtpDirs)               = derefAref($remoteDir);
	my(@FtpPasswords)          = derefAref($ftpPwd);
	my(@FtpLogins)             = derefAref($ftpUser);
	my(@FtpActions)            = derefAref($ftpAction);
	my(@FtpActionParameters)   = derefAref($ftpActionParameters);
	my $NumberofNodes          = $#FtpNodes;
 
	if (!$FtpSilent ) {
		addToLogFile("Possible multiple distribution targets\n",getLogfileName(),$verbal);
	} 
	for (my $i = 0; $i <= $NumberofNodes; $i++) {
		$retStr = $retStr . ftpCreateDirAndPutFilesWithActionParameter($FtpNodes[$i],$FtpLogins[$i],$FtpPasswords[$i],$FtpDirs[$i],$FtpActions[$i],$FtpActionParameters[$i],@files);
	}
  }
  return $retStr;
}

sub transferFileViaFtp {
  my($sourceFile,$destinationFile,$finalDestinationFile,$maxTriesInErrorCase,$waitTimeForNextTry,$ftpHanlder,$logFileName,$verbal) = @_;

  my $ftpErrorTries = 0;
  
  do {
     my $localFtpErrorMsg = "";
     addToLogFile("  --> Put ${sourceFile} ${destinationFile}",$logFileName,$verbal); 
     ftpSetMode($sourceFile,$ftpHanlder,$FALSE);  
     if ($destinationFile eq "") {
         $ftpHanlder->put($sourceFile) or $localFtpErrorMsg = "Couldn't put ${sourceFile} to ${destinationFile} $!";
     } else {
         $ftpHanlder->put($sourceFile,$destinationFile) or $localFtpErrorMsg = "Couldn't put ${sourceFile} to ${destinationFile} $!";
     }
     $ftpErrorTries++;
     if ($localFtpErrorMsg ne "") { 
        my $triesLeft = $maxTriesInErrorCase - $ftpErrorTries;
        my $errorMsgLocal = "Problem in ftp! Wait ${ftpWaitTimeForNextTryAfterError}s for next try. ${triesLeft} tries left";
        if ($triesLeft <= 0) {
            $errorMsgLocal = "Problem in ftp which could not be resolved by waiting";
            addToLogFile("ERROR: ${localFtpErrorMsg}",$logFileName,$verbal);
            addToLogFile("ERROR: ${errorMsgLocal}",$logFileName,$verbal);
        } else {
            addToLogFile("WARNING: ${localFtpErrorMsg}",$logFileName,$verbal);
            addToLogFile("WARNING: ${errorMsgLocal}",$logFileName,$verbal);
        }
        if ($triesLeft > 0) {
            sleep($waitTimeForNextTry);
        }
     }
    
   } until (($triesLeft <= 0) || ($localFtpErrorMsg eq ""));
   if ($localFtpErrorMsg ne "") {
       return addToLogfileAndNotifyForError("ERROR: ${localFtpErrorMsg}");
   }          
   if ($ftpErrorTries > 1) {
       addToLogFile("Problem in ftp could be resolved by waiting",$logFileName,$verbal);
   }
    
   if ($finalDestinationFile ne "") {
       addToLogFile("  --> ftp rename ${destinationFile}  --> ${finalDestinationFile}!",$logFileName,$verbal);
       $ftpHanlder->rename($destinationFile,$finalDestinationFile);
   }
   return "";
}

sub transferFilesViaFtp {
  my($refToSourceFileList,$refToDestinationFileList,$refToFinalDestinationFileList,$maxTriesInErrorCase,$waitTimeForNextTry,$ftpHanlder,$logFileName,$verbal) = @_;
  
  my @sourceFileList = @$refToSourceFileList;
  my $countOfFiles   = @sourceFileList;
  my $errorMsg       = "";
  
  for (my $i =0; $i < $countOfFiles; $i++) {
  	 $errorMsg = transferFileViaFtp($refToSourceFileList->[$i],$refToDestinationFileList->[$i],$refToFinalDestinationFileList->[$i],$maxTriesInErrorCase,$waitTimeForNextTry,$ftpHanlder,$logFileName,$verbal);
  	 if ($errorMsg ne "") { return $errorMsg; }
  }
  return "";
}

sub ftpFilePutOrGet {
  my($filename,$destNode,$descDir,$ftpUser,$ftpPwd,$sourceDir,$doPut) = @_;
  my($retStr) = "";
  my $ftp = Net::FTP->new($destNode, Timeout=>$ftpTimeOut) or return "Error: can't connect: $@\n";
  $ftp->login($ftpUser, $ftpPwd) or return "Error: couldn't login to $destNode\n";
  $ftp->cwd($descDir) or return "Error: couldn't change directory to $descDir on $destNode\n" ;
  if ($doPut) {
  	 ftpSetMode($filename,$ftp,$FALSE);           
     $ftp->put("${localDir}/${filename}") or return  "Error: couldn't put $filename to $descDir on $destNode\n ";
     $retStr = sprintf("${filename} transfered to $descDir on ${destNode}\n");
  } else {
     $ftp->get("${localDir}/${filename}") or return "Error: couldn't get $filename\n";
     $retStr = sprintf("ftp (get) ${filename} from ${destNode}\n");
  }
  return $retStr;
}

# returns "" if it was succesfull
sub ftpCreateDir {
  my($remoteNode,$ftpUser,$ftpPwd,$remoteDir) = @_;

  my $ftp = Net::FTP->new($remoteNode, Timeout=>$ftpTimeOut) or return "Error: can't connect: $@\n";
  $ftp->login($ftpUser, $ftpPwd) or return "Error: couldn't login to $destNode! $!\n";
  my $retVal = $ftp->mkdir($remoteDir, $TRUE); # creates directory hirachicaly
  if ($retVal eq $remoteDir) {
     return "";
  } else {
     return $retVal;
  }
}

############################################################################
# common  html functions 
############################################################################

# displaySelectObject creates html list box with any additional $options
# takes an array reference as $listRef parameter 
# if $selectedStr is "All" then all of the items in the box are selected
# $selectedStr can be also arrayRef

sub displaySelectObject {
  my($size,$widgetName,$selectedStr, $options,$listRef) = @_;
  my( @aList)= derefAref ($listRef);
  my (@selectedValues) = ();

  if (ref($selectedStr) eq 'ARRAY') {
    @selectedValues = @$selectedStr;
  }
  my($aField)   = "";
  if (length($size)        == 0) {$size        = "1"; }
  if (length($widgetName)  == 0) {$widgetName  = ""; }
  if (length($selectedStr) == 0) {$selectedStr = ""; }
 
  printf ("<SELECT NAME=\"%s\" %s size=\"%s\">\n",$widgetName, $options, $size);
  foreach $aField (@aList) {
     if ($selectedStr eq $aField || $selectedStr eq "All" 
           || foundInArray( $aField,@selectedValues)) {
         printf ("   <OPTION VALUE=\"%s\" SELECTED>%s\n",$aField,$aField);
     } else {
        printf ("   <OPTION VALUE=\"%s\">%s\n",$aField,$aField);
     }
  }
  printf ("</SELECT>\n");
}


############################################################################
# common  db functions 
############################################################################

# returns username, password
# e.g.
#   my($dbUserName,$dbPassword) = getDbUser_PasswordFromEnv("IQ_DBLOGON");
#
sub getDbUser_PasswordFromEnv {
	my($envName) = @_;
	my $dbloginStr     = $ENV{$envName};
	my @LoginPassword  = split("/", $dbloginStr);
	return @LoginPassword;
}

sub dbPackageExists {
	my($dbName, $dbUser, $dbPassword, $packageName) = @_;
	my $retVal = $FALSE;
	if (($tables eq "") && (index($dbUser,"/") != -1)) {
		my(@loginPassword) = split("/",$dbUser);
		$tables     = $dbPassword;
		$dbUser     = $loginPassword[0];
		$dbPassword = $loginPassword[1];
	}
	## printf("Try to connect to :$dbName: :$dbUser: :$dbPassword: to find :$tables:\n");
	my $dbh = dbConnect($dbName,$dbUser,$dbPassword,"",,$FALSE,$TRUE);
	if (!($ERROR_FOUND)) { 
		## printf("....conected\n");
		$retVal = dbPackageExists_dbh($dbh, $packageName);
		$dbh->disconnect();
	} else {
		### printf("dbTablesExists could not connect to dB\n");
	}
	return $retVal;
}

sub dbPackageExists_dbh {
	my($dbh,$packageName) = @_;
	$packageName = uc($packageName);
	my $aSql = qq {
		SELECT * 
		FROM user_objects 
		WHERE object_name='${packageName}' and status='VALID' and OBJECT_TYPE='PACKAGE BODY'
	};
	## printf("aSql:\n${aSql}\n");
	my $sth = $dbh->prepare($aSql);
	my @queryResultRef = dbExecutePreparedSelectSttmnt($sth);
	my $anzRes = @queryResultRef;
	if ($anzRes == 1) {
		return $TRUE;
	} else {
		return $FALSE;
	}
}

sub dbTablesExists {
	my($dbName, $dbUser, $dbPassword, $tables) = @_;
	my $retVal = $FALSE;
	if (($tables eq "") && (index($dbUser,"/") != -1)) {
		my(@loginPassword) = split("/",$dbUser);
		$tables     = $dbPassword;
		$dbUser     = $loginPassword[0];
		$dbPassword = $loginPassword[1];
	}
	## printf("Try to connect to :$dbName: :$dbUser: :$dbPassword: to find :$tables:\n");
	my $dbh = dbConnect($dbName,$dbUser,$dbPassword,"",,$FALSE,$TRUE);
	if (!($ERROR_FOUND)) { 
		## printf("....conected\n");
		$retVal = dbTablesExists_dbh($dbh, $tables);
		$dbh->disconnect();
	} else {
		### printf("dbTablesExists could not connect to dB\n");
	}
	return $retVal;
}

sub dbTablesExists_dbh {
	my($dbh,$tables) = @_;
	$tables = uc($tables);
	my $retVal = $TRUE;
	my %aResHash    = dbBuildHash_dbh($dbh,"cat","TABLE_NAME","TABLE_TYPE","",$FALSE);
	my @tableNames  = split(",",$tables);
	my $aTabName    = "";
	foreach $aTabName (@tableNames) {
		if (!(exists($aResHash{$aTabName}))) {
			$retVal = $FALSE;
			## printf("db table :${aTabName}: not exists\n");
		}
	}
	return $retVal;
}

sub getFieldNamesFromTbl {
	my ($database,$login,$password,$tableName) = @_;
	my $tradeIQ_dbHandler = dbConnect($database,$login,$password);
	my @retValues = getFieldNamesFromTbl_dbh($tradeIQ_dbHandler,$tableName);
	dbDisconnect($tradeIQ_dbHandler);
	return @retValues;
}

sub getFieldNamesFromTbl_dbh {
	my($dbh,$tableName) = @_;
	my %dbNameTypeHash = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_TYPE",   "TABLE_NAME='${tableName}'");
	my @retValues = keys %dbNameTypeHash;  
	return @retValues;
}

sub isFieldExistsInTable {
	my($database,$login,$password,$tableName,$fieldName) = @_;
	my $tradeIQ_dbHandler = dbConnect($database,$login,$password);
	my $retVal = isFieldExistsInTable_dbh($tradeIQ_dbHandler,$tableName,$fieldName);
	dbDisconnect($tradeIQ_dbHandler);
	return $retVal;
}

sub isFieldExistsInTable_dbh {
	my($dbh,$tableName,$fieldName) = @_;
	my @fieldNames = getFieldNamesFromTbl_dbh($dbh,$tableName);
	return foundInArrayWithCase($fieldName,$FALSE,@fieldNames);
}


sub getFieldsFromDB {
	my ($database, $login, $password, $tableName, $fieldName, $whereClause) = @_;
	my $tradeIQ_dbHandler = dbConnect($database,$login,$password);
	my @retValues = getFieldsFromDB_dbh($tradeIQ_dbHandler,$tableName,$fieldName,$whereClause);
	dbDisconnect($tradeIQ_dbHandler);
	return @retValues;
}

sub getFieldsFromDB_dbh {
	my($dbh, $tableName, $fieldName, $whereClause) = @_;
	if ($whereClause ne "") { $whereClause = "where ${whereClause}"; }
  
	my @retValues = ();
	my $sql = "select ${fieldName} from ${tableName} ${whereClause}";
	my $preparedSql = $dbh->prepare($sql);
	my @itemsRef = dbExecutePreparedSelectSttmnt($preparedSql);
  
	foreach my $itemRef (@itemsRef) {
		push(@retValues,$itemRef->{uc($fieldName)});
	}
	return  @retValues;
}

sub getRowCountFromTbl {
	my ($database,$login,$password,$tableName,$whereClause) = @_;
	my $tradeIQ_dbHandler = dbConnect($database,$login,$password);
	my $retVal = getRowCountFromTbl_dbh($tradeIQ_dbHandler,$tableName,$whereClause);
	dbDisconnect($tradeIQ_dbHandler);
	return $retVal;
}

sub getRowCountFromTbl_dbh {
	my($dbh,$tableName,$whereClause) = @_;
	my @ResultRef = ();
	my $count = 0;
  
	my $sqlToGetRowCountFromTbl_dbh = qq {
		select count(*) COUNT
		from   ${tableName} ${whereClause}
	};
	my $prepared_sqlToGetRowCountFromTbl_dbh = $dbh->prepare($sqlToGetRowCountFromTbl_dbh);
	@ResultRef = dbExecutePreparedSelectSttmnt($prepared_sqlToGetRowCountFromTbl_dbh);
	if (@ResultRef[0]) {
		$count = @ResultRef[0]->{COUNT};
	}
  
	if ($FALSE) { 
		print("getRowCountFromTbl: tableName:${tableName}  whereClause:${whereClause}\n");
		print("   select statement:${sqlToGetRowCountFromTbl_dbh}\n");
		print("   count:${count}\n");
	}
	return $count;
}

sub sqlToFlat {
	  my ($sttmnt,$tmpOutFile,$db,$login,$password,$LogFile,$verbal,$sepChar) = @_;
	$verbal     = setDefault($verbal,$TRUE);
	$sepChar    = setDefault($sepChar,"\|");

	my $dbh = dbConnect($db,$login,$password,$LogFile,$verbal,$FALSE);
	sqlToFlat_dbh($sttmnt, $tmpOutFile, $dbh);
	$dbh->disconnect();
}

sub sqlToFlat_dbh {
  my ($sttmnt,$tmpOutFile,$dbh,$replaceCharForNewLine,$sepChar) = @_;

  $countOfSqlToFlat = 0;
  $replaceCharForNewLine = setDefault($replaceCharForNewLine," ");
  if ($sepChar ne ";") {
     $sepChar = "\|";
  }

  my ($sql) = qq{$sttmnt};
  open(TMP_OUT_FILE,"> $tmpOutFile") || return "Can't open temp file $tmpOutFile: $!\n";
 
  my $sth = $dbh->prepare($sql);
  $sth->execute();
  my $rl_names = $sth->{NAME};
  my $line = "";
  foreach $field_name (@$rl_names) {
        $line = "${line}${sepChar}${field_name}"
  }
  if ($sepChar eq ";") {
     $line =~ s/^;//;
  } else {
     $line =~ s/^\|//;
  }
  print TMP_OUT_FILE "$line\n";
  while (@results = $sth->fetchrow) {
    if ($DBI::err) {
      print "$DBI::errstr\n";
      last;
     }
    my $line = "";
    foreach $field_name (@$rl_names) {
       $line = "${line}${sepChar}" . shift @results;
    }
    if ($sepChar eq ";") {
       $line =~ s/^;//;
    } else {
       $line =~ s/^\|//;
    }
    if ($replaceCharForNewLine eq "<BR>") {
       $line =~ s/\n/\<BR\>/g;
    } else {
       $line =~ s/\n/ /g;
    }
    $line =~ s/\r//g;
    print TMP_OUT_FILE "$line\n";
    $countOfSqlToFlat++;
  }
 
  $sth->finish();
  close TMP_OUT_FILE;
}

sub selectToFltString {
	my ($db,$login,$password,$selectString,$logFile,$verbal,$fieldSepChar,$lineSepChar) = @_;
	$verbal          = setDefault($verbal,$TRUE);
	$fieldSepChar    = setDefault($fieldSepChar,"\|");
	$lineSepChar     = setDefault($lineSepChar,"\n");
	my $retStr = "";
	my $dbh = dbConnect($db,$login,$password,$logFile,$verbal,$FALSE);
	$retStr = selectToFltString_dbh($dbh,$selectString,$logFile,$verbal,$fieldSepChar,$lineSepChar);
	$dbh->disconnect();
	return $retStr;
}


# {UserFct:parseTemplateUsingFltStr(
#       {UserFct:selectToFltString(${IQ_DB1},"CSOWNER",{UserFct:getPassword(csowner)},"select 
# 		ID ID,
# 		BID_FIELD BID_1,
# 		CCY1 CCY_1,
# 		CCY2 CCY_2
# 		from CSG_FX_SPOT_RICS")},"
#        ein template mit [BID_1] [CCY_1] with
#        [CCY_2]",$TRUE)}
#
sub selectToFltString_dbh {
	my ($dbh,$selectString,$logFile,$verbal,$fieldSepChar,$lineSepChar) = @_;
	$verbal          = setDefault($verbal,$TRUE);
	$fieldSepChar    = setDefault($fieldSepChar,"\|");
	$lineSepChar     = setDefault($lineSepChar,"\n");
  
	my (@retLines) = ();
  
	my $sql = qq{$selectString};
	
	# print("selectString:${selectString}:\n");
	# print("sql:${sql}:\n");
	my $sth = $dbh->prepare($sql);
	$sth->execute();
	my $rl_names = $sth->{NAME};
	my $headLine = "";
	foreach $field_name (@$rl_names) {
        if ($headLine eq "") {
			$headLine = "${field_name}"
		} else {
			$headLine = "${headLine}${fieldSepChar}${field_name}"
		}
	}
	push(@retLines,$headLine);
	while (@results = $sth->fetchrow) {
		if ($DBI::err) {
			print "$DBI::errstr\n";
			last;
		}
		my $line = "";
		foreach $field_name (@$rl_names) {
			if ($line eq "") {
				$line = "" . shift @results;
			} else {
				$line = "${line}${fieldSepChar}" . shift @results;		
			}
		}
		push(@retLines,$line);
	}
	$sth->finish();
	return makeStrFromArray($lineSepChar,@retLines);
}

# sqlToFlatWithPostProcessor
# --------------------------
# History:
# 04/25/00    V1.0 Walter Rothlin     Initial Version
#
# Description:
# ------------
# That function creates a flt file using a select statement. It than calls $postProcessorFctName for each record
# If the postprocessor returns $TRUE that record will be written to the file. The fields will be in the order how
# they are defined in $outputFieldsRef. The function returns how many records have been written to the output file.
#
# If $reopenOutputFile eq $TRUE it opens an existing file and appends the records.
# $globalVarPrefix specifies what the prefix for the global variable names should be (Default REC1_)
# In the post processor function ($postProcessorFctName) all the variables should be uppercase.
# e.g.
#
# @outFields = ("Amount","NameVorname","PLZ");
#
# $aSelect = qq {
#     select 
#         Amount       Amount,
#         Name         Name,
#         Vorname      Vorname,
#         Postleitzahl PLZ
#     from ADRESS_TABLE
# };
#
# sub myPostProcessor {
#    $REC1_NameVorname = "$REC1_Name $REC1_Vorname";
#    $REC1_AMOUNT = formatCurrency($REC1_AMOUNT);
#    if ($REC1_PLZ ne "8855") {
#       return $FALSE;   # do not write to output file!!!
#    } else {
#       return $TRUE;
#    }
# }
#
# $countOfRecordsWritten = sqlToFlatWithPostProcessor($aSelect,\&myPostProcessor,"Outfile.flt","OutfileTmp.flt");
#
# Result in Outfile.flt:
# Amount|NameVorname|PLZ
# 1'000|Rothlin Walter|8855
# 2'300|Collet Claudia|8855
sub sqlToFlatWithPostProcessor {
    my($selectStatement,$postProcessorFctName,$outFilename,$tmpOutFilename,$outputFieldsRef,$reopenOutputFile,$globalVarPrefix,$processMode,$logFileName,$verbal,$db,$login,$password,$outputDelimiter) = @_;
    my $dbh = dbConnect($db,$login,$password,$logFileName,$verbal,$FALSE);
    my($count) = sqlToFlatWithPostProcessor_dbh($selectStatement,$postProcessorFctName,$outFilename,$tmpOutFilename,$outputFieldsRef,$reopenOutputFile,$globalVarPrefix,$processMode,$logFileName,$verbal,$dbh,$outputDelimiter);
    $dbh->disconnect();
    return $count;
}

$sqlToFlatWithPostProcessor_sqlOnlyMode           = "sqlOnly";
$sqlToFlatWithPostProcessor_postProcessorOnlyMode = "postProcessorOnly";

sub sqlToFlatWithPostProcessor_dbh {
    my($selectStatement,$postProcessorFctName,$outFilename,$tmpOutFilename,$outputFieldsRef,$reopenOutputFile,$globalVarPrefix,$processMode,$logFileName,$verbal,$dbh,$outputDelimiter) = @_;
    my(@outputFields) = @$outputFieldsRef;
    $varPrefix        = setDefault($varPrefix,"SQLVAR_");
    $outputDelimiter  = setDefault($outputDelimiter,"\\|");
    $inputDelimiter   = $outputDelimiter;
    $reopenOutputFile = setDefault($reopenOutputFile,$FALSE);
    $globalVarPrefix  = setDefault($globalVarPrefix,"REC1_");

    my $sepChar               = "\|";
    if ($outputDelimiter eq ";") {
       $sepChar = ";";
    }

    my($countOfRecordsWritten) = 0;

    if (($processMode eq "") || ($processMode eq $sqlToFlatWithPostProcessor_sqlOnlyMode)) {
       addToLogFile("Starting SQL...",$logFileName,$verbal);
       sqlToFlat_dbh($selectStatement,$tmpOutFilename,$dbh,"",$sepChar);
       $countOfRecordsWritten = $countOfSqlToFlat;
       addToLogFile("...End SQL (count of records: ${countOfRecordsWritten})",$logFileName,$verbal);
    }
    if (($processMode eq "") || ($processMode eq $sqlToFlatWithPostProcessor_postProcessorOnlyMode)) {
       addToLogFile("Starting Post-Processing...",$logFileName,$verbal);
       if ($postProcessorFctName eq "") {
           $countOfRecordsWritten = copyFltFileWithHeaderTranslation($tmpOutFilename,$outFilename,$reopenOutputFile,@outputFields);
           ### unlink($outFilename);
           ### copy($tmpOutFilename,$outFilename);
           addToLogFile("    No Post-Processing",$logFileName,$verbal);
       } else {
           $countOfRecordsWritten = postProcessFltFile($tmpOutFilename,$outFilename,$postProcessorFctName,$outputFieldsRef,$inputDelimiter,$outputDelimiter,$reopenOutputFile,$globalVarPrefix);
       }
       addToLogFile("...End Post-Processing",$logFileName,$verbal);
    }
    return $countOfRecordsWritten;
}

sub prepareAndExecuteSqlStatement {
   my ($dbh, $sql, $outFileName, $logFile, $verbal) = @_;	
   $verbal     = setDefault($verbal,$TRUE);
   if ($outFileName ne "") {
      $writeToFile = $TRUE;
   } else {
      $writeToFile = $FALSE;
   }
   
   my $record      = {};
   my @records     = ();
   my $writeToFile = "";
  
   my $preparedSqlStmt = $dbh->prepare($sql);
   if ($DBI::err) {
  	addToLogFile("ERROR in prepareAndExecuteSqlStatement: prepare failed: $DBI::errstr",  $logFile, $TRUE);
  	addToLogFile("sql statement causing that error was:\n${sql}",  $logFile, $TRUE);
  	return @records;
   }

   if ($writeToFile) {
     if (! open(TMP_OUT_FILE,"> $outFileName") ) {
       addToLogFile ("ERROR in prepareAndExecuteSqlStatement: Can't open temp file $outFileName : $!\n",  $logFile, $TRUE);
     }
   }
 
  $preparedSqlStmt -> execute();
  if ($DBI::err) {
      addToLogFile ("ERROR in prepareAndExecuteSqlStatement: execute failed: $DBI::errstr\n", $logFile, $TRUE);
      addToLogFile("sql statement causing that error was:\n${sql}",  $logFile, $TRUE);
      return @records;
  }
  my $rl_names = $preparedSqlStmt->{NAME};
  my $line = "";
  foreach $field_name (@$rl_names) {
        $line = "${line}|${field_name}"
  }
 
  $line =~ s/^\|//;
 
  if ($writeToFile) {
    print TMP_OUT_FILE "$line\n";
  }
 
   while (@results = $preparedSqlStmt->fetchrow) {
    if ($DBI::err) {
      addToLogFile ("ERROR in prepareAndExecuteSqlStatement: fetch failed: $DBI::errstr\n", $logFile, $TRUE);
      addToLogFile("sql statement causing that error was:\n${sql}",  $logFile, $TRUE);
      return @records;
      last;
    }
    my $line = "";
 
    foreach $field_name (@$rl_names) {
       my $value = shift @results;
       $line = "${line}|" . $value;
       $record -> {"$field_name"} =  $value;
    }
 
    @records = ( @records,  $record);
    $record = {};
 
    $line =~ s/^\|//;
 
    if ($writeToFile) {
     print TMP_OUT_FILE "$line\n";
    }
  }
  $preparedSqlStmt->finish();
  return @records;
}
	

# Executes prepared select statement
# returns array of matched records
# (each record represented as hash with column names as keys)
# Also writes results to $outFileName if this variable is set 
sub dbExecutePreparedSelectSttmnt {
  my ($sth, $outFileName, $LogFile, $verbal) = @_;
  my ($record) = {};
  my (@records) = ();
  my ($writeToFile) = "";
 
  $verbal     = setDefault($verbal,$TRUE); 
  if ($outFileName ne "") {
    $writeToFile = $TRUE;
  } else {
    $writeToFile = $FALSE;
  }
 
 
  if ($writeToFile) {
    if (! open(TMP_OUT_FILE,"> $outFileName") ) {
       addToLogFile ("Can't open temp file $outFileName : $!\n",  $LogFile, $verbal);
       die;
    }
  }
 
  $sth -> execute();
  if ($DBI::err) {
  	print("ERROR in dbExecutePreparedSelectSttmnt: $DBI::errstr\n");
      addToLogFile ("ERROR in dbExecutePreparedSelectSttmnt: $DBI::errstr\n", $LogFile, $verbal);
      last;
  }
  my $rl_names = $sth->{NAME};
  my $line = "";
  foreach $field_name (@$rl_names) {
        $line = "${line}|${field_name}"
  }
 
  $line =~ s/^\|//;
 
  if ($writeToFile) {
    print TMP_OUT_FILE "$line\n";
  }
 
   while (@results = $sth->fetchrow) {
    if ($DBI::err) {
      addToLogFile ( "$DBI::errstr\n", $LogFile, $verbal);
      last;
     }
    my $line = "";
 
    foreach $field_name (@$rl_names) {
       my $value = shift @results;
       $line = "${line}|" . $value;
       $record -> {"$field_name"} =  $value;
    }
 
    @records = ( @records,  $record);
    $record = {};
 
    $line =~ s/^\|//;
 
    if ($writeToFile) {
     print TMP_OUT_FILE "$line\n";
    }
  }
  $sth->finish();
  return @records;
}


sub sqlExecute {    # executes sql statement
	my ($sttmnt,$db,$login,$password,$LogFile) = @_;
	$verbal = setDefault($verbal,$TRUE);
	my $sql  = qq {$sttmnt};
	my $dbh  = dbConnect($db,$login,$password,$LogFile,$verbal,$TRUE);
	my $rows = $dbh->do ($sql);
	## $dbh->commit();
	$dbh->disconnect();
	return $rows;
}

sub sqlExecute_dbh {    # executes sql statement
	my ($sttmnt, $dbh) = @_;
	my $rows = $dbh->do($sttmnt) ;
	if ($DBI::err) {
		return $DBI::errstr; 
	}
	return $rows;
}

sub executeSqlScript {
	my($dbLogonStr,$logFileName,$verbal,@scriptList) = @_;
	my $scriptName = "";
	foreach $scriptName (@scriptList) {
		addToLogFile("   --> Calling ${scriptName}",$logFileName,$verbal);
		my $cmd = "sqlplus -s $dbLogonStr  @"; $cmd = "${cmd}${scriptName} 2>&1";
		## addToLogFile("---> Execute: ${cmd}",$logFileName,$verbal);
		$msg = `$cmd  2>&1`;
		if ($msg ne "") {
			addToLogFile("  ---> Return-Status:\n${msg}",$logFileName,$verbal);
		}
	}
	printf("\n");
}

sub dbConnect {
  my ($db,$login,$password,$LogFile,$verbal,$autoCommit,$printError) = @_;
  $verbal     = setDefault($verbal,$TRUE);
  $autoCommit = setDefault($autoCommit,$FALSE);
  $printError  = setDefault($printError,$TRUE);
  
  # remove @ at the beginning of the dB Name because of TNS
  $db =~ s/^\@//g;
  addToLogFile ("Connecting to dB:${db}:",  $LogFile, $verbal);
  my $dbh = DBI->connect(
                         "dbi:Oracle:${db}",
                         "${login}",
                         "${password}",
                         {
                           PrintError => $printError,
                           RaiseError => $FALSE,
                           AutoCommit => $autoCommit
                         }
                 ) || addToLogFile("Database connection not made: $DBI::errstr", $LogFile, $verbal, $ERROR);
   return $dbh;
}

sub dbDisconnect {
   my ($dbh) = @_;
   $dbh->disconnect();
}

sub dbCommit {
   my ($dbh) = @_;
   $dbh->commit();
}

sub dbRollback {
   my ($dbh) = @_;
   $dbh->rollback();
}


sub sqlExecuteSttmnt {
  my ($sthRef,$valuesRef, $LogFile, $verbal) = @_;
   $$sthRef->execute(@{$valuesRef})
       ||  addToLogFile( "Failed to Execute Sttmnt:  $DBI::errstr", $LogFile, $verbal)  ;
 
 
}

sub dbExecuteSqlCommand { 
  my ($sttmnt,$db,$login,$password,$LogFile,$verbal,$prinError ) = @_;
  my $returnMsg = "";
 
  $verbal   = setDefault($verbal,$TRUE);
  my ($sql) = qq {$sttmnt};
  my $dbh = dbConnect($db,$login,$password,$LogFile,$verbal,$TRUE, $prinError);
  $rows = $dbh->do ($sql) ;
  $returnMsg= "$DBI::errstr" ;
  $dbh->disconnect() ;
 
  return $returnMsg;
}


sub sqlPrepareSttmnt {
  my ($table, $columnsAsStr,  $dbhRef, $LogFile, $verbal) = @_;
  my (@columns) = split (",", $columnsAsStr);
  my ($valStr) = "";
  my ($columnStr) = "";
  my ($sql) = "";
  my ($Value) = "";
 
  @columns = trimArray(@columns);
 
 
  foreach $columnLong (@columns) {
   ($column, $colType, $format) = split(":", $columnLong);
 
   if ($colType eq "date") {
     $Value = "to_date(?,'${format}')";
   } else {
     $Value = "?";
   }
 
   if ($valStr ne "") {
     $valStr = "${valStr}, \n      $Value";
     $columnStr = "${columnStr},\n   ${column}";
   } else {
     $valStr = $Value;
     $columnStr = "$column";
   }
 }
 
 $sql = qq { INSERT INTO $table (
               $columnStr
              )
          values (
             $valStr
       )
  };
 
  my $sth = $$dbhRef->prepare($sql)
    ||  addToLogFile("Prepare Failed: $DBI::errstr", $LogFile, $verbal, $ERROR);
 
  return $sth;
 
}


# obsolet please use dbConnect
sub sqlConnect {
	my ($db, $login, $password, $LogFile, $verbal, $autoCommit) = @_;
	$autoCommit = setDefault($autoCommit,$FALSE);
	return dbConnect($db, $login, $password, $LogFile, $verbal,$autoCommit);
}

# obsolet please use dbDiconnect
sub sqlDisconnect {
	my($dbhRef) = @_;
	dbDisconnect($$dbhRef);
}

# obsolet please use dbCommit
sub sqlCommit {
	my($dbhRef) = @_;
	$$dbhRef->commit();
}

sub deleteDbEntries {
	my($db,$login,$password,$tableName,$whereClause) = @_;
	my $dbh = dbConnect ($db, $login, $password, $LogFile, $verbal, $FALSE) ;
	my $retVal = deleteDbEntries_dbh($dbh,$tableName,$whereClause);
	dbDisconnect($dbh);
	return  $retVal;
}

sub deleteDbEntries_dbh {
	my($dbh,$tableName,$whereClause) = @_;
	if ($whereClause ne "") {
		$whereClause = "WHERE $whereClause";
	}
	my $sql = qq {
		DELETE 
		FROM $tableName
		$whereClause
	};
 
	my $sth = $dbh->prepare($sql);
	$sth->execute();
	return $sth->rows;
}


## dbBuildHash and dbBuildHash_dbh
## returns a hash with $key column as the key of the hash 
## and column $value as values
## dbBuildHash opens a db connection
sub dbBuildHash {
	my ($table, $key, $value, $whereClause, $distinct, $db, $login, $password, $LogFile, $verbal) = @_;
	my %myHashTable = ();
	my $dbh = dbConnect ($db, $login, $password, $LogFile, $verbal, $FALSE) ;
	%myHashTable =  dbBuildHash_dbh ($dbh, $table, $key, $value, $whereClause, $distinct); 
	dbDisconnect($dbh);
	return  %myHashTable;
}

sub dbBuildHash_dbh {
	my($dbh, $table, $key, $value, $whereClause, $distinct) = @_;
	my %myHashTable = ();
 
	if ($distinct eq $TRUE) {
		$distinct = "distinct";
	} else {
		$distinct = ""; 
	}
 
	if ($whereClause ne "") {
		$whereClause = "WHERE $whereClause";
	}
 
	my $sql = qq {
		SELECT $key, $value
		FROM $table
		$whereClause
	};

	my $sth = $dbh->prepare($sql);
	$sth->execute();
 
	while (@results = $sth->fetchrow) {
		$myHashTable{$results[0]} = $results[1];
	}
 
	$sth->finish();
	return %myHashTable;
}

#################################################
# dynamic creating of a sqlloader descriptor file
#################################################
sub createSqlLoaderDescFile {
	my ($db,$login,$password,$fltFileName, $tableName, $ctrlFile, $transFltToDbFieldnameTableRef, $badDealDir, $discardDealDir,$LogFile,$verbal) = @_; 
	my $dbh = dbConnect($db,$login,$password,$LogFile,$verbal,$autoCommit);
	my $retStr = createSqlLoaderDescFile_dbh($dbh,$fltFileName, $tableName, $ctrlFile, $transFltToDbFieldnameTableRef, $badDealDir, $discardDealDir,$LogFile,$verbal);
	dbDisconnect($dbh);
	$retStr;
}

sub createSqlLoaderDescFile_dbh {
  my ($dbh, $fltFileName, $tableName, $ctrlFile, $transFltToDbFieldnameTableRef, $badDealDir, $discardDealDir,$LogFile,$verbal) = @_;
  $badDealDir     = setDefault($badDealDir     ,getPathNameOutOfFullName($fltFileName));
  $discardDealDir = setDefault($discardDealDir ,getPathNameOutOfFullName($fltFileName));
  $fltFileNameWithoutExt = getFilenameWithoutExtension(getFileNameOutOfFullName($fltFileName));

  my $retStr = "";
  ### print("fltFileName:${fltFileName}\n");
  ### print("tableName  :${tableName}\n");
  ### print("ctrlFile   :${ctrlFile}\n");

  %transFltToDbFieldnameTable = changeCaseForHash($TRUE,$TRUE,%$transFltToDbFieldnameTableRef);
  ### print("transHash...\n");
  ### displayHashTable(%transFltToDbFieldnameTable);

  my %dbNameTypeHash     = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_TYPE",   "TABLE_NAME='${tableName}'");
  my %dbNameLengthHash   = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_LENGTH", "TABLE_NAME='${tableName}'");

  my @dbFields = keys %dbNameTypeHash;
  ### print("db table fields...\n");
  ### displayArray(@dbFields);

  ### displayHashTable(%dbNameTypeHash);
  ### displayHashTable(%dbNameLengthHash);


  my @fltFields = getTableHeaderAsArray($fltFileName);
  my $sepChar   = getSepCharFromTable($fltFileName,$FALSE);

  ### print("fltFileName:${fltFileName}\n");
  my(%oneFltRecord) = getOneFltTableRecord($fltFileName);
  ### displayHashTable(%oneFltRecord);

  # Process translation table
  # -------------------------
  my $transLogStr = "";
  my @tmpFltList = ();
  foreach my $aFltFieldName (@fltFields) {
     if (exists($transFltToDbFieldnameTable{uc($aFltFieldName)})) {
         push(@tmpFltList,$transFltToDbFieldnameTable{uc($aFltFieldName)});
         if ($transLogStr eq "") {
             $transLogStr = "Translation used:\n  ${aFltFieldName}  ==> ".$transFltToDbFieldnameTable{uc($aFltFieldName)};
         } else {
             $transLogStr = "${transLogStr}\n  ${aFltFieldName}  ==> ".$transFltToDbFieldnameTable{uc($aFltFieldName)};
         }
     } else {
         push(@tmpFltList,$aFltFieldName);
     }
  }
  @fltFields = @tmpFltList;
  addToLogFile("INFO:${transLogStr}",$LogFile,$verbal);
  $retStr = "${retStr}\n${transLogStr}";

  ### print("\nflt fiele fields...\n");
  ### displayArray(@fltFields);
  my @fltFieldsUpper = doUpperCaseArray(@fltFields);


  # Check for duplicate column headers in flt file
  # ----------------------------------------------
  my @doubleHeaders = getMultipleEntriesFromArray($FALSE,@fltFieldsUpper);
  if (!(isArrayEmty(@doubleHeaders))) {
    $transLogStr = "";
    $transLogStr = "ERROR: Duplicate Headers in ${fltFileName}..\n";
    $transLogStr = "${transLogStr}".makeQuotedStrFromArray("\n","                         ",@doubleHeaders);
    addToLogFile($transLogStr,$LogFile,$verbal);
    $retStr = "${retStr}\n${transLogStr}";
    
  }

  # Which fields are defined in db table but not in flt
  # ---------------------------------------------------
  my @missingInFlt = getExclutionOfArrays(\@dbFields,\@fltFieldsUpper);
  if (!(isArrayEmty(@missingInFlt))) {
    $transLogStr = "";
    $transLogStr = "WARNING:--> missing fields in flt file...\n";
    $transLogStr = "${transLogStr}".makeQuotedStrFromArray("\n","                         ",@missingInFlt);
    addToLogFile($transLogStr,$LogFile,$verbal);
    $retStr = "${retStr}\n${transLogStr}";
  }

  # Which fields are defined in ftl but not in DB
  # ---------------------------------------------
  my @missingInDB = getExclutionOfArrays(\@fltFieldsUpper,\@dbFields);
  if (!(isArrayEmty(@missingInDB))) {
    $transLogStr = "";
    $transLogStr = "WARNING:--> missing fields in db table...\n";
    $transLogStr = "${transLogStr}".makeQuotedStrFromArray("\n","                         ",@missingInDB);
    addToLogFile($transLogStr,$LogFile,$verbal);
    $retStr = "${retStr}\n${transLogStr}";
  }
  

  # start creating ctr file
  # -----------------------
  my $maxFieldNameLength = maxStrLength(@fltFieldsUpper)+10;
  my $first = TRUE;
  open(CTRFILE_createSqlLoaderDescFile,">${ctrlFile}") || showError(sprintf("ERROR (createSqlLoaderDescFile_dbh): Can't open file: %s : %s",$ctrlFile,$!));
  my $libDesc = getAnyDesc("csfbPerlLib"); $libDesc =~ s/\n/ /g;
  print(CTRFILE_createSqlLoaderDescFile "-- Created at ".formatTimeStamp(getTimeStamp(),$dateFormat,$TRUE,$TRUE,$language)." by createSqlLoaderDescFile_dbh from ${libDesc}\n");
  print(CTRFILE_createSqlLoaderDescFile "-- SQL*Loader Control file to load ${fltFileName} file into ${tableName}\n\n");


  print(CTRFILE_createSqlLoaderDescFile "OPTIONS (BINDSIZE=1000000,readsize=2000000,rows=10000)\n\n");

  print(CTRFILE_createSqlLoaderDescFile "LOAD DATA\n");
  print(CTRFILE_createSqlLoaderDescFile "INFILE          '${fltFileName}'\n");
  print(CTRFILE_createSqlLoaderDescFile "BADFILE         '${badDealDir}/${fltFileNameWithoutExt}.badDeals'\n");
  print(CTRFILE_createSqlLoaderDescFile "DISCARDFILE     '${discardDealDir}/${fltFileNameWithoutExt}.discardDeals'\n\n");


  print(CTRFILE_createSqlLoaderDescFile "INTO TABLE ${tableName} APPEND\n");
  print(CTRFILE_createSqlLoaderDescFile "fields terminated by \"${sepChar}\" optionally enclosed by '\"' TRAILING NULLCOLS\n\n");

  foreach my $aFltFieldName (@fltFields) {
     if ($first) {
         $first = $FALSE;
         print(CTRFILE_createSqlLoaderDescFile "(");
     } else {
         print(CTRFILE_createSqlLoaderDescFile ",\n");
     }
     printf(CTRFILE_createSqlLoaderDescFile "%-${maxFieldNameLength}s",$aFltFieldName);
     if (foundInArrayWithCase($aFltFieldName,$FALSE,@dbFields)) {
        if ($dbNameTypeHash{uc($aFltFieldName)} eq DATE) {
          if (length($oneFltRecord{$aFltFieldName}) == 8) {
              print(CTRFILE_createSqlLoaderDescFile "DATE(8) \"YYYYMMDD\"");
          } else {
              print(CTRFILE_createSqlLoaderDescFile "DATE(14) \"YYYYMMDDHH24MISS\"");
          }
        }
     } else {
        print(CTRFILE_createSqlLoaderDescFile "FILLER    CHAR");
     }
  }
  print(CTRFILE_createSqlLoaderDescFile "\n)\n");
  close(CTRFILE_createSqlLoaderDescFile);
  return $retStr;
}

###############################
# dbBuildArray_dbh
###############################
sub dbBuildArray_dbh {
  my($dbh, $table, $column, $whereClause, $distinct) = @_;

  if ($distinct eq $TRUE) {
   $distinct = "distinct";
  } else {
   $distinct = "";
  }


  if ($whereClause ne "") {
   $whereClause = "WHERE $whereClause";
  }

  my $sql = qq {

   SELECT $column
   FROM $table
   $whereClause

  };

  my $ary_ref = $dbh->selectcol_arrayref($sql);

  return @$ary_ref;

}



###############################
# dbLoadHash and dbLoadHash_dbh 
###############################
# You can use this function to Load a Hash (key=FieldName and Value=Value) into a DB table. 
# If your columns in the file are different from db columns you can create a hash table with mappings
# and pass it as $fieldNameTranslationHashRef where  db columns are keys and file columns are values 
# 
# returns $TRUE if everything went well
sub  dbLoadAnHash_dbh {   #### TBS TBS
   my($dbh,$table,$fieldNameTranslationHashRef,$logFile,$verbal) = @_;

   my %nameTypeHash     = dbBuildHash_dbh ($dbh,"all_tab_columns","COLUMN_NAME","DATA_TYPE",   "TABLE_NAME= '${table}'");
   my %nameLengthHash   = dbBuildHash_dbh ($dbh,"all_tab_columns","COLUMN_NAME","DATA_LENGTH", "TABLE_NAME= '${table}'");
   my (@dBTableColumns) = sort keys  %nameTypeHash;

}

###############################################################
# dbUpdateRecordsFromFltFile and dbUpdateRecordsFromFltFile_dbh 
###############################################################
sub dbUpdateRecordsFromFltFile_dbh {
   my($dbh,$dbTableName,$fltFilename,$keyFieldsRef,$keyFieldsFromFileArrRef,$newOldFieldHashRef,$logFile,$verbal) = @_;
   my($sepChar)        = getSepCharFromTable($fltFilename);
   my(@fileRecordsRef) = getAllMatchesFromFltFileAsHashes($fltFilename,$sepChar,"","");
   my($aFileRecordRef) = "";
   my(@valRecRefsToUpdate) = ();
   my(@keyRecRefs)         = ();
   foreach $aFileRecordRef (@fileRecordsRef) {
      my(@keyFieldsFromFile) = @$keyFieldsFromFileArrRef;
      my($aKeyFieldFromFile) = "";
      foreach $aKeyFieldFromFile (@keyFieldsFromFile) {
         my($keyFieldVal) = $aFileRecordRef->{$aKeyFieldFromFile};
         ### printf("${aKeyFieldFromFile} has keyFieldVal:${keyFieldVal}:\n");
         $keyFieldsRef->{$aKeyFieldFromFile} = $keyFieldVal;
         delete $aFileRecordRef->{$aKeyFieldFromFile};
      }
      push(@valRecRefsToUpdate,$aFileRecordRef);
      my(%newKeyFields) = %$keyFieldsRef;
      push(@keyRecRefs,\%newKeyFields);
      ## printf("....key\n");
      ## my(%keyFields) = %$keyFieldsRef;
      ## displayHashTable(%keyFields);

      ## printf("....updateRec\n");
      ## my(%aValFileRecord) = %$aFileRecordRef;
      ## displayHashTable(%aValFileRecord);
     
      ## printf("tableName:${tableName}:\n");
   }
   my($retMsg) = dbUpdateRecords_dbh($dbh,$dbTableName,\@valRecRefsToUpdate,\@keyRecRefs,$newOldFieldHashRef,$logFile,$verbal);
   if ($retMsg ne "") {
     addToLogFile("----> WARNING: in dbUpdateRecordsFromFltFile_dbh: $retMsg",$logFile,$verbal);
   }

}

#######################################
# get table describtion
#######################################
sub getDbTableDescribtion {
   my ($db,$login,$password,$tableName) = @_;
   my $dbh = dbConnect($db, $login, $password, $LogFile, $verbal,$autoCommit);
   my  %retHash = getDbTableDescribtion_dbh($dbh,$tableName);
   dbDisconnect ($dbh );
   return %retHash;
}

sub getDbTableDescribtion_dbh {
   my ($dbh,$tableName) = @_;
   my %dbNameTypeHash     = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_TYPE",   "TABLE_NAME='${tableName}'");
   my %dbNameLengthHash   = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_LENGTH", "TABLE_NAME='${tableName}'");
   my (@dBTableColumns)   = keys %dbNameTypeHash;
   my($aFieldName) = "";
   foreach $aFieldName (@dBTableColumns) {
      $dbNameTypeHash{$aFieldName} = sprintf("%s (%s)",$dbNameTypeHash{$aFieldName},$dbNameLengthHash{$aFieldName});
   }   
   return %dbNameTypeHash;
}

#######################################
# setDbEntries_dbh    (Update if record is existing or insert if not)
#######################################
sub doNotAutomatedTest_setDbEntries_dbh {
	  my($dbh) = @_;
	  
	  my %recordToInsert_1 = (
	     "NAME"       => "EOD070306",
	     "CCY1"       => "AUD",
	     "CCY2"       => "CHF",
	     "BID"        => 1.20,
	     "OFFER_RATE" => 1.30,
	  );
	  
	  my %recordToInsert_2 = (
	     "NAME"       => "EOD070306",
	     "ccy1"       => "USD",
	     "CCY2"       => "EUR",
	     "BID"        => 1.50,
	     "OFFER_RATE" => 1.60,
	  );
	  my @recordSetData = (\%recordToInsert_1,\%recordToInsert_2);

    #Fieldname mapping DB-fieldname => record-set fieldname
	  my %translation = (
	     "BID_RATE"   => "BID",
	  );	  	 
	 
	  my %defaultValus = (
	     "TIMESTAMP"  => "20070516080000",
	  );
	  
	  my @keyFields = ("NAME","CCY1","CCY2");
	  	  
	  my ($countOfInserts,$countOfUpdates) = setDbEntries_dbh($dbh, "MRS_FXSPOT", \@recordSetData, \%translation, \%defaultValus, \@keyFields, $logFileName, $verbal);
	  print("countOfUpdates:${countOfUpdates}:   countOfInserts:${countOfInserts}:\n");
}

sub setDbEntries_dbh {
  my($dbh, $table, $recordSet, $fieldMapping, $defaultValues, $keyFields, $logFileName, $verbal) = @_;
  
  my %dbNameTypeHash       = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_TYPE",   "TABLE_NAME='${table}'");
  my $countOfUpdates       = 0;
  my $countOfInserts       = 0;
  my $countOfFailedUpdates = 0;
  my $countOfFailedInserts = 0;
  my @defaultKeys          = keys %$defaultValues;
  
  foreach my $aRecord (@$recordSet) {
  	   my %modRecord = changeCaseForHashKeys($TRUE,%$aRecord);

       
       # process default values
       foreach my $aKey (@defaultKeys) {
           if (!(exists($modRecord{$aKey}))) {
           	   %modRecord = (%modRecord,($aKey,$defaultValues->{$aKey}));
           }
       }
       $aRecord = \%modRecord;
      
       # prepare where clause
       my @whereClauseParts = ();
       my %dbKeys           = ();
       foreach $aKeyField (@$keyFields) {
       	   my $fieldValue = "";
       	   if (exists($aRecord->{$aKeyField})) {
       	   	   $fieldValue = $aRecord->{$aKeyField};
       	   } else {
       	   	   $fieldValue = $aRecord->{$fieldMapping->{$aKeyField}};
       	   }

       	   %dbKeys =(%dbKeys,($aKeyField,$fieldValue));
           if ($dbNameTypeHash{$aKeyField} eq "VARCHAR2") {
               push(@whereClauseParts,"${aKeyField} = '".$fieldValue."'");
           } elsif ($dbNameTypeHash{$newDbFieldName} eq "DATE") {
           	   push(@whereClauseParts,"${aKeyField} = to_date(".$fieldValue.",'YYYYMMDDHH24MISS')");
           } else {
               if ($aRecord->{$aKeyField} eq "") {
                   push(@whereClauseParts,"${aKeyField} = 0");
               } else {
               	   push(@whereClauseParts,"${aKeyField} = ".$fieldValue);
               }
           }       	
       }
       my $whereClause = " where ".makeStrFromArray(" AND ",@whereClauseParts);
       my @recordSetKeys = (\%dbKeys);
       ## print("whereClause:${whereClause}:\n");
       
       my @oneRecInRecSet = ($aRecord);
       if (getRowCountFromTbl_dbh($dbh,$table,$whereClause) > 0) {   
        	  my $retMsg = dbUpdateRecords_dbh($dbh, $table, \@oneRecInRecSet, \@recordSetKeys, $fieldMapping, $logFileName, $verbal);
        	  ## displayRecordSet(\@oneRecInRecSet,"Updated","   ");
        	  if ($retMsg eq "") { $countOfUpdates++; } else { $countOfFailedUpdates++; }
       } else { 
        	  my $retMsg = insertDbEntries_dbh($dbh, $table, \@oneRecInRecSet, $fieldMapping, $defaultValues, $logFileName, $verbal);
        	  if ($retMsg == 1) { $countOfInserts++; } else { $countOfFailedInserts++; }
       }
  }
  return ($countOfInserts,$countOfUpdates,$countOfFailedInserts,$countOfFailedUpdates);
}




#######################################
# insertDbEntries_dbh 
#######################################
sub doNotAutomatedTest_insertDbEntries_dbh {
	  my($dbh) = @_;
	  
	  my %recordToInsert_1 = (
	     "NAME"       => "EOD070306",
	     "CCY1"       => "AUD",
	     "CCY2"       => "CHF",
	     "BID"        => 1.20,
	     "OFFER_RATE" => 1.30,
	  );
	  
	  my %recordToInsert_2 = (
	     "NAME"       => "EOD070306",
	     "ccy1"       => "USD",
	     "CCY2"       => "EUR",
	     "BID"        => 1.50,
	     "OFFER_RATE" => 1.60,
	  );
	  my @recordSetData = (\%recordToInsert_1,\%recordToInsert_2);

    #Fieldname mapping DB-fieldname => record-set fieldname
	  my %translation = (
	     "BID_RATE"   => "BID",
	  );	  	 
	 
	  my %defaultValus = (
	     "TIMESTAMP"  => "20070516080000",
	  );
	  	  
	  my $count = insertDbEntries_dbh($dbh, "MRS_FXSPOT", \@recordSetData, \%translation, \%defaultValus, $logFileName, $verbal);
}


sub insertDbEntries_dbh {
  my($dbh, $table, $recordSet, $fieldMapping, $defaultValues, $logFileName, $verbal) = @_;
 
  my %NAME_TYPE_HASH   = dbBuildHash_dbh ($dbh,"all_tab_columns","COLUMN_NAME","DATA_TYPE",   "TABLE_NAME= '${table}'");
  my %NAME_LENGTH_HASH = dbBuildHash_dbh ($dbh,"all_tab_columns","COLUMN_NAME","DATA_LENGTH", "TABLE_NAME= '${table}'");
  my @DB_COLUMNS = sort keys  %NAME_TYPE_HASH;
 
  my $valStr      = "";
  my $columnStr   = "";
  my $valueFormat = "";
  my $column      = "";
  my $insertSql   = "";
  
  ## Prepare Insert Sttmnt
  foreach $column (@DB_COLUMNS) {
     if ($NAME_TYPE_HASH{$column} eq "DATE") {
        $valueFormat = "to_date(?,'YYYYMMDDHH24MISS')";
     } else {
        $valueFormat = "?";
     }
     if ($valStr ne "") {
         $valStr    = "${valStr},   \n   ${valueFormat}";
         $columnStr = "${columnStr},\n   ${column}";
     } else {
         $valStr    = $valueFormat;
         $columnStr = $column;
     }
  }
  $insertSql = qq { INSERT INTO $table (
           $columnStr
       )
       values (
           $valStr
       )
  };
 
  ## printf("insertSql:${insertSql}\n");
  
  $dbh->{PrintError} = $FALSE;
  $dbh->{RaiseError} = $FALSE;

  my $SQLSTH = $dbh->prepare($insertSql);
  if ($DBI::err) {
      addToLogFile("----> ERROR: In dbLoadFile_dbh: Failed to prepare insertSql",$LogFile,$TRUE);
      addToLogFile("----> ERROR caused by:${insertSql}",$LogFile,$TRUE);
      return 0;  # count
  } 
 
  my $errCount = 0;
  my $count    = 0;
  
  foreach my $aRecord (@$recordSet) {
  	   my %modRecord = changeCaseForHashKeys($TRUE,%$aRecord);
  	   $aRecord = \%modRecord;
  	   
       ## displayHashTableRef($aRecord,"DataRecord","   ");

       ## Insert one record
       my (@INSERT_VALUES) = ();
       foreach $dbcolumn (@DB_COLUMNS) {
           if (exists $aRecord ->{$dbcolumn}) {
              $fldValue = $aRecord ->{$dbcolumn};
           } else {
           	  # check if there is a mapping defined for this field
           	  if (exists $fieldMapping ->{$dbcolumn}) {
           	  	  $fldValue = $aRecord ->{$fieldMapping ->{$dbcolumn}};
           	  } else {
                  # check for default values defined
                  if (exists $defaultValues ->{$dbcolumn}) {
                  	  $fldValue = $defaultValues ->{$dbcolumn};
                  } else {
                      $fldValue = "";
                  }
              }
           } 
           $value = $fldValue;
           push(@INSERT_VALUES,$value);
       }
       ## print("INSERT_VALUES:\n"); displayArray(@INSERT_VALUES);
       
       $SQLSTH->execute(@INSERT_VALUES);
       if ($DBI::err) {
           if ($errCount > 1000) {
               addToLogFile("----> ERROR: More than 1000 records with error. Loading aborted....",$LogFile,$TRUE);
               last;
           }
           addToLogFile("----> ERROR in loading the following record",$LogFile,$TRUE);
           addToLogFile(sprintf("----> ERROR was: %s",$DBI::errstr),$LogFile,$TRUE);
           displayRecordCausedError(\@INSERT_VALUES,\@DB_COLUMNS,\%NAME_TYPE_HASH,\%NAME_LENGTH_HASH);
           $errCount++;
       } else {
           $count++;
       }
  }
  return $count;
}


#######################################
# dbUpdateRecord and dbUpdateRecord_dbh 
#######################################
sub dbUpdateRecord {
 my($db,$login,$password,$tableName,$recordToUpdateRef,$keyFieldsRef,$newOldFieldHashRef,$logFile,$verbal,$autoCommit) = @_; 
 my $dbh = dbConnect($db, $login, $password, $LogFile, $verbal,$autoCommit);
 my($retMsg) = dbUpdateRecord_dbh($dbh,$tableName,$recordToUpdateRef,$keyFieldsRef,$newOldFieldHashRef,$logFile,$verbal);
 dbDisconnect ($dbh );
 return $retMsg;
}

sub dbUpdateRecord_dbh {
   my ($dbh,$tableName,$recordToUpdateRef,$keyFieldsRef,$newOldFieldHashRef,$logFile,$verbal) = @_; 
   ### printf("\n-->recordToUpdateRef\n");
   ### displayHashTable(%$recordToUpdateRef);

   ### printf("\n-->keyFieldsRef\n");
   ### displayHashTable(%$keyFieldsRef);

   # reading table definitions from dB
   my %dbNameTypeHash     = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_TYPE",   "TABLE_NAME='${tableName}'");
   my %dbNameLengthHash   = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_LENGTH", "TABLE_NAME='${tableName}'");
   my (@dBTableColumns)   = sort keys %dbNameTypeHash;

   ### printf("\n-->dbNameTypeHash\n");
   ### displayHashTable(%dbNameTypeHash);

   # preparing parameters
   my(%updateRecord)        = %$recordToUpdateRef;
   my(%keyFieldRecord)      = %$keyFieldsRef;
   my(%transRecord)         = %$newOldFieldHashRef;        %transRecord = swapHash(%transRecord);
   my(@updateFields)        = sort keys %updateRecord;
   my(@whereClauseFields)   = sort keys %keyFieldRecord;
   ### printf("\n-->keyFieldRecord\n");
   ### displayHashTable(%keyFieldRecord);
   ### printf("\n-->transRecord\n");
   ### displayHashTable(%transRecord);


   # preparing sql statement
   my($updateSql) = "UPDATE ${tableName}";
   my($aUpdateField) = "";
   my($lineTerminator) = "  SET ";
   foreach $aUpdateField (@updateFields) {
     my($newDbFieldName) = uc($aUpdateField);
     # check if there is a translation
     if (!(exists($dbNameTypeHash{$newDbFieldName}))) {
         if (exists($transRecord{$aUpdateField})) {
              $newDbFieldName = uc($transRecord{$aUpdateField});
              addToLogFile("WARNING:${aUpdateField}: is been replaced by :${newDbFieldName}:",$logFile,$TRUE);
         }
     }

     if (exists($dbNameTypeHash{$newDbFieldName})) {
      if ($dbNameTypeHash{$newDbFieldName} eq "VARCHAR2") {
          $fldValue = $updateRecord{$aUpdateField};
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s = '%s'",$newDbFieldName,$fldValue);
      } elsif ($dbNameTypeHash{$newDbFieldName} eq "DATE") {
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s = to_date('%s','YYYYMMDDHH24MISS')",$newDbFieldName,$updateRecord{$aUpdateField});
      } else {
          my($numVal) = $updateRecord{$aUpdateField};
          if ($numVal eq "") {
             $numVal = 0;
          }
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s = %s",$newDbFieldName,$numVal);
      }
      $lineTerminator = ",";
     } else {
        addToLogFile("WARNING: Field :${aUpdateField}: is not defined in the dB (will not be updated)",$logFile,$TRUE);
     }
   }

   $updateSql = "${updateSql}\n WHERE";
   my($aWhereClauseField)   = "";
   $lineTerminator          = "";

   foreach $aWhereClauseField (@whereClauseFields) {
     my($newDbFieldName) = uc($aWhereClauseField);
     # check if there is a translation
     if (!(exists($dbNameTypeHash{$newDbFieldName}))) {
         if (exists($transRecord{$aWhereClauseField})) {
              $newDbFieldName = uc($transRecord{$aWhereClauseField});
              addToLogFile("WARNING:${aWhereClauseField}: is been replaced by :${newDbFieldName}: for Where-Clause",$logFile,$TRUE);
         }
     }
     if (exists($dbNameTypeHash{$newDbFieldName})) {
      if ($dbNameTypeHash{$newDbFieldName} eq "VARCHAR2") {
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s = '%s'",$newDbFieldName,$keyFieldRecord{$aWhereClauseField});
      } elsif ($dbNameTypeHash{$newDbFieldName} eq "DATE") {
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s = to_date('%s','YYYYMMDDHH24MISS')",$newDbFieldName,$keyFieldRecord{$aWhereClauseField});
      } else {
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s = %s",$newDbFieldName,$keyFieldRecord{$aWhereClauseField});
      }
      $lineTerminator = " AND ";
     } else {
        addToLogFile("WARNING: Field :${aWhereClauseField}: is not defined in the dB (will not used in the where clause)",$logFile,$TRUE);
     }

   }
   addToLogFile("updateSql:\n${updateSql}",$logFile,$verbal);

   # prepare and execute sql statement

   $dbh->{PrintError} = $FALSE;
   $dbh->{RaiseError} = $FALSE;
   my($sth) = $dbh->prepare($updateSql);
   if ($DBI::err) {
      addToLogFile("ERROR (1) in dbUpdateRecord_dbh: Failed to prepare updateSql",$logFile,$TRUE);
      addToLogFile("ERROR caused by:${updateSql}",$logFile,$TRUE);
      return "ERROR: Could not update record";
   } 

   $sth->execute;
   if ($DBI::err) {
      addToLogFile("ERROR (2) in dbUpdateRecord_dbh: Failed to execute updateSql",$logFile,$TRUE);
      addToLogFile("ERROR caused by:\n${updateSql}",$logFile,$TRUE);
      addToLogFile(sprintf("----> ERROR was: %s",$DBI::errstr),$logFile,$TRUE);
      
      my(@updateValues) = ();
      my(%usedFields)   = ();
      my($aFieldName)   = "";
      foreach $aFieldName (@updateFields) {
         %usedFields = (%usedFields,(uc($aFieldName),$updateRecord{$aFieldName}));
      }
      foreach $aFieldName (@whereClauseFields) {
         %usedFields = (%usedFields,(uc($aFieldName),$keyFieldRecord{$aFieldName}));
      }
      foreach $aFieldName (@dBTableColumns) {
         push(@updateValues,$usedFields{$aFieldName});
      }
      displayRecordCausedError(\@updateValues,\@dBTableColumns,\%dbNameTypeHash,\%dbNameLengthHash,$logFile,$verbal);
      return "ERROR: Could not update record";
   } 

   return $retMsg;
}

#########################################
# dbUpdateRecords and dbUpdateRecords_dbh 
#########################################
#
# Example to call function
#	  my %recordToInsert = (
#	     "NAME"       => $eodDate,
#	     "CCY1"       => $ccy1,
#	     "CCY2"       => $ccy2,
#	     "BID_RATE"   => $bid,
#	     "OFFER_RATE" => $ask,
#	  );
#	  my @recordSetData = (\%recordToInsert);
#	  
#	  my %dbKeys = (
#	     "NAME"       => $eodDate,
#	     "CCY1"       => $ccy1,
#	     "CCY2"       => $ccy2,
#	  );
#	  my @recordSetKeys = (\%dbKeys);
#
#	  my %translation = (
#	     "NAME"       => "NAME",
#	     "CCY1"       => "CCY1",
#	     "CCY2"       => "CCY2",
#	     "BID_RATE"   => "BID_RATE",
#	     "OFFER_RATE" => "OFFER_RATE",
#	  );	  
#	  
#	  my $retMsg = dbUpdateRecords_dbh($dbh,"MRS_FXSPOT",\@recordSetData,\@recordSetKeys,\%translation,$logFileName,$verbal); 
#    if ($retMsg ne "") {
#      addToLogFile("----> WARNING: in setSpotRate_dbh: $retMsg",$logFile,$verbal);
#    }
#
sub dbUpdateRecords {
 my($db,$login,$password,$tableName,$arrayRefOfRefToRecordToUpdate,$arrayRefOfRefToKeyFields,$newOldFieldHashRef,$logFile,$verbal,$autoCommit) = @_; 
 my $dbh = dbConnect($db,$login,$password,$LogFile,$verbal,$autoCommit);
 my($retMsg) = dbUpdateRecords_dbh($dbh,$tableName,$arrayRefOfRefToRecordToUpdate,$arrayRefOfRefToKeyFields,$newOldFieldHashRef,$logFile,$verbal);
 dbDisconnect($dbh);
 return $retMsg;
}

sub dbUpdateRecords_dbh {
   my ($dbh,$tableName,$arrayRefOfRefToRecordToUpdate,$arrayRefOfRefToKeyFields,$newOldFieldHashRef,$logFile,$verbal) = @_; 

   my @arrayOfRefToRecordToUpdate = @$arrayRefOfRefToRecordToUpdate;
   my @arrayOfRefToKeyFields      = @$arrayRefOfRefToKeyFields;
   my $aRecordRef = "";
   my $countOfValues = @$arrayRefOfRefToRecordToUpdate;
   my $countOfKeys   = @$arrayRefOfRefToKeyFields;
   ## printf("countOfValues:${countOfValues}:  countOfKeys:${countOfKeys}:\n");
   ## for (my $i =0; $i < $countOfKeys; $i++) {
   ##     printf("\n--> Values\n");
   ##     $aRecordRef = $arrayOfRefToRecordToUpdate[$i];
   ##     displayHashTable(%$aRecordRef);
   ##     printf("\n--> Where-Clause\n");
   ##     $aRecordRef = $arrayOfRefToKeyFields[$i];
   ##     displayHashTable(%$aRecordRef);
   ## }

   # reading table definitions from dB
   my %dbNameTypeHash     = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_TYPE",   "TABLE_NAME='${tableName}'");
   my %dbNameLengthHash   = dbBuildHash_dbh($dbh,"all_tab_columns","COLUMN_NAME","DATA_LENGTH", "TABLE_NAME='${tableName}'");
   my @dBTableColumns     = sort keys %dbNameTypeHash;

   ### printf("\n-->dbNameTypeHash\n");
   ### displayHashTable(%dbNameTypeHash);

   # preparing parameters
   my $recordToUpdateRef    = $arrayOfRefToRecordToUpdate[0];
   my %updateRecord         = %$recordToUpdateRef;
   initHash(\%updateRecord,"?");

   my $keyFieldsRef         = $arrayOfRefToKeyFields[0];
   my %keyFieldRecord       = %$keyFieldsRef;
   initHash(\%keyFieldRecord,"?");

   my %transRecord          = %$newOldFieldHashRef;        %transRecord = swapHash(%transRecord);
   my @updateFields         = sort keys %updateRecord;
   my @whereClauseFields    = sort keys %keyFieldRecord;
   ### printf("\n-->keyFieldRecord\n");
   ### displayHashTable(%keyFieldRecord);
   ### printf("\n-->transRecord\n");
   ### displayHashTable(%transRecord);


   # preparing sql statement
   my($updateSql) = "UPDATE ${tableName}";
   my($aUpdateField) = "";
   my($lineTerminator) = "  SET ";
   foreach $aUpdateField (@updateFields) {
     my($newDbFieldName) = uc($aUpdateField);
     # check if there is a translation
     if (!(exists($dbNameTypeHash{$newDbFieldName}))) {
         if (exists($transRecord{$aUpdateField})) {
              $newDbFieldName = uc($transRecord{$aUpdateField});
              addToLogFile("WARNING:${aUpdateField}: is been replaced by :${newDbFieldName}:",$logFile,$verbal);
         }
     }

     if (exists($dbNameTypeHash{$newDbFieldName})) {
      if ($dbNameTypeHash{$newDbFieldName} eq "VARCHAR2") {
          $fldValue = $updateRecord{$aUpdateField};
          ### Not used anymore WR 09/12/00
          ### if ($fldValue =~ "'") {   # replace single quote by double
          ###  $fldValue =~ s/\'/''/g;
          ### }
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s = %s",$newDbFieldName,$fldValue);
      } elsif ($dbNameTypeHash{$newDbFieldName} eq "DATE") {
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s = to_date(%s,'YYYYMMDDHH24MISS')",$newDbFieldName,$updateRecord{$aUpdateField});
      } else {
          my($numVal) = $updateRecord{$aUpdateField};
          if ($numVal eq "") {
             $numVal = 0;
          }
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s = %s",$newDbFieldName,$numVal);
      }
      $lineTerminator = ",";
     } else {
        addToLogFile("WARNING: Field :${aUpdateField}: is not defined in the dB (will not be updated)",$logFile,$verbal);
     }
   }

   $updateSql = "${updateSql}\n WHERE";
   my($aWhereClauseField)   = "";
   $lineTerminator          = "";

   foreach $aWhereClauseField (@whereClauseFields) {
     my($newDbFieldName) = uc($aWhereClauseField);
     # check if there is a translation
     if (!(exists($dbNameTypeHash{$newDbFieldName}))) {
         if (exists($transRecord{$aWhereClauseField})) {
              $newDbFieldName = uc($transRecord{$aWhereClauseField});
              addToLogFile("WARNING:${aWhereClauseField}: is been replaced by :${newDbFieldName}: for Where-Clause",$logFile,$TRUE);
         }
     }
     if (exists($dbNameTypeHash{$newDbFieldName})) {
      if ($dbNameTypeHash{$newDbFieldName} eq "VARCHAR2") {
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s (+) = %s",$newDbFieldName,$keyFieldRecord{$aWhereClauseField});
      } elsif ($dbNameTypeHash{$newDbFieldName} eq "DATE") {
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s (+) = to_date(%s,'YYYYMMDDHH24MISS')",$newDbFieldName,$keyFieldRecord{$aWhereClauseField});
      } else {
          $updateSql = sprintf("${updateSql}${lineTerminator}\n  %-20s (+) = %s",$newDbFieldName,$keyFieldRecord{$aWhereClauseField});
      }
      $lineTerminator = " AND ";
     } else {
        addToLogFile("WARNING: Field :${aWhereClauseField}: is not defined in the dB (will not used in the where clause)",$logFile,$verbal);
     }

   }
   ## addToLogFile("updateSql:\n${updateSql}",$logFile,$TRUE);

   # prepare and execute sql statement

   $dbh->{PrintError} = $FALSE;
   $dbh->{RaiseError} = $FALSE;
   my($sth) = $dbh->prepare($updateSql);
   if ($DBI::err) {
      addToLogFile("ERROR (1) in dbUpdateRecord_dbh: Failed to prepare updateSql",$logFile,$TRUE);
      addToLogFile("ERROR caused by:${updateSql}",$logFile,$TRUE);
      return "ERROR: Could not update record";
   } 

   my($startTimeStamp) = getTimeStamp();
   ## TIME my($maxBeforeExecutionDuration) = 0;
   ## TIME my($maxExecutionDuration)       = 0;
   ## TIME my($minBeforeExecutionDuration) = 1000000;
   ## TIME my($minExecutionDuration)       = 1000000;


   for (my $i =0; $i < $countOfKeys; $i++) {
       ## TIME my($startForLoopStamp) = getTimeStamp();
       my $aRecordRef     = $arrayOfRefToRecordToUpdate[$i];
       my @valuesToUpdate  = ();
       
       #       print("---------> Defining the values\n");
       #       print("DB fields:\n");displayHashTable(%dbNameTypeHash);
       #       print("Data Record:\n");displayHashTable(%$aRecordRef);
       #       print("Translation:\n");displayHashTable(%transRecord);
       
       foreach my $fieldname (sort (keys %$aRecordRef)) {
       	 if (exists($dbNameTypeHash{$fieldname})) {
        	   push(@valuesToUpdate,$aRecordRef->{$fieldname});
         } elsif (exists($dbNameTypeHash{$transRecord{$fieldname}})) {
        	   push(@valuesToUpdate,$aRecordRef->{$fieldname});
         } 
       }
       ## my @valuesToUpdate = getAllValuesSortedFromHash_AsArray($TRUE,%$aRecordRef);

       $aRecordRef    = $arrayOfRefToKeyFields[$i];
       ## print("Values (Hash):\n");      displayHashTable(%$aRecordRef);
       my @keyValues = getAllValuesSortedFromHash_AsArray($TRUE,%$aRecordRef);
       my @execValue = (@valuesToUpdate,@keyValues);
       ## print("valuesToUpdate:\n");  displayArray(@valuesToUpdate);
       ## print("keyValues:\n");       displayArray(@keyValues);
       ## print("Values    :\n");          displayArray(@execValue);
       ### printf("...end\n");
       ## TIME my($beforeExecuteStamp) = getTimeStamp();
       $sth->execute(@execValue);
       ## TIME my($afterExecuteStamp) = getTimeStamp();

       ## TIME my($execDuration) = secDiff_YYYYMMDDhhmmss($afterExecuteStamp,$beforeExecuteStamp);
       ## TIME my($beforeExecDuration) = secDiff_YYYYMMDDhhmmss($beforeExecuteStamp,$startForLoopStamp);
       ## TIME if ($execDuration > $maxExecutionDuration) { $maxExecutionDuration = $execDuration; }
       ## TIME if ($beforeExecDuration > $maxBeforeExecutionDuration) { $maxBeforeExecutionDuration = $beforeExecDuration; }

       ## TIME if ($execDuration < $minExecutionDuration) { $minExecutionDuration = $execDuration; }
       ## TIME if ($beforeExecDuration < $minBeforeExecutionDuration) { $minBeforeExecutionDuration = $beforeExecDuration; }

       if ($DBI::err) {
          addToLogFile("ERROR (2) in dbUpdateRecord_dbh: Failed to execute updateSql",$logFile,$TRUE);
          addToLogFile("ERROR caused by:\n${updateSql}",$logFile,$TRUE);
          addToLogFile(sprintf("----> ERROR was: %s",$DBI::errstr),$logFile,$TRUE);
      
          my(@updateValues) = ();
          my(%usedFields)   = ();
          my($aFieldName)   = "";
          foreach $aFieldName (@updateFields) {
            %usedFields = (%usedFields,(uc($aFieldName),$updateRecord{$aFieldName}));
          }
          foreach $aFieldName (@whereClauseFields) {
            %usedFields = (%usedFields,(uc($aFieldName),$keyFieldRecord{$aFieldName}));
          }
          foreach $aFieldName (@dBTableColumns) {
            push(@updateValues,$usedFields{$aFieldName});
          }
          displayRecordCausedError(\@updateValues,\@dBTableColumns,\%dbNameTypeHash,\%dbNameLengthHash,$logFile,$verbal);
          return "ERROR: Could not update record";
       } 
   }
   my($endTimeStamp) = getTimeStamp();
   addToLogFile(sprintf("----> Update needed (for ${countOfKeys}) from ${startTimeStamp} to ${endTimeStamp} = %s",secDiff_YYYYMMDDhhmmss($endTimeStamp,$startTimeStamp)),$logFile,$verbal);
   ## TIME printf("maxBeforeExecutionDuration:${maxBeforeExecutionDuration}    minBeforeExecutionDuration:${minBeforeExecutionDuration}\n");
   ## TIME printf("maxExecutionDuration:${maxExecutionDuration}    minExecutionDuration:${minExecutionDuration}\n");
   return $retMsg;
}

###############################
# dbLoadFile and dbLoadFile_dbh 
###############################
# You can use this function to Load a delimetered file into  DB 
# First record in the file is used to produce DB columns
# If your columns in the file are different from db columns you can create a hash table with mappings
# and pass it as $NewOldFieldHashRef where  db columns are keys and file columns are values 
# 
# returns count of loaded records
sub dbLoadFile {
 my ($db,$login,$password,$FileName,$SepChar,$table,$NewOldFieldHashRef,$LogFile,$verbal,$autoCommit) = @_; 
 my $dbh    = dbConnect($db,$login,$password,$LogFile,$verbal,$autoCommit);
 my($count) = dbLoadFile_dbh($dbh,$FileName,$SepChar,$table,$NewOldFieldHashRef,$LogFile,$verbal);
 dbDisconnect($dbh);
 return $count;
}

sub dbLoadFile_dbh {
  my($dbh,$FileName,$SepChar,$table,$NewOldFieldHashRef,$LogFile,$verbal) = @_;
  
  if ( $SepChar eq "") {
    $SepChar = "\\|";
  }

  addToLogFile("Reading file ${FileName}",$LogFile,$verbal);
  my ($header,$RefAll,$sepChar, $locNameToIndexRef) =   getAllMatchesFromFltFile($FileName,$SepChar,"","","","");
  my @dealRecords = @$RefAll;
  addToLogFile("Finish reading file ${FileName}",$LogFile,$verbal);
  my($count)    = 0;
  $count = @dealRecords;
  if ($count == 0) {
      return $count;
  } else {
      $count = 0;
  }

  my %LOC_NAME_INDEX = ();
 
  my %NAME_TYPE_HASH   = dbBuildHash_dbh ($dbh,"all_tab_columns","COLUMN_NAME","DATA_TYPE",   "TABLE_NAME= '${table}'");
  my %NAME_LENGTH_HASH = dbBuildHash_dbh ($dbh,"all_tab_columns","COLUMN_NAME","DATA_LENGTH", "TABLE_NAME= '${table}'");
  my (@DB_COLUMNS) = sort keys  %NAME_TYPE_HASH;
 
  my $valStr      = "";
  my $columnStr   = "";
  my $valueFormat = "";
  my $column      = "";
  my $insertSql   = "";
  
  ## Prepare Insert Sttmnt
  ## ---------------------
  foreach $column (@DB_COLUMNS) {
     if ($NAME_TYPE_HASH{$column} eq "DATE") {
        $valueFormat = "to_date(?,'YYYYMMDDHH24MISS')";
     } else {
        $valueFormat = "?";
     }
     if ($valStr ne "") {
         $valStr    = "${valStr},   \n   ${valueFormat}";
         $columnStr = "${columnStr},\n   ${column}";
     } else {
         $valStr    = $valueFormat;
         $columnStr = $column;
     }
  }
  $insertSql = qq { INSERT INTO $table (
           $columnStr
       )
       values (
           $valStr
       )
  };
 
 
  ## printf("insertSql:${insertSql}\n");
  $dbh->{PrintError} = $FALSE;
  $dbh->{RaiseError} = $FALSE;

  ### printf("insertSql:${insertSql}\n");
  my $SQLSTH = $dbh->prepare($insertSql);
  if ($DBI::err) {
      addToLogFile("----> ERROR: In dbLoadFile_dbh: Failed to prepare insertSql",$LogFile,$TRUE);
      addToLogFile("----> ERROR caused by:${insertSql}",$LogFile,$TRUE);
      return 0;  # count
  } 
  ## Insert Sttmnt Prepared
  ## ----------------------   
 
  ## Change all file columns to upper case
  foreach $oldKey (keys %$locNameToIndexRef ) {
     $val = $locNameToIndexRef->{$oldKey};
     $newKey = uc($oldKey);
     $LOC_NAME_INDEX{$newKey} = $val;
  }
 
  ## Check if DB column is part of file columns
  foreach $dbColumn (@DB_COLUMNS) {
   if ( !exists $LOC_NAME_INDEX {$dbColumn}) {
    addToLogFile("----> WARNING: DB column $dbColumn is not a part of column names in the file",$LogFile,$TRUE);
    my $oldKey = "";
    if (exists $NewOldFieldHashRef->{$dbColumn}) {
      $oldKey = $NewOldFieldHashRef -> {$dbColumn};
    }
    if ($oldKey  ne "") {
       addToLogFile("Old file column is $oldKey",$LogFile,$verbal);
       addToLogFile("Replacing new key with old key",$LogFile,$verbal);
       my $value = $LOC_NAME_INDEX{$oldKey};
       delete ( $LOC_NAME_INDEX{$oldKey});
       $LOC_NAME_INDEX {$dbColumn} =  $value;
    }
   }
  }
 
 
  my($errCount) = 0;
  foreach $singleRecord (@dealRecords) {
     my @PARTS = ();
     @PARTS    = split($sepChar, $singleRecord);
 
 
  ## Insert a record
  ## ---------------
  my (@INSERT_VALUES) = ();
  ### my $value    = "";
  ### my $fldValue = "";
  foreach $dbcolumn (@DB_COLUMNS) {
   $ValueExists = $TRUE;
   if (exists $LOC_NAME_INDEX{$dbcolumn}) {
      $fldValue =  $PARTS[$LOC_NAME_INDEX{$dbcolumn}];
      ### Not used anymore WR 09/12/00
      ### if ($fldValue =~ "'") {   # replace single quote by double
      ###    $fldValue =~ s/\'/''/g;
      ### }
   } else {
      $fldValue = "";
   } 
   $value = $fldValue;
   @INSERT_VALUES = (@INSERT_VALUES,$value);
  }
 
  ### displayArray(@INSERT_VALUES);

  $SQLSTH->execute(@INSERT_VALUES);
  if ($DBI::err) {
      if ($errCount > 50) {
          addToLogFile("----> ERROR: More than 50 records with error. Loading aborted....",$LogFile,$TRUE);
          last;
      }
      addToLogFile("----> ERROR in loading the following record",$LogFile,$TRUE);
      addToLogFile(sprintf("----> ERROR was: %s",$DBI::errstr),$LogFile,$TRUE);
      displayRecordCausedError(\@INSERT_VALUES,\@DB_COLUMNS,\%NAME_TYPE_HASH,\%NAME_LENGTH_HASH);
      $errCount++;
  } else {
     $count++;
  }
  ## Record inserted
  ## ---------------
 }
  return $count;
}

sub  displayRecordCausedError {
      my($refToRecordValues,$refToDbColumns,$refToNameTypeHash,$refToNameLengthHash,$logFile,$verbal) = @_;
      my($aRecVal) = "";
      my($i)       = 0;

      foreach $aRecVal (@$refToRecordValues) {
        my($fieldName)   = @$refToDbColumns[$i];
        my($fieldType)   = $refToNameTypeHash->{$fieldName};
        my($fieldLength) = $refToNameLengthHash->{$fieldName};
        my($valueLength) = length($aRecVal);
        my($fullType)    = $fieldType;
        my($errMsg)      = "";
      
        if ($fieldType eq VARCHAR2) {
            $fullType = "${fieldType} ${fieldLength}";
            if ($valueLength > $fieldLength) {
               $errMsg = "   ERROR: String too Long";
            }
        } elsif ($fieldType eq DATE) {
            my($newVal) = $aRecVal;
            $newVal =~ s/\D//g;
            if ($newVal ne $aRecVal) {
                $errMsg = "   ERROR: Date contains non numeric character";
            } elsif (!(($valueLength == 8) || ($valueLength == 14) || ($valueLength == 0))) {
                $errMsg = "   ERROR: Date farmat needs to be either YYYYMMDD or YYMMDDHH24MISS  (${valueLength})";
            }
        } elsif ($fieldType eq NUMBER) {
            my($newVal)                     = $aRecVal;
            my($aRecValWithoutDecimalPoint) = $aRecVal;
            $newVal                     =~ s/\D//g;
            $aRecValWithoutDecimalPoint =~ s/\.//g;
            $aRecValWithoutDecimalPoint =~ s/\,//g;
            $aRecValWithoutDecimalPoint =~ s/^-//g;
            if ($newVal ne $aRecValWithoutDecimalPoint) {
                $errMsg = "   ERROR: Number contains non numeric character";
            }
        } 

        addToLogFile(sprintf("------> $fieldName ($fullType):$aRecVal:Length=$valueLength:$errMsg"),$logFile,$TRUE);
        $i++;
      }
}

############################################################################
# Common mapping table and their access methods
############################################################################
%cityShortName_insightCityCode = (
     "NY" => "na",
     "LN" => "ln",
     "ZH" => "ch",
     "ZN" => "eur",
);

sub getInsightCityCode_CityShortName {
  my($cityShortName) = @_;
  return getValueFromHash($cityShortName,$NotDefinedStr,$FALSE,%cityShortName_insightCityCode);
}

sub getCityShortName_insightCityCode {
  my($insightCityCode) = @_;
  return getValueFromHash($insightCityCode,$NotDefinedStr,$TRUE,%cityShortName_insightCityCode);
}

%branchCode_cityShortName = (
      "0835" => "ZH",
      "0933" => "LN",
      "0941" => "NY",
      "1926" => "FF",
      "1927" => "FA",
      "2903" => "CY",
      "0251" => "GE",
      "0982" => "TK",
      "0974" => "SG",
      "0975" => "SH",
      "0930" => "HK",
      "0998" => "SY",
      "0971" => "ZN",
);

%branchCode_cityName = (
      "0835" => "Zurich",
      "0933" => "London",
      "0941" => "New York",
      "1926" => "Frankfurt",
      "1927" => "Frankfurt-ALM",
      "2903" => "Cyprus",
      "0251" => "Geneva",
      "0982" => "Tokyo",
      "0974" => "Singapore",
      "0975" => "Shanghai",
      "0930" => "Hong Kong",
      "0998" => "Sydney",
      "0971" => "Eurom",
);

%branchCode_wssCityShortName = (
      "0941" => "N1",
      "0982" => "T1",
      "0974" => "S1",
      "0975" => "SH",
      "0930" => "H1",
      "0998" => "SY",
      "0933" => "L1",
);

sub getCityShortName_BranchCode {
  my($branchCode) = @_;
  return getValueFromHash($branchCode,$NotDefinedStr,"",%branchCode_cityShortName);
}

sub getBranchCode_CityShortName {
  my($cityShortName) = @_;
  my($retVal) = getValueFromHash($cityShortName,$NotDefinedStr,$TRUE,%branchCode_cityShortName);
  if ($retVal eq $NotDefinedStr) {
    $retVal = getValueFromHash($cityShortName,$NotDefinedStr,$TRUE,%branchCode_wssCityShortName);
  }
  return $retVal;
}

sub getCityName_BranchCode {
  my($branchCode) = @_;
  return getValueFromHash($branchCode,$NotDefinedStr,"",%branchCode_cityName);
}

sub getCityName_CityShortName {
  my($cityShortName) = @_;
  my($branchCode) = getBranchCode_CityShortName($cityShortName);
  return getCityName_BranchCode($branchCode);
}

sub getWssCityShortName_CityShortName {
  my($cityShortName) = @_;
  my($retVal) = $NotDefinedStr;
  my($branchCode) = getBranchCode_CityShortName($cityShortName);
  $retVal = getValueFromHash($branchCode,$NotDefinedStr,$FALSE,%branchCode_wssCityShortName);
  return $retVal;
}

sub getCityShortName_WssCityShortName {
  my($cityShortName) = @_;
  my($retVal) = $NotDefinedStr;
  my($branchCode) = getBranchCode_CityShortName($cityShortName);
  $retVal = getValueFromHash($branchCode,$NotDefinedStr,$FALSE,%branchCode_cityShortName);
  return $retVal;
}

csfbDisplayError(lookForMissingKeys("branchCode_cityShortName","branchCode_cityName"));

sub getGmmBaseCodeFromWSS_BaseCode {
  my($wssBasisCode) = @_;
  my $retVal = $NotDefinedStr;
  $retVal = getValueFromHash($wssBasisCode,$NotDefinedStr,$FALSE,%basisCodeMappingWSS_TIQ);
  return $retVal;   
}

# -------------------------------------------------------------------------------------------
%businessDaysMapping = (
	'Today' => 0,
	'1d'    => 1,
	'1bd'   => 1,
	'2d'    => 2,
	'2bd'   => 2,
	'3d'    => 3,
	'4d'    => 4,
	'5d'    => 5,
	'5bd'   => 5,
	'1w'    => 7,
	'10d'   => 10,
	'2w'    => 14,
);

%basisCodeMapping = (
  "ACT365"   => "1",
  "ACTACT"   => "1",
  "ACTACU"   => "1",
  "365365"   => "1",
  "WRK360"   => "1",
  "A/365"    => "1",
  "A/360"    => "2",
  "ACT360"   => "2",
  "A/A"      => "3",
  "30 360"   => "4",
  "30/360"   => "4",
  "D30360"   => "4",
  "3E/36I"   => "4",
  "30D360"   => "4",
  "30E360"   => "4",
  "30+360"   => "5",
  "30E+/360" => "5",
);

%basisCodeMappingWSS_TIQ = (
  "30 360"   =>  "30/360",
  "365365"   =>  "A/A",
  "ACT360"   =>  "A/360",
  "ACT365"   =>  "A/365",
  "ACTACT"   =>  "A/A",
  "ACTACU"   =>  "A/A",
  "30D360"   =>  "3E+/36",
  "30E360"   =>  "3E+/36",
);
# GPAC extracors related

sub gpacLoadBasisTagMappings {
 
  my ($tmpDir) = @_;
 
  my $ftpDir = "/share/dealweb/spool/GpacExtractors";
  my $ftpNode = "pnygmmd1.fir.fbc.com";
  my $ftpUser = "lhftp";
  my $ftpPassword = getFtpLoginPassword($ftpUser,$ftpNode);
 
  my (@files) = ("futuretype_to_basistag.txt", "rateindex_to_basistag.txt",
                 "tiq_sectype_to_basistag.txt", "wss_sectype_to_basistag.txt"  );
 
 
 
  foreach $file (@files) {
 
    ftpGet($file,$ftpNode,$ftpDir,"${ftpUser} ${ftpPassword}",$tmpDir,"ascii",$TRUE);
    chompFile ("${tmpDir}/${file}", "${tmpDir}/X${file}");
    my $cmd = "mv ${tmpDir}/X${file} ${tmpDir}/${file}";
    `$cmd`;
    convertTXT_to_FLT("${tmpDir}/${file}","\|");
  }
 
   %FutureTypeBasisTagTbl_TIQ = getTransTable("${tmpDir}/futuretype_to_basistag.flt","\\|",
                                              "System=TIQ","FutType","Basis_Tag","","");
 
   %FutureTypeBasisTagTbl_WSS = getTransTable("${tmpDir}/futuretype_to_basistag.flt","\\|",
                                              "System=WSS","FutType","Basis_Tag","","");
 
   %SecurityTypeBasisTagTbl_WSS = getTransTable("${tmpDir}/wss_sectype_to_basistag.flt","\\|",

                                                "","SEC_TYPE","BASIS_TAG","","");
   %SecurityTypeBasisTagTbl_TIQ = getTransTable("${tmpDir}/tiq_sectype_to_basistag.flt","\\|",
                                                "","Security_Class","Basis_Tag","","");
 
   %RateIndexBasisTagTbl_TIQ =  getTransTable("${tmpDir}/rateindex_to_basistag.flt","\\|",
                                              "SYSTEM=TIQ","RATE_INDEX","BASIS_TAG","","");

   %RateIndexBasisTagTbl_WSS =  getTransTable("${tmpDir}/rateindex_to_basistag.flt","\\|",
                                              "SYSTEM=WSS","RATE_INDEX","BASIS_TAG","","");
 
 
} 

sub gpacMapBasisTag {
  my ($gpacDealtype, $tradingSystem, $keyValue, $keyValue2, $keyValue3) = @_;
 
 
  my $basisTag = "";
 
  if ($gpacDealtype eq "001" || $gpacDealtype eq "002" || $gpacDealtype eq "004" || $gpacDealtype eq "OO5") {
    return "LOTCD";
  }
 
  if ($gpacDealtype eq "003") {
    return "LEXTD";
  }
 
 
  if ($gpacDealtype eq "901" || $gpacDealtype eq "902") {
    return "LCASH";
  }
 
  if ($gpacDealtype eq "903") {  # FRA

		if ($keyValue eq "AUD") { return "LOTCD"; }
		
		if ($keyValue eq "NZD") { return "LEXTD";  }

     return "NLOTC";
  }
 
  if ($gpacDealtype eq "909") {
     return "NGREP";
  }
 
 
  if ($gpacDealtype eq "920") {
     return "OIS";
  }
 
  if ($gpacDealtype eq "999") {
    return "";
  }
 
  if ($gpacDealtype eq "904" || $gpacDealtype eq "905") {
    my $defaultFuturebasisTag = "LEXTD";


#    if ($tradingSystem eq "WSS" ) {
#      if (substr( $keyValue,0,2) eq "EY") {
#        if (substr( $keyValue2,0,2) eq "YE") {
#          return "NLETD";
#         } else {
#          return "LEXTD";
#         }
#       }
# 
#     }

  if ($tradingSystem eq "WSS" ) {
      if (substr( $keyValue,0,2) eq "EY") {
          return "NLETD";
      }
  }
 

 
    if ($tradingSystem eq "WSS") {
      %FutureTypeBasisTagTbl = %FutureTypeBasisTagTbl_WSS;
    } else {
      %FutureTypeBasisTagTbl = %FutureTypeBasisTagTbl_TIQ;
    }
 
    $basisTag= $FutureTypeBasisTagTbl{$keyValue};
 
    if ($basisTag eq "" && $keyValue ne "") {
      foreach $key ( keys %FutureTypeBasisTagTbl) {
        if (substr ($keyValue, 0, length($key)) eq $key ) {
          return $FutureTypeBasisTagTbl{$key};
        }
 
      }
    } else {
       return $basisTag;
    }
    return $defaultFuturebasisTag; 
  }
 
 
  if ($gpacDealtype eq "906" ) {
 
    my $basisTagDefault = "CORP";
 
    if ($tradingSystem eq "WSS") {
        # $keyValue is the sec type
         return $SecurityTypeBasisTagTbl_WSS{$keyValue} || $basisTagDefault;
 
    } else {
       my $Issuer = $keyValue;
       my $SecurityClass = $keyValue2;
       my $SecurityTypeString = $keyValue3;
 
       if ($Issuer =~ "GOV" || $Issuer =~ "KING" || $Issuer =~ "CENJAP" || $Issuer =~ "TREAS") {
         return "GOSEC";
       } else {
         if ( $SecurityClass eq "BOND"  &&  ( $SecurityTypeString  eq "JGB" || $SecurityTypeString  eq "JGTB" || $SecurityTypeString  eq "CJGB" || $SecurityTypeString  eq "JGFB"  )  ) {
             return "GOSEC";
         } else {
           return $SecurityTypeBasisTagTbl_TIQ{$SecurityClass} || $basisTagDefault;
         }
       }
    }
     return $basisTagDefault;
  }
 
  if ($gpacDealtype eq "910" ) {
    my %RateIndexBasisTagTbl = ();
 
    my $defaultSwapBasisTag = "NLOTC";
 
    if ($keyValue eq "") {  # fixed side
        return "LOTCD";
    }
 
 
    if ($tradingSystem eq "WSS") {
      %RateIndexBasisTagTbl = %RateIndexBasisTagTbl_WSS ;
    } else {
      %RateIndexBasisTagTbl = %RateIndexBasisTagTbl_TIQ;
    }
 
    $basisTag= $RateIndexBasisTagTbl{$keyValue};
 
    if ($basisTag eq "") {
      foreach $key ( keys %RateIndexBasisTagTbl) {
        if (substr ($keyValue, 0, length($key)) eq $key ) {
          return $RateIndexBasisTagTbl{$key};
 
        }
      }
    } else {
      return $basisTag;
    }
 
    return $defaultSwapBasisTag; # default
  }
  return $basisTag;
 
}
 
 

# -------------------------------------------------------------------------------------------
sub getBucketFromDaycount {
  my($days) = @_;
  my($retVal) = $NotDefinedStr;
  if ($days < 2) {
     $retVal = "O/N";
  } elsif (($days >= 2) && ($days <= 7)) {
     $retVal = "1W";
  } elsif (($days >= 8) && ($days <= 14)) {
     $retVal = "2W";
  } elsif (($days >= 15) && ($days <= 45)) {
     $retVal = "1M";
  } elsif (($days >= 46) && ($days <= 76)) {
     $retVal = "2M";
  } elsif (($days >= 77) && ($days <= 106)) {
     $retVal = "3M";
  } elsif (($days >= 107) && ($days <= 136)) {
     $retVal = "4M";
  } elsif (($days >= 137) && ($days <= 166)) {
     $retVal = "5M";
  } elsif (($days >= 167) && ($days <= 196)) {
     $retVal = "6M";
  } elsif (($days >= 197) && ($days <= 286)) {
     $retVal = "9M";
  } elsif ($days >= 287) {
     $retVal = "1Y";
  }
  return $retVal;
}

sub getBucketDaysFromDaycount {
  my($days) = @_;
  my($retVal) = $NotDefinedStr;
  if ($days < 2) {
     $retVal = "1";
  } elsif (($days >= 2) && ($days <= 7)) {
     $retVal = "7";
  } elsif (($days >= 8) && ($days <= 14)) {
     $retVal = "14";
  } elsif (($days >= 15) && ($days <= 45)) {
     $retVal = "30";
  } elsif (($days >= 46) && ($days <= 76)) {
     $retVal = "60";
  } elsif (($days >= 77) && ($days <= 106)) {
     $retVal = "90";
  } elsif (($days >= 107) && ($days <= 136)) {
     $retVal = "120";
  } elsif (($days >= 137) && ($days <= 166)) {
     $retVal = "150";
  } elsif (($days >= 167) && ($days <= 196)) {
     $retVal = "180";
  } elsif (($days >= 197) && ($days <= 286)) {
     $retVal = "270";
  } elsif ($days >= 287) {
     $retVal = "360";
  }
  return $retVal;
}

###################################################
##### ARGV manipulations
####################################################

sub getAndSetArguments {
  my($commonControlFile, $numberOfArgs, $WhereClause) = @_;
  my (%AppInfo) = ();


  if ($commonControlFile eq "") {
   return;
  } 

  if($WhereClause eq "") {
    $WhereClause  = "AppName=${APP_NAME}";
  }
 
  %AppInfo = getSingleRecInHash($commonControlFile,"\\|","",$WhereClause,"","");
 
  for (my $i = 0; $i< $numberOfArgs;$i++) {
    if ($ARGV[$i] eq "") {
      my $k = $i + 1;
      my $ArgName = "Arg$k";
      $ARGV[$i] = $AppInfo{$ArgName};
    }
 }
}

####################################################
##### CommonControl function and definitions
####################################################

$countOfCommonControlArguments = 30;


sub setHashFromCommonControl {
   my($inVal,$onlyUseBRSep,$keyValSep,$stripKey,$stripValue) = @_;
   $onlyUseBRSep    = setDefault($onlyUseBRSep,  $FALSE);
   $keyValSep       = setDefault($keyValSep,     "=>");
   $stripKey        = setDefault($stripKey,      $TRUE);
   $stripValue      = setDefault($stripValue,    $TRUE);
   my(@aList)  = setListFromCommonControl($inVal,$onlyUseBRSep);
   my %retHash = ();
   my $aKey    = "";
   my $aVal    = "";
   
   foreach my $aEntry (@aList) {
      my(@parts) = split($keyValSep,$aEntry);
      $aKey = $parts[0];
      $aVal = $parts[1];
      if ($stripKey)   { $aKey = strip($aKey); }
      if ($stripValue) { $aVal = strip($aVal); }
      %retHash = (%retHash,($aKey,$aVal));
   }
   return %retHash;
}


$commonControlUrl = "http://gmmit.csfb.net/cgi-bin/gmmit/getCommonControlTable.pl";
## $commonControlUrl = "http://kallo.tszrh.csfb.com:7780/cgi-bin/gmmit/getCommonControlTable.pl";

sub getCommonControlViaHttpGet {
   my($aUrl,$fileName,$eMailAdr,$subject,$logfile,$verbal) = @_;
   $verbal     = setDefault($verbal,$TRUE);

   #### Overwrite parameter
   $eMailAdr = $httpGetCommonControlSupport;

   my $tmpFilename = "${fileName}_tmp";
   getHttpSimple($aUrl,$tmpFilename,$FALSE);
   if (-s $tmpFilename) {
      `cp $tmpFilename $fileName && rm $tmpFilename`;
       addToLogFile("-->  Received CommonControl from ${aUrl}",$logfile,$verbal);
   } else {
       if (-f $tmpFilename) {
	       `rm $tmpFilename`;
	       addToLogFile("-->  WARNING: CommonControl file received was size ZERO.",$logfile,$verbal);
       }
       addToLogFile("-->  WARNING: Could not receive CommonControl from ${aUrl}",$logfile,$verbal);
       $ERROR_FOUND = $FALSE;
       $msg = qq {
         Fetching new CommonControl table failed!
         Took the old one (see attachment)
       };
       if ($eMailAdr ne "") {
         sendMailwithAttachments($eMailAdr,$eMailAdr,$subject,$msg,"${fileName},${logfile}","","");
       }
   }
}


sub getCommonControlViaHttpGetForZH_nodes {
	my($aUrl,$fileName,$eMailAdr,$subject,$logfile,$verbal) = @_;
	$verbal     = setDefault($verbal,$TRUE);
   
	# Read commonControl url from FT ZH config DB
	my $aTmpUrl = `csg_getConfig APPLICATION=gmm INSTANCE=ZHREP CONFIGURATION=common_ctrl_url`;
	if (stringStartsWith($aTmpUrl,"http://") && (stringEndsWith($aTmpUrl,"getCommonControlTable.pl"))) {
		addToLogFile("CommonControl URL overwritten from FT ZH Config Server!!!",$logfile,$verbal);
		addToLogFile("  old: ${aUrl}",$logfile,$verbal);
		addToLogFile("  new: ${aTmpUrl}",$logfile,$verbal);
		$aUrl = $aTmpUrl;
	} elsif ($aTmpUrl eq "NO HTTP-GET") {
		addToLogFile("WARNING: CommonControl via http-get is disabled!",$logfile,$verbal);
		return $TRUE;
	}

	if (isZH_Node()) {
		addToLogFile("Loading commonControl via http-get from web server",$logfile,$verbal);
		if ($fileName eq "") {
			if ($commonControlFile eq "") {
				$commonControlFile = $ENV{CSG_COMMON_CONTROL_DIR}."/commonControl.flt";
			}
			$fileName = $commonControlFile
		}
		addToLogFile("....Loaded:${aUrl}",$logfile,$verbal);
		addToLogFile("....Saved :${fileName}",$logfile,$verbal);
		getCommonControlViaHttpGet($aUrl,$fileName,$eMailAdr,$subject,$logfile,$verbal);
		return $TRUE;
	} else {
		return $FALSE;
	}
}

sub setCommonCtrlWhereClause {
 my($appNameWhereClause,$location,$compareLocation,$instance,$compareInstance) = @_;

  my $whereClause = $appNameWhereClause;
  if ($location ne "") {
    $whereClause = "${whereClause} AND LocationCode=${compareLocation}";
  }
  if ($instance ne "") {
    $whereClause = "${whereClause} AND SelectedInstance=${compareInstance}";
  }
  return $whereClause;
}

sub setCommonVariablesFromControlFileForApplicationName {
  my($commonControlFile,$appNameWhereClause,$location,$instance,$verbal) = @_;
  $entryFound  = setCommonVariablesFromControlFile($commonControlFile,setCommonCtrlWhereClause($appNameWhereClause,$location,$location,$instance,$instance),$verbal);
  if ($entryFound) { return $entryFound; }

  # try to find one where instance is set to "all"
  $entryFound  = setCommonVariablesFromControlFile($commonControlFile,setCommonCtrlWhereClause($appNameWhereClause,$location,$location,$instance,"all"),$verbal);
  if ($entryFound) { return $entryFound; }

  # try to find one where instance is set to "any"
  $entryFound  = setCommonVariablesFromControlFile($commonControlFile,setCommonCtrlWhereClause($appNameWhereClause,$location,$location,$instance,"any"),$verbal);
  if ($entryFound) { return $entryFound; }

  # try to find one where location is set to "all"
  $entryFound  = setCommonVariablesFromControlFile($commonControlFile,setCommonCtrlWhereClause($appNameWhereClause,$location,"all",$instance,$instance),$verbal);
  if ($entryFound) { return $entryFound; }

  # try to find one where location is set to "any"
  $entryFound  = setCommonVariablesFromControlFile($commonControlFile,setCommonCtrlWhereClause($appNameWhereClause,$location,"any",$instance,$instance),$verbal);
  if ($entryFound) { return $entryFound; }

  # try to find one where location and instance are set to "all"
  $entryFound  = setCommonVariablesFromControlFile($commonControlFile,setCommonCtrlWhereClause($appNameWhereClause,$location,"all",$instance,"all"),$verbal);
  if ($entryFound) { return $entryFound; }

  # try to find one where location and instance are set to "any"
  $entryFound  = setCommonVariablesFromControlFile($commonControlFile,setCommonCtrlWhereClause($appNameWhereClause,$location,"any",$instance,"any"),$verbal);
  if ($entryFound) { return $entryFound; }

  # try to find one where location and instance are set to "any" and "all"
  $entryFound  = setCommonVariablesFromControlFile($commonControlFile,setCommonCtrlWhereClause($appNameWhereClause,$location,"any",$instance,"all"),$verbal);
  if ($entryFound) { return $entryFound; }

  # try to find one where location and instance are set to "all" and "any"
  $entryFound  = setCommonVariablesFromControlFile($commonControlFile,setCommonCtrlWhereClause($appNameWhereClause,$location,"all",$instance,"any"),$verbal);
  if ($entryFound) { return $entryFound; }


  return $FALSE;
}


# set global variables set by the common control file
#  returns $FALSE if no record has been found for the specified whereClause
sub setCommonVariablesFromControlFile {
      my($controlFileName,$whereClause,$verbal) = @_;
      $whereClause = setDefault($whereClause,"AppName=${myOnlyName}");

      if (!(isFileExists($controlFileName))) {
        return $FALSE;
      }

      my(@ftpUser)      = ();
      my(@ftpNodes)     = ();
      my($oldDebugFlag) = $debug;
      $debug            = $verbal;
      %APP_INFO         = getSingleRecInHash($controlFileName,"\\|","",$whereClause,"","");

      if (isHashEmpty(%APP_INFO)) {
        return $FALSE;
      } 


      ## test flags
      ## ----------
      $IsTest = $APP_INFO{"IsTest"};               
      if (uc($IsTest) eq "YES") {
         $IsTest    = $TRUE;
      } else {
         $IsTest    = $FALSE;
      }
 
      ## dB access information
      ## ---------------------
      $db          = $APP_INFO{"dbName"};
      if ($db =~ /^\$/) {
          $db =~ s/^\$//g;
          $db = $ENV{$db};
      }
      dumpVar("db","-20");


      $dbUser    = $APP_INFO{"dbUser"};                 
      if ($dbUser =~ /^\$/) {
          $dbUser =~ s/^\$//g;
          my($dbloginStr)    = $ENV{$dbUser};
          my(@loginPassword) = split("/", $dbloginStr);
          $dbUser              = $loginPassword[0];
          $dbPassword          = $loginPassword[1];
      } else {
         $dbPassword    = getFtpLoginPassword($dbUser,$db);
         if ($dbPassword eq "") { $dbPassword = $APP_INFO{"dbPassword"}; }

      }
      dumpVar("dbUser","-20");
      ### dumpVar("dbPassword","-20");

      ## ftp information
      ## ---------------
      $doFtp       = $APP_INFO{"doFtp"};          
      if (uc($doFtp) eq "YES") {
         $doFtp = $TRUE;
      } else {
         $doFtp = $FALSE;
      }
       
      my($multiNode) = $FALSE;
      $ftpNode =  makeQuotedStrFromArray(";","",trimRemoveEmptiesAndCommentsInArray(setListFromCommonControl($APP_INFO{"ftpNode"})));
      if (index($ftpNode,";") != -1) {
          @ftpNodes   = split("\;", $ftpNode);
          $ftpNode    = \@ftpNodes;
          $multiNode  = $TRUE;
      }

      $ftpDirStr = makeQuotedStrFromArray(";","",trimRemoveEmptiesAndCommentsInArray(setListFromCommonControl($APP_INFO{"ftpDir"})));
      if (index($ftpDirStr,";") != -1) {
          my(@ftpDirStrArr)            = split("\;",$ftpDirStr);
          my(@ftpDir)                  = ();
          my(@ftpAction)               = ();
          my(@ftpActionParameters)     = ();
          foreach my $aFtpDirStr (@ftpDirStrArr) {
             my $dirStr = $aFtpDirStr;
             $dirStr =~ s/\s+/ /g;
             push(@ftpDir,getFieldFromString(" ",0,$dirStr,""));
             push(@ftpAction,getFieldFromString(" ",1,$dirStr,""));
             my $ftpParam = removeFieldFromString(" ",0,$dirStr,"");
                $ftpParam = removeFieldFromString(" ",0,$ftpParam,"");
             push(@ftpActionParameters,$ftpParam);
          }
          $ftpDir              = \@ftpDir;
          $ftpAction           = \@ftpAction;
          $ftpActionParameters = \@ftpActionParameters;
      } else {
          $ftpDir      = getFieldFromString(" ",0,$ftpDirStr,"");
          $ftpAction   = getFieldFromString(" ",1,$ftpDirStr,"");
          my $ftpParam = removeFieldFromString(" ",0,$ftpDirStr,"");
             $ftpParam = removeFieldFromString(" ",0,$ftpParam,"");
          $ftpActionParameters = $ftpParam;
      }

      $ftpUser = makeQuotedStrFromArray(";","",trimRemoveEmptiesAndCommentsInArray(setListFromCommonControl($APP_INFO{"ftpUser"})));
      if (index($ftpUser,";") != -1) {
          @ftpUser = split("\;", $ftpUser);
          $ftpUser = \@ftpUser;
      }

      $ftpPassword = makeQuotedStrFromArray(";","",trimRemoveEmptiesAndCommentsInArray(setListFromCommonControl($APP_INFO{"ftpPassword"})));                                        
      if (index($ftpPassword,";") != -1) {
          my(@ftpPassword) = split("\;", $ftpPassword);
          $ftpPassword = \@ftpPassword;
      } elsif ($ftpPassword eq "") {
          if ($multiNode) {
              my(@ftpPassword) = ();
              my($aFtpUserName) = "";
              my($i) = 0;
              foreach $aFtpUserName (@ftpUser) {
                  push(@ftpPassword,getFtpLoginPassword($aFtpUserName,$ftpNodes[$i]));
                  $i++;
              }
              $ftpPassword = \@ftpPassword;
          } else {
              $ftpPassword = getFtpLoginPassword($ftpUser,$ftpNode);
          }
      }


      ## email information
      ## -----------------
      $doSendMail  = $APP_INFO{"SendData"};         
      if (uc($doSendMail) eq "YES") {
         $doSendMail = $TRUE;
      } else {
         $doSendMail = $FALSE;
      }
      $fromAdr        = $APP_INFO{"FromAddress"};
      $receiverName   = $APP_INFO{"Reciever"};          
      $toAdr          = $APP_INFO{"RecieverEmail"};        $toAdr          =~ s/\<BR\>/,/g;
      $ccAdr          = $APP_INFO{"Cc"};                   $ccAdr          =~ s/\<BR\>/,/g;
      $bccAdr         = $APP_INFO{"Bcc"};                  $bccAdr         =~ s/\<BR\>/,/g;
      $notifyEmailAdr = $APP_INFO{"notifyEmailAdr"};       $notifyEmailAdr =~ s/\<BR\>/,/g;
      $senderName     = getNameFromEmail($fromAdr,$TRUE);

      ## other data items
      ## ----------------
      $lockName       = $APP_INFO{"lockName"};      


      if ($verbal) {
         printf("\nSettings read from ....\n");
         displayHashTable(%APP_INFO);
         printf("...${commonControlFile}\n");
      }
      $debug = $oldDebugFlag;
      return $TRUE;
  }


############################################################################
# Function to manipulate ftp password file
############################################################################
# looks for the env CSG_FTP_LOGIN_FILE_PATH otherwise "$RunS/Common/Control/" is
# used to refere to the password file.
sub doTest_getPassword {
   my($myFullName,$debugThisFct) = @_;
   $debugThisFct = setDefault($debugThisFct,$FALSE);
	my $testCases = qq {
		Nr|UserName     |Resource    |Instance|Level|Line|Expected
		01|A_TEST_USER_1|A_TEST_RES_1|LHX     |ET   |A   |pwd_001
		02|A_TEST_USER_1|A_TEST_RES_1|LHX     |ET   |B   |pwd_002
		03|A_TEST_USER_1|A_TEST_RES_1|LHX     |PR   |A   |pwd_003
		04|A_TEST_USER_1|A_TEST_RES_1|LHX     |PR   |C   |pwd_004
		05|A_TEST_USER_1|A_TEST_RES_1|LHS     |ET   |A   |pwd_005
		06|A_TEST_USER_1|A_TEST_RES_1|LHS     |ET   |D   |pwd_006
		07|A_TEST_USER_1|A_TEST_RES_1|LHS     |PR   |A   |pwd_007
		08|A_TEST_USER_1|A_TEST_RES_1|SGX     |PR   |D   |pwd_008
	};

	my $useDB = $FALSE;
	# for (my $i = 2; $i <= getCountOfLinesFromQQ($testCases); $i++) {
		# my $testCaseNr  = getFieldFromQQ($testCases,$i,1);
		# my $userName    = getFieldFromQQ($testCases,$i,2);
		# my $server      = getFieldFromQQ($testCases,$i,3);
		# my $pInstance   = getFieldFromQQ($testCases,$i,4);
		# my $testLevel   = getFieldFromQQ($testCases,$i,5);
		# my $pLine       = getFieldFromQQ($testCases,$i,6);
		# my $expectedRes = getFieldFromQQ($testCases,$i,7);

		# if ($debugThisFct) {
			# print("\n==> ${myFullName}: Test-Case:${i}:${testCaseNr}\n");
			# print("       userName    :${userName}:\n");
			# print("       server      :${server}:\n");
			# print("       testLevel   :${testLevel}:\n");
			# print("       pLine       :${pLine}:\n");
			# print("       pInstance   :${pInstance}:\n");
			# print("       expectedPwd :${expectedPwd}:\n");
			# print("       getPassword(${userName}, ${server}, ${testLevel}, ${pInstance}, ${pLine}, , , ${useDB})=".getPassword($userName, $server, $testLevel, $pInstance, $pLine, "", "", $useDB)."\n");
		# }
		# if (!(getPassword($userName, $server, $testLevel, $pInstance, $pLine, "", "", $useDB) eq $expectedRes)) { print("ERROR: Test-Case ${testCaseNr}\n"); print("       getPassword(${userName}, ${server}, ${testLevel}, ${pInstance}, ${pLine}, , , ${useDB})=".getPassword($userName, $server, $testLevel, $pInstance, $pLine, "", "", $useDB)."        Expected:${expectedRes}:\n");}
	# }
	
	$useDB = $TRUE;
	for (my $i = 2; $i <= getCountOfLinesFromQQ($testCases); $i++) {
		my $testCaseNr  = getFieldFromQQ($testCases,$i,1);
		my $userName    = getFieldFromQQ($testCases,$i,2);
		my $server      = getFieldFromQQ($testCases,$i,3);
		my $pInstance   = getFieldFromQQ($testCases,$i,4);
		my $testLevel   = getFieldFromQQ($testCases,$i,5);
		my $pLine       = getFieldFromQQ($testCases,$i,6);
		my $expectedRes = getFieldFromQQ($testCases,$i,7);

		if ($debugThisFct) {
			print("\n==> ${myFullName}: Test-Case:${i}:${testCaseNr}\n");
			print("       userName    :${userName}:\n");
			print("       server      :${server}:\n");
			print("       testLevel   :${testLevel}:\n");
			print("       pLine       :${pLine}:\n");
			print("       pInstance   :${pInstance}:\n");
			print("       expectedPwd :${expectedPwd}:\n");
			print("       getPassword(${userName}, ${server}, ${testLevel}, ${pInstance}, ${pLine}, , , ${useDB})=".getPassword($userName, $server, $testLevel, $pInstance, $pLine, "", "", $useDB)."\n");
		}
		if (!(getPassword($userName, $server, $testLevel, $pInstance, $pLine, "", "", $useDB) eq $expectedRes)) { print("ERROR: Test-Case ${testCaseNr}\n"); print("       getPassword(${userName}, ${server}, ${testLevel}, ${pInstance}, ${pLine}, , , ${useDB})=".getPassword($userName, $server, $testLevel, $pInstance, $pLine, "", "", $useDB)."        Expected:${expectedRes}:\n");}
	}

}

$ftpLoginFile_CryptKey       = "CS_NY 01";
$ftpLoginFile_KeyFNam        = "Hash";
$ftpLoginFile_HostNameFNam   = "HostName";
$ftpLoginFile_UserIdFNam     = "UserId";
$ftpLoginFile_PasswdFNam     = "Password";
$ftpLoginFile_InstanceFNam   = "Instance";
$ftpLoginFile_TestLevelFNam  = "TestLevel";
$ftpLoginFile_LineFNam       = "Line";
$ftpLoginFile_ModDateFNam    = "ModDate";
$ftpLoginFile_ModByFNam      = "ModBy";
$ftpLoginFile_CommentFNam    = "Comment";
$ftpLoginFile_FieldSep       = "\\|";
$passwordFileCrypted         = "ftpLogins_crypted.flt";
$passwordFileCryptedLocal    = "ftpLogins_crypted_local.flt";
$passwordFileCryptedFT_11    = "ftpLogins_crypted_FT_11.flt";
$passwordFileDecrypted       = "ftpLogins_decrypted.flt";
$passwordFileDecryptedLocal  = "ftpLogins_decrypted_local.flt";
$passwordFileDecryptedFT_11  = "ftpLogins_decrypted_FT_11.flt";

sub getUserNameWhereClause_Hidden {
	my($userName) = @_;

	my $whereClause = "${ftpLoginFile_UserIdFNam} eq ${userName}";
	if (index($userName,"\\") != -1) {
		$userName =~ s/\\+/;/g;
		my(@parts) = split(";",$userName);
		$whereClause = "${ftpLoginFile_UserIdFNam} starts ".$parts[0]." AND ${ftpLoginFile_UserIdFNam} ends ".$parts[1];
	} 
	return $whereClause;
}

sub getResourceNameWhereClause_Hidden {
	my($resName) = @_;

	my $whereClause = " AND ${ftpLoginFile_HostNameFNam} LIKE ${resName}";
	if ($resName eq "") {
		$whereClause = "";
	} 
	return $whereClause;
}


sub getFtpLoginPasswordExact_Hidden {
	my($userName,$resName,$pLevel,$pInstance,$pLine,$notFoundMsg,$doDebug) = @_;
	my $passwd = $notFoundMsg;

	my $locWhereClause = getUserNameWhereClause_Hidden($userName) .getResourceNameWhereClause_Hidden($resName) . " AND ${ftpLoginFile_InstanceFNam} eq ${pInstance} AND ${ftpLoginFile_TestLevelFNam} eq ${pLevel} AND ${ftpLoginFile_LineFNam} eq ${pLine}";

	writeTrace($doDebug,"getFtpLoginPasswordExact_Hidden::locWhereClause:${locWhereClause}:");
	my %ftpRec = getSingleRecInHash(getFtpLoginFileDecryptedFilename(),$ftpLoginFile_FieldSep,"",$locWhereClause);
	writeTrace($doDebug,"getFtpLoginPasswordExact_Hidden::Return-Hash");if ($doDebug) { displayHashTable(%ftpRec); print("\n"); }

	if (exists($ftpRec{$ftpLoginFile_PasswdFNam})) {
		$passwd = $ftpRec{$ftpLoginFile_PasswdFNam};
	}

	writeTrace($doDebug,"getFtpLoginPasswordExact_Hidden::Password found:${passwd}:");
	return $passwd;
}

sub getFtpLoginPasswordExactFT7_Hidden {
	my($userName,$resName,$pLevel,$notFoundMsg,$doDebug) = @_;
	my $passwd = $notFoundMsg;

	my $locWhereClause = getUserNameWhereClause_Hidden($userName) .getResourceNameWhereClause_Hidden($resName) . " AND ${ftpLoginFile_TestLevelFNam} eq ${pLevel}";

	writeTrace($doDebug,"getFtpLoginPasswordExactFT7_Hidden::locWhereClause:${locWhereClause}:");
	my %ftpRec = getSingleRecInHash(getFtpLoginFileDecryptedFilename(),$ftpLoginFile_FieldSep,"",$locWhereClause);
	writeTrace($doDebug,"getFtpLoginPasswordExactFT7_Hidden::Return-Hash");if ($doDebug) { displayHashTable(%ftpRec); print("\n"); }

	if (exists($ftpRec{$ftpLoginFile_PasswdFNam})) {
		$passwd = $ftpRec{$ftpLoginFile_PasswdFNam};
	}

	writeTrace($doDebug,"getFtpLoginPasswordExactFT7_Hidden::Password found:${passwd}:");
	return $passwd;
}

sub getFtpLoginPassword_Hidden {
	my($userName,$resName,$pLevel,$pInstance,$pLine,$notFoundMsg,$doDebug) = @_;

	my $isNewFileStruct = $TRUE;
	my $fullDecryptedFilename = getFtpLoginFileDecryptedFilename();
	$isNewFileStruct          = (index(getTableHeader($fullDecryptedFilename),$ftpLoginFile_LineFNam) != -1);


	if (!($isNewFileStruct)) { # FT-7
		$pLevel      = setDefault($pLevel,      $ENV{CSG_CURRENT_TEST_LEVEL});
	} else {
		$pLevel      = setDefault($pLevel,      $ENV{CSG_LEVEL});
	}
	$pInstance   = setDefault($pInstance,   $ENV{CSG_INSTANCE});
	$pLine       = setDefault($pLine,       $ENV{CSG_LINE});
	# $notFoundMsg = setDefault($notFoundMsg, "");
	$doDebug     = setDefault($doDebug,     $FALSE);

	my $passwd                = "";
	writeTrace($doDebug,"getFtpLoginPassword_Hidden:: userName:${userName}:   resName:${resName}:   pLevel:${pLevel}:   pInstance:${pInstance}:   pLine:${pLine}:   notFoundMsg:${notFoundMsg}:   isNewFileStruct:${isNewFileStruct}:");

	if ($userName eq "") { return $notFoundMsg; }
	if (!($isNewFileStruct)) { # FT-7
		$passwd = getFtpLoginPasswordExactFT7_Hidden($userName,$resName,$pLevel,$notFoundMsg,$doDebug);
		if ($passwd eq "") {
			$passwd = getFtpLoginPasswordExactFT7_Hidden($userName,$resName,"ALL",$notFoundMsg,$doDebug);
		}
	} else { # FT-11
		$passwd = getFtpLoginPasswordExact_Hidden($userName,$resName,$pLevel,$pInstance,$pLine,$notFoundMsg,$doDebug);
		if ($passwd eq "") {
			$passwd = getFtpLoginPasswordExact_Hidden($userName,$resName,$pLevel,$pInstance,"ALL",$notFoundMsg,$doDebug);
		}
		if ($passwd eq "") {
			$passwd = getFtpLoginPasswordExact_Hidden($userName,$resName,"ALL",$pInstance,$pLine,$notFoundMsg,$doDebug);
		}
		if ($passwd eq "") {
			$passwd = getFtpLoginPasswordExact_Hidden($userName,$resName,"ALL",$pInstance,"ALL",$notFoundMsg,$doDebug);
		}
		
		if ($passwd eq "") {
			$passwd = getFtpLoginPasswordExact_Hidden($userName,$resName,$pLevel,"ALL",$pLine,$notFoundMsg,$doDebug);
		}
		if ($passwd eq "") {
			$passwd = getFtpLoginPasswordExact_Hidden($userName,$resName,$pLevel,"ALL","ALL",$notFoundMsg,$doDebug);
		}
		if ($passwd eq "") {
			$passwd = getFtpLoginPasswordExact_Hidden($userName,$resName,"ALL","ALL",$pLine,$notFoundMsg,$doDebug);
		}
		if ($passwd eq "") {
			$passwd = getFtpLoginPasswordExact_Hidden($userName,$resName,"ALL","ALL","ALL",$notFoundMsg,$doDebug);
		}
	}
	return $passwd;
}

sub getPassword {
	my($userName,$resName,$pLevel,$pInstance,$pLine,$notFoundMsg,$doDebug,$useDB) = @_;
	$doDebug     = setDefault($doDebug,     $FALSE);
	$useDB       = setDefault($useDB,       $FALSE);

	if ($useDB) {
		return getPasswordDB_withDefault($userName, $resName, $pLevel, $pInstance, $pLine);
	} else {
		return getFtpLoginPassword($userName,$resName,$pLevel,$pInstance,$pLine,$notFoundMsg,$doDebug);
	}
}


# getPassword csowner LH_DB
# execPerlFct getPassword csowner LH_DB  
# --> sommer#cseta123
sub getFtpLoginPassword {
	my($userName,$resName,$pLevel,$pInstance,$pLine,$notFoundMsg,$doDebug) = @_;
	$pLevel      = setDefault($pLevel,      $ENV{CSG_CURRENT_TEST_LEVEL});
	$pInstance   = setDefault($pInstance,   $ENV{CSG_INSTANCE});
	$pLine       = setDefault($pLine,       $ENV{CSG_LINE});
	# $notFoundMsg = setDefault($notFoundMsg, "");
	$doDebug     = setDefault($doDebug,     $FALSE);

	writeTrace($doDebug,"getFtpLoginPassword:: userName:${userName}:   resName:${resName}:   pLevel:${pLevel}:   pInstance:${pInstance}:   pLine:${pLine}:   notFoundMsg:${notFoundMsg}:");

	decryptFtpLoginPasswordFile();

	my $passwd = getFtpLoginPassword_Hidden($userName,$resName,$pLevel,$pInstance,$pLine,$notFoundMsg,$doDebug);
	if ($passwd eq $notFoundMsg) {
		#try to find a password for this user independent of the resName
		$passwd = getFtpLoginPassword_Hidden($userName,"",$pLevel,$pInstance,$pLine, $notFoundMsg,$doDebug);
	}

	unlink(getFtpLoginFileDecryptedFilename());
	purgeUnixDir(getPathNameOutOfFullName(getFtpLoginFileDecryptedFilename()), "", $TRUE);

	return $passwd;
}

sub decryptFtpLoginPasswordFile {
	my $decryptedFilePath = getPathNameOutOfFullName(getFtpLoginFileDecryptedFilename());
	# print("decryptedFilePath:${decryptedFilePath}:\n");
	if (!(isFileExists($decryptedFilePath))) {    # works also with isDirectoryExisting_UNIX 
		# print("Dir not existing\n");
		mkUnixDir($decryptedFilePath ,"/");
	}
	if (getEnvVal("CSG_FULL_ENV_NAME","XXXXX") eq "XXXXX") {
		cryptUNIXFile(getFtpLoginFileCryptedFilename(),getFtpLoginFileDecryptedFilename(),$ftpLoginFile_CryptKey);
		if (isFileExists(getFtpLoginFileCryptedFilename("LOCAL"))) {
			cryptUNIXFile(getFtpLoginFileCryptedFilename("LOCAL"),getFtpLoginFileDecryptedFilename("LOCAL"),$ftpLoginFile_CryptKey);
			appendFltFiles(getFtpLoginFileDecryptedFilename(),getFtpLoginFileDecryptedFilename("LOCAL"));
			unlink(getFtpLoginFileDecryptedFilename("LOCAL"));
		}
	} else {
		cryptUNIXFile(getFtpLoginFileCryptedFilename("FT_11"),getFtpLoginFileDecryptedFilename(),$ftpLoginFile_CryptKey);
	}
}

sub encryptFtpLoginPasswordFile {
	my $unixCmd = "chmod 777 ".getFtpLoginFileCryptedFilename("FT_11");
	my $ret = `$unixCmd`; 
	if ($ret ne "") {print("ERROR: Cmd:${unixCmd}: caused ${ret}\n");}

	cryptUNIXFile(getFtpLoginFileDecryptedFilename(),getFtpLoginFileCryptedFilename("FT_11"),$ftpLoginFile_CryptKey);

	$unixCmd = "chmod 500 ".getFtpLoginFileCryptedFilename("FT_11");
	$ret = `$unixCmd`; 
	if ($ret ne "") {print("ERROR: Cmd:${unixCmd}: caused ${ret}\n");}
	unlink(getFtpLoginFileDecryptedFilename());
}

sub addPassword {
	my($user,$password,$recource,$instance,$level,$line,$comment,$doDebug)  = @_;
	$doDebug     = setDefault($doDebug,$FALSE);
	$level       = uc($level);
	$line        = uc($line);
	
	writeTrace($doDebug,"addPassword:: user:${user}, password:${password}, resource:${recource}, instance:${instance}, level:${level}, line:${line}, comment:${comment}:");
	
	# check parameters
	if  (($user eq "") || 
		 ($password eq "") || 
		 ($recource eq "") || 
		 ($instance eq "") || 
		 (($level ne "ET") && ($level ne "IT") && ($level ne "PT") && ($level ne "PR") && ($level ne "ALL"))  ||
		 (($line ne "A") && ($line ne "B") && ($line ne "C") && ($line ne "D") && ($line ne "E") && ($line ne "F") && ($line ne "ALL"))  ||
		 (length($comment) <  5)) {
		my $retStr = "ERROR: Parameter missing or wrong values!\nUsage: addPassword user password recource instance level line comment";
				$retStr = $retStr ."\n" . "      level:   [ET, IT, PT, PR, ALL]  ";
				$retStr = $retStr ."\n" . "      line:    [A,B,C,D,E,F,ALL]  ";
				$retStr = $retStr ."\n" . "      commend: length of commend has to be more than 5 ";
		return $retStr;
	}

	# decrypt
	decryptFtpLoginPasswordFile();

	# insert new entry
	my(%newNameValuePairs) = (
		$ftpLoginFile_KeyFNam         => getNextKey(getFtpLoginFileDecryptedFilename(),"",$ftpLoginFile_KeyFNam),
		$ftpLoginFile_HostNameFNam    => $recource,
		$ftpLoginFile_UserIdFNam      => $user,
		$ftpLoginFile_PasswdFNam      => $password,
		$ftpLoginFile_InstanceFNam    => $instance,
		$ftpLoginFile_TestLevelFNam   => $level,
		$ftpLoginFile_LineFNam        => $line,
		$ftpLoginFile_ModDateFNam     => getTimeStamp(),
		$ftpLoginFile_ModByFNam       => getMyUnixUserId(),
		$ftpLoginFile_CommentFNam     => $comment,
	);

	if ($doDebug) { displayHashTable(%newNameValuePairs); }
	my $resLine = generateNewRecord(getFtpLoginFileDecryptedFilename(),"",%newNameValuePairs);
	insertRecord(getFtpLoginFileDecryptedFilename(),$resLine);
	writeTrace($doDebug,"New Entry:${resLine}:\n");
	
	# encrypt
	encryptFtpLoginPasswordFile();
	return $newNameValuePairs{$ftpLoginFile_KeyFNam};
}

sub delPassword {
	my($hash)  = @_;

	# check parameters
	if  ($hash eq "") {
		return "ERROR: Parameter missing!\nUsage: delPassword hash";
	}

	# decrypt
	decryptFtpLoginPasswordFile();
	$fltUpdateRecordByHash_Verbal = $FALSE;
	my (@deletedRecord) = fltUpdateRecordByHash(getFtpLoginFileDecryptedFilename(),"${ftpLoginFile_KeyFNam} eq ${hash}","MARK_AS_DELETE","",$FALSE);


	# encrypt
	encryptFtpLoginPasswordFile();
	
	# return value
	my $retStr = "";
	my $countOfDeletedRec = @deletedRecord;
	if ($countOfDeletedRec eq "0") {
		$retStr = "No entry has been found for (Hash eq ${hash})";
	} elsif ($countOfDeletedRec eq "1") {
		$retStr = "One Entry has been found for (Hash eq ${hash}) and deleted!";
	} else {
		$retStr = "The following $countOfDeletedRec} entries have been found for (Hash eq ${hash}) and deleted";
	}
	foreach my $aRecord (@deletedRecord) {
		$retStr = $retStr . "\n" . "  --> " . $aRecord;
	}
	return $retStr;
}

sub modPassword {
	my($filePlace,$server,$user,$password,$level,$comment)  = @_;
	$filePlace = setDefault($filePlace,"LOCAL");
	print("modPassword:: server:${server}, user:${user}, password:${password}, level:${level}, comment:${comment}:\n");
}

sub getFtpLoginFilePath {
   my($passwordFilePath) = $ENV{"CSG_FTP_LOGIN_FILE_CRYPTED_PATH"};
   if ($passwordFilePath eq "") {
      my($myRun) = $ENV{"RunI"};
      $passwordFilePath = "${myRun}/Case/";
   }
   if (!(stringEndsWith($passwordFilePath,"/"))) {
     $passwordFilePath = "${passwordFilePath}/";
   }
   return $passwordFilePath;
}

sub getFtpLoginFileCryptedFilename {
	 my($version) = @_;
	 my $filename = $passwordFileCrypted;
	 
	 if ($version eq "LOCAL") {
	 	 $filename = $passwordFileCryptedLocal;
	 } elsif ($version eq "FT_11") {
		$filename = $passwordFileCryptedFT_11;
	 }
   return getFtpLoginFilePath().$filename;
}

sub getFtpLoginFileDecryptedFilename {
	 my($version) = @_;
	 my $filename = $passwordFileDecrypted;
	 
	 if ($version eq "LOCAL") {
	 	 $filename = $passwordFileDecryptedLocal;
	 } elsif ($version eq "FT_11") {
		$filename = $passwordFileDecryptedFT_11;
	 }
	 
   my($passwordFilePath) = $ENV{"CSG_FTP_LOGIN_FILE_DECRYPTED_PATH"};
   if ($passwordFilePath eq "") {
      my($myRunS) = $ENV{"RunS"};
      $passwordFilePath = "${myRunS}/Common/Control/";
   }
   if (!(stringEndsWith($passwordFilePath,"/"))) {
     $passwordFilePath = "${passwordFilePath}/";
   }
   my $pid = getMyUnixPid();
   return putTimeStampInFileName("${passwordFilePath}${filename}","",$pid);
}

############################################################################
# Fct to use the TUM (Treasury User Management) web-service
############################################################################
sub doTest_TUM_Function {
   my($myFullName,$debugThisFct) = @_;
   $debugThisFct = setDefault($debugThisFct,$FALSE);

   if ($debugThisFct) { 
     my %nameValueTable = getUserRecFromTUM("a438995",$FALSE);
     displayHashTable(%nameValueTable);
     print("\n");
     
     %nameValueTable    = getUserRecFromTUM("A438995",$FALSE);
     displayHashTable(%nameValueTable);
     print("\n");
     
     
     print(getUserRecFromTUM("A554700",$TRUE)."\n");
     
     print(getFieldFromUserRecFromTUM("a438995","address2")."\n"); 
     print(getFieldFromUserRecFromTUM("a438995","xxxxx")."\n"); 
     
     print(getValidFieldnamesFromTUM_AsString()."\n"); 
     @validFields = getValidFieldnamesFromTUM_AsArray();
     displayArray(@validFields);
   }
}

%initialTUM_Record = (
      "address1"            => "",
      "address2"            => "",
      "address3"            => "",
      "address4"            => "",
      "address5"            => "",
      "authorizedBuids"     => "",
      "authorizedProfiles"  => "",
      "buid"                => "",
      "department"          => "",
      "email"               => "",
      "firstName"           => "",
      "lastName"            => "",
      "phone"               => "",
      "pid"                 => "",
      "postalCode"          => "",
      "role"                => "",
      "state"               => "",
      "country"             => "",
   );
 
  
  

sub getFieldFromUserRecFromTUM {
   my($requestedPID,$fieldName,$notFoundMsg) = @_;
   $notFoundMsg   = setDefault($notFoundMsg,"Error: Field ${fieldName} not found in TUM Record");
   my %nameValueTable    = getUserRecFromTUM($requestedPID,$FALSE);
   if (exists($nameValueTable{$fieldName})) {
   	   return $nameValueTable{$fieldName};
   } else {
   	   return $notFoundMsg
   }
}
   
sub getValidFieldnamesFromTUM_AsString {
   my($sep) = @_;
   my $retStr = "";
   
   $sep   = setDefault($sep,";");
   foreach my $aField (sort keys %initialTUM_Record) {
      if ($retStr eq "") {
          $retStr = $aField;
      } else {
      	  $retStr = "${retStr}${sep}${aField}";
      }
   }  
   return $retStr;
}

sub getValidFieldnamesFromTUM_AsArray {
   my @retStr = ();
   
   foreach my $aField (sort keys %initialTUM_Record) {
   	  push(@retStr,$aField);
   }  
   return @retStr;
}

sub isA_ValidTUMField {
	  my($fieldName) = @_;
	  if (exists($initialTUM_Record{$fieldName})) {
	      return $TRUE;	
	  } else {
	  	  return $FALSE;
	  }
}

sub getUserRecFromTUM {
  my($requestedPID,$asString,$silent) = @_;

  $asString   = setDefault($asString,$TRUE);
  $silent     = setDefault($silent,$TRUE);

  my $errorRec = "";
  my $message  = qq {
    <env:Envelope  xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
     <env:Body   env:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <m:getUserProfile    xmlns:m="http://www.pyx.ch/webservices">
      <string     xsi:type="xsd:string">${requestedPID}</string>
      </m:getUserProfile>
     </env:Body>
    </env:Envelope>	
  };

  my $userAgent = LWP::UserAgent->new(agent => 'perl post');
  
  ################### OLD SETTINGS ######################
  # ET:
  # http://zus40a-1802.tszrh.csfb.com:8092/ws/getUserProfile
  # 
  # IT: 
  # http://zus90a-1801.tszrh.csfb.com:8092/ws/getUserProfile
  # 
  # PTA: 
  # http://zus70a-1800.tszrh.csfb.com:8092/ws/getUserProfile
  # http://zus10a-1800.tszrh.csfb.com:8092/ws/getUserProfile
  # http://treasurynet-pta.tszrh.csfb.com:8092/ws/getUserProfile
  # 
  # Prod:
  # http://zus10a-1805.tszrh.csfb.com:7072/ws/getUserProfile
  # http://zus10a-1806.tszrh.csfb.com:7072/ws/getUserProfile
  # http://zus70a-1860.tszrh.csfb.com:7072/ws/getUserProfile
  # http://zus70a-1861.tszrh.csfb.com:7072/ws/getUserProfile
  
  ################## NEW SETTINGS ########################
  # ET:
  # http://vzus45a-5601.tszrh.csfb.com:8092/ws/getUserProfile
  #
  # IT:
  # http://vzus95a-5601.tszrh.csfb.com:8092/ws/getUserProfile
  #
  # PTA:
  # http://vzus75a-5658.tszrh.csfb.com:8092/ws/getUserProfile
  # http://vzus75a-5659.tszrh.csfb.com:8092/ws/getUserProfile
  #
  # PROD:
  # http://vzus15a-5608.tszrh.csfb.com:7072/ws/getUserProfile
  # http://vzus15a-5609.tszrh.csfb.com:7072/ws/getUserProfile
  # http://vzus75a-5608.tszrh.csfb.com:7072/ws/getUserProfile
  # http://vzus75a-5609.tszrh.csfb.com:7072/ws/getUserProfile


  my $tumService=$ENV{CSG_TUM_SERVER};
  if ($tumService eq "") {
  	print("WARNING:No TUM server defined. Please set \$CSG_TUM_SERVER\n");
  	$tumService="http://vzus15a-5608.tszrh.csfb.com:7072/ws/getUserProfile";
  }
  my $response = $userAgent->request(POST $tumService,
  Content_Type => 'text/xml',
  Content => $message);
  
  ### print $response->error_as_HTML unless $response->is_success;
  $errorRec = $response unless $response->is_success;
  if ($errorRec ne "") {
  	  $headerRef = $response->headers;
  	  my $errorStr = $headerRef->title;
  	  if (!($silent)) {
  	    print("ERROR:${errorStr}\n");
  	  }
  	  return %initialTUM_Record;
  }
  my %nameValueTable = getNameValuePairsFromTUM($response->as_string);
  if ($asString) {
  	  return makeStrFromHash("","","","",%nameValueTable);
  } else {
    	return %nameValueTable;
  }
}


sub getNameValuePairsFromTUM {
   my($inString) = @_;

   foreach my $aField (sort keys %initialTUM_Record) {
      $retHash{$aField} = getTagValueFromXML($aField,$inString);
   }
   %retHash = replaceUNICODE_UmlauteInHash(%retHash);
   return %retHash;
}


############################################################################
# Function used by extractors
############################################################################
sub addExtractorHeader {
  my($fileName,%counts) = @_;
  my(@keyOfHash) = keys %counts;
  my($key)       = "";
  my($comment)   = "#";
  foreach $key (sort @keyOfHash) {
     $comment = sprintf("%s%s:%s | ",$comment,$key,$counts{$key});
  }

  my($DATE_RECORD) =`date +'%d-%b-%y %H:%M:%S'`;
  chop $DATE_RECORD;

  $comment   = "${comment}Produced by:${myOnlyName} (${myLatestVersion}) at:${DATE_RECORD} | System-Date:${sysDate} | ";
  putLineOnTop($fileName,$comment); 
}

# Possible timeformat:
#   NONE
#   YYYYMMDDHHMMDD (Default)
#   FORMATED  (Language dependend)
#   FORMATED_WITH_MONTHNAME
#   FORMATED_WITH_WEEKDAY
sub addExtractorHeader_1 {
  my($fileName,$recordCount,$timeFormat,$producerNameIncluded,$additionalComment) = @_;
  $producerNameIncluded = setDefault($producerNameIncluded,$FALSE);
  
  my $comment   = "";
  my $timeStamp = getTimeStamp();
  if (uc($timeFormat) eq "NONE") {
      $timeStamp = "";
  } elsif (uc($timeFormat) eq "FORMATED") {
      $timeStamp = formatTimeStamp($timeStamp);
  } elsif (uc($timeFormat) eq "FORMATED_WITH_MONTHNAME") {
      $timeStamp = formatTimeStamp($timeStamp,"",$TRUE);
  } elsif (uc($timeFormat) eq "FORMATED_WITH_WEEKDAY") {
      $timeStamp = formatTimeStamp($timeStamp,"",$TRUE,$TRUE);
  }
   
  if ($producerNameIncluded) {
    $comment = "Produced by:${myOnlyName} (${myLatestVersion})";
  }

  $comment   = "# ".$comment."|".$timeStamp."|".$recordCount.$additionalComment;
  putLineOnTop($fileName,$comment); 
}


sub NotifyEmailOnError {
  my($logfileName) = @_;
  $logfileName     = setDefault($logfileName,getLogfileName());
  if ($NotifyEmailAdr eq "") {
     $NotifyEmailAdr = $notifyEmailAdr;
  }

  if ($NotifyEmailAdr eq "") { 
     $NotifyEmailAdr = $gmmdbSupport;
     csfbDisplayError("Notify E-mail address not specified. Using Default\n");
  }
  my($subject) = "ERROR in ${myOnlyName} on ".getMyUnixFullHostname()." / ".$ENV{CSG_ENV};
  my($msg)     = "Error Found!! \n Look at attached log file \n";
  my($fromAdr) = $myOnlyName;

  my($mailFileName) = sprintf("%s/EMAIL_%s",getPathNameOutOfFullName($logfileName),getFileNameOutOfFullName($logfileName));
  if (isFileExists($logfileName)) {
    convertFromUNIX_ASCII_to_DOS_ASCII($logfileName,$mailFileName);
    ### printf("Error e-mail sent to ${NotifyEmailAdr}\n");
    sendMailwithAttachments($fromAdr,$NotifyEmailAdr,$subject,$msg,$mailFileName);
  }
}  

sub addToLogfileAndNotifyForError {
   my($msg,$logFileName,$verbal) = @_;
   $logFileName     = setDefault($logFileName,getLogfileName());
   addToLogFile($msg,$logFileName,$verbal);
   NotifyEmailOnError();
   $ERROR_FOUND = $TRUE;
   return $msg;
}


#### Disk Space
@Monitored_Disks = ("/app", "/data/oracle/u01", "/db_dumps");
 
%maxCapacityAllowed = (
  "/data/oracle/u01" => "98",
);
 
 
%minSpaceRequired = (
  "/app" => 400*1024,
  "/db_dumps" => 800*1024,
 
);

# checkDiskSpace
#
#  $outputOption  "html", "stdout", "none"

sub checkDiskSpace {
  my ($DirsRef,$maxCapacityAllowedHashRef, $minSpaceRequiredHashRef, $outputOption) = @_;;
 
  my %diskInfo = ();
  my ($msg) = "";
  my ($success) = $TRUE;
 
  if ($outputOption eq "html") {
   print ("<TABLE border=1 cellpadding=4 cellspacing=0>\n ");
   print("<TR><TD colspan = 3 bgcolor=\"yellow\" align=\"center\"><font color=\"black\">Disk Monitor </TD><TR></font>\n");
   print ("<TR > <TD bgcolor=\"black\" align=\"center\"><font color=\"white\">Disk</TD> </font>\n");
   print ("<TD bgcolor=\"black\" align=\"center\"><font color=\"white\">Available</TD> </font>\n");
   print ("<TD bgcolor=\"black\" align=\"center\"><font color=\"white\">Capacity</TD> </font> </tr>\n");
  }
 
  foreach $dir (@$DirsRef) {
 
    my $maxCapacity = $maxCapacityAllowedHashRef -> {$dir};
    my $minSpaceRequired = $minSpaceRequiredHashRef -> {$dir};
 
    %diskInfo =  getDiskSpaceInfo($dir);
    $availableSpace = $diskInfo{"avail"};
    $capacity = $diskInfo{"capacity"};
    $capacity =~ s/%//g;
 
    my $bgColor = "Lawngreen";
    my $textColor = "black";
 
 
    if ($maxCapacity ne "" ) {
 
       if ($capacity > $maxCapacity) {
         $msg = "$msg  $dir capacity reached ${capacity}% \n";
          $bgColor = "red";
       }
 
      } elsif ($minSpaceRequired  ne "") {
          if ($availableSpace < $minSpaceRequired ) {
           $bgColor = "red";
           $msg = "${msg} $availableSpace is less then $minSpaceRequired \n";
         }
      }
      if ($outputOption eq "html") {
         
        print("<TR bgcolor=\"$bgColor\">  <font color=\"${textColor}\"> \n");
        print ("<td> $dir </td> <td>$availableSpace </td><td> ${capacity}% </td> \n");
        print ("</font> </tr>\n");
      }
  }
 
  if ($outputOption eq "html") {
    print ("</TABLE>\n");
  }
 
   if ($outputOption eq "stdout") {
     print" $msg \n";
   }
 
   return $msg;
 
 
}

sub getDiskSpaceInfo   {
  my ($dir) = @_;
  my (%dirInfoHash) = ();
 
  $msg = `df -k $dir `;
 
  my @parts = split("\n", $msg);
 
  my @columns  = split(" ", $parts[0]);
  my @dirInfo = split(" ", $parts[1]);
 
  for ($i = 0; $i <  $#columns; $i++) {
    my $column = $columns[$i];
    $column = strip ($column);
    my $val = $dirInfo[$i];
    $val = strip ($val);
    $dirInfoHash{$column} = $val;
  }
 
  return %dirInfoHash;
}

sub getUserId {

  my $id="NA";


  my @tmp = split(" ",`who am i 2> /dev/null `);

  $id = $tmp[0];

  if ($id eq "" ) {
    $id = $loginUserId || $ENV{"REMOTE_USER"};  # cgi web programm
  }

  if ($id eq "") { # try second method
    $id = `id|cut -d \"\(\" -f2|cut -d \"\)\" -f1`;
  }

  $id = strip ($id);  
  return $id;
}


sub getAlertListFromPasswordFile {
   my($userId,$level,$useHolidayCalendar) = @_;
   $useHolidayCalendar = setDefault($useHolidayCalendar,$TRUE);

   $userId =~ s/\s//g;
   my(@userIdList) = ($userId);
   my $locWhereClause = "";
   if (index(uc($userId),"GMMIT") == 0) {
      my $cityCode = substr(uc($userId),5,2);
      if (length($cityCode) == 2) {
         $locWhereClause = "kindOfUser=GMM IT AND Location=${cityCode}";
      } else {
         $locWhereClause = "kindOfUser=GMM IT";
      }
      @userIdList = getColumnValues($fullLocalPasswordFileName,$passwdSepChar,"UserId",$locWhereClause,"",$TRUE);
      ### print("cityCode:${cityCode}:\n");
      ### print("locWhereClause:${locWhereClause}:\n");
      ### displayArray(@userIdList);
   }

   my(@retList) = ();

   foreach my $aUserId (@userIdList) {
     my(%addrRec) = getSingleRecInHash($fullLocalPasswordFileName,$passwdSepChar,"","UserId=${aUserId}","",$FALSE);
     ### print("\n\naUserId:${aUserId}:\n");
     ### displayHashTable(%addrRec);

     my(%holidayCal) = setHashFromCommonControl($addrRec{"vacationPlan"});

     if ($useHolidayCalendar) {
       if (isDateBetweenUseCalendar(getTimeStamp(),\%holidayCal)) {
        ### printf("Is on vacation....\n");
        next;
       } 
     }

     my $listAsStr = $addrRec{"alerts"};
     if ($level eq "1") {
        $listAsStr = $addrRec{"escalation"};
     }
     my(@tmpList) = setListFromCommonControl($listAsStr);
     @retList = (@retList,@tmpList);
   }
   @retList = trimAndRemoveEmptiesInArray(@retList);
   @retList = makeArrayEntriesDistinct($TRUE,@retList);
   return @retList;
}

############################################################################
# Function for ftps and filebroker
############################################################################
# to login to filebroker in ZH:
# /cs/lftp/bin/lftp.sh
# ET:   open -u s204087, -p 2121 fbrkftpsa.csintra.net
# IT:   open -u s204087, -p 2121 fbrkftpst.csintra.net
# PTA:  open -u s202087, -p 2121 fbrkftpsq.csintra.net
# PROD: open -u s202087, -p 2121 fbrkftpsp.csintra.net
################## NY, LN and AP ##########################################
# ET:   open -u s204214, -p 2121 fbrkftpsa.csintra.net
# IT:   open -u s204214, -p 2121 fbrkftpst.csintra.net
# PTA:  open -u s202214, -p 2121 fbrkftpsq.csintra.net
# PROD: open -u s202214, -p 2121 fbrkftpsp.csintra.net


$filebrokerMarker = "FILEBROKER"; # used in commonControl in the server list to specify that files have to be sent to filebroker
$filecopyMarker   = "FILECOPY";   # used in commonControl in the server list to specify that files have to be distributed via "normal" file system copy
$filebrokerDir    = "."; #Stores the dir given in ftp Dir on common control for filebroker (FTPS)
$filebrokerTrace  = $FALSE;

sub sendFileToFileBrokerSetDestDir {
	my($sourceFullFilename,$destinationDir,$destinationFilename,$modeBin,$logFileName,$verbal) = @_;
	$destinationDir = strip($filebrokerDir);
	$modeBin = setDefault($modeBin,isFtpModeBin($sourceFullFilename));
   
	my $filename  = getFileNameOutOfFullName($sourceFullFilename);
	my $startTime = getTimeStamp();
	if ($destinationFilename eq "") {
		addToLogFile("   --> started  ftps of ${filename} ....",$logFileName,$verbal);
	} else {
		addToLogFile("   --> started  ftps of ${filename} ==> ${destinationFilename} ....",$logFileName,$verbal);   	
	}
	my $scriptName = "";
	if ($modeBin) {
		$scriptName = strip($ENV{$CSG_FILEBROKER_SCRIPT_BINARY}); 
		if ($scriptName eq "") {
			$scriptName = getFirstExistingFile(("/app/ft/code/sitebin/filebroker_binary.ksh",$ENV{"CSG_GLOBAL"}."/utils/filebroker_binary.ksh")); 
		}
	} else {
		$scriptName = $ENV{$CSG_FILEBROKER_SCRIPT_ASCII};  
		if ($scriptName eq "") { 
			$scriptName = getFirstExistingFile(("/app/ft/code/sitebin/filebroker.ksh",$ENV{"CSG_GLOBAL"}."/utils/filebroker.ksh"));
		}
	}
	$scriptName = strip($scriptName); 

	if (!(isFileExists($scriptName))) {
		addToLogFile("ERROR:${scriptName} not available",$logFileName,$verbal);
		return;
	}
	my $fbUnixCmd = "${scriptName} -s ${sourceFullFilename} -d ${destinationDir}";
	if ($destinationFilename ne "") {
		$fbUnixCmd = "${fbUnixCmd} -f ${destinationFilename}";
	}
	if ($filebrokerTrace) {
		$fbUnixCmd = $fbUnixCmd . " -l";
		addToLogFile("${fbUnixCmd}",$logFileName,$verbal);
	}
	my $retVal = callUnixCmd($fbUnixCmd);
	chomp($retVal);
	if ($retVal ne "") {
		if ($filebrokerTrace) {
			addToLogFile("INFO FILEBROKER:\n${retVal}\n",$logFileName,$verbal);
		} else {
			addToLogFile("ERROR:${retVal}",$logFileName,$verbal);
		}
	}
	addToLogFile("   --->finished ftps of ${filename} (".secDiff_YYYYMMDDhhmmss(getTimeStamp(),$startTime)."s)!",$logFileName,$verbal);
	return $retVal;
}

sub sendFileToFileBroker {
	my($sourceFullFilename,$destinationFilename,$modeBin,$logFileName,$verbal) = @_;
	return sendFileToFileBrokerSetDestDir($sourceFullFilename,"",$destinationFilename,$modeBin,$logFileName,$verbal);
}

sub sendFilesToFileBrokerSetDestDir {
	 my($maxThreads,$refToFullFilenameList,$destinationDir,$logFileName,$verbal) = @_;
	 $maxThreads = setDefault($maxThreads,0);
	 $destinationDir = $filebrokerDir;
	 
	 my @fullFilenameList = @$refToFullFilenameList;
	 if ($maxThreads <= 0) {
	 	 $maxThreads = @fullFilenameList;
	 }
	  
	 my $startTime = getTimeStamp();
	 
	 my $completed = $FALSE;
	 while (!($completed)) {
	 	   #split fileList
	 	   my @tempFileList = ();
       for (my $i = 0; $i < $maxThreads; $i++) {
       	  if ($fullFilenameList[0] eq "") { 
       	  	$completed = $TRUE;
       	  	last; 
       	  }
       	  push(@tempFileList,$fullFilenameList[0]);
       	  shift(@fullFilenameList);
       }
     	 if ($fullFilenameList[0] eq "") { 
     	    $completed = $TRUE;
     	 }      	  	
#     	 print("tmpList\n");
#     	 displayArray(@tempFileList);
#     	 print("fullFilenameList\n");
#     	 displayArray(@fullFilenameList);
#     	 halt();
	 
	 	   my @threadList = ();
    	 foreach my $afile (@tempFileList) {
    	 	  my $finalDestName = "";
    	 	  if (index ($afile,"==>") > -1) {
    	 	  	 ($afile,$finalDestName) = split("==>",$afile);
    	 	  	 $afile         = strip($afile);
    	 	  	 $finalDestName = strip($finalDestName);
    	 	  }
    	    push(@threadList,new Thread(\&sendFileToFileBroker,$afile,$finalDestName,"",$logFileName,$verbal));
    	 }
    	 
    	 
    	 foreach my $aThread (@threadList) {
    	 	  $aThread->join();
    	 }    	 
   }
	 addToLogFile("Transfer took ".secDiff_YYYYMMDDhhmmss(getTimeStamp(),$startTime)."s",$logFileName,$verbal);
}

sub sendFilesToFileBroker {
	my($maxThreads,$refToFullFilenameList,$logFileName,$verbal) = @_;
	return sendFilesToFileBrokerSetDestDir($maxThreads,$refToFullFilenameList,"",$logFileName,$verbal);
}

############################################################################
# Misc Function 
############################################################################
$gmmBuildLibPath  = $ENV{"CSG_APP_BUILD"}."/../tools/cgi/common";
$gmmBuildGpacPath = $ENV{"CSG_APP_BUILD"}."/global/application/gpac";

$gmmLibPath  = $gmmBuildLibPath;
$gmmGpacPath = $gmmBuildGpacPath;



if (isZH_Node()) {
  $gmmLibPath  = $ENV{"CSG_GMM_LIBRARIES"};
  $gmmGpacPath = $ENV{"CSG_GMM"};	
}

sub getSCCS_Versions {
    my($libPathAndfilePattern,$sepChar) = @_;  
    
    my $filenameFieldLength = 50;
    my @list = ` what ${libPathAndfilePattern} | grep SCCS 2>&1`;
    foreach my $entrie (@list) {
    	  chomp($entrie);
    	  $entrie = strip($entrie);
    	  ## print("entrie:${entrie}:\n");
    	  $entrie =~ s/\s+/;/g;
    	  my @parts = split(";",$entrie);
    	  my $aLine = paddenNull($parts[0],-${filenameFieldLength},$sepChar);
    	  my $countOfParts = @parts;
    	  for (my $i=1; $i <= $countOfParts; $i++) {
    	     $aLine = $aLine.$sepChar.$parts[$i];
    	  }
        print("${aLine}\n");
    }
}


sub getGpacVersions {
	 my $path = 
	 getSCCS_Versions("${gmmGpacPath}/generate*"," ");
	 getSCCS_Versions("${gmmGpacPath}/tradeIQ_*"," ");
}

sub getGmmLibVersions {
	 getSCCS_Versions("${gmmLibPath}/*.p*"," ");
}

sub getGmmSccsVersions {
	getGmmLibVersions();
	getGpacVersions ();
}

sub showMenu_GmmCmd {
	
	 my %menu = (
     "1: Show GMM library versions (execPerlFct getGmmSccsVersions)"               => "getGmmSccsVersions;halt",
   );
   createAsciiMenuAndPerformActions("0: Exit","Following UNIX-Commands are defined:","\nSelect",%menu);
}

#
# Functions for FT-11
# ===================
$loggedInUser = "";

sub getLoggingUser {
	my($doFormat,$preFix,$postFix) = @_;
	$doFormat  = setDefault($doFormat,$FALSE);
	$preFix    = setDefault($preFix,"     Logged-in: ");
	
	my $retStr = "";
	
	if ($loggedInUser eq "") {
		my $unixCmd = "who -m";
		$retStr =  `${unixCmd} 2>&1`;
		$retStr =~ s/\n+//g;
		$retStr =~ s/\r+//g;
		$retStr =~ s/\s+/;/g;
		$retStr = strip(getFieldFromString(";",0,$retStr));
		if ($retStr eq "") {
			$retStr = $ENV{"LOGGING_USER"}
		}
	} else {
		$retStr = $loggedInUser;
	}
	
	if ($doFormat) {
		$retStr = $preFix.$retStr.$postFix;
	}
	return $retStr;
}

sub getEmailAdressForPid {
	my($pidFromUser) = @_;
	$pidFromUser  = setDefault($pidFromUser,getLoggingUser());
	
	my $unixCmd = "mailAddressLookup \"${pidFromUser}\"";
	# print("UnixCmd:${unixCmd}:\n");
	my @retStr =  `${unixCmd} 2>&1`;
	@retStr = chompArrayEntries(@retStr);
	# displayArray(@retStr);
	
	return $retStr[0];
}

sub isPrivUserLogedIn {
	my $privUsers = getParameter(getLevelFromFullEnvName($ENV{"CSG_FULL_ENV_NAME"}),"PRIVILIGED_USERS",$DefaultCryptKey);
	if (uc(getLoggingUser()) eq "A438995") {
		return $TRUE;
	} else {
		return (stringContains(uc($privUsers), uc(getLoggingUser())));
	}
}

sub currentFtEnv_toString {
	my $retStr = "";
	my $dbConnect_Package = getPackageDB_Details("","SQLPLUS");
	my $jdbc_PackageDB    = getPackageDB_Details("","JDBC");
	my $dbConnect_Config  = getConfigDB_Details ("","SQLPLUS");
	my $loginUserID       = getMyUnixUserId();
	my $realLoginUserID   = getLoggingUser();
	# my $cfgDB_Name        = getParameter($pLevel, $pParamName, "", $TRUE, $FALSE);

	my $currLevel         = getLevelFromFullEnvName($ENV{"CSG_FULL_ENV_NAME"});

	my $retStrPart_1 = "";
	if ($lhManageComponentsRootMode) {
		my $configDB_PrivUsers_ET = getParameter("ET","PRIVILIGED_USERS",$DefaultCryptKey);
		my $configDB_PrivUsers_IT = getParameter("IT","PRIVILIGED_USERS",$DefaultCryptKey);
		my $configDB_PrivUsers_PT = getParameter("PT","PRIVILIGED_USERS",$DefaultCryptKey);
		my $configDB_PrivUsers_PR = getParameter("PR","PRIVILIGED_USERS",$DefaultCryptKey);

		my $configDB_DbName    = getParameter($currLevel,"CONFIG_DB");
		my $configDB_Username  = getParameter($currLevel,"CONFIG_DB_USERNAME");
		my $configDB_Password  = getParameter($currLevel,"CONFIG_DB_PASSWORD",$DefaultCryptKey);

		my $configDB_DbName_ET   = getParameter("ET","CONFIG_DB");
		my $configDB_Username_ET = getParameter("ET","CONFIG_DB_USERNAME");
		my $configDB_Password_ET = getParameter("ET","CONFIG_DB_PASSWORD",$DefaultCryptKey);

		my $configDB_DbName_IT   = getParameter("IT","CONFIG_DB");
		my $configDB_Username_IT = getParameter("IT","CONFIG_DB_USERNAME");
		my $configDB_Password_IT = getParameter("IT","CONFIG_DB_PASSWORD",$DefaultCryptKey);

		my $configDB_DbName_PT   = getParameter("PT","CONFIG_DB");
		my $configDB_Username_PT = getParameter("PT","CONFIG_DB_USERNAME");
		my $configDB_Password_PT = getParameter("PT","CONFIG_DB_PASSWORD",$DefaultCryptKey);

		my $configDB_DbName_PR   = getParameter("PR","CONFIG_DB");
		my $configDB_Username_PR = getParameter("PR","CONFIG_DB_USERNAME");
		my $configDB_Password_PR = getParameter("PR","CONFIG_DB_PASSWORD",$DefaultCryptKey);

		$retStrPart_1 = qq {
		DB-Connections
		--------------
		Package-DB: ${dbConnect_Package}
		            ${jdbc_PackageDB}
		Config-DB : ${dbConnect_Config}


		Parameters
		----------
		ET: PRIVILIGED_USERS    :${configDB_PrivUsers_ET}
		IT: PRIVILIGED_USERS    :${configDB_PrivUsers_IT}
		PT: PRIVILIGED_USERS    :${configDB_PrivUsers_PT}
		PR: PRIVILIGED_USERS    :${configDB_PrivUsers_PR}

		ET: CONFIG_DB           :${configDB_DbName_ET}
		ET: CONFIG_DB_USERNAME  :${configDB_Username_ET}
		ET: CONFIG_DB_PASSWORD  :${configDB_Password_ET}

		IT: CONFIG_DB           :${configDB_DbName_IT}
		IT: CONFIG_DB_USERNAME  :${configDB_Username_IT}
		IT: CONFIG_DB_PASSWORD  :${configDB_Password_IT}

		PT: CONFIG_DB           :${configDB_DbName_PT}
		PT: CONFIG_DB_USERNAME  :${configDB_Username_PT}
		PT: CONFIG_DB_PASSWORD  :${configDB_Password_PT}

		PR: CONFIG_DB           :${configDB_DbName_PR}
		PR: CONFIG_DB_USERNAME  :${configDB_Username_PR}
		PR: CONFIG_DB_PASSWORD  :${configDB_Password_PR}
		};
	}


	my $privFct = makeQuotedStrFromArrayElements("\n","                ","","",getPriviligedMgmFunctions());
	my $retStr = qq {
		Priviliged lhManageComponent functions
		--------------------------------------
${privFct}


		Login-Details
		-------------
		User Id    : ${loginUserID}
		LoginUserID: ${realLoginUserID}


		Environment Varibles
		--------------------
		CSG_FULL_ENV_NAME: $ENV{"CSG_FULL_ENV_NAME"}
		CSG_SHARE_LEVEL  : $ENV{"CSG_SHARE_LEVEL"}


		${retStrPart_1}
	};
	return $retStr;
}

sub getDBNameForFT11 {
	my($pInstance,$pLine,$pLevel) = @_;
	$pLevel    = setDefault($pLevel,    $ENV{"CSG_LEVEL"});
	$pInstance = setDefault($pInstance, $ENV{"CSG_INSTANCE"});
	$pLine     = setDefault($pLine,     $ENV{"CSG_LINE"});
	my $fullEnvName = "${pInstance}_${pLine}_${pLevel}";
	my $dbName      = "${fullEnvName}.ROWINI.NET";
	return $dbName;
}

sub get_lhParameterValue_TestCase {
	my($testCase,$debugThisFct) = @_;

	my $testCaseFN     = getSourceFullName("TEST_CASES.txt");
	my $compName       = "";
	my $subCompName    = "";
	my $fullEnvName    = "";
	my $paramName      = "";
	my $expextedResult = "";
	my $notFoundStr    = "";

	my @testCase  = filterArrayWithRegEx($testCase,readFile(getSourceFullName($testCaseFN)));
	my $lineCount = @testCase;
	if ($lineCount == 0) {
		print("ERROR: get_lhParameterValue_TestCase:${testCase}: not found\n");
	} elsif ($lineCount > 1) {
		print("ERROR: get_lhParameterValue_TestCase:${testCase}: Multiple testcases (${lineCount}) found!\n");
	} else {
		my @parts = split("\\|",$testCase[0]);
		$compName       = strip(getFieldFromString(":",1,$parts[0]));
		$subCompName    = strip($parts[1]);
		$fullEnvName    = strip($parts[2]);
		$paramName      = strip($parts[3]);
		$expextedResult = strip($parts[4]);
		$notFoundStr    = strip($parts[5]);
	}

	if ($debugThisFct) {
		displayArray(@parts);
		print("testCaseFN :${testCaseFN}:\n");
		print("testCase   :${testCase}:\n");
		print("compName   :${compName}:\n");
		print("subCompName:${subCompName}:\n");
		print("fullEnvName:${fullEnvName}:\n");
		print("paramName  :${paramName}:\n");
		print("Expected   :${expextedResult}:\n");
		print("NotFoundStr:${notFoundStr}:\n\n");
	}

	return ($compName,$subCompName,$fullEnvName,$paramName,$expextedResult,$notFoundStr);
}

sub get_lhGetConfig_TestCase {
	my($testCase,$debugThisFct) = @_;
	
	my $testCaseFN     = getSourceFullName("TEST_CASES.txt");
	my @expextedResult = readFileBetweenMarkers($testCaseFN,"START_EXPECTED_RESULT_${testCase}:","END_EXPECTED_RESULT_${testCase}:","",1);
	my @testCase       = readFileBetweenMarkers($testCaseFN,"START_${testCase}:","END_${testCase}:","",1);
	my @retList        = selectFromArray("Component_Name: ",$TRUE,@testCase);
	my $compName       = strip(getFieldFromString(":",1,$retList[0]));

	@retList           = selectFromArray("SubComponentName: ",$TRUE,@testCase);
	my $subCompName    = strip(getFieldFromString(":",1,$retList[0]));

	@retList           = selectFromArray("FullEnvName: ",$TRUE,@testCase);
	my $fullEnvName    = strip(getFieldFromString(":",1,$retList[0]));

	if ($debugThisFct) {
		print("testCaseFN :${testCaseFN}:\n");
		print("testCase   :${testCase}:\n");
		print("compName   :${compName}:\n");
		print("subCompName:${subCompName}:\n");
		print("fullEnvName:${fullEnvName}:\n\n");
		print("TestCase:\n"); displayArray(@testCase);       print("\n\n");
		print("Expected:\n"); displayArray(@expextedResult); print("\n\n");
	}
	if ($compName eq "") {
		print("ERROR: Test-Case (${testCase}) not found!\n");
	}
	return ($compName,$subCompName,$fullEnvName,chompArrayEntries(@expextedResult));
}

sub doTest_lhGetConfig {
	my($myFullName,$debugThisFct) = @_;
	$debugThisFct = setDefault($debugThisFct,$FALSE);   
    
	my @testCaseList = ("TEST_01", "TEST_02","TEST_03","TEST_04","TEST_05","TEST_06","TEST_10","TEST_10a","TEST_14","TEST_15");
	## @testCaseList = ("TEST_15"); 

	foreach my $testCaseName (@testCaseList) {
		my ($cmpName, $subCompName, $fullEnvName,@expectedResList) = get_lhGetConfig_TestCase($testCaseName,$debugThisFct);

		my $pInstance   = getInstanceFromFullEnvName($fullEnvName);
		my $pLine       = getLineFromFullEnvName($fullEnvName);
		my $pLevel      = getLevelFromFullEnvName($fullEnvName);
		my $expectedRes = makeQuotedStrFromArray("\n","",@expectedResList);

		if ($debugThisFct) {
			print("\n+++++++++++++++++++++++++++++++++++++++ START_DEBUG (${testCaseName}) +++++++++++++++++++++++++++++++++++++++\n");
			print("doTest_lhGetConfig:    testCaseName:${testCaseName}\n");
			print("doTest_lhGetConfig:    cmpName     :${cmpName}:     subCompName:${subCompName}:\n");
			print("doTest_lhGetConfig:    pInstance   :${pInstance}:   pLine:${pLine}:   pLevel:${pLevel}:\n");
			print("Expected Result (a):\n"); displayArray(@expectedResList); print("\n\n");
			print("Expected Result (b):\n${expectedRes}:\n\n");
			print("+++++++++++++++++++++++++++++++++++++++++ END_DEBUG (${testCaseName})   +++++++++++++++++++++++++++++++++++++++\n\n");
		}
		my $result   = lhGetConfig($cmpName,$subCompName,"ZH",$pInstance,$pLine,$pLevel,"","",$debugThisFct);
		$result      = removeCR($result);
		$expectedRes = removeCR($expectedRes);
		if ($result ne $expectedRes) {
			print("\n+++++++++++++++++++++++++++++++++++++++ START_ERROR LOG (${testCaseName}) +++++++++++++++++++++++++++++++++++++++\n");
			print("ERROR: ${myFullName} failed (${testCaseName})\n");
			print(convertASCII_to_HEX($result,4)."\n\n\n\n");
			print(convertASCII_to_HEX($expectedRes,4)."\n\n");
			print("Length          result:".length($result)."\n");
			print("Length expected-result:".length($expectedRes)."\n");
			print("lhGetConfig ${cmpName} ${subCompName} ZH ${pInstance} ${pLine} ${pLevel} \"\" \"\" 1\n");
			print("lhGetConfig(\"${cmpName}\",\"${subCompName}\",\"${pInstance}\",\"${pLine}\",\"${pLevel}\") = \n${result}:\n\n    Expected:\n${expectedRes}:\n\n");
			print("+++++++++++++++++++++++++++++++++++++++++ END_ERROR LOG (${testCaseName})   +++++++++++++++++++++++++++++++++++++++\n\n");
		}
	}
}

$placeHolderNotFoundstr = "!!!lhGetConfig::NOT FOUND!!!";
sub processConfigTemplateString {
	my($templateStr, $configPostAction, $componentName, $subComponentName, $pFullEnvName, $verbal) = @_;
	$pFullEnvName = setDefault($pFullEnvName,         $ENV{"CSG_FULL_ENV_NAME"});
	my $retString = $templateStr;

	if ($verbal) {
		print("processConfigTemplateString:: templateStr     :${templateStr}:\n");
		print("processConfigTemplateString:: configPostAction:${configPostAction}:\n");
	}

	if ((stringStartsWith($configPostAction,"Translate")) && ($configType ne "Bin-File:Code")) {
		my $postFetchAction  = getFieldFromString("::",0,$configPostAction);
		my $startMarker      = getFieldFromString("::",1,$configPostAction,"{");
		my $defaultEndMarker = $startMarker;
		if ($defaultEndMarker eq "{") {
			$defaultEndMarker = "}"
		}
		my $endMarker        = getFieldFromString("::",2,$configPostAction,$defaultEndMarker);
		### $startMarker = escapeRegExSpecChar($startMarker);
		my @containedPlaceholders = getPlaceholders($templateStr,$startMarker,$endMarker);
		if ($verbal) { print("\nPlaceholders found (${startMarker}.........${endMarker}):\n");displayArray(@containedPlaceholders); }
		my(%transTab) = ();
		foreach my $aPlaceholder (@containedPlaceholders) {
			my $paramName = $aPlaceholder;
			$paramName =~ s/$startMarker//g;
			$paramName =~ s/$endMarker//g;
			my $placeValue = "";
			if ($postFetchAction eq "Translate") {
				if ($verbal) { print("Calling lhGetEnvParameterValue....\n"); }
				$placeValue = lhGetEnvParameterValue($componentName, $subComponentName, $paramName, $pFullEnvName,"",$verbal);
			} elsif ($postFetchAction eq "TranslateExact") {
				if ($verbal) { print("Calling lhGetEnvParameterValueExact....\n"); }
				$placeValue = lhGetEnvParameterValueExact($componentName, $subComponentName, $paramName, $pFullEnvName,"",$verbal);
			} else {
				print("WARNING lhGetConfig: postFetchAction:(${postFetchAction}) not implemented!\n");
				$exitCode_lhGetConfig = 4; return $templateStr;
			}
			if ($placeValue ne $placeHolderNotFoundstr) {
				%transTab = (%transTab,($aPlaceholder,$placeValue));
			}
		}
		if ($verbal) { print("\nTranslation-Table:\n");displayHashTable(%transTab); print(unterstreichen("End of Debug","="));}
		$retString = replacePlaceholdersStr($templateStr,%transTab);
	}
	return $retString;
}

# if $locfileName ne "" the string will be saved in a file. If localFN starts with . (or ..) it is a relativ path to $CSG_CONFIG
sub lhGetConfig {
	my($componentName,$subComponentName,$location,$pInstance,$pLine,$pLevel,$localFN,$logFileName,$verbal) = @_;
	$pLevel    = setDefault($pLevel,    $ENV{"CSG_LEVEL"});
	$pInstance = setDefault($pInstance, $ENV{"CSG_INSTANCE"});
	$pLine     = setDefault($pLine,     $ENV{"CSG_LINE"});
	$location  = setDefault($location,  "ZH");
	$verbal    = setDefault($verbal,    $FALSE);
	
	my $fullEnvName = "${pInstance}_${pLine}_${pLevel}";
	my $retString = "";

	# find out current linked version of the component
	my $pathToExec  = $ENV{"CSG_SHARE_ROOT"}."/${pLevel}/${pInstance}_${pLine}/scripts/${componentName}"; 	if ($verbal) { print(unterstreichen("Debug on for lhGetConfig","=")); print("pathToExec:${pathToExec}:\n"); }
	my @dirList     = getDirList_UNIX($pathToExec,$TRUE);													if ($verbal) { print("\nFiles found:\n");displayArray(@dirList); }
	my $linkEntry   = getLinkDestFromUnixDirEntry($dirList[0],$TRUE);										if ($verbal) { print("linkEntry   :${linkEntry}:\n"); }
	if ($linkEntry eq "") {  # try COMMON4_ALL
		if ($verbal) { print("Checking COMMON4_ALL for that component\n"); }
		$pathToExec  = $ENV{"CSG_SHARE_ROOT"}."/${pLevel}/COMMON4_ALL/scripts/${componentName}"; 	if ($verbal) { print(unterstreichen("Debug on for lhGetConfig","=")); print("pathToExec:${pathToExec}:\n"); }
		@dirList     = getDirList_UNIX($pathToExec);												if ($verbal) { print("\nFiles found:\n");displayArray(@dirList); }
		$linkEntry   = getLinkDestFromUnixDirEntry($dirList[0]);									if ($verbal) { print("linkEntry   :${linkEntry}:\n"); }
	}
	my $codeVersion = getLastFieldFromString("/",$linkEntry,1);												if ($verbal) { print("codeVersion :${codeVersion}:\n"); }
	
	# get name and version of config from config mapping table
	my ($configType, $configName, $configVersion, $configPostAction)  = getConfigDetailsFromMappingTbl($componentName,$subComponentName,$codeVersion,$verbal);					if ($verbal) { print("\n--> configType:${configType}:   configName:${configName}:   configVersion:${configVersion}:   configPostAction:${configPostAction}:\n"); }
	$configName = replacePerlVariablesAndENV_InString($configName);
	if ($verbal) {
		print("Results from getConfigDetailsFromMappingTbl(...)\n");
		print("    configType       :${configType}:\n");
		print("    configName       :${configName}:\n");
		print("    configVersion    :${configVersion}:\n");
		print("    configPostAction :${configPostAction}:\n");
	}

	if ($configType eq "") { $exitCode_lhGetConfig = 1; return $retString;}
	if (($configType eq "File:Code") || ($configType eq "Bin-File:Code")) {
		my $configFullFileName = $ENV{"CSG_SHARE_ROOT"}."/".$ENV{"CSG_LEVEL"}."/code/${componentName}/${codeVersion}/scripts/${configName}";
		if (stringStartsWith($configName,"/")) {
			$configFullFileName = $configName;
		}
		if ($verbal) { print("configFullFileName:${configFullFileName}:\n"); }
		if (isFileExists($configFullFileName)) {
			$retString = processConfigTemplateString(readFileIntoStr($configFullFileName), $configPostAction, $componentName, $subComponentName, $fullEnvName, $verbal);
		} else {
			addToLogFile("ERROR: lhGetConfig: Config-Template (${configFullFileName}) not exists!",$logFileName,$verbal);
			$exitCode_lhGetConfig = 2; return $retString;
		}
	} elsif ($configType eq "DB") {
		$retString = processConfigTemplateString(getConfigTemplateFromDB($componentName,$subComponentName,$configName,$configVersion,$verbal), $configPostAction, $componentName, $subComponentName, $fullEnvName, $verbal);
		if ($retString eq $NotDefined) {
			addToLogFile("ERROR: lhGetConfig: Config-Template not found in DB!",$logFileName,$verbal);
			$exitCode_lhGetConfig = 5; return $retString;
		}
	} elsif (stringStartsWith($configType,"NameValue")) {
		my %nameVal = ();
		if ($verbal) { print (" ----> configType:${configType}, componentName:${componentName}, subComponentName:${subComponentName}, configPostAction:${configPostAction},\n"); }
		if ($configPostAction eq "") {
			%nameVal = lhGetEnvParameterValueAsHash($componentName, $subComponentName, $fullEnvName, $FALSE,  "--***", "", $verbal);
		} else {
			%nameVal = lhGetEnvParameterValueAsHash($componentName, $subComponentName, $fullEnvName, $FALSE, $configPostAction, "", $verbal);
		}
		$retString = hashTableToStrFormat($TRUE,getFieldFromString(":",1,$configType,"Default"),getFieldFromString(":",2,$configType," "),%nameVal);
	} else {
		addToLogFile("ERROR: lhGetConfig: Config-Type (${configType}) not implemented yet!",$logFileName,$TRUE);
		$exitCode_lhGetConfig = 3; return $retString;
	}

	if ($localFN ne "") {
		if (!(stringStartsWith($localFN,"/"))) {
			$localFN = $ENV{"CSG_CONFIG"}."/".$componentName."/".$localFN;
		}
		if ($verbal) { print("Save to file: ${localFN}\n"); }
		mkUnixDir(getPathNameOutOfFullName($localFN),"/");

		my $retStr = writeStringToFile($localFN,$FALSE,$retString,$FALSE);
		if ($retStr ne "") {
			print("${retStr}\n");
		}
		$retString = "";
	}

	if ($configType eq "Bin-File:Code") {
		$retString = "It is a BIN-File!!\n";
	}
	return $retString;
}


$configDB_Handle     = "";
$releaseDB_Handle    = "";
($releaseDB_Username, $releaseDB_Password, $releaseDB_DbName) = split(" ",getPackageDB_Details());
($configDB_Username , $configDB_Password , $configDB_DbName ) = split(" ",getConfigDB_Details());



sub doTest_getConfigDB_Details {
	my($myFullName,$debugThisFct) = @_;
	$debugThisFct = setDefault($debugThisFct,$FALSE);   

	my $cookieCryptKey             = $DefaultCryptKey;
	my $currLevel                  = getLevelFromFullEnvName($ENV{"CSG_FULL_ENV_NAME"});
	my $cookieName                 = "CONFIGDB_DEFINTIONS_COOKIE__${currLevel}";
	my $cookiePath                 = setDefault($ENV{"CSG_COOKY_PATH"},"/tmp");

	VT52_cls_home();
	my @testCases = (
		"No cookie at all, pkgdb ready ==> read it from DB and write cookie",
		"Cookie valid, pkgdb ready      ==> read it from cookie (and don't set new time stamp in cookie)",
		"Cookie expired, pkgdb ready    ==> read it from DB and write cookie",
		"Cookie valid, pkgdb down       ==> read it from cookie (and don't set new time stamp in cookie) ",
		"Cookie expired, pkgdb down     ==> read it from expired cookie and set new time stamp in cookie",
		"No cookie at all, pkgdb down  ==> No chance to recover!",
	);
	
	if ($debugThisFct) {
		my $answer1 = "";
		my $answer = createAsciiMenuExtended("","getConfigDB_Details Test-Cases","  Select","1","",5,"",@testCases);
		VT52_cls_home();
		print(unterstreichen($testCases[$answer - 1]));
		my $doTrace        = $TRUE;
		my $result         = "";
		my $expectedResult = "lhcfg winter#cfget123 LHCFG_DB.ROWINI.NET";

		if ($answer eq "1") {
			print("\n\n".boxingUnterstreichen("Delete cookie and get configDB_Details"));
			removeLhCookie($cookieName,$cookiePath);
			$result = getConfigDB_Details("","","",$doTrace);

		} elsif ($answer eq "2") {
			print("\n\n".boxingUnterstreichen("Set cookie to valid and get configDB_Details"));
			$result = getConfigDB_Details("","","","");
			$result = getConfigDB_Details("","","",$doTrace);

		} elsif ($answer eq "3") {
			print("\n\n".boxingUnterstreichen("Expire cookie and get configDB_Details"));
			my $newExpiryTime = alterCookieExpiryTime($cookieName,$cookiePath);
			print("Set cookie expiry to: ".$newExpiryTime.": (expire)\n");
			print("Set cookie expiry to: ".formatTimeStamp($newExpiryTime, "ENG", $TRUE, $FALSE, $LangEnglish)."\n");
			print("Current time:         ".formatTimeStamp(getTimeStamp(), "ENG", $TRUE, $FALSE, $LangEnglish)."\n");
			$result = getConfigDB_Details("","","",$doTrace);

		} elsif ($answer eq "4") {
			print("\n\n".boxingUnterstreichen("Shoutdown CFG-DB first manually! Cookie altered to be valid and get configDB_Details"));
			do {
				$answer1 = uc(readln("Have you manually shutdown CPK-DB connection?","N"));
			} until ($answer1 eq "Y");
			if (getParameter("ET","CONFIG_DB") eq "LHCFG_DB.ROWINI.NET") {
				print("WARNING: PKG-DB seems not to be down!\n");
				print("        getParameter(${currLevel},CONFIG_DB) still returns : ".getParameter($currLevel,"CONFIG_DB")."\n\n\n");
			}
			my $newExpiryTime = alterCookieExpiryTime($cookieName,$cookiePath,addSec_YYYYMMDDhhmmss(getTimeStamp(),20));
			print("Set cookie expiry to: ".$newExpiryTime.": (to be valid)\n");
			print("Set cookie expiry to: ".formatTimeStamp($newExpiryTime, "ENG", $TRUE, $FALSE, $LangEnglish)."\n");
			print("Current time:         ".formatTimeStamp(getTimeStamp(), "ENG", $TRUE, $FALSE, $LangEnglish)."\n");
			$result = getConfigDB_Details("","","",$doTrace);

		} elsif ($answer eq "5") {
			print("\n\n".boxingUnterstreichen("Shoutdown CFG-DB first manually! Cookie altered to be expired and get configDB_Details"));
			do {
				$answer1 = uc(readln("Have you manually shutdown CPK-DB connection?","N"));
			} until ($answer1 eq "Y");
			if (getParameter("ET","CONFIG_DB") eq "LHCFG_DB.ROWINI.NET") {
				print("WARNING: PKG-DB seems not to be down!\n");
				print("        getParameter(${currLevel},CONFIG_DB) still returns : ".getParameter($currLevel,"CONFIG_DB")."\n\n\n");
			}
			my $newExpiryTime = alterCookieExpiryTime($cookieName,$cookiePath);
			print("Set cookie expiry to: ".$newExpiryTime.": (expire)\n");
			print("Set cookie expiry to: ".formatTimeStamp($newExpiryTime, "ENG", $TRUE, $FALSE, $LangEnglish)."\n");
			print("Current time:         ".formatTimeStamp(getTimeStamp(), "ENG", $TRUE, $FALSE, $LangEnglish)."\n");
			$result = getConfigDB_Details("","","",$doTrace);

		} elsif ($answer eq "6") {
			print("\n\n".boxingUnterstreichen("Shoutdown CFG-DB first manually! Cookie deleted and get configDB_Details"));
			do {
				$answer1 = uc(readln("Have you manually shutdown CPK-DB connection?","N"));
			} until ($answer1 eq "Y");
			if (getParameter("ET","CONFIG_DB") eq "LHCFG_DB.ROWINI.NET") {
				print("WARNING: PKG-DB seems not to be down!\n");
				print("        getParameter(${currLevel},CONFIG_DB) still returns : ".getParameter($currLevel,"CONFIG_DB")."\n\n\n");
			}
			removeLhCookie($cookieName,$cookiePath);
			$result = getConfigDB_Details("","","",$doTrace);
		}

		if ($result ne $expectedResult) {
			print("ERROR: Test-Case (${answer})!\n");
			print("     Result  :${result}:\n");
			print("     Expected:${expectedResult}:\n");
		} else {
			print("\n\nCookie expiry is:        ".getCookieExpiryTime($cookieName,"GE_LONG",$cookiePath)."\n");
			print("\n".boxingUnterstreichen("Result  :${result}:  As expected!"));
		}
	}
}

# return values:
# 	format:	result:
# 	""		user password dbName
#	sqlplus	user/password@dbname
sub getConfigDB_Details {
	my ($pFullEnvName,$formatIt,$forceRefreshCookie,$doTrace) = @_;
	$pFullEnvName       = setDefault($pFullEnvName,         $ENV{"CSG_FULL_ENV_NAME"});
	$forceRefreshCookie = setDefault($forceRefreshCookie,   $FALSE);
	$doTrace            = setDefault($doTrace,              $FALSE);

	my $cookieCryptKey             = $DefaultCryptKey;
	my $currLevel                  = getLevelFromFullEnvName($pFullEnvName);
	my $cookieName                 = "CONFIGDB_DEFINTIONS_COOKIE__${currLevel}";
	my $configDB_DbName            = "";
	my $configDB_Username          = "";
	my $configDB_Password          = "";
	my $valueReadFromCookie        = $FALSE;
	my $getDetailsFromPKGDB_Trace  = $doTrace; # $TRUE;

	if ($doTrace) { print("===> getConfigDB_Details:: START TRACE!! <=== \n"); }
	if ($forceRefreshCookie) { # just to keep function common usable
		if ($doTrace) { print("      getConfigDB_Details:: forceRefreshCookie!! Read values from PKG-DB\n"); }
		($configDB_Username, $configDB_Password, $configDB_DbName) = split(" ",getConfigDB_DetailsFromPackageDB($currLevel, "", "" ,1, $getDetailsFromPKGDB_Trace));
	} else { # normal case
		my $cookieValue = readLhCookie($cookieName, $cookieCryptKey, $ENV{"CSG_COOKY_PATH"},"","",$FALSE);    # Cookie expiry not checked anymore; Read it allways from cookie
		if ($doTrace) { print("      getConfigDB_Details:: Normal Case: Read values from cookie\n"); print("\n\n======\n${cookieValue}\n======\n\n"); }
		if (stringContains($cookieValue,"ERROR:",$FALSE)) { # not found or expired
			if ($doTrace) { print("      getConfigDB_Details:: Read values from cookie returned ERROR:\n"); print("\n\n-----\n${cookieValue}\n-----\n\n"); }
			if ($doTrace) { print("===>  getConfigDB_Details:: CASE 1 / 3 <=== \n"); }
			($configDB_Username, $configDB_Password, $configDB_DbName) = split(" ",getConfigDB_DetailsFromPackageDB($currLevel, "", "" ,1, $getDetailsFromPKGDB_Trace));
		} else {
			if ($doTrace) { print("      getConfigDB_Details:: Read values from cookie was fine:\n"); print("\n\n+++++\n${cookieValue}\n+++++\n\n"); }
			if ($doTrace) { print("===>  getConfigDB_Details:: CASE 2 / 4 <=== \n"); }
			$configDB_DbName   = getFieldFromQQ($cookieValue,1,2,": ",1);
			$configDB_Username = getFieldFromQQ($cookieValue,2,2,": ",1);
			$configDB_Password = getFieldFromQQ($cookieValue,3,2,": ",1);
			if (($configDB_DbName ne "") && ($configDB_Username ne "") && ($configDB_Password ne "")) { $valueReadFromCookie = $TRUE; }
		}
	}

	if ($configDB_DbName eq "") { ($configDB_Username, $configDB_Password, $configDB_DbName) = split(" ",getConfigDB_DetailsFromPackageDB($currLevel, "", "" ,1, $getDetailsFromPKGDB_Trace)); }

	if (stringContains(uc($configDB_DbName),"ERROR")) {  # could not read it from Cookie (expired or not found) nor from DB
		if ($doTrace) {  print("      getConfigDB_Details:: Values still not read from cookie nor DB!!! Try to read it from expired cookie!\n\n\n"); }
		if ($doTrace) {  print("      getConfigDB_Details:: CASE 5\n"); }
		my $cookieValue      = readLhCookie($cookieName, $cookieCryptKey, $ENV{"CSG_COOKY_PATH"},"","",$FALSE);
		$configDB_DbName     = getFieldFromQQ($cookieValue,1,2,": ",1);
		$configDB_Username   = getFieldFromQQ($cookieValue,2,2,": ",1);
		$configDB_Password   = getFieldFromQQ($cookieValue,3,2,": ",1);
		$valueReadFromCookie = $TRUE;
		if ($doTrace) {  print("getConfigDB_Details:: Read values from expired cookie:\n     configDB_DbName:${configDB_DbName}     configDB_Username:${configDB_Username}     configDB_Password:${configDB_Password}"); }
	} 
	if (!($valueReadFromCookie)) {
		my $cookieValueNew = qq {
			DB_Name:     ${configDB_DbName}
			DB_User:     ${configDB_Username}
			DB_Password: ${configDB_Password}
		};
		$cookieValueNew    = trimQQ_String($cookieValueNew);
		my $cookieFullName = writeLhCookie($cookieName, $cookieValueNew, $cookieCryptKey, $ENV{"CSG_COOKY_LIFETIME"}, $ENV{"CSG_COOKY_PATH"});
		if ($doTrace) {  print("      getConfigDB_Details:: cookieFullName:${cookieFullName}: written!!\n  cookieValueNew:\n${cookieValueNew}\n\n"); }
	}

	my $retStr = "${configDB_Username} ${configDB_Password} ${configDB_DbName}";
	if (uc($formatIt) eq "SQLPLUS") {
		$retStr = "${configDB_Username}/${configDB_Password}\@${configDB_DbName}";
	}
	if ($doTrace) { print("===> getConfigDB_Details:: END TRACE!! <=== \n"); }
	return $retStr;
}

sub getConfigDB_DetailsFromPackageDB {
	my ($pFullEnvName, $formatIt, $cookieCryptKey, $useDefaultKey, $doTrace) = @_;
	$pFullEnvName      = setDefault($pFullEnvName,         $ENV{"CSG_FULL_ENV_NAME"});
	$doTrace           = setDefault($doTrace,              $FALSE);

	if ($doTrace) { print("\n===> getConfigDB_DetailsFromPackageDB:: START TRACE!! <=== \n"); }
	my $currLevel      = getLevelFromFullEnvName($pFullEnvName);
	if ($useDefaultKey) { $cookieCryptKey = $DefaultCryptKey; }

	my $configDB_DbName   = getParameter($currLevel,"CONFIG_DB");
	my $configDB_Username = getParameter($currLevel,"CONFIG_DB_USERNAME");
	my $configDB_Password = "";
	if ($cookieCryptKey ne "") {
		$configDB_Password = getParameter($currLevel,"CONFIG_DB_PASSWORD",$cookieCryptKey);
	} else {
		$configDB_Password = getParameter($currLevel,"CONFIG_DB_PASSWORD");
	}
	if ($doTrace) { print("   getConfigDB_DetailsFromPackageDB:Values read via getParameter:\n      configDB_DbName  :${configDB_DbName}:\n      configDB_Username:${configDB_Username}:\n      configDB_Password:${configDB_Password}: \n"); }

	my $retStr = "${configDB_Username} ${configDB_Password} ${configDB_DbName}";
	if (uc($formatIt) eq "SQLPLUS") {
		$retStr = "${configDB_Username}/${configDB_Password}\@${configDB_DbName}";
	}
	if ($doTrace) { print("\n===> getConfigDB_DetailsFromPackageDB:: END TRACE!! <=== \n"); }
	return $retStr;
}

sub getParameter {
	my ($pLevel, $pParamName, $cookieCryptKey, $useDefaultKey, $doTrace) = @_;
	$pLevel             = setDefault($pLevel,        $ENV{"CSG_LEVEL"});
	$useDefaultKey      = setDefault($useDefaultKey, $FALSE);

	if ($useDefaultKey) { $cookieCryptKey = $DefaultCryptKey; }
	my $unixCmd = "getParameter ${pLevel} ${pParamName} 2>&1 || echo ERROR";
	if ($doTrace) { print("getParameter::   unixCmd:${unixCmd}:\n"); }
	my $paramVal = `${unixCmd}`;   chomp($paramVal);
	if ($doTrace) { print("getParameter::   paramVal:${paramVal}:\n"); }
	if ($cookieCryptKey ne "") { $paramVal = decryptString($paramVal,$cookieCryptKey); } # entschluesselt
	return $paramVal;
}

sub setParameter {
	my ($pLevel, $pParamName, $pParamVal, $cookieCryptKey, $useDefaultKey, $doTrace) = @_;
	$pLevel             = setDefault($pLevel,        $ENV{"CSG_LEVEL"});
	$useDefaultKey      = setDefault($useDefaultKey, $FALSE);

	if ($useDefaultKey) { $cookieCryptKey = $DefaultCryptKey; }
	if ($cookieCryptKey ne "") { $pParamVal = encryptString($pParamVal, $cookieCryptKey); } # verschluesseln

	my $unixCmd = "setParameter ${pLevel} ${pParamName} \"${pParamVal}\" 2>&1";
	if ($doTrace) { print("setParameter::   unixCmd:${unixCmd}:\n"); }
	my $retVal = `${unixCmd}`;
	$retVal = "";
	return $retVal;
}

sub delParameter {
	my ($pLevel, $pParamName, $doTrace) = @_;
	$pLevel             = setDefault($pLevel,        $ENV{"CSG_LEVEL"});

	my $unixCmd = "deleteParameter ${pLevel} ${pParamName} 2>&1";
	if ($doTrace) { print("delParameter::   unixCmd:${unixCmd}:\n"); }
	my $retVal = `${unixCmd}`;
	$retVal = "";
	return $retVal;
}

sub listParameter {
	my ($pLevel, $pParamName, $cookieCryptKey, $useDefaultKey, $outMask, $outSep, $withTitle, $doTrace) = @_;
	$pLevel             = setDefault($pLevel,        $ENV{"CSG_LEVEL"});
	$useDefaultKey      = setDefault($useDefaultKey, $FALSE);
	$outMask            = setDefault($outMask,       "****");
	$outSep             = setDefault($outSep,        ";");
	$withTitle          = setDefault($withTitle,     $FALSE);

	if ($pLevel     eq "*") { $pLevel     = ""; }
	if ($pParamName eq "*") { $pParamName = ""; }

	if ($useDefaultKey) { $cookieCryptKey = $DefaultCryptKey; }

	my $retVal = "";
	my $unixCmd = "listParameters 2>&1";
	my @outLines = `${unixCmd}`;
	my $outSepStr = $outSep;
	@outLines = getSubsetFromArray(2,"",chompArrayEntries(@outLines));
	if ($doTrace) {
		print("listParameter::   unixCmd:${unixCmd}:\n");
		displayArray(@outLines);
	}

	# Filter rows
	if ($doTrace) { print("\n\nFilter:\n"); }
	my @retList = ();
	if ($withTitle) {
		@retList = ("Level${outSep}Parameter-Name${outSep}Parameter-Value${outSep}Parameter-Value (encrypted)${outSep}");
	}
	my $levelMatches = $TRUE;
	my $nameMatches  = $TRUE;
	foreach my $aLine (@outLines) {
		my ($tLevel, $tpParamName, $tParamVal) = split(" ",$aLine);
		if ($doTrace) { 
			print("\n---> aLine:${aLine}:   pLevel:${pLevel}:   pParamName:${pParamName}:   \n");
			print("     tLevel:${tLevel}:     tpParamName:${tpParamName}:     tParamVal:${tParamVal}: \n");
		}
		if ($pLevel ne "") {
			$levelMatches = stringStartsWith($aLine,$pLevel,$FALSE);
			if ($doTrace) { print("     levelMatches:${levelMatches}: \n"); }
		}
		if ($pParamName ne "") {
			$nameMatches = stringContains($aLine,$pParamName,$FALSE);
			if ($doTrace) { print("     nameMatches:${nameMatches}: \n"); }
		}

		my $dParamVal =  "";
		if ($cookieCryptKey ne "") { $dParamVal = decryptString($tParamVal,$cookieCryptKey); } # entschluesselt
		if ($dParamVal eq "XXX ERROR XXX") { $dParamVal = $tParamVal; }

		if ($doTrace) { 
			print("    levelMatches:${levelMatches}:   nameMatches:${nameMatches}:\n");
		}
		if (($levelMatches) && ($nameMatches)) {
			my @retTmpList = ();
			if ($doTrace) { print("     tLevel:${tLevel}: \n"); }

			$outSepStr = $outSep;
			if ($outSep eq "*") {
				$tLevel      = padString($tLevel,     -10);
				$tpParamName = padString($tpParamName,-20);
				$dParamVal   = padString($dParamVal,  -20);
				$tParamVal   = padString($tParamVal,  -10);
				$outSepStr   = "";
			} 
			if (substr($outMask,0,1) eq "*") { push(@retTmpList,$tLevel);      }
			if (substr($outMask,1,1) eq "*") { push(@retTmpList,$tpParamName); }
			if (substr($outMask,2,1) eq "*") { push(@retTmpList,$dParamVal);   }
			if (substr($outMask,3,1) eq "*") { push(@retTmpList,$tParamVal);   }
			my $retVal = makeStrFromArray($outSepStr,@retTmpList);
			push(@retList,$retVal);
		}
	}

	my @fieldLen_1  = (4);
	my @padStr_1    = (" ");
	# print("\n\n");displayArray(@retList);print("\n\noutSepStr:${outSepStr}:\n\n");
	if ($withTitle) {
		return padFieldsInFieldStringArray($outSepStr,$TRUE,$FALSE,\@retList,\@fieldLen_1,\@padStr_1,$TRUE,"-");
	} else {
		return padFieldsInFieldStringArray($outSepStr,$TRUE,$FALSE,\@retList,\@fieldLen_1,\@padStr_1,$TRUE);
	}
}



# ##############################################################################################
# Functions for lhCloud, Nolio, artifacts DB
# ##############################################################################################
sub getPackageDB_DetailsFromXML {
	my ($hibernatXmlFN, $valueName) = @_;
	if ($hibernatXmlFN eq "") {
		$hibernatXmlFN      = $ENV{CSG_COMMON_PERL_LIBRARIES}."/hibernate_lhpkg.cfg.xml";
		if (($ENV{"TESTMODE"} eq "1") || ($ENV{"USE_LHPKGTEST"} eq "1")) {
			$hibernatXmlFN      = $ENV{CSG_COMMON_PERL_LIBRARIES}."/hibernate_lhpkgtest.cfg.xml";
		}
	}

	my $tagName = "";
	if ($valueName eq "db.name")     { $tagName = "<property name=\"lhpkg.db.name\">"; }
	if ($valueName eq "db.user")     { $tagName = "<property name=\"hibernate.connection.username\">"; }
	if ($valueName eq "db.password") { $tagName = "<property name=\"hibernate.connection.password\">"; }
	if ($valueName eq "jdbc.url")    { $tagName = "<property name=\"hibernate.connection.url\">"; }

	my $returnVal = getTagValueFromXML($tagName,readFileIntoStr($hibernatXmlFN,$fromLine,$toLine,$trace));
	# print("getPackageDB_DetailsFromXML::hibernatXmlFN:${hibernatXmlFN}:  valueName:${valueName}:  returnVal:${returnVal}:\n\n");
	return $returnVal;
}

# return values:
# 	format:	result:
# 	""		user password dbName
#	sqlplus	user/password@dbname
sub getPackageDB_Details {
	my ($pFullEnvName,$formatIt,$fromHibernateFile) = @_;
	$pFullEnvName      = setDefault($pFullEnvName,         $ENV{"CSG_FULL_ENV_NAME"});
	$fromHibernateFile = setDefault($fromHibernateFile,    $TRUE);

	my $javaPropFN         = $ENV{CSG_COMMON_PERL_LIBRARIES}."/lhpkgDb.properties";
	if (($ENV{"TESTMODE"} eq "1") || ($ENV{"USE_LHPKGTEST"} eq "1")) {
		$javaPropFN         = $ENV{CSG_COMMON_PERL_LIBRARIES}."/lhpkgtestDb.properties";
	}
	my $releaseDB_DbName   = "";
	my $releaseDB_Username = "";
	my $releaseDB_Password = "";
	my $releaseDB_jdbcStr  = "";
	
	if ($fromHibernateFile) {
		$releaseDB_DbName   = getPackageDB_DetailsFromXML("","db.name");
		$releaseDB_Username = getPackageDB_DetailsFromXML("","db.user");
		$releaseDB_Password = getPackageDB_DetailsFromXML("","db.password");
		$releaseDB_jdbcStr  = getPackageDB_DetailsFromXML("","jdbc.url");
	} else {
		$releaseDB_DbName   = getJavaPropertyFromFile($javaPropFN,"db.name");
		$releaseDB_Username = getJavaPropertyFromFile($javaPropFN,"db.user");
		$releaseDB_Password = getJavaPropertyFromFile($javaPropFN,"db.password");
		$releaseDB_jdbcStr  = getJavaPropertyFromFile($javaPropFN,"jdbc.url");
	}

	my $retStr = "${releaseDB_Username} ${releaseDB_Password} ${releaseDB_DbName}";

	if (uc($formatIt) eq "SQLPLUS") {
		$retStr = "${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}";
	}
	if (uc($formatIt) eq "JDBC") {
		$retStr = $releaseDB_jdbcStr;
	}
	if (uc($formatIt) eq "TOTRACE") {
		$retStr = "${releaseDB_Username}/XXXXXXXX\@${releaseDB_DbName}";
	}
	if (uc($formatIt) eq "ONLYUSERNAME") {
		$retStr = "${releaseDB_Username}";
	}
	return $retStr;
}

sub getConfigTemplateFromDB {
	my($componentName,$subComponentName,$templateName,$templateVersion,$verbal) = @_;
	$verbal      = setDefault($verbal,        $FALSE);

	my $retString = "";

	if ($configDB_Handle eq "") {
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	$configDB_Handle->{LongReadLen} = 1024 * 1024;  # Max size of CLOB 1MB
	my $sql = qq {
		select
			CMP_CFG_DB.CONTENT TEMPLATE_STRING
		from
			CMP_CFG_DB, COMPONENTS
		where
			COMPONENTS.ID                            = CMP_CFG_DB.SUBCMP_ID   and 
			COMPONENTS.CMP_NAME                      = '${componentName}'     and 
			COMPONENTS.SUBCMP_NAME                   = '${subComponentName}'  and 
			cmp_cfg.version_to_num(DB_CFG_VERSION)  <= cmp_cfg.version_to_num('${templateVersion}')
	};
	if ($verbal) { print("---> Getting config template from DB:  ${configDB_Username}/${configDB_Password}\@${configDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $configDB_Handle->prepare($sql);
	my @recordSet   = dbExecutePreparedSelectSttmnt($prepared_sql);
	my $resCount = @recordSet;
	if ($resCount = 1) {
		my $aRecord = $recordSet[0];
		$retString = $aRecord->{TEMPLATE_STRING};
	} else {
		if ($resCount = 0) {
			print("ERROR: in getConfigTemplateFromDB! No entry found for...\n");
		} else {
			print("ERROR: in getConfigTemplateFromDB! Too many entries found for...\n");
		}
		$retString = $NotDefined;
		print("   ${sql}\n"); 
	}

	return $retString;
}

sub getMultipleConfigDetailsFromMappingTbl {
	my($componentNameFilter, $subComponentNameFilter, $codeVersionFilter, $isLikeFilter, $returnRawDataSet, $verbal) = @_;
	$componentNameFilter    = setDefault($componentNameFilter,      "ALL");
	$subComponentNameFilter = setDefault($subComponentNameFilter,   "ALL");
	$codeVersionFilter      = setDefault($codeVersionFilter,        "");
	$isLikeFilter           = setDefault($isLikeFilter,             $TRUE);
	$returnRawDataSet       = setDefault($returnRawDataSet,         $TRUE);
	$verbal                 = setDefault($verbal,                   $FALSE);

	if (uc($componentNameFilter)    eq "ALL") { $componentNameFilter    = ""; }
	if (uc($subComponentNameFilter) eq "ALL") { $subComponentNameFilter = ""; }
	
	if ($configDB_Handle eq "") {
		# print("configDB_DbDetails XXXXX:${configDB_DbName},${configDB_Username},${configDB_Password}:\n");
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	my $whereClause = "";
	if ($componentNameFilter ne "") {
			my $tmpWhereClause = "";
			if ($isLikeFilter) { $tmpWhereClause = "                        CMP_NAME     like   '${componentNameFilter}\%'    "; } else {
								 $tmpWhereClause = "                        CMP_NAME     =      '${componentNameFilter}'      "; }
			if ($whereClause eq "") {
				$whereClause = $tmpWhereClause;
			} else {
				$whereClause = $whereClause ." and \n".$tmpWhereClause;
			}
	}
	if ($subComponentNameFilter ne "") {
			my $tmpWhereClause = "";
			if ($isLikeFilter) { $tmpWhereClause = "                        SUBCMP_NAME  like   '${subComponentNameFilter}\%' "; } else {
								 $tmpWhereClause = "                        SUBCMP_NAME  =      '${subComponentNameFilter}'   "; }

			if ($whereClause eq "") {
				$whereClause = $tmpWhereClause;
			} else {
				$whereClause = $whereClause ." and \n".$tmpWhereClause;
			}
	}
	if ($codeVersionFilter ne "") {
			my $tmpWhereClause = "                        cmp_cfg.version_to_num(CODE_VERSION)  <= cmp_cfg.version_to_num('${codeVersionFilter}') ";
			if ($whereClause eq "") {
				$whereClause = $tmpWhereClause;
			} else {
				$whereClause = $whereClause ." and \n".$tmpWhereClause;
			}
	}
	if ($whereClause ne "") {
		$whereClause = "\n	        where\n".$whereClause;
	}

	my @recordSet = ();
	my $sql = qq {
		select
			CMP_NAME,
			SUBCMP_NAME,
			CODE_VERSION,
			CFG_TYPE,
			CFG_NAME,
			POST_FETCH_ACTION,
			DB_CFG_VERSION
		from
			CMP_CFG_VERSIONS_V ${whereClause}
		order by 
			CMP_NAME                             ASC,
			SUBCMP_NAME                          ASC,
			cmp_cfg.version_to_num(CODE_VERSION) DESC
	};
	if ($verbal) { print("---> Getting Details from DB:  ${configDB_Username}/${configDB_Password}\@${configDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $configDB_Handle->prepare($sql);
	@recordSet   = dbExecutePreparedSelectSttmnt($prepared_sql);

	if ($returnRawDataSet) {
		return @recordSet;
	} else {
		my %fieldTitleOrderHash = (
			"2:SUBCMP_NAME"       => "Subcomponent-Name;Left;String;Descending",
			"1:CMP_NAME"          => "Component-Name;Left;String;Descending",
			"3:CODE_VERSION"      => "Code-Version;Right;String;Ascending",
			"4:CFG_TYPE"          => "Component-Name;Left;String;Descending",
			"5:CFG_NAME"          => "CFG_TYPE;Left;String;Descending",
			"6:DB_CFG_VERSION"    => "DB_CFG_VERSION;Right;String;Descending",
			"7:POST_FETCH_ACTION" => "POST_FETCH_ACTION;Left;String;Descending",
			"8:CHANGED_BY"        => "CHANGED_BY;Left;String;Descending",
			"9:CHANGED_TS"        => "CHANGED_TS;Left;String;Descending",
		);
		if ($FALSE) {
			#									  displayRecSetAsTable($recordSetRef, $fieldTitleOrderHashRef, $formatIt, $addTitle, $beforeFirstRecStr, $beforeFirstFieldStr, $preFieldStr, $postFieldStr, $fieldSeparator, $afterLastFieldStr, $afterLastRecStr, $emptyFieldText, $removeSepInOutput, $doDebug)
			print("\n\n1:\n");displayLines($FALSE,displayRecSetAsTable(\@recordSet  , \%fieldTitleOrderHash  , $FALSE   , $TRUE    , "<TABLE>\n"       , "  <TR>\n"          , "    <TD>"  , "</TD>\n"    , ""             ,"  </TR>\n"        , "</TABLE>\n"    , "&nbsp"        , $removeSepInOutput, $doDebug)); halt(); 
			print("\n\n2:\n");displayLines($FALSE,displayRecSetAsTable(\@recordSet  , \%fieldTitleOrderHash  , $TRUE    , $TRUE    , ""                , ""                  , ""          ,  ""          , "\|"           , "\n"              , ""              , ""             , $FALSE            , $doDebug)); halt(); 
			print("\n\n3:\n");displayLines($FALSE,displayRecSetAsTable(\@recordSet  , \%fieldTitleOrderHash  , $TRUE    , $TRUE    , ""                , ""                  , ""          ,  ""          , ";"            , "\n"              , ""              , ""             , $FALSE            , $doDebug)); halt();
			print("\n\n4:\n");displayLines($FALSE,displayRecSetAsTable(\@recordSet  , \%fieldTitleOrderHash  , $TRUE    , $TRUE    , ""                , ""                  , ""          ,  ""          , "\|"           , "\n"              , ""              , ""             , $TRUE             , $doDebug)); halt(); 
			print("\n\n5:\n");displayLines($FALSE,displayRecSetAsTable(\@recordSet  , \%fieldTitleOrderHash  , $TRUE    , $TRUE    , ""                , ""                  , ""          ,  ""          , ";"            , "\n"              , ""              , ""             , $TRUE             , $doDebug)); halt(); 	
		}
		return                                    displayRecSetAsTable(\@recordSet  , \%fieldTitleOrderHash  , $TRUE    , $TRUE    , ""                , ""                  , ""          ,  ""          , "\|"           , "\n"              , ""              , " "             , $FALSE            , $doDebug);
	}
}

sub getConfigDetailsFromMappingTbl {
	my($componentName,$subComponentName,$codeVersion,$verbal) = @_;
	$verbal = setDefault($verbal,        $FALSE);

	my @retList = ();
	## print("getConfigDetailsFromMappingTbl....\n");
	my @recordSet = getMultipleConfigDetailsFromMappingTbl($componentName, $subComponentName, $codeVersion, $FALSE, $TRUE, $verbal);
	foreach my $aRec (@recordSet) {
		if ($verbal) {
			print("--> from getConfigDetailsFromMappingTbl\n");
			print("    1) ".$aRec->{CFG_TYPE}."\n");
			print("    2) ".$aRec->{CFG_NAME}."\n");
			print("    3) ".$aRec->{DB_CFG_VERSION}."\n");
			print("    4) ".$aRec->{POST_FETCH_ACTION}."\n\n");
		}
	}

	my $resCount = @recordSet;
	if ($resCount >= 1) {
		my $aRecord = $recordSet[0];
		push(@retList,$aRecord->{CFG_TYPE});
		push(@retList,strip($aRecord->{CFG_NAME}));
		push(@retList,strip($aRecord->{DB_CFG_VERSION}));
		push(@retList,$aRecord->{POST_FETCH_ACTION});
	} else {
		print("ERROR: in getConfigDetailsFromMappingTbl! No entry found for...\n");
		print("   ${sql}\n"); 
	}

	if ($verbal) { displayArray(@retList); }
	return @retList;
}

sub getLevels {
	my ($passedVal) = @_;
	my @retVal = ();
	if ($passedVal eq "") {
		my $tmpStr = `getLevels`;  chomp($tmpStr);
		@retVal = split(" ",$tmpStr);
	} else {
		@retVal = split(";",$passedVal);
	}
	if ($FALSE) {
		print("\n   Levels\n");     
		displayArrayEnhanced($TRUE,$FALSE,"   -> ","\n",@retVal);
	}
	return @retVal;
}

sub getInstances {
	my ($pLevel, $passedVal) = @_;
	my @retVal = ();
	if ($passedVal eq "") {
		my $tmpStr = `getInstances $pLevel`;  chomp($tmpStr);
		@retVal = split(" ",$tmpStr);
	} else {
		@retVal = split(";",$passedVal);
	}
	if ($FALSE) {
		print("\n      Instances\n");     
		displayArrayEnhanced($TRUE,$FALSE,"      -> ","\n",@retVal);
	}
	return @retVal;
}

sub getEnvs {
	my ($pLevel, $passedVal) = @_;
	my @retVal = ();
	if ($passedVal eq "") {
		my $tmpStr = `getEnvs $pLevel`;  chomp($tmpStr);
		@retVal = split(" ",$tmpStr);
	} else {
		@retVal = split(";",$passedVal);
	}
	if ($FALSE) {
		print("\n         Envs\n");     
		displayArrayEnhanced($TRUE,$FALSE,"         -> ","\n",@retVal);
	}
	return @retVal;
}

sub getLines {
	my ($pLevel, $pInstance, $passedVal) = @_;
	my @retVal = ();
	if ($passedVal eq "") {
		my $tmpStr = `getLines $pLevel $pInstance`;  chomp($tmpStr);
		@retVal = split(" ",$tmpStr);
	} else {
		@retVal = split(";",$passedVal);
	}
	if ($FALSE) {
		print("\n            Lines\n");     
		displayArrayEnhanced($TRUE,$FALSE,"            -> ","\n",@retVal);
	}
	return @retVal;
}

sub getAllInstalledEnvByFullName {
	my @retVal = ();
	foreach my $aLevel (getLevels()) {
		foreach my $aInstance (getInstances($aLevel)) {
			foreach my $aLine (getLines($aLevel, $aInstance)) {
				push(@retVal,getFullEnvName($aLevel, $aInstance, $aLine));
			}
		}
	}
	return @retVal;
}

sub areThereMultipleStoresOnShare {
	my $count = getLevels();
	# print("areThereMultipleStoresOnShare:: count:${count}:\n");
	if ($count eq "1") {
		# print("areThereMultipleStoresOnShare:: One Level\n");
		return $FALSE;
	} else {
		# print("areThereMultipleStoresOnShare:: Multiple Levels\n");
		return $TRUE;
	}
}


# returns e.g. LHX_A_ET   = if you don't pass any of the parameters it takes it from ENV
sub getFullEnvName {
	my ($pLevel, $pInstance, $aLine) = @_;
	my $retVal = "";
	$pLevel    = setDefault($pLevel,    $ENV{"CSG_LEVEL"});
	$pInstance = setDefault($pInstance, $ENV{"CSG_INSTANCE"});
	$aLine     = setDefault($aLine,     $ENV{"CSG_LINE"});
	$retVal = "${pInstance}_${aLine}_${pLevel}";
	return $retVal;
}

sub getLevel_FromFullEnvName {
	my ($pFullEnvName, $notFoundStr) = @_;
	return getLevelFromFullEnvName($pFullEnvName, $notFoundStr);
}

sub getLevelFromFullEnvName {
	my ($pFullEnvName, $notFoundStr) = @_;
	my $retVal = "";
	$pFullEnvName = setDefault($pFullEnvName,    $ENV{"CSG_FULL_ENV_NAME"});
	$retVal       = strip(getFieldFromString("_",2,$pFullEnvName,$notFoundStr));
	return $retVal;
}

sub getLine_FromFullEnvName {
	my ($pFullEnvName, $notFoundStr) = @_;
	return getLineFromFullEnvName($pFullEnvName, $notFoundStr);
}

sub getLineFromFullEnvName {
	my ($pFullEnvName, $notFoundStr) = @_;
	$pFullEnvName    = setDefault($pFullEnvName,    $ENV{"CSG_FULL_ENV_NAME"});
	return strip(getFieldFromString("_",1,$pFullEnvName,$notFoundStr));;
}

sub getInstanceName_FromFullEnvName {
	my ($pFullEnvName, $notFoundStr) = @_;
	return getInstanceFromFullEnvName($pFullEnvName, $notFoundStr);
}

sub getInstanceFromFullEnvName {
	my ($pFullEnvName, $notFoundStr) = @_;
	my $retVal = "";
	$pFullEnvName    = setDefault($pFullEnvName,    $ENV{"CSG_FULL_ENV_NAME"});
	$retVal = strip(getFieldFromString("_",0,$pFullEnvName,$notFoundStr));
	return $retVal;
}

sub splitFullEnvName {
	my ($pFullEnvName, $notFoundStr) = @_;
	my $pInstance = strip(getFieldFromString("_",0,$pFullEnvName,$notFoundStr));
	my $pLine     = strip(getFieldFromString("_",1,$pFullEnvName,$notFoundStr));
	my $pLevel    = strip(getFieldFromString("_",2,$pFullEnvName,$notFoundStr));
	return ($pInstance, $pLine, $pLevel);
}

sub alterFullEnv {
	my ($pFullEnvName, $allInstance, $allLine, $allLevel) = @_;
	my $doDebug = $FALSE;
	if ($doDebug) {
		print("\nIn alterFullEnv (A)\n");
		print("     pFullEnvName:${pFullEnvName}:\n");
		print("     allInstance :${allInstance}:\n");
		print("     allLine     :${allLine}:\n");
		print("     allLevel    :${allLevel}:\n");
	}
	$pFullEnvName = setDefault($pFullEnvName, $ENV{"CSG_FULL_ENV_NAME"});
	$allInstance  = setDefault($allInstance,  getInstanceName_FromFullEnvName($pFullEnvName));
	$allLevel       = setDefault($allLevel,  getLevel_FromFullEnvName($pFullEnvName));
	$allLine        = setDefault($allLine,  getLine_FromFullEnvName        ($pFullEnvName));
	if ($doDebug) {
		print("\nIn alterFullEnv (B)\n");
		print("     pFullEnvName:${pFullEnvName}:\n");
		print("     allInstance :${allInstance}:\n");
		print("     allLine     :${allLine}:\n");
		print("     allLevel    :${allLevel}:\n");
	}

	return "${allInstance}_${allLine}_${allLevel}";
}

sub removeAnEnv{
	my ($pLevel, $pEnv, $doAsk) = @_;
	$doAsk                      = setDefault($doAsk,    $TRUE);
	my $ans = $FALSE;
	my @retVal = ();
	my $pInstance  = getInstanceFromFullEnvName($pEnv);
	my $pLine      = getLineFromFullEnvName($pEnv);
	
    if ($isLastLineForAnInstance) {
		print("Removing ${pEnv} on ${pLevel}....that will take some time!!!");
	} else {
		print("Removing ${pEnv} on ${pLevel}....that will take some time!!! BTW: It is the last line for ${pInstance}");
	}
	
	if ($doAsk) {
		$ans = setBooleanFromYesNoStr("N");
		$ans = setBooleanFromYesNoStr(readln("\nDo you really want to delete ${pEnv}?","N"));
	} else {
	    $ans = $TRUE;
	}
	
	if ($ans) {
		my $unixCmd = "rm -rf ".$ENV{"CSG_SHARE_ROOT"}."/${pLevel}/${pEnv}";
		print("\nExecute ${unixCmd}\n\n");
		@retVal = `${unixCmd} 2>&1`;
		print ("...done!!\n");

		my $skip_DoYouReallySure = $TRUE;
		my $verbal               = $TRUE;
		print(removeAnEnvFromPKGDB($pInstance,$pLine,$pLevel,$FALSE,$verbal,$skip_DoYouReallySure)."\nDB part remoevd!\n");		
	} else {
		print ("Nothing removed!!\n");
	}
	return @retVal;
}

sub getComponents {
	my ($pLevel, $pInstance, $aLine, $passedVal) = @_;
	my @retVal = ();
	if ($passedVal eq "") {
		@retVal = getComponentNamesFromDB($pLevel, $pInstance, $aLine);
	} else {
		@retVal = split(";",$passedVal);
	}
	if ($FLASE) {
		print("\n            Components\n");     
		displayArrayEnhanced($TRUE,$FALSE,"            -> ","\n",@retVal);
	}
	return @retVal;
}

sub copyConfigEnvParamFileToDB {
	my ($fullEnvName,$verbal) = @_;
	$fullEnvName = setDefault($fullEnvName,$ENV{"CSG_FULL_ENV_NAME"});
	$verbal      = setDefault($verbal,$FALSE);

	my @fullEnvList = ($fullEnvName);
	if ($fullEnvName = "ALL") {
		@fullEnvList = (
			"LHX_A_ET",
			"LHX_B_ET",
			"LHX_C_ET",
			"LHX_A_IT",
			"LHX_B_IT",
			"LHX_D_IT",
			"LHX_A_PT",
			"LHX_B_PT",
			"LHX_C_PT",
			"LHX_A_PR",
		);
	}

	my $countRec    = 0;
	my $errCountRec = 0;
	my $pMappingFileName = $ENV{"CSG_DATA_COMMON"}."/Config_FullInstanceName_Parameters.flt";
	print("Reading from ${pMappingFileName}\n");

	my @recordSet = getAllMatchesFromFltFileAsHashes($pMappingFileName,"","");
	my $configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);

	foreach my $aRec (@recordSet) {
		foreach my $aFullEnv (@fullEnvList) {
			my $aInstName = getInstanceName_FromFullEnvName($aFullEnv);
			my $aLevel    = getLevel_FromFullEnvName($aFullEnv);
			my $aLine     = getLine_FromFullEnvName($aFullEnv);
			my $userId    = getMyUnixUserId();

			if ($verbal) {
				print("HAS_PSO          : ".$aRec->{"PSO"}              ."\n");
				print("Component_Name   : ".$aRec->{"Component-Name"}   ."\n");
				print("SubComponent_Name: ".$aRec->{"SubComponent-Name"}."\n");
				print("Instance         : ".$aInstName                  ."\n");
				print("Level            : ".$aLevel                     ."\n");
				print("Line             : ".$aLine                      ."\n");
				print("UserId           : ".$userId                     ."\n");
				print("Parameter-Name   : ".$aRec->{"Parameter-Name"}   ."\n");
				print("Parameter-Value  : ".$aRec->{$aFullEnv}          ."\n");
				print("\n\n");
			}
			if ($aRec->{"Parameter-Name"} eq "") {
				$errCountRec = $errCountRec + 1;
				print("ERROR in the following record:\n");
				print("HAS_PSO          : ".$aRec->{"PSO"}              ."\n");
				print("Component_Name   : ".$aRec->{"Component-Name"}   ."\n");
				print("SubComponent_Name: ".$aRec->{"SubComponent-Name"}."\n");
				print("Instance         : ".$aInstName                  ."\n");
				print("Level            : ".$aLevel                     ."\n");
				print("Line             : ".$aLine                      ."\n");
				print("UserId           : ".$userId                     ."\n");
				print("Parameter-Name   : ".$aRec->{"Parameter-Name"}   ."\n");
				print("Parameter-Value  : ".$aRec->{$aFullEnv}          ."\n");
				print("\n\n");
			} else {
				my $sth    = $configDB_Handle->prepare("BEGIN cmp_cfg.put_param_value(:P_INST_NAME, :P_LEVEL, :P_LINE, :P_CMP_NAME, :P_SUBCMP_NAME, :P_PARAM_NAME, :P_PARAM_VALUE, :P_HAS_PSO, :P_CHANGED_BY); END;");
				$sth->bind_param(":P_INST_NAME",      $aInstName);
				$sth->bind_param(":P_LEVEL",          $aLevel);
				$sth->bind_param(":P_LINE",           $aLine);
				$sth->bind_param(":P_CMP_NAME",       $aRec->{"Component-Name"});
				$sth->bind_param(":P_SUBCMP_NAME",    $aRec->{"SubComponent-Name"});
				$sth->bind_param(":P_PARAM_NAME",     $aRec->{"Parameter-Name"});
				$sth->bind_param(":P_PARAM_VALUE",    $aRec->{$aFullEnv});
				$sth->bind_param(":P_HAS_PSO",        $aRec->{"PSO"});
				$sth->bind_param(":P_CHANGED_BY",     $userId);
				$sth->execute();
				$countRec = $countRec + 1;
			}
		}
	}

	dbDisconnect($configDB_Handle);
	print("${countRec} record(s) inserted into CMP_CFG_PARAMS_V\n");
	if ($errCountRec > 0) {
		print("ERROR: ${errCountRec} record(s) failed to insert\n");
	}
	return ""
}


sub copyConfigVersionMappingFileToDB {
	my ($interactiv,$verbal) = @_;
	$interactiv = setDefault($interactiv,$TRUE);
	$verbal     = setDefault($verbal,$FALSE);

	my $countRec    = 0;
	my $errCountRec = 0;
	my $answer      = "Y";

	my $pMappingFileName = $ENV{"CSG_DATA_COMMON"}."/Config_Version_Mappimg.flt";
	print("Reading from ${pMappingFileName}\n");
	
	my @recordSet = getAllMatchesFromFltFileAsHashes($pMappingFileName,"","");
	my $configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);

	foreach my $aRec (@recordSet) {
		my $userId    = getMyUnixUserId();
		if (($aRec->{"Component-Name"} eq "") || ($aRec->{"SubComponent-Name"} eq "")) {
			$errCountRec = $errCountRec + 1;
			print("ERROR in the following record:\n");
			print("Component_Name   : ".$aRec->{"Component-Name"}   ."\n");
			print("SubComponent_Name: ".$aRec->{"SubComponent-Name"}."\n");
			print("Code_Version     : ".$aRec->{"Code_Version"}     ."\n");
			print("Conf_Type        : ".$aRec->{"Conf_Type"}        ."\n");
			print("Conf_Name        : ".$aRec->{"Conf_Name"}        ."\n");
			print("Conf_Version     : ".$aRec->{"Conf_Version"}     ."\n");
			print("Post_Fetch_Action: ".$aRec->{"Post_Fetch_Action"}."\n");
			print("\n\n");
		} else {
			if (($verbal) || ($interactiv)) {
				print("Component_Name   : ".$aRec->{"Component-Name"}   ."\n");
				print("SubComponent_Name: ".$aRec->{"SubComponent-Name"}."\n");
				print("Code_Version     : ".$aRec->{"Code_Version"}     ."\n");
				print("Conf_Type        : ".$aRec->{"Conf_Type"}        ."\n");
				print("Conf_Name        : ".$aRec->{"Conf_Name"}        ."\n");
				print("Conf_Version     : ".$aRec->{"Conf_Version"}     ."\n");
				print("Post_Fetch_Action: ".$aRec->{"Post_Fetch_Action"}."\n");
				print("\n\n");
				if ($interactiv) {
					$answer = readln("Load this record","Y");
				}
			}
			if ($answer eq "Y") {
				my $sth    = $configDB_Handle->prepare("BEGIN cmp_cfg.put_cfg_version(:P_CMP_NAME, :P_SUBCMP_NAME, :P_CODE_VERSION, :P_CFG_TYPE, :P_CFG_NAME, :P_POST_FETCH_ACTION, :P_CONF_VERSION, :P_CHANGED_BY); END;");
				$sth->bind_param(":P_CMP_NAME",          $aRec->{"Component-Name"});
				$sth->bind_param(":P_SUBCMP_NAME",       $aRec->{"SubComponent-Name"});
				$sth->bind_param(":P_CODE_VERSION",      $aRec->{"Code_Version"});
				$sth->bind_param(":P_CFG_TYPE",          $aRec->{"Conf_Type"});
				$sth->bind_param(":P_CFG_NAME",          $aRec->{"Conf_Name"});
				$sth->bind_param(":P_POST_FETCH_ACTION", $aRec->{"Post_Fetch_Action"});
				$sth->bind_param(":P_CONF_VERSION",      $aRec->{"Conf_Version"});
				$sth->bind_param(":P_CHANGED_BY",        $userId);
				$sth->execute();
				$countRec = $countRec + 1;
			}
		}
	}

	dbDisconnect($configDB_Handle);
	print("${countRec} record(s) inserted into CMP_CFG_VERSIONS_V\n");
	if ($errCountRec > 0) {
		print("ERROR: ${errCountRec} record(s) failed to insert\n");
	}
	return ""
}

# execPerlFct doTest_lhGetEnvParameterValue lhGetEnvParameterValue 1
sub doTest_lhGetEnvParameterValue {
	my($myFullName,$debugThisFct) = @_;
	$debugThisFct = setDefault($debugThisFct,$FALSE);   
   
 	my @testCaseList = ("TC_A_01", "TC_A_02","TC_A_03","TC_A_04","TC_A_05","TC_A_06","TC_A_07","TC_A_08","TC_A_09");
	## my @testCaseList = ("TC_A_02"); 

	foreach my $testCaseName (@testCaseList) {
		my ($compName,$subCompName,$fullEnvName,$paramName,$expextedResult,$notFoundStr) = get_lhParameterValue_TestCase($testCaseName,$debugThisFct);
		if ($debugThisFct) {
			print("In doTest_lhGetEnvParameterValue::Test_Case:${testCaseName}:\n");
			print("  Test-Case Paramenters:\n");
			print("       compName:${compName}:\n");
			print("       subCompName:${subCompName}:\n");
			print("       fullEnvName:${fullEnvName}:\n");
			print("       paramName:${paramName}:\n");
			print("       expextedResult:${expextedResult}:\n");
			print("       notFoundStr:${notFoundStr}:\n\n");
		}
		if (lhGetEnvParameterValue($compName,$subCompName,$paramName,$fullEnvName,$notFoundStr,$debugThisFct) ne $expextedResult) {
			print("\n+++++++++++++++++++++++++++++++++++++++ START_ERROR LOG (${testCaseName}) +++++++++++++++++++++++++++++++++++++++\n");
			print("ERROR: ${myFullName} failed (${testCaseName})\n");
			print("lhGetEnvParameterValue ${compName} ${subCompName} ${paramName} ${fullEnvName} \"${notFoundStr}\" \"\" 1\n");
			print("lhGetEnvParameterValue(\"${compName}\",\"${subCompName}\",\"${paramName}\",\"${fullEnvName}\") = :".lhGetEnvParameterValue($compName,$subCompName,$paramName,$fullEnvName,$notFoundStr,$debugThisFct).":\nExpected:${expextedResult}:\n");
			print("+++++++++++++++++++++++++++++++++++++++++ END_ERROR LOG (${testCaseName})   +++++++++++++++++++++++++++++++++++++++\n\n");
		}
	}  
}

sub lhGetEnvParameterValueDetailedParameter {
	my ($pComponentName, $pSubComponentName, $pParameterName, $pLocation, $pInstance, $pLine, $pLevel, $pNotFound, $verbal) = @_;
	$pLevel    = setDefault($pLevel,    $ENV{"CSG_LEVEL"});
	$pInstance = setDefault($pInstance, $ENV{"CSG_INSTANCE"});
	$pLine     = setDefault($pLine,     $ENV{"CSG_LINE"});
	if ($verbal) { print("lhGetEnvParameterValueDetailedParameter:\n   pComponentName:${pComponentName}:\n   pSubComponentName:${pSubComponentName}:\n   pParameterName:${pParameterName}:\n   pLocation:${pLocation}:\n   pInstance:${pInstance}:\n   pLine:${pLine}:\n   pLevel:${pLevel}:\n   pNotFound:${pNotFound}:\n   placeHolderNotFoundstr:${placeHolderNotFoundstr}:\n\n"); }
	return lhGetEnvParameterValue($pComponentName, $pSubComponentName, $pParameterName, "${pInstance}_${pLine}_${pLevel}", $pNotFound, $verbal);
}

sub lhGetEnvParameterValue {
	my ($pComponentName, $pSubComponentName, $pParameterName, $pFullEnvName, $pNotFound, $verbal) = @_;
	$pFullEnvName         = setDefault($pFullEnvName,         $ENV{"CSG_FULL_ENV_NAME"});
	$pNotFound            = setDefault($pNotFound,            $placeHolderNotFoundstr);
	if ($verbal) { print("In lhGetEnvParameterValue:\n   pComponentName:${pComponentName}:\n   pSubComponentName:${pSubComponentName}:\n   pParameterName:${pParameterName}:\n   pFullEnvName:${pFullEnvName}:\n   pNotFound:${pNotFound}:\n   placeHolderNotFoundstr:${placeHolderNotFoundstr}:\n\n"); }

	my  $retVal =  $pNotFound;
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,""   ,""   ,""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, ""                , $pParameterName, alterFullEnv($pFullEnvName,""   ,""   ,""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,""   ,""   ,""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , ""                , $pParameterName, alterFullEnv($pFullEnvName,""   ,""   ,""   ), $pNotFound, $verbal); }

	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,""   ,""   ,"ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, ""                , $pParameterName, alterFullEnv($pFullEnvName,""   ,""   ,"ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,""   ,""   ,"ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , ""                , $pParameterName, alterFullEnv($pFullEnvName,""   ,""   ,"ALL"), $pNotFound, $verbal); }

	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,""   ,"ALL",""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, ""                , $pParameterName, alterFullEnv($pFullEnvName,""   ,"ALL",""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,""   ,"ALL",""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , ""                , $pParameterName, alterFullEnv($pFullEnvName,""   ,"ALL",""   ), $pNotFound, $verbal); }

	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,""   ,"ALL","ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, ""                , $pParameterName, alterFullEnv($pFullEnvName,""   ,"ALL","ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,""   ,"ALL","ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , ""                , $pParameterName, alterFullEnv($pFullEnvName,""   ,"ALL","ALL"), $pNotFound, $verbal); }

	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,"ALL",""   ,""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, ""                , $pParameterName, alterFullEnv($pFullEnvName,"ALL",""   ,""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,"ALL",""   ,""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , ""                , $pParameterName, alterFullEnv($pFullEnvName,"ALL",""   ,""   ), $pNotFound, $verbal); }

	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,"ALL",""   ,"ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, ""                , $pParameterName, alterFullEnv($pFullEnvName,"ALL",""   ,"ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,"ALL",""   ,"ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , ""                , $pParameterName, alterFullEnv($pFullEnvName,"ALL",""   ,"ALL"), $pNotFound, $verbal); }

	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,"ALL","ALL",""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, ""                , $pParameterName, alterFullEnv($pFullEnvName,"ALL","ALL",""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,"ALL","ALL",""   ), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , ""                , $pParameterName, alterFullEnv($pFullEnvName,"ALL","ALL",""   ), $pNotFound, $verbal); }

	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,"ALL","ALL","ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact($pComponentName, ""                , $pParameterName, alterFullEnv($pFullEnvName,"ALL","ALL","ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , $pSubComponentName, $pParameterName, alterFullEnv($pFullEnvName,"ALL","ALL","ALL"), $pNotFound, $verbal); }
	if ($retVal eq $pNotFound) { $retVal = lhGetEnvParameterValueExact(""             , ""                , $pParameterName, alterFullEnv($pFullEnvName,"ALL","ALL","ALL"), $pNotFound, $verbal); }

	return $retVal;
}

sub lhGetEnvParameterValueExact {
	my ($pComponentName, $pSubComponentName, $pParameterName, $pFullEnvName, $pNotFound, $verbal) = @_;
	$pFullEnvName         = setDefault($pFullEnvName,         $ENV{"CSG_FULL_ENV_NAME"});
	$pComponentName       = setDefault($pComponentName,       "ALL");
	$pSubComponentName    = setDefault($pSubComponentName,    "ALL");
	$pNotFound            = setDefault($pNotFound,            $placeHolderNotFoundstr);
	$verbal               = setDefault($verbal,               $FALSE);
	
	if ($verbal) { 
		print("\nIn lhGetEnvParameterValueExact");
		print("--> pFullEnvName      :${pFullEnvName}:\n");
		print("--> pComponentName    :${pComponentName}:\n");
		print("--> pSubComponentName :${pSubComponentName}:\n");
		print("--> pParameterName    :${pParameterName}:\n");
	}

	my $locWhereClause = "";
	$exitCode_lhGetEnvParameterValue = 0;
	
	if ($configDB_Handle eq "") {
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	my $retVal = "";
	my @recordSet = ();

	my $aInstName = getInstanceName_FromFullEnvName($pFullEnvName);
	my $aLevel    = getLevel_FromFullEnvName($pFullEnvName);
	my $aLine     = getLine_FromFullEnvName($pFullEnvName);

	my $sql = qq {
		select
			PARAM_VALUE ${pFullEnvName}
		from
			CMP_CFG_PARAMS_V
		where
			    CMP_NAME       = '${pComponentName}'      
			and SUBCMP_NAME    = '${pSubComponentName}'   
			and PARAM_NAME     = '${pParameterName}'
			and INST_NAME      = '${aInstName}'
			and LEVEL_NAME     = '${aLevel}'
			and LINE_NAME      = '${aLine}'
	};
	if ($verbal) { print("---> ${configDB_Username}/${configDB_Password}\@${configDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $configDB_Handle->prepare($sql);
	@recordSet   = dbExecutePreparedSelectSttmnt($prepared_sql);
	foreach my $aRec (@recordSet) {
		if ($verbal) {
			print("--> ".$aRec->{"${pFullEnvName}"}."\n");
		}
	}

	my $resCount = @recordSet;
	if ($resCount > 1) {
		if ($verbal) { print("WARNING: Multiple entries (${resCount}) found for (${locWhereClause})\n"); }
		$exitCode_lhGetEnvParameterValue = 1;
		$retVal = $pNotFound;
	} elsif ($resCount < 1) {
		if ($verbal) { print("WARNING: No entry found for (${locWhereClause})\n"); }
		$exitCode_lhGetEnvParameterValue = 2;
		$retVal = $pNotFound;
	} else {
		my $aRecord = $recordSet[0];
		if ($verbal) { displayHashTableRef($aRecord);print("\n\n"); }
		if (exists($aRecord->{$pFullEnvName})) {
			$retVal = $aRecord->{$pFullEnvName};
		} else {
			$retVal = $pNotFound;
			$exitCode_lhGetEnvParameterValue = 3;
		}
	}
	# print("\n\n");
	return $retVal;
}


sub doTest_lhGetEnvParameterNameValues {
	my($myFullName,$debugThisFct) = @_;
	$debugThisFct = setDefault($debugThisFct,    $FALSE);   
	$pFullEnvName = setDefault($pFullEnvName,    $ENV{"CSG_FULL_ENV_NAME"});

	if ($debugThisFct) {
		# my $verbal = $debugThisFct;
		displayHashTableFormated("\nExact"    , "  ", "", "  ", "", "", $TRUE, $FALSE, "", lhGetEnvParameterNameValuesExact("gmm", $pSubComponentName, $pFullEnvName, $verbal)); 
		displayHashTableFormated("\nNot Exact", "  ", "", "  ", "", "", $TRUE, $FALSE, "", lhGetEnvParameterNameValues     ("gmm", $pSubComponentName, $pFullEnvName, "*****", $verbal));
		displayHashTableFormated("\nNot Exact", "  ", "", "  ", "", "", $TRUE, $FALSE, "", lhGetEnvParameterNameValues     ("gmm", $pSubComponentName, $pFullEnvName, "*----", $verbal)); 		
	}
}


sub lhGetEnvParameterNameValues {
	my ($pComponentName, $pSubComponentName, $pFullEnvName, $pDefaultMask, $verbal) = @_;
	$pFullEnvName         = setDefault($pFullEnvName,         $ENV{"CSG_FULL_ENV_NAME"});
	$pComponentName       = setDefault($pComponentName,       "ALL");
	$pSubComponentName    = setDefault($pSubComponentName,    "ALL");
	$pDefaultMask         = setDefault($pDefaultMask,         "*****");
	$verbal               = setDefault($verbal,               $FALSE);

	if ($verbal) { print("  ======> lhGetEnvParameterNameValues: pDefaultMask:${pDefaultMask}:    pNotFound:${pNotFound}:    placeHolderNotFoundstr:${placeHolderNotFoundstr}:\n"); }

	my %tmpHash = ();
	my %retHash = ();
	if (checkMask("-----",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, $pSubComponentName, alterFullEnv($pFullEnvName,""   ,""   ,""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"00:lhGetEnvParameterNameValues"); }
	if (checkMask("-*---",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, ""                , alterFullEnv($pFullEnvName,""   ,""   ,""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"01:lhGetEnvParameterNameValues"); }
	if (checkMask("*----",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , $pSubComponentName, alterFullEnv($pFullEnvName,""   ,""   ,""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"02:lhGetEnvParameterNameValues"); }
	if (checkMask("**---",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , ""                , alterFullEnv($pFullEnvName,""   ,""   ,""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"03:lhGetEnvParameterNameValues"); }

	if (checkMask("----*",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, $pSubComponentName, alterFullEnv($pFullEnvName,""   ,""   ,"ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"04:lhGetEnvParameterNameValues"); }
	if (checkMask("-*--*",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, ""                , alterFullEnv($pFullEnvName,""   ,""   ,"ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"05:lhGetEnvParameterNameValues"); }
	if (checkMask("*---*",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , $pSubComponentName, alterFullEnv($pFullEnvName,""   ,""   ,"ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"06:lhGetEnvParameterNameValues"); }
	if (checkMask("**--*",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , ""                , alterFullEnv($pFullEnvName,""   ,""   ,"ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"07:lhGetEnvParameterNameValues"); }

	if (checkMask("---*-",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, $pSubComponentName, alterFullEnv($pFullEnvName,""   ,"ALL",""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"08:lhGetEnvParameterNameValues"); }
	if (checkMask("-*-*-",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, ""                , alterFullEnv($pFullEnvName,""   ,"ALL",""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"09:lhGetEnvParameterNameValues"); }
	if (checkMask("*--*-",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , $pSubComponentName, alterFullEnv($pFullEnvName,""   ,"ALL",""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"10:lhGetEnvParameterNameValues"); }
	if (checkMask("**-*-",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , ""                , alterFullEnv($pFullEnvName,""   ,"ALL",""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"11:lhGetEnvParameterNameValues"); }

	if (checkMask("---**",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, $pSubComponentName, alterFullEnv($pFullEnvName,""   ,"ALL","ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"12:lhGetEnvParameterNameValues"); }
	if (checkMask("-*-**",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, ""                , alterFullEnv($pFullEnvName,""   ,"ALL","ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"13:lhGetEnvParameterNameValues"); }
	if (checkMask("*--**",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , $pSubComponentName, alterFullEnv($pFullEnvName,""   ,"ALL","ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"14:lhGetEnvParameterNameValues"); }
	if (checkMask("**-**",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , ""                , alterFullEnv($pFullEnvName,""   ,"ALL","ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"15:lhGetEnvParameterNameValues"); }

	if (checkMask("--*--",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, $pSubComponentName, alterFullEnv($pFullEnvName,"ALL",""   ,""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"16:lhGetEnvParameterNameValues"); }
	if (checkMask("-**--",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, ""                , alterFullEnv($pFullEnvName,"ALL",""   ,""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"17:lhGetEnvParameterNameValues"); }
	if (checkMask("*-*--",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , $pSubComponentName, alterFullEnv($pFullEnvName,"ALL",""   ,""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"18:lhGetEnvParameterNameValues"); }
	if (checkMask("***--",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , ""                , alterFullEnv($pFullEnvName,"ALL",""   ,""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"19:lhGetEnvParameterNameValues"); }

	if (checkMask("--*-*",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, $pSubComponentName, alterFullEnv($pFullEnvName,"ALL",""   ,"ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"20:lhGetEnvParameterNameValues"); }
	if (checkMask("-**-*",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, ""                , alterFullEnv($pFullEnvName,"ALL",""   ,"ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"21:lhGetEnvParameterNameValues"); }
	if (checkMask("*-*-*",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , $pSubComponentName, alterFullEnv($pFullEnvName,"ALL",""   ,"ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"22:lhGetEnvParameterNameValues"); }
	if (checkMask("***-*",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , ""                , alterFullEnv($pFullEnvName,"ALL",""   ,"ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"23:lhGetEnvParameterNameValues"); }

	if (checkMask("--**-",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, $pSubComponentName, alterFullEnv($pFullEnvName,"ALL","ALL",""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"24:lhGetEnvParameterNameValues"); }
	if (checkMask("-***-",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, ""                , alterFullEnv($pFullEnvName,"ALL","ALL",""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"25:lhGetEnvParameterNameValues"); }
	if (checkMask("*-**-",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , $pSubComponentName, alterFullEnv($pFullEnvName,"ALL","ALL",""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"26:lhGetEnvParameterNameValues"); }
	if (checkMask("****-",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , ""                , alterFullEnv($pFullEnvName,"ALL","ALL",""   ), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"27:lhGetEnvParameterNameValues"); }

	if (checkMask("--***",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, $pSubComponentName, alterFullEnv($pFullEnvName,"ALL","ALL","ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"28:lhGetEnvParameterNameValues"); }
	if (checkMask("-****",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact($pComponentName, ""                , alterFullEnv($pFullEnvName,"ALL","ALL","ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"29:lhGetEnvParameterNameValues"); }
	if (checkMask("*-***",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , $pSubComponentName, alterFullEnv($pFullEnvName,"ALL","ALL","ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"30:lhGetEnvParameterNameValues"); }
	if (checkMask("*****",$pDefaultMask)) { %tmpHash = lhGetEnvParameterNameValuesExact(""             , ""                , alterFullEnv($pFullEnvName,"ALL","ALL","ALL"), $verbal); %retHash = addNewKey_ValuesIfKeyIsNotAlreadyThere(\%retHash,\%tmpHash,"",$verbal,"31:lhGetEnvParameterNameValues"); }

	return %retHash;
}

sub lhGetEnvParameterNameValuesExact {
	my ($pComponentName, $pSubComponentName, $pFullEnvName, $verbal) = @_;
	$pFullEnvName         = setDefault($pFullEnvName,         $ENV{"CSG_FULL_ENV_NAME"});
	$pComponentName       = setDefault($pComponentName,       "ALL");
	$pSubComponentName    = setDefault($pSubComponentName,    "ALL");
	$verbal               = setDefault($verbal,               $FALSE);

	if ($verbal) { 
		print("In lhGetEnvParameterNameValueExacts");
		print("--> pFullEnvName      :${pFullEnvName}:\n");
		print("--> pComponentName    :${pComponentName}:\n");
		print("--> pSubComponentName :${pSubComponentName}:\n");
	}

	if ($configDB_Handle eq "") {
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	my $aInstName = getInstanceName_FromFullEnvName($pFullEnvName);
	my $aLevel    = getLevel_FromFullEnvName       ($pFullEnvName);
	my $aLine     = getLine_FromFullEnvName        ($pFullEnvName);

	my $sql = qq {
		select
			PARAM_NAME  PARAM_NAME,
			PARAM_VALUE ${pFullEnvName}
		from
			CMP_CFG_PARAMS_V
		where
			    CMP_NAME       = '${pComponentName}'      
			and SUBCMP_NAME    = '${pSubComponentName}'   
			and INST_NAME      = '${aInstName}'
			and LEVEL_NAME     = '${aLevel}'
			and LINE_NAME      = '${aLine}'
	};
	if ($verbal) { print("---> ${configDB_Username}/${configDB_Password}\@${configDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $configDB_Handle->prepare($sql);
	my @recordSet = dbExecutePreparedSelectSttmnt($prepared_sql);
	my %retHash = ();
	foreach my $aRecord (@recordSet) {
		%retHash = (%retHash,($aRecord->{"PARAM_NAME"},$aRecord->{$pFullEnvName}));
	}
	return %retHash;
}

sub lhGetEnvParameterValueAsHash {
	my ($pComponentName, $pSubComponentName, $pFullEnvName, $doExact, $defaultMask, $pNotFound, $verbal) = @_;
	$pFullEnvName         = setDefault($pFullEnvName,         $ENV{"CSG_FULL_ENV_NAME"});
	$doExact              = setDefault($doExact,              $TRUE);
	$defaultMask          = setDefault($defaultMask,          "*****");
	$pNotFound            = setDefault($pNotFound,            $placeHolderNotFoundstr);
	$verbal               = setDefault($verbal,               $FALSE);

	my %retHash = ();
	if ($verbal) { print("==> lhGetEnvParameterValueAsHash(pComponentName:${pComponentName}, pSubComponentName:${pSubComponentName}, pFullEnvName:${pFullEnvName}, doExact:${doExact}, defaultMask:${defaultMask}):\n"); }
	if ($doExact) {
		if ($verbal) { print("    DO EXACT!!!\n"); }
		%retHash = lhGetEnvParameterNameValuesExact($pComponentName, $pSubComponentName, $pFullEnvName, $verbal);
	} else {
		if ($verbal) { print("    DO not EXACT!!!\n"); }
		%retHash = lhGetEnvParameterNameValues($pComponentName, $pSubComponentName, $pFullEnvName, $defaultMask, $verbal);
	}
	if ($verbal) { displayHashTableFormated("\nName-Values found:"    , "  ", "", "  ", "", "", $TRUE, $FALSE, "", %retHash); print("\n"); }
	return %retHash;
}

sub getComponentsInStore {
	my ($pComponentName) = @_;
	if ($inInteractivMode) {
		$pComponentName = readlnWithHelp("Component-Name ","","If you leave it empty, it lists all components");
		print("\n");
	}
	my @retVal = ();
	my $oldInteractiveState = $inInteractivMode;
	$inInteractivMode = $FALSE;
	@retVal = concatArrayOptimized(@retVal,getComponentsInStores($pComponentName, $ENV{CSG_LEVEL}));
	$inInteractivMode = $oldInteractiveState;
	return @retVal;
}

sub getListOfUsersDefinedInArtifactStore {
	my ($pFilter, $pOrderBy) = @_;
	$pOrderBy = setDefault($pOrderBy, "PID");

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT
			PID             PID,
			FIRST_NAME      FIRST_NAME,
			MIDDLE_NAME     MIDDLE_NAME,
			LAST_NAME       LAST_NAME,
			EMAIL           EMAIL
		FROM
			USERS 
		WHERE IS_ACTIVE='Y' ${pFilter}
		ORDER BY ${pOrderBy} 
	};
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my @retVal       =  ();
	foreach my $aRecord (@recordSet) {
		push(@retVal,$aRecord->{"PID"}."  :  ".padString(strip($aRecord->{"FIRST_NAME"}).":".strip($aRecord->{"MIDDLE_NAME"}),-30)."  :  ".padString(strip($aRecord->{"LAST_NAME"}),-30)."  :   ".$aRecord->{"EMAIL"}.":");
		# if (strip($aRecord->{"FIRST_NAME"}) ne "") {
			# if (strip($aRecord->{"MIDDLE_NAME"}) ne "") {
				# push(@retVal,$aRecord->{"LAST_NAME"}.",".strip($aRecord->{"FIRST_NAME"})." ".strip($aRecord->{"MIDDLE_NAME"}));
			# } else {
				# push(@retVal,$aRecord->{"LAST_NAME"}.",".strip($aRecord->{"FIRST_NAME"}));
			# }
		# } else {
			# push(@retVal,$aRecord->{"LAST_NAME"});
		# }
	}
	return @retVal;
}

sub selectUser {
	my($filter, $filterPrompt, $menuTitle, $verbal) = @_;
	$filterPrompt        = setDefault($filterPrompt,     "Regular-expression filter for users");
	$menuTitle           = setDefault($menuTitle,        "List of defined users");
	$verbal              = setDefault($verbal,           $FALSE);
	if ($filter eq "") { $filter    = readln($filterPrompt,".+"); }

	my @tmpArray_1  = getListOfUsersDefinedInArtifactStore(" AND PID='".getLoggingUser($FALSE)."'","LAST_NAME");
	my @tmpArray_2  = getListOfUsersDefinedInArtifactStore("","LAST_NAME");
	my @tmpArray    = (@tmpArray_1,@tmpArray_2);

	my $usersFullName  = $tmpArray[createAsciiMenuExtended("",$menuTitle,"  Select",1,"N",5,"",@tmpArray)-1];
	$usersFullName = stripFieldsFromString(":",$usersFullName);
	return $usersFullName;
}

sub getComponentsInArtifactStore {
	my($filter,$onlyCmpNames) = @_;
	$filter        = setDefault($filter,       ".+");
	$onlyCmpNames  = setDefault($onlyCmpNames, $TRUE);
	
	my $oldInteractiveState = $inInteractivMode;
	$inInteractivMode = $FALSE;

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT DISTINCT
			CMP_ID    CMP_ID,
			CMP_NAME  CMP_NAME,
			ARTF_ID   ARTF_ID,
			VERSION   VERSION
		FROM
			CMP_VERSIONS_V
		ORDER BY CMP_NAME, release.version_to_num(VERSION) DESC 
	};
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my @retVal       =  ();
	foreach my $aRecord (@recordSet) {
		my $cmpName = $aRecord->{"CMP_NAME"};
		if ($cmpName =~ /$filter/) {
			if ($onlyCmpNames) {
				push(@retVal,$aRecord->{"CMP_NAME"});
			} else {
				push(@retVal,$aRecord);
			}
		}
	}
	if ($onlyCmpNames) {
		@retVal =  makeArrayEntriesDistinct($TRUE,@retVal); 
	}
	$inInteractivMode = $oldInteractiveState;
	return @retVal;
}

sub getCandidatesToDeleteInArtifactStore {
	my($filter,$onlyCmpNames) = @_;
	$filter        = setDefault($filter,       ".+");
	$onlyCmpNames  = setDefault($onlyCmpNames, $TRUE);
	
	my $oldInteractiveState = $inInteractivMode;
	$inInteractivMode = $FALSE;

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT DISTINCT
			CMP_ID    CMP_ID,
			CMP_NAME  CMP_NAME,
			ARTF_ID   ARTF_ID,
			VERSION   VERSION
		FROM
			REL_NOT_USED_ARTF_V
		ORDER BY CMP_NAME, release.version_to_num(VERSION) DESC
	};
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my @retVal       =  ();
	foreach my $aRecord (@recordSet) {
		my $cmpName = $aRecord->{"CMP_NAME"};
		if ($cmpName =~ /$filter/) {
			if ($onlyCmpNames) {
				push(@retVal,$aRecord->{"CMP_NAME"});
			} else {
				push(@retVal,$aRecord);
			}
		}
	}
	if ($onlyCmpNames) {
		@retVal =  makeArrayEntriesDistinct($TRUE,@retVal); 
	}
	$inInteractivMode = $oldInteractiveState;
	return @retVal;
}

sub getComponentVersionsInArtifactStore {
	my ($pComponentName) = @_;

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT DISTINCT
			VERSION VERSION
		FROM
			CMP_VERSIONS_V
		WHERE CMP_NAME = '${pComponentName}'
		ORDER BY release.version_to_num(VERSION) DESC
	};
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my @retVal       =  ();
	foreach my $aRecord (@recordSet) {
		push(@retVal,$aRecord->{"VERSION"});
	}
	return @retVal;
}

sub getComponentID {
	my ($pComponentName, $verbal) = @_;
	$verbal = setDefault($verbal, $FALSE);

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT
			ID ID
		FROM
			COMPONENTS
		WHERE 
		     NAME = '${pComponentName}'
	};
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my $retStr       =  "";
	foreach my $aRecord (@recordSet) {
		$retStr = $retStr.$aRecord->{"ID"};
	}
	return $retStr;
}

sub getArtifactID {
	my ($pComponentName, $pComponentVersion, $verbal) = @_;
	$verbal = setDefault($verbal, $FALSE);

	if ($releaseDB_Handle eq "") {
		$releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	my $splitChr = "\\.";
	my($verMajor,$verMinor,$verPatch,$verBuild) = split($splitChr,$pComponentVersion);
	if ($verbal) { print("${pComponentVersion} --> verMajor:${verMajor}: verMinor:${verMinor}: verPatch:${verPatch}: verBuild:${verBuild}:\n"); }

	my $cmpID = getComponentID($pComponentName);
	
	my $sql = qq {
		SELECT
			ID          ID
		FROM
			ARTIFACTS
		WHERE
			    CMP_ID          = ${cmpID}
			AND VER_MAJOR       = ${verMajor}
			AND VER_MINOR       = ${verMinor}
			AND VER_PATCH       = ${verPatch}
			AND VER_BUILD       = ${verBuild}
	};

	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my $retStr       =  "";
	foreach my $aRecord (@recordSet) {
		$retStr = $retStr.$aRecord->{"ID"};
	}
	return $retStr;
}

sub deleteArtifactBycompVersion {
	my ($compName, $compVersion, $simulate, $verbal, $skip_DoYouReallySure) = @_;
	$simulate                = setDefault($simulate,                $TRUE);
	$verbal                  = setDefault($verbal,                  $FALSE);
	$skip_DoYouReallySure    = setDefault($skip_DoYouReallySure,    $FALSE);
	
	my $retVal = "";
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	print("NOT IMPLEMENTED YET (in csfbPerlLib::deleteArtifactBycompVersion)!\n");
	my $artId = getArtifactID($compName, $compVersion, $verbal);
	if ($artId eq "") {
		$retVal = "No ArtifactID found for ${compName}-${compVersion} in ${releaseDB_Username}/XXXXX\@${releaseDB_DbName}";
	} else {
		$retVal = deleteArtifactByID($artId, $simulate, $verbal, $skip_DoYouReallySure);
	}
	return $retVal;
}

sub deleteArtifactByID {
	my ($artId, $simulate, $verbal, $skip_DoYouReallySure) = @_;
	$simulate                = setDefault($simulate,                $TRUE);
	$verbal                  = setDefault($verbal,                  $FALSE);
	$skip_DoYouReallySure    = setDefault($skip_DoYouReallySure,    $FALSE);
	
	if ($releaseDB_Handle eq "") {
		$releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE);
	}
	
	my $retVal = "";
	
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	
	my $sth = $releaseDB_Handle -> prepare("BEGIN release.delete_artifact(:P_ARTIFACT_ID); END;");
	$sth->bind_param(":P_ARTIFACT_ID",  $artId);
	$sth->execute();
	if ( $sth->err ) {
		$retVal = "ERROR: return code: ". $sth->err . " error msg: " . $sth->errstr . "\n";
	}	
	return $retVal;
}

sub removeAnEnvFromPKGDB {
	my ($pInstance,$pLine,$pLevel,$simulate,$verbal,$skip_DoYouReallySure) = @_;
	$doDeleteFirst           = setDefault($doDeleteFirst,           $FALSE);
	$simulate                = setDefault($simulate,                $TRUE);
	$verbal                  = setDefault($verbal,                  $FALSE);
	$skip_DoYouReallySure    = setDefault($skip_DoYouReallySure,    $FALSE);

	my $releaseDB_HandleErrorDisabled = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$FALSE); # write error msg disabled because I write it myself!
	my $retVal = "";
	
	if ($verbal) { 
		print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\n");
		print("removeAnEnvFromPKGDB::calling stored procedure release.remove_env_and_instance(${pLevel}, ${pInstance}, ${pLine})\n");
	}
	
	my $sth = $releaseDB_HandleErrorDisabled -> prepare("BEGIN release.remove_env_and_instance(:P_LEVEL_NAME, :P_INSTANCE, :P_LINE); END;");
	$sth->bind_param(":P_LEVEL_NAME",  $pLevel);
	$sth->bind_param(":P_INSTANCE"  ,  $pInstance);
	$sth->bind_param(":P_LINE"      ,  $pLine);
	
	$sth->execute();
	if ( $sth->err ) {
		$retVal = "ERROR: return code: ". $sth->err . " error msg: " . $sth->errstr . "\n";
	}
	
	dbDisconnect($releaseDB_HandleErrorDisabled);	
	return $retVal;
}

sub updateActivatedComponentsInPKGDB {
	my ($pInstance,$pLine,$pLevel,$pComponentName,$pCompVersion, $doDeleteFirst, $simulate, $verbal, $skip_DoYouReallySure) = @_;
	$doDeleteFirst           = setDefault($doDeleteFirst,           $FALSE);
	$simulate                = setDefault($simulate,                $TRUE);
	$verbal                  = setDefault($verbal,                  $FALSE);
	$skip_DoYouReallySure    = setDefault($skip_DoYouReallySure,    $FALSE);

	# verify table select * from CURR_FS_ACTIVATIONS;
	my $releaseDB_HandleErrorDisabled = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$FALSE); # write error msg disabled because I write it myself!
	my $retVal = "";
	
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }

	if ($doDeleteFirst) {
		my $sth = $releaseDB_HandleErrorDisabled -> prepare("BEGIN release.delete_fs_activation_imports(:P_LEVEL_NAME); END;");
		$sth->bind_param(":P_LEVEL_NAME",  $pLevel);
		$sth->execute();
		if ( $sth->err ) {
			$retVal = "ERROR: return code: ". $sth->err . " error msg: " . $sth->errstr . "\n";
		}
		print(" ===> Deleted all earlier imported activations for ${pLevel}\n\n"); # halt();
	}
	
	my $sth = $releaseDB_HandleErrorDisabled -> prepare("BEGIN release.insert_activation_from_fs(:P_CMP_NAME, :P_VERSION, :P_LEVEL_NAME, :P_INSTANCE, :P_LINE); END;");
	$sth->bind_param(":P_CMP_NAME"  ,  uc($pComponentName));
	$sth->bind_param(":P_VERSION"   ,  $pCompVersion);
	$sth->bind_param(":P_LEVEL_NAME",  $pLevel);
	$sth->bind_param(":P_INSTANCE"  ,  $pInstance);
	$sth->bind_param(":P_LINE"      ,  $pLine);
	
	$sth->execute();
	if ( $sth->err ) {
		$retVal = "ERROR: return code: ". $sth->err . " error msg: " . $sth->errstr . "\n";
	}
	dbDisconnect($releaseDB_HandleErrorDisabled);	
	return $retVal;
}

sub updateDeployedComponentsInPKGDB {
	my ($pLevel,$pComponentName,$pCompVersion, $doDeleteFirst, $simulate, $verbal, $skip_DoYouReallySure) = @_;
	$doDeleteFirst           = setDefault($doDeleteFirst,           $FALSE);
	$simulate                = setDefault($simulate,                $TRUE);
	$verbal                  = setDefault($verbal,                  $FALSE);
	$skip_DoYouReallySure    = setDefault($skip_DoYouReallySure,    $FALSE);

	# verify table select * from CURR_FS_ACTIVATIONS;
	my $releaseDB_HandleErrorDisabled = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$FALSE); # write error msg disabled because I write it myself!
	my $retVal = "";
	
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }

	if ($doDeleteFirst) {
		my $sth = $releaseDB_HandleErrorDisabled -> prepare("BEGIN release.delete_fs_deployment_imports(:P_LEVEL_NAME); END;");
		$sth->bind_param(":P_LEVEL_NAME",  $pLevel);
		$sth->execute();
		if ( $sth->err ) {
			$retVal = "ERROR: return code: ". $sth->err . " error msg: " . $sth->errstr . "\n";
		}
		print(" ===> Deleted all earlier imported deployments\n\n"); # halt();
	}
	
	my $sth = $releaseDB_HandleErrorDisabled -> prepare("BEGIN release.insert_deployment_from_fs(:P_CMP_NAME, :P_VERSION, :P_LEVEL_NAME); END;");
	$sth->bind_param(":P_CMP_NAME"  ,  uc($pComponentName));
	$sth->bind_param(":P_VERSION"   ,  $pCompVersion);
	$sth->bind_param(":P_LEVEL_NAME",  $pLevel);
	
	$sth->execute();
	if ( $sth->err ) {
		$retVal = "ERROR: return code: ". $sth->err . " error msg: " . $sth->errstr . "\n";
	}
	dbDisconnect($releaseDB_HandleErrorDisabled);	
	return $retVal;
}


sub  getFS_NotUsedDeployments {
	my ($filter, $verbal) = @_;
	$filter  = setDefault($filter, readln("Regular-expression filter for component","^(?!TP_)"));
	$verbal  = setDefault($verbal, $FALSE);
	
	my $oldInteractiveState = $inInteractivMode;
	$inInteractivMode = $FALSE;

	$filter  = uc($filter);
	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $currebtLevel = $ENV{"CSG_LEVEL"};
	
	my $sql = qq {
		SELECT
			ID         ID,
			CMP_NAME   CMP_NAME,
			VERSION    VERSION,
			LEVEL_NAME LEVEL_NAME
		FROM
			fs_not_used_deployments_v
		WHERE
			LEVEL_NAME = '${currebtLevel}'
		ORDER BY LEVEL_NAME, CMP_NAME, release.version_to_num(VERSION) DESC	
	};
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my @retVal       =  ();
	foreach my $aRecord (@recordSet) {
		my $cmpName = $aRecord->{"CMP_NAME"};
		if ($cmpName =~ /$filter/) {
			if ($onlyCmpNames) {
				push(@retVal,$aRecord->{"CMP_NAME"});
			} else {
				push(@retVal,$aRecord);
			}
		}
	}
	if ($onlyCmpNames) {
		@retVal =  makeArrayEntriesDistinct($TRUE,@retVal); 
	}
	$inInteractivMode = $oldInteractiveState;
	return @retVal;
}


sub  getFS_Deployments {
	my ($filter, $verbal) = @_;
	$filter  = setDefault($filter, readln("Regular-expression filter for component","^(?!TP_)"));
	$verbal  = setDefault($verbal, $FALSE);
	
	my $oldInteractiveState = $inInteractivMode;
	$inInteractivMode = $FALSE;

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT
			ID         ID,
			CMP_NAME   CMP_NAME,
			VERSION    VERSION,
			LEVEL_NAME LEVEL_NAME
		FROM
			CURR_FS_DEPLOYMENTS
		ORDER BY LEVEL_NAME, CMP_NAME, release.version_to_num(VERSION) DESC	
	};
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my @retVal       =  ();
	foreach my $aRecord (@recordSet) {
		my $cmpName = $aRecord->{"CMP_NAME"};
		if ($cmpName =~ /$filter/) {
			if ($onlyCmpNames) {
				push(@retVal,$aRecord->{"CMP_NAME"});
			} else {
				push(@retVal,$aRecord);
			}
		}
	}
	if ($onlyCmpNames) {
		@retVal =  makeArrayEntriesDistinct($TRUE,@retVal); 
	}
	$inInteractivMode = $oldInteractiveState;
	return @retVal;
}

sub  getFS_Activations {
	my ($filter, $verbal) = @_;
	$filter  = setDefault($filter, readln("Regular-expression filter for component","^(?!TP_)"));
	$verbal  = setDefault($verbal, $FALSE);
	
	my $oldInteractiveState = $inInteractivMode;
	$inInteractivMode = $FALSE;

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT
			ID         ID,
			CMP_NAME   CMP_NAME,
			VERSION    VERSION,
			LEVEL_NAME LEVEL_NAME,
			INSTANCE   INSTANCE,
			LINE       LINE
		FROM
			CURR_FS_ACTIVATIONS
		ORDER BY LEVEL_NAME, INSTANCE, LINE, CMP_NAME, release.version_to_num(VERSION) DESC	
	};
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my @retVal       =  ();
	foreach my $aRecord (@recordSet) {
		my $cmpName = $aRecord->{"CMP_NAME"};
		if ($cmpName =~ /$filter/) {
			if ($onlyCmpNames) {
				push(@retVal,$aRecord->{"CMP_NAME"});
			} else {
				push(@retVal,$aRecord);
			}
		}
	}
	if ($onlyCmpNames) {
		@retVal =  makeArrayEntriesDistinct($TRUE,@retVal); 
	}
	$inInteractivMode = $oldInteractiveState;
	return @retVal;
}

sub  getReleaseID {
	my ($pReleaseName, $verbal) = @_;
	$verbal = setDefault($verbal, $FALSE);

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT
			ID          ID
		FROM
			RELEASES
		WHERE
			name = '${pReleaseName}'
	};

	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my $retStr       =  "";
	foreach my $aRecord (@recordSet) {
		$retStr = $retStr.$aRecord->{"ID"};
	}
	return $retStr;
}

sub getReleaseStatus {
	my ($pReleaseName, $verbal) = @_;
	$verbal = setDefault($verbal, $FALSE);

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT
			STATUS        STATUS
		FROM
			RELEASEs
		WHERE
			NAME = '${pReleaseName}'
	};
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my $retStr       =  "";
	foreach my $aRecord (@recordSet) {
		$retStr = $aRecord->{"STATUS"};
	}
	return $retStr;
}

sub  getReleaseDetails {
	my ($pReleaseName, $verbal) = @_;
	$verbal = setDefault($verbal, $FALSE);

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT
			CMP_NAME          CMP_NAME,
			VERSION           VERSION
		FROM
			RELEASE_ARTIFACTS_V
		WHERE
			RELEASE_NAME = '${pReleaseName}'
	};

	my %retStr = ();
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my $retStr       =  "";
	foreach my $aRecord (@recordSet) {
		%retStr = (%retStr,($aRecord->{"CMP_NAME"},$aRecord->{"VERSION"}));
	}
	return %retStr;
}

sub  getUserID_FromAtrifactDB {
	my ( $firstName, $lastName, $verbal) = @_;
	$verbal = setDefault($verbal, $FALSE);

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	my $sql = qq {
		SELECT
			PID          ID
		FROM
			USERS
		WHERE
			    FIRST_NAME = '${firstName}'
			AND LAST_NAME  = '${lastName}'
		ORDER BY LAST_NAME, FIRST_NAME
	};

	if ($firstName eq "") {
		$sql = qq {
			SELECT
				PID          ID
			FROM
				USERS
			WHERE
				LAST_NAME  = '${lastName}'
			ORDER BY LAST_NAME, FIRST_NAME
		};
	}
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my $retStr       =  "";
	foreach my $aRecord (@recordSet) {
		$retStr = $retStr.$aRecord->{"ID"};
	}
	return $retStr;
}
 
sub getLevelsForArtifactDeploymentAsStr {
	my ($sepChar) = @_;
	$sepChar          = setDefault($sepChar,         ";");
	return makeStrFromArray($sepChar,getLevelsForArtifactDeployment());
}
 
sub getLevelsForArtifactDeployment {
	my @retList = ();
	if ($releaseDB_Handle eq "") {
		$releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE);
	}
	my $sth = $releaseDB_Handle -> prepare("DECLARE rc sys_refcursor; BEGIN :rc := release.get_levels(); END;");
	my $sth_cursor;
	$sth->bind_param_inout(":rc", \$sth_cursor, 0, {ora_type => ORA_RSET });
	$sth->execute();

	while (my $r = $sth_cursor->fetchrow_hashref) {
		push(@retList,$r->{"LEVEL_NAME"});
	}
	my @sortedRetList = ("ET","IT","PT","PR");
	return getIntersectionOfArrays(\@retList, \@sortedRetList);
}

sub getInstancesForArtifactActivation {
	my ($pLevel) = @_;
	my @retList = ();
	if ($releaseDB_Handle eq "") {
		$releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE);
	}
	my $sth = $releaseDB_Handle -> prepare("DECLARE rc sys_refcursor; BEGIN :rc := release.get_instances(:P_LEVEL); END;");
	my $sth_cursor;
	$sth->bind_param_inout(":rc", \$sth_cursor, 0, {ora_type => ORA_RSET });
	$sth->bind_param(":P_LEVEL" ,  $pLevel);
	$sth->execute();

	while (my $r = $sth_cursor->fetchrow_hashref) {
		push(@retList,$r->{"INSTANCE"});
	}
	return @retList;
}

sub getLinesForArtifactActivation {
	my ($pLevel,$pInstance) = @_;
	my @retList = ();
	if ($releaseDB_Handle eq "") {
		$releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE);
	}
	my $sth = $releaseDB_Handle -> prepare("DECLARE rc sys_refcursor; BEGIN :rc := release.get_lines(:P_LEVEL, :P_INSTANCE); END;");
	my $sth_cursor;
	$sth->bind_param_inout(":rc"  , \$sth_cursor, 0, {ora_type => ORA_RSET });
	$sth->bind_param(":P_LEVEL"   ,  $pLevel);
	$sth->bind_param(":P_INSTANCE",  $pInstance);
	$sth->execute();

	while (my $r = $sth_cursor->fetchrow_hashref) {
		push(@retList,$r->{"LINE"});
	}
	return @retList;
}

sub getEnvironmentsForArtifactActivationAsStr {
	my ($pLevel,$doReturnFullName, $withALL_ALL, $sepChar) = @_;
	$doReturnFullName = setDefault($doReturnFullName,$TRUE);
	$withALL_ALL      = setDefault($withALL_ALL,     $FALSE);
	$sepChar          = setDefault($sepChar,         ";");
	return makeStrFromArray($sepChar,getEnvironmentsForArtifactActivation($pLevel,$doReturnFullName, $withALL_ALL));
}
	
sub getEnvironmentsForArtifactActivation {
	my ($pLevel,$doReturnFullName, $withALL_ALL, $grouped) = @_;
	$doReturnFullName = setDefault($doReturnFullName,$TRUE);
	$withALL_ALL      = setDefault($withALL_ALL,     $FALSE);
	$grouped          = setDefault($grouped,         $FALSE);
	
	my @retList = ();
	my @instances = getInstancesForArtifactActivation($pLevel);

	if ($withALL_ALL) {
		if ($doReturnFullName) {
			push(@retList,"ALL_ALL_${pLevel}");
		} else {
			push(@retList,"ALL_ALL");
		}
	}
	foreach my $aInstance (@instances) {
		my @lines = getLinesForArtifactActivation($pLevel,$aInstance);
		foreach my $aLine (@lines) {
			if ($doReturnFullName) {
				push(@retList,"${aInstance}_${aLine}_${pLevel}");
			} else {
				push(@retList,"${aInstance}_${aLine}");
			}
		}
	}
	
	@retList = (sort @retList);
	
	my @groupedRetList = @retList;
	my @lhxGroup   = ();
	my @lhsGroup   = ();
	my @otherGroup = ();
	
	if ($grouped) {
		foreach my $aInstance (@retList) {
			if (stringStartsWith($aInstance,"LHX_")) {
				push(@lhxGroup,$aInstance);
			} elsif (stringStartsWith($aInstance,"LHS_")) {
				push(@lhsGroup,$aInstance);
			} else {
				push(@otherGroup,$aInstance);
			}
		}
		@groupedRetList = ("# LHX (FX,MM,EUROM):",@lhxGroup,"#","# LHS (SINGAPORE):",@lhsGroup,"#","# COMMON/STAGE:",@otherGroup);
	}
	
	return @groupedRetList;
}

sub getReleasesAsStr {
	my ($regExFilter, $pStatus, $withDetails, $verbal, $sepChar) = @_;
	$regExFilter   = setDefault($regExFilter,".+");
	$pStatus       = setDefault($pStatus,"ALL");
	$withDetails   = setDefault($withDetails,$FALSE);
	$verbal        = setDefault($verbal,$FALSE);
	$sepChar          = setDefault($sepChar,         ";");
	return makeStrFromArray($sepChar,getReleases($regExFilter, $pStatus, $withDetails, $verbal));
}

sub getReleases {
	my ($regExFilter, $pStatus, $withDetails, $verbal) = @_;
	$regExFilter   = setDefault($regExFilter,".+");
	$pStatus       = setDefault($pStatus,"ALL");
	$withDetails   = setDefault($withDetails,$FALSE);
	$verbal        = setDefault($verbal,$FALSE);

	my @retList = ();
	if ($verbal) { print("getReleases::   releaseDB_DbName:${releaseDB_DbName}:   releaseDB_Username:${releaseDB_Username}:   releaseDB_Password:${releaseDB_Password}:\n"); }
	if ($releaseDB_Handle eq "") {
		if ($verbal) { print("getReleases::   connecting DB..."); }
		$releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE);
		if ($verbal) { print("done\n"); }
	}
	my $sth = $releaseDB_Handle -> prepare("DECLARE rc sys_refcursor; BEGIN :rc := release.get_releases(:P_STATUS); END;");
	my $sth_cursor;
	$sth->bind_param_inout(":rc", \$sth_cursor, 0, {ora_type => ORA_RSET });
	my @statusList = split(",",$pStatus);
	foreach my $aStatus (@statusList) {
		if ($verbal) { print("    binding P_STATUS:${aStatus}\n"); }
		$sth->bind_param(":P_STATUS",  $aStatus);
		$sth->execute();

		while (my $r = $sth_cursor->fetchrow_hashref) {
			my $pReleaseName = $r->{"RELEASE_NAME"};
			if (!(foundInArray($pReleaseName,@retList))) {
				if ($withDetails) {
					my $relStatus = getReleaseStatus($pReleaseName);
					push(@retList,$pReleaseName.";".$relStatus);
				} else {
					push(@retList,$pReleaseName);
				}
			}
		}
	}
	return filterArrayWithRegEx($regExFilter,@retList);
}

sub getComponentVersionForRelease {
	my ($pRelease,$verbal) = @_;
	$verbal      = setDefault($verbal,$FALSE);

	if ($verbal) { 
		print("In getComponentVersionForRelease");
		print("--> pRelease      :${pRelease}:\n");
	}

	if ($releaseDB_Handle eq "") {
		$releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	my $sql = qq {
		SELECT
			CMP_NAME          CMP_NAME,
			VERSION           VERSION
		FROM
			RELEASE_ARTIFACTS_V
		WHERE
			RELEASE_NAME       = '${pRelease}' 
	};
	if ($verbal) { print("---> ${configDB_Username}/${configDB_Password}\@${configDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my %retHash      = ();
	foreach my $aRecord (@recordSet) {
		%retHash = (%retHash,($aRecord->{"CMP_NAME"},$aRecord->{"VERSION"}));
	}
	return %retHash;
}

sub getComponentVersionForReleaseSortedByPrio {
	my ($pRelease,$verbal) = @_;
	
	if (!foundInArray($pRelease,  getReleases())) { my $errorMsg = "ERROR: Unknown release:${pRelease}!"; print($errorMsg); return $errorMsg;}
	
	my %compVersions = getComponentVersionForRelease($pRelease);
	my $aStr = makeStrFromHashFormat($TRUE, $TRUE, "-", $entrySep, $FALSE, $keyPadOffset, %compVersions);
	my @compVersionList = split(";",$aStr);
	@compVersionList    = sortComponentsByPriority($verbal, $pRelease, @compVersionList);
	return @compVersionList;
}		

sub getPriorityForComponent {
	my ($releaseName, $compName, $verbal) = @_;
	$verbal      = setDefault($verbal,$FALSE);

	if ($verbal) { 
		print("In getPriorityForComponent");
		print("--> compName      :${compName}:\n");
		print("--> releaseName   :${releaseName}:\n");
	}

	if ($releaseDB_Handle eq "") {
		$releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	my $sql = qq {
		SELECT
			PRIORITY          PRIO
		FROM
			RELEASE_ARTIFACTS_V
		WHERE
			     CMP_NAME       = '${compName}'
			AND RELEASE_NAME    = '${releaseName}'
	};
	if ($verbal) { print("---> ${configDB_Username}/${configDB_Password}\@${configDB_DbName}\nSelect:\n${sql}\n"); }
	my $prepared_sql = $releaseDB_Handle->prepare($sql);
	my @recordSet    = dbExecutePreparedSelectSttmnt($prepared_sql);
	my $retVal       = "";
	foreach my $aRecord (@recordSet) {
		$retVal = $retVal.$aRecord->{"PRIO"};
	}
	if ($verbal) { print("retVal:${retVal}\n"); }
	return $retVal;
}

sub doTest_sortComponentsByPriority {
	my($myFullName,$debugThisFct) = @_;
	$debugThisFct = setDefault($debugThisFct,$FALSE);

	if ($debugThisFct) {
		my $pRelease = menu_selectRelease();
		my @compVersionList = getComponentVersionForReleaseSortedByPrio($pRelease);
		displayArray(@compVersionList);	
	}
}

sub sortComponentsByPriority {
	my ($verbal, $releaseName, @compNameList) = @_;
	$verbal      = setDefault($verbal,$FALSE);

	my %compName_Prio = ();
	foreach my $aCompNameVersion (@compNameList) {
		my $aCompName = getFieldFromString("-",0,$aCompNameVersion,$notFoundStr);
		%compName_Prio = (%compName_Prio,(padString(getPriorityForComponent($releaseName, $aCompName, $verbal),6,"0")."_${aCompNameVersion}",$aCompNameVersion));
	}
	if ($verbal) { print("Hash-Table:\n"); displayHashTable(%compName_Prio); }
	my @keyList = sort keys %compName_Prio;
	if ($verbal) {  print("Sorted-Keys of Hash-Table:\n"); displayArray(@keyList); }

	my @prioList = ();
	foreach my $aKey (@keyList) {
		push(@prioList,$compName_Prio{$aKey});
	}

	if ($verbal) { print("Return-List:\n"); displayArray(@prioList); }
	return @prioList;
}

sub getComponentsInStores {
	my ($pComponentNamePattern, $pLevel) = @_;
	if ($inInteractivMode) {
		if ($pComponentNamePattern eq "") {
			$pComponentNamePattern = readlnWithHelp("Component-Name Pattern","","If you leave it empty, it lists all components");
		}

		if ($pLevel eq "") {
			my @installedLevels = getLevels();
			my $countOfLevels = @installedLevels;
			if ($countOfLevels > 1) {
				$pLevel = readlnWithHelp("Level     ",$ENV{CSG_LEVEL},"If you leave it empty, it lists from all levels");
			} else {
				$pLevel = $ENV{CSG_LEVEL};
			}
		}
		print("\n");
	} else {
		$pLevel = setDefault($pLevel, $ENV{"CSG_LEVEL"});
	}

	my @retListx = ();

	if ($pLevel eq "") {
		foreach $pLevel (getLevels()) {
			#  @retListx = concatArrayOptimized(@retListx,getComponentsInStores($pComponentNamePattern, $pLevel));
		}
	} else {
		my @compDirList = getDirList_UNIX($ENV{"CSG_SHARE_ROOT"}."/".${pLevel}."/code");
		foreach my $dirCompEntry (@compDirList) {
			if (!(stringStartsWith($dirCompEntry,"d"))) {
				next;
			}

			$dirCompEntry = getLastFieldFromString(" ",$dirCompEntry);
			### print("dirCompEntry:${dirCompEntry}:    pComponentNamePattern:${pComponentNamePattern}:\n");
			if (($pComponentNamePattern eq "") || (stringContains($dirCompEntry,$pComponentNamePattern))) {
				
				push(@retListx,$dirCompEntry);
			}
		}
	}
	return (sort @retListx);
}

sub deleteComponentVersionInStore {
	my ($pComponentName, $version, $simulate, $verbal, $skip_DoYouReallySure) = @_;
	$simulate                = setDefault($simulate,                $TRUE);
	$verbal                  = setDefault($verbal,                  $TRUE);
	$skip_DoYouReallySure    = setDefault($skip_DoYouReallySure,    $FALSE);

	my $dirToDelete = $ENV{"CSG_COMPONENT_STORE"}."/${pComponentName}/${version}";
	my @dirList = getDirList_UNIX($dirToDelete);
	if ($verbal) {
		print("In deleteComponentVersionInStore:\n");
		print("pComponentName:${pComponentName}\n");
		print("version       :${version}\n");
		print("simulate      :${simulate}\n");
		print("Directories found:\n");
		displayArray(@dirList);
	}

	my $count = @dirList;
	if ($count > 0) {
		my $answer = "N";
		if (!($skip_DoYouReallySure)) {
			$answer = strip(uc(readln("Are you really sure to delete ${dirToDelete}","N")));
		} else {
			$answer = "Y";
		}
		if (stringStartsWith($answer,"J") || stringStartsWith($answer,"Y")) {
			my $unixCmd = "rm -rf ${dirToDelete}";
			print("Execute ${unixCmd}\n");
			my $msg = "";
			if (!$simulate) {
				$msg =  `${unixCmd} 2>&1`;
			} else {
				$msg = "Simulated only!!";
			}
			return $msg;
		} else {
			return "Nothing deleted!";
		}
	} else {
		return "${dirToDelete} not existing!!!!";
	}
}

sub showComponentVersionsInStore {
	my ($pComponentName, $withTitle, $padStr, $verbal) = @_;
	if ($inInteractivMode) {
		$pComponentName = readlnWithHelp("Component-Name Pattern","","If you leave it empty, it lists all components");
		print("\n");
	} 
	$withTitle            = setDefault($withTitle,           $TRUE);
	$padStr               = setDefault($padStr,              "      ");
	$verbal               = setDefault($verbal,              $FALSE);

	my @retList = ();
	my $oldInteractiveState = $inInteractivMode;
	$inInteractivMode = $FALSE;
	my @compList = getComponentsInStore($pComponentName);
	$inInteractivMode = $oldInteractiveState;
	foreach my $aComponent (@compList) {
		if ($withTitle) {
			push(@retList," --> ${aComponent}");
		}
		my @versionDirList = getDirList_UNIX($ENV{"CSG_COMPONENT_STORE"}."/${aComponent}");
		foreach my $versionEntry (@versionDirList) {
			$versionEntry = getLastFieldFromString(" ",$versionEntry);
			push(@retList,"${padStr}${versionEntry}");
		}
	}
	return @retList;
}


sub showActivatedVersionsForaComponent {
	my ($pComponentName, $doPad, $padOffset, $keyPrefix, $verbal) = @_;
	$verbal = setDefault($verbal, $FALSE);

	my $retString = "";
	my $oldInteractiveState = $inInteractivMode;
	
	$inInteractivMode = $FALSE;
	if ($inInteractivMode) {
		if ($pComponentName eq "") { $pComponentName = readlnWithHelp("Component-Name filter (e.g. lh_)","","If you leave it empty, it lists all components"); print("\n"); }
	} 

	my $aLevel    = $ENV{"CSG_LEVEL"};
	foreach my $anFullInstance (getAllInstalledEnvByFullName(),"COMMON4_ALL_${aLevel}") {
		my $tmpStr = showActivatedVersions($pComponentName, $anFullInstance, $doPad, $padOffset, "${anFullInstance}:", $FALSE);
		if ($tmpStr ne "") {
			$retString = $retString."\n".$tmpStr
		}
	}
	$inInteractivMode = $oldInteractiveState;
	if ($verbal) {
		print("${retString}\n");
	}
	return $retString;
}

sub whichComponentVersionInStoreHaveBeenAltered {
	my ($lastReleaseDate, $componentNames, $pLevel, $withSummary, $withDetailedSummary,$verbal) = @_;
	$lastReleaseDate       = setDefault($lastReleaseDate,     getYYYYMMDD_DaysSince1582(daysSince1582_YMD_str(substr(getTimeStamp(),0,8)) - 10));
	$verbal                = setDefault($verbal,              $FALSE);
	$withSummary           = setDefault($withSummary,         $TRUE);
	$withDetailedSummary   = setDefault($withDetailedSummary, $TRUE);
	$pLevel                = setDefault($pLevel,              $FALSE);
	
	my @basePathList = ();
	my $topBasePath  = "$ENV{CSG_SHARE_ROOT}/${pLevel}/code";
	my $daysInPast   = dayDifference_str2(substr(getTimeStamp(),0,8),$lastReleaseDate);
	@basePathList    = ($topBasePath);
	if ($componentNames ne "") {
		@basePathList = getFieldsFromString(";",$componentNames,$TRUE,"${topBasePath}/");
	}
	
	print("\n".unterstreichen("Looking for change components/files since ".formatTimeStamp($lastReleaseDate, "",$TRUE, $TRUE)." which are ${daysInPast} days back! (can take a while!!)","-"," ",1));
	foreach my $basePath (@basePathList) {
		my $unixCmd  = "cd ${basePath} ; find . -type f -mtime -${daysInPast} -exec ls -l {} \+ 2>&1";     if ($verbal) { print("unixCmd:${unixCmd}\n"); }
		my $retMsg   = `$unixCmd`;
		my @retList  = ();
		my @aDirList = split("\n",$retMsg);
		
		foreach my $anDirEntry (@aDirList) {
			$anDirEntry =~ s/\s+/ /g;
			my $relFileName = getFilenameFromUNIX_DirEntry($anDirEntry);
			$relFileName = $basePath.substr($relFileName,1);
			
			#### To slow with these functions
			# my $lastModDate = getFileLastModify($relFileName);
			# my $lastAccDate = getFileLastAccess($relFileName);
			my $lastModDate = getFileLastModFromUNIX_DirEntry($anDirEntry);
			push(@retList, "${relFileName} ${lastModDate}");
		}
		
		@retList = sort (@retList);
		if ($verbal) { 
			my $countOfLines = @retList;
			displayArray(@retList);
			print("---> Total count differences:${countOfLines}\n");
		}
		
		if ($withSummary) {
			my $prevCompName    = "";
			my $prevCompVersion = "";
			my $prevFileModDate = "";
			my @subDirList      = ();
			my %timeStampHash   = ();
			foreach my $aDirEntry (@retList) {
				my $currentCompName    = getComponentNameFromDirEntry($aDirEntry);
				my $currentCompVersion = getComponentVersionFromDirEntry($aDirEntry);
				my $currModDate        = getFieldFromString(" ",1,$aDirEntry);
				if (($currentCompName ne $prevCompName) ||  ($currentCompVersion ne $prevCompVersion)) {
					if ($withDetailedSummary) { showdirListHidden(@subDirList); }		
					$prevCompName    = $currentCompName;
					$prevCompVersion = $currentCompVersion;
					$prevFileModDate = "";
					@subDirList = ();
					print("${prevCompName} (${prevCompVersion})\n");
				}
				push(@subDirList,$aDirEntry);		
			}
			if ($withDetailedSummary) { showdirListHidden(@subDirList); }
		}
	}
	
	# return @retList;
	return "";
	
	
}

sub showdirListHidden {
	my (@subDirList) = @_;
	my @sortedList = ();
	foreach my $aDirEntryFromSubList (@subDirList) {
		my $currModDate        = getFieldFromString(" ",1,$aDirEntryFromSubList);
		
		push(@sortedList,formatTimeStamp(${currModDate}, "", $FALSE, $FALSE) ." : " . getFileNameOutOfFullName(getFieldFromString(" ",0,$aDirEntryFromSubList)));
	}
	@sortedList = sort (@sortedList);
	
	my $countOfItems = @sortedList;
	# print("Sub-Liste of changed files (${countOfItems})\n");
	# displayArray(@sortedList);
	
	if ($countOfItems > 1) {
		my $firstDate = getFieldFromString(" ",0,$sortedList[0]). " " . getFieldFromString(" ",1,$sortedList[0]);
		my $lastDate  = getFieldFromString(" ",0,$sortedList[$countOfItems - 1]). " " . getFieldFromString(" ",1,$sortedList[$countOfItems - 1]);
		if ($firstDate ne $lastDate) {
			foreach my $aSortedEntry (@sortedList) {
				print("     ". $aSortedEntry . "\n");
			}
		} else {
			print("    ---> Component has been fully release at ".getFieldFromString(" ",0,$sortedList[0]). " " . getFieldFromString(" ",1,$sortedList[0])."\n");
		}
		# print("    ------> ".$sortedList[0].  "    firstDate:${firstDate}:\n");
		# print("    ------> ".$sortedList[$countOfItems - 1].  "    lastDate:${lastDate}:\n");
	} else {
		foreach my $aSortedEntry (@sortedList) {
			print("     ". $aSortedEntry . "\n");
		}
	}
}

sub writeBackCompVersionActivate {
	my ($interactive) = @_;
	$interactive = setDefault($interactive,$FALSE);

	my $doDeleteInDbFirst = $TRUE;
	
	if ($interactive) { VT52_cls_home(); }

	my $aLevel    = $ENV{"CSG_LEVEL"};
	my $title     = "Activated versions on ${aLevel} to be written back to PKGDB (".getPackageDB_Details("","ONLYUSERNAME").")";
	print(unterstreichen($title));
	if ($interactive) { 
		$inInteractivMode = $TRUE;
	} else {
		$inInteractivMode = $FALSE;
	}
	my $pComponentNameFilter = readlnWithHelp("Filter for Component-Name (e.g. lh_)","","If you leave it empty, it lists all components");
	
	my $retStr = showActivatedVersionsForaComponent($pComponentNameFilter);

	$retStr =~ s/\n/,/g;
	$retStr =~ s/\s+//g;
	$retStr =~ s/==>/;/g;
	$retStr =~ s/:/;/g;
	$retStr =~ s/,/\n/g;
	my @retList = split("\n", $retStr); shift @retList; # print("AAAA\n"); displayArray(@retList); halt();
	
	# instance filter
	my $instanceFilter = "";
	my $lineFilter     = "";
	if ($interactive) { 
		$instanceFilter = uc(strip(readln("Filter for instance       (e.g. LHX)")));
		$lineFilter     = uc(strip(readln("Filter for line           (e.g. A)  ")));
	}
	
	if (($instanceFilter eq "") && ($lineFilter eq "") && ($pComponentNameFilter eq "")) {
		$doDeleteInDbFirst = $TRUE;
	} else {
		$doDeleteInDbFirst = $FALSE;
	}
	if (($instanceFilter ne "") || ($lineFilter     ne "")) {
		# save common4all entries
		my @common4allEntries = filterArrayWithRegEx("COMMON4_ALL_",@retList);
		
		if ($instanceFilter ne "") { @retList = filterArrayWithRegEx($instanceFilter,@retList); }
		if ($lineFilter     ne "") { $lineFilter = "_${lineFilter}_"; @retList = filterArrayWithRegEx($lineFilter    ,@retList); }
		push @retList, @common4allEntries;
	}
    @retList = ("Instance;Component;Version",@retList); # print("BBBB\n"); displayArray(@retList); halt();

	my @fieldLen_1  = (5);
	my @padStr_1    = (" ");
	my @res_1 = padFieldsInFieldStringArray(";",$TRUE,$FALSE,\@retList,\@fieldLen_1,\@padStr_1,$TRUE,"-");
	
	if ($interactive) { 
		VT52_cls_home();
		print("\n".unterstreichen($title));
	}
	displayArrayEnhanced($TRUE,$FALSE,"  ","\n",@res_1);
	my $count = @res_1;	$count = $count - 1; print("\n   Total: ${count} of component-versions\n");
	print("\n\n");
	shift @res_1; # Title-String remove
	
	# update in PKG-DB
	my $count    = 0;
	my $errCount = 0;
	my $ans   = setBooleanFromYesNoStr("Y");
	my $ans_1 = setBooleanFromYesNoStr("Y");
	my $ans_2 = setBooleanFromYesNoStr("Y");
	if ($interactive) { $ans   = setBooleanFromYesNoStr(readln("Do you really want to update activated components on filesystem (lhCloud) in DB (PKG-DB)","Y")); }
	if ($ans) {
		if ($interactive) { $ans_1 = setBooleanFromYesNoStr(readln("Suppress detailed error msg","Y")); }
		if ($interactive) { $ans_2 = setBooleanFromYesNoStr(readln("Show only error msg","Y")); }
		foreach my $activatedComponentVersion (@res_1) {
			$activatedComponentVersion =~ s/\s+/;/g;
			my ($fullInstanceName,$componentName,$compVersion) = split(";",$activatedComponentVersion);
			my ($instance,$line,$level) = split("_",$fullInstanceName);
			my $retMsg = updateActivatedComponentsInPKGDB($instance,$line,$level,$componentName,$compVersion, $doDeleteInDbFirst, $simulate, $verbal, $skip_DoYouReallySure);
			$doDeleteInDbFirst = $FALSE;
			my $displayStr = "    Update ".padString("${instance} ${line} ${level}",-15)."  -->  ".padString($componentName,-25)." ".padString($compVersion,-20);
			if ($retMsg eq "") {
				if (!($ans_2)) {
					print("${displayStr}      Done!!\n");
				} else {
					# print(".");
				}
				$count = $count + 1;
			} else {
				$errCount = $errCount + 1;
				if ($ans_1) {
					print("${displayStr}  ==> ERROR!!\n");
				} else {
					print("${displayStr}  ==> ERROR!!\n${retMsg}!!\n");
				}
			}
		}
	
		print("\n");
		print("\n   Total: ".padString(($count + $errCount),5)." of component-versions tried to updated in PKG-DB\n");
		print("          ".padString($count,5)." updated in PKG-DB\n");
		if ($errCount > 0) {
			print("          ".padString($errCount,5)." with error state\n");
		}
	}
	print("\n\n\n");
	$inInteractivMode = $FALSE;
	if ($interactive) { 
		print("   For command line usage: execPerlFct writeBackCompVersionActivate\n");
		print("\n\n\n");
		halt();
	}
}



sub showVersionsToBeDeleted {
	my ($pComponentName, $showOnlyListToDelete, $verbal) = @_;
	$verbal               = setDefault($verbal,               $FALSE);
	$showOnlyListToDelete = setDefault($showOnlyListToDelete, $FALSE);

	if ($inInteractivMode) {
		my @pComponentNames       = getComponentsInStores("", $ENV{"CSG_LEVEL"});
		$pComponentName = $pComponentNames[createAsciiMenuExtended("","Select a component","  Select","","",5,"",@pComponentNames)-1];
		VT52_cls_home(); print("\n\n");
	} 
	$usedVersions    = showActivatedVersionsForaComponent($pComponentName,"","","",$TRUE);
	my @usedVersions = trimAndRemoveEmptiesInArray(chompArrayEntries(split("\n",$usedVersions)));
	# print("\n\nBBBBB\n");displayArray(@usedVersions);

	my %tmpTbl = convertArrayMappingTblToHashMappingTbl(" ==> ",@usedVersions);
	# print("\n\nBBBBB1111111\n");displayHashTable(%tmpTbl);

	my @tmpList = getAllValuesSortedFromHash_AsArray($TRUE,%tmpTbl);
	# print("\n\nBBBBB222222\n");displayArray(@tmpList);

	@usedVersions    = makeArrayEntriesDistinct($TRUE, @tmpList);
	# print("\n\nCCCCC\n");displayArray(@usedVersions);

	if ($verbal) {
		if (!$showOnlyListToDelete) {
			print("\n\nUsed versions from store for ${pComponentName}:\n");
			displayArrayEnhanced($TRUE,$FALSE,"     ","\n",@usedVersions);
			my $count = @usedVersions;
			print("   Count:${count}\n");
		}
	}

	my $oldInteractiveState = $inInteractivMode;
	$inInteractivMode = $FALSE;
	my @availableVersions = trimAndRemoveEmptiesInArray(showComponentVersionsInStore($pComponentName,$FALSE," "));
	if ($verbal) {
		if (!$showOnlyListToDelete) {
			print("\n\nAvailable versions in store for ${pComponentName}:\n");
			displayArrayEnhanced($TRUE,$FALSE,"     ","\n",@availableVersions);
			my $count = @availableVersions;
			print("   Count:${count}\n");
		}
	}

	my @toDelete = getExclutionOfArrays(\@availableVersions,\@usedVersions);
	if ($verbal) {
		my $countToDel = @toDelete;
		if ($countToDel > 0) {
			print("\nCandidates of versions to be deleted in store for ${pComponentName} (not activated at the moment):\n");
			displayArrayEnhanced($TRUE,$FALSE,"     ","\n",@toDelete);
			my $count = @toDelete;
			print("   Count:${count}\n");
		} else {
			print("\nNo candidates of versions to be deleted in store for ${pComponentName} (not activated at the moment):\n");
		}
	}

	$inInteractivMode = $oldInteractiveState;
	return ($pComponentName,@toDelete);
}


# Shows the version of the activ components
#	If no pComponentname is specified ==> it lists all activated components with its version
#	otherwise it just lists the specified component version
sub showActivatedVersions {
	my ($pComponentNamePattern, $pFullEnvName, $doPad, $padOffset, $keyPrefix, $verbal) = @_;
	if ($inInteractivMode) {
		if ($pComponentNamePattern eq "") { $pComponentNamePattern = readlnWithHelp("Component-Name Pattern","","If you leave it empty, it lists all components"); }
		if ($pFullEnvName   eq "")        { $pFullEnvName          = readlnWithHelp("Full_Env_Name  ",$ENV{"CSG_FULL_ENV_NAME"},"(e.g. LHX_A_ET)");         }
		print("\n");
	} 
	$pFullEnvName         = setDefault($pFullEnvName,        $ENV{"CSG_FULL_ENV_NAME"});
	$doPad                = setDefault($doPad,               $TRUE);
	$padOffset            = setDefault($padOffset,           0);
	$verbal               = setDefault($verbal,              $FALSE);
	
	$verbal               = $FALSE;

	my $aInstName = getInstanceName_FromFullEnvName($pFullEnvName);
	my $aLevel    = getLevel_FromFullEnvName($pFullEnvName);
	my $aLine     = getLine_FromFullEnvName($pFullEnvName);

	my %compVersionHash = ();
	my $retString       = "";

	my $pathToExec  = $ENV{"CSG_SHARE_ROOT"}."/${aLevel}/${aInstName}_${aLine}/scripts/"; 					if ($verbal) { print(unterstreichen("Debug on for showActivatedVersions","=")); print("pathToExec:${pathToExec}:\n"); }
	my @dirList     = getDirList_UNIX($pathToExec);															if ($verbal) { print("\nFiles found:\n");displayArray(@dirList); }
	foreach my $aDirEntry (@dirList) {
		my $linkEntry      = getLinkDestFromUnixDirEntry($aDirEntry,!($verbal));							if ($verbal) { print("linkEntry:${linkEntry}:\n"); }
		my $pComponentName = getLastFieldFromString("/",$linkEntry,2);										if ($verbal) { print("pComponentName:${pComponentName}:\n\n"); }
		my $codeVersion    = getLastFieldFromString("/",$linkEntry,1);										if ($verbal) { print("codeVersion:${codeVersion}:\n\n"); }
		my $strangeLink    = "";
		if ($pComponentName eq "code") {
			$pComponentName = getLastFieldFromString("/",$linkEntry,1);										if ($verbal) { print("pComponentName:${pComponentName}:\n\n"); }
			$codeVersion    = getLastFieldFromString("/",$linkEntry,0);										if ($verbal) { print("codeVersion:${codeVersion}:\n\n"); }
			$strangeLink    = " *";
		}
		if (($pComponentName ne "") && ($codeVersion ne "")) {
			# print("pComponentName:${pComponentName}:    pComponentNamePattern:${pComponentNamePattern}: \n");
			if (($pComponentNamePattern eq "") || (stringContains($pComponentName,$pComponentNamePattern,$FALSE))) {
				%compVersionHash = (%compVersionHash,($keyPrefix.$pComponentName,$codeVersion.$strangeLink));
			}
		}
	}

	if ($verbal) { print("Hash-Table:\n"); displayHashTable(%compVersionHash); print("\n");}
	$retString = makeStrFromHashFormat_1($TRUE, $TRUE, " ==> ", "\n", $doPad, $padOffset, $TRUE, %compVersionHash);
	return $retString;
}

sub getComponentNamesFromDB {
	my($pLevel, $pInstance, $aLine) = @_;
	my @whereClauseParts = ();
	my @retList = ();
	# print("getComponentNames:: pLevel:${pLevel}:: pInstance:${pInstance}:: aLine:${aLine}:\n");
	my $locWhereClause = "";
	if ($pLevel ne "") {
		push(@whereClauseParts,"LEVEL eq ${pLevel}");
	}
	if ($pInstance ne "") {
		push(@whereClauseParts,"Instance eq ${pInstance}");
	}
	if ($aLine ne "") {
		push(@whereClauseParts,"Line eq ${aLine}");
	}

	$locWhereClause = makeQuotedStrFromArray(" AND ","",@whereClauseParts);
	# print("getComponentNames::whereClause: ${locWhereClause}:\n");

	@retList = getColumnValues($ENV{"CSG_DATA_COMMON"}."/Component_Version_Mapping.flt",";","Component",$locWhereClause,"Component",$TRUE);
	return @retList;
}

sub deployActivateComponentMenu {
	my($pComponentName, $pComponentVersion, $pInstanceLineLevel, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulate, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript) = @_;
	
	my ($pLevel, $pInstance, $pLine) = splitFullEnvName($pInstanceLineLevel, $notFoundStr);
	
	my $firstMenuPoint = 1;
	$pLevel = menu_selectLevel("",$pLevel);
	print("\n\n");

	my @listOfEnvironments = ("X_X_${pLevel}");
	
	($pComponentName, $pComponentVersion) = menu_selectComponentWithVersion($pComponentName, $pComponentVersion, $filter);
	print("\n\n");
	
	($doDeploy, $doDeploymentImmediate, $doActivate, $doActivateImmediate) = menu_DoDeployActivateAndImmediately  ($pLevel,$doDeploy,$doDeploymentImmediate,$doActivate,$doActivateImmediate);
	print("\n\n");
	($simulate, $verbal, $detailedVerbal)                                  = menu_DoSimulateVerbal                ($simulate, $verbal, $detailedVerbal);

	if (($doDeploy) ||  ($doActivate)) {
	    ($eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript)       = menu_eMailMode($eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript);
		if ($doActivate) {
			my @tmpArray   = getEnvironmentsForArtifactActivation($pLevel,"", "", $TRUE);   # getEnvironmentsFoexecrArtifactActivation($pLevel);
			my $selections = createAsciiMenuMultipleSelectionWithComments("All","List of available environment for ${pLevel}","  Multiple-Select separated by , or ; or space",$firstMenuPoint,"0",5,"",$TRUE,"#",@tmpArray);
			if ($selections eq "0") {
				@listOfEnvironments = trimRemoveEmptiesAndCommentsInArray(@tmpArray);
			} else {
				@listOfEnvironments = getArrayElements($selections,"",1,trimRemoveEmptiesAndCommentsInArray(@tmpArray));
			}
		} 
	} else {
		@listOfEnvironments = ("X_X_X");
	}
	print("\n");

	return ($pComponentName, $pComponentVersion, \@listOfEnvironments, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulate, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript);

}

# Called by wrapper script
#
# lhDplyAct
#	--> deployActivateComponent
#		--> deployActivateComponents
#				--> deployMultipleComponentsToMultipleLevels
#					  --> deploySingleComponent
#				--> activateMultipleComponentsToMultipleInst_Line_Levels
#					  --> activateSingleComponent
sub lhDplyAct {
	my($pComponentName, $pComponentVersion, $aLevel, $aInstance, $aLine, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $skipComponentActivationScript)  = @_;
	$aLevel                        = setDefault($aLevel,        getLevel_FromFullEnvName($ENV{"CSG_FULL_ENV_NAME"}));
	$aInstance                     = setDefault($aInstance,     getInstanceName_FromFullEnvName($ENV{"CSG_FULL_ENV_NAME"}));
	$aLine                         = setDefault($aLine,         getLine_FromFullEnvName($ENV{"CSG_FULL_ENV_NAME"}));
	
	$verbal                        = setDefault($verbal,        $FALSE);
	$detailedVerbal                = setDefault($detailedVerbal,$FALSE);
	$eMailBatchMode                = setDefault($eMailBatchMode,"ALL_REQUESTS"); # ALL_REQUESTS NO_EMAILS_AT_ALL
	$emailLogFile                  = setDefault($emailLogFile,  "/tmp/lhDplyAct_Logfile_".getTimeStamp().".log");
	$skipComponentActivationScript = setDefault($skipComponentActivationScript, $FALSE);
	$pComponentName                = strip($pComponentName);
	$pComponentVersion             = strip($pComponentVersion);
	
	if  (($pComponentName eq "") || ($pComponentName eq "?") || ($pComponentName eq "-h")) {
		print("Usage: lhDplyAct componentName componentVersion [Level Instance Line Verbal DetailedVerbal eMailBatchMode emailLogFile]\n");
		print("                 Default for optional parameters are:\n");
		print("                 	Level           \$CSG_LEVEL    (".$ENV{"CSG_LEVEL"}.")\n");
		print("                 	Instance        \$CSG_INSTANCE (".$ENV{"CSG_INSTANCE"}.")\n");
		print("                 	Line            \$CSG_LINE     (".$ENV{"CSG_LINE"}.")\n");
		print("                 	Verbal          FALSE (0)\n");
		print("                 	DetailedVerbal  FALSE (0)\n");
		print("                 	eMailBatchMode  ALL_REQUESTS\n");
		print("                 	emailLogFile    /tmp/lhDplyAct_Logfile_".getTimeStamp().".log\n");
	} else {
		my @destination = ("${aInstance}_${aLine}_${aLevel}");
		deployActivateComponent($pComponentName, $pComponentVersion, \@destination, $TRUE, $TRUE, $TRUE, $TRUE, $FALSE, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript);
	}
}

sub deployActivateComponent {
	my($pComponentName, $pComponentVersion, $destinationListRef, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript) = @_;
	
	my @compNameVersionList = ("${pComponentName}-${pComponentVersion}");
	my $retStr = deployActivateComponents(\@compNameVersionList, $destinationListRef, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, "", $skipComponentActivationScript);
	
	return $retStr;
}

sub deployActivateComponents {
	my($componentNameVersionListRef, $destinationListRef, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease, $skipComponentActivationScript) = @_;
	my $retStr      = unterstreichen("Summary of action",$uChr,$startChr,0);
	
	my @compNameVersionList = @$componentNameVersionListRef;
	my @destinationList     = @$destinationListRef;
	
	if ($detailedVerbal) {
			print("\n\nIn deployActivateComponents...\n");
			print("   componentVersionList  :\n");
			displayArrayEnhanced($doChomp,$addLineNumber,"     ","\n",@compNameVersionList);print("\n");
			print("   destinationListRef    :\n");
			displayArrayEnhanced($doChomp,$addLineNumber,"     ","\n",@destinationList);print("\n");
			print("   doDeploy                       :${doDeploy}:\n");
			print("   doActivate                     :${doActivate}:\n");
			print("   doDeploymentImmediate          :${doDeploymentImmediate}:\n");
			print("   doActivateImmediate            :${doActivateImmediate}:\n");
			print("   simulateOnly                   :${simulateOnly}:\n");
			print("   verbal                         :${verbal}:\n");
			print("   detailedVerbal                 :${detailedVerbal}:\n");
			print("   eMailBatchMode                 :${eMailBatchMode}:\n");
			print("   emailLogFile                   :${emailLogFile}:\n");
			print("   activationGreaterModeOnly      :${activationGreaterModeOnly}:\n");
			print("   belongsToRelease               :${belongsToRelease}:\n");
			print("   skipComponentActivationScript  :${skipComponentActivationScript}:\n");
			print("... end of deployActivateComponents\n\n\n");
			## print("\nCount of components to be released: ".displayHashTableFormated("Components found for \"${release}\"", "  ", "", "", "", $delimiter, 1, -1, 1, %compVersions)."\n\n\n");
	}
	
	$deployActivateTopLogPath = "";  # global variable
	print(formatTimeStamp(getTimeStamp(),"","","",$language).": Deployments / Activations in progress! Please wait...");
	if ($doDeploy) {
		my @toLevel = ();
		foreach my $aInstLineLevel (@destinationList) {
			push(@toLevel,getFieldFromString("_",2,$aInstLineLevel));
		}
		@toLevel = makeArrayEntriesDistinct($TRUE,@toLevel);
		$retStr = $retStr.deployMultipleComponentsToMultipleLevels(\@compNameVersionList, \@toLevel, $doDeploymentImmediate, $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease);
	}
	if ($doActivate) {
		$retStr = $retStr.activateMultipleComponentsToMultipleInst_Line_Levels(\@compNameVersionList, \@destinationList, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease, $skipComponentActivationScript);
	}
	print("\n".formatTimeStamp(getTimeStamp(),"","","",$language).": done!!\n");
	
	if (!(isFileEmpty($emailLogFile))) {
		putLineOnTop($emailLogFile,unterstreichen("Mail summary",$uChr,$startChr,0));
		appendLine($emailLogFile,"\n");
		my $emailContent = readFileIntoStr($emailLogFile);
		
		if ($deployActivateTopLogPath ne "") {
			$emailContent = $emailContent."\nMore details under: ".$deployActivateTopLogPath."\n\n";
		}
			
		if ($emailContent ne "") { 
			$retStr = $retStr."\n".$emailContent;
			sendCS_Email("", "FT Summary from Deployments/Activations", $emailContent);
		}
	}
	return $retStr;
}

sub doTest_deployMultipleComponents {
	my($myFullName,$debugThisFct) = @_;
	$debugThisFct = setDefault($debugThisFct,$FALSE);

	if ($debugThisFct) {
		my @comVerList = (
			"eod-11.3.0.7",
			"eoy-11.1.0.2",
		);
		
		my @levelList = (
			"ET",
			"IT",
		);
		
		my @instLineLevelList = (
			"LHX_A_ET",
			"LHX_B_ET",
			"LHX_D_IT",
			"LHX_E_IT",
		);
		
		$debugThisFct = $FALSE;
		print("deployMultipleComponentsToMultipleLevels...\n");
		deployMultipleComponentsToMultipleLevels(\@comVerList, \@levelList, $TRUE, $simulateOnly, $TRUE, $TRUE, $debugThisFct, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly);		
		print("\n\n\n\n");
		
		print("activateMultipleComponentsToMultipleInst_Line_Levels...\n");
		activateMultipleComponentsToMultipleInst_Line_Levels(\@comVerList, \@instLineLevelList, $TRUE, $simulateOnly, $TRUE, $TRUE, $debugThisFct, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly);
	}
}

# NEW
# e.g. 
# my @comVerList = (
# 	"eod-11.3.0.7",
# 	"eoy-11.1.0.2",
# );
#	
# my @levelList = (
# 	"ET",
# 	"IT",
# );
#		
#   deployMultipleComponentsToMultipleLevels(\@comVerList, \@levelList);
sub deployMultipleComponentsToMultipleLevels {
	my($component_versionListRef, $toLevelRef, $doDeploymentImmediate, $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease) = @_;
	$toLevel               = setDefault($toLevel              , $ENV{CSG_CURRENT_TEST_LEVEL});
	$doDeploymentImmediate = setDefault($doDeploymentImmediate, $FALSE);
	$simulateOnly          = setDefault($simulateOnly         , $TRUE);
	$verbal                = setDefault($verbal               , $FALSE);
	$detailedVerbal        = setDefault($detailedVerbal       , $FALSE);
	$doDebug               = setDefault($doDebug              , $FALSE);
	
	my $retStr = "";
	
	my @componentenVersionListe = ();
	my @toLevelListe            = ();
	
	if (ref($component_versionListRef) eq "ARRAY") {
		@componentenVersionListe = @$component_versionListRef;
	} else {
		@componentenVersionListe = ($component_versionListRef);
	}
	
	if (ref($toLevelRef) eq "ARRAY") {
		@toLevelListe = @$toLevelRef;
	} else {
		@toLevelListe = ($toLevelRef);
	}
	
	if ($doDebug) {
		print("activateMultipleComponentsToMultipleInst_Line_Levels...\n");
		print("    componentenVersionListe:\n"); displayArrayEnhanced("","","      ","\n",@componentenVersionListe);
		print("    toLevelListe:\n");            displayArrayEnhanced("","","      ","\n",@toLevelListe);
	}
	
	my $lastRound        = $FALSE;
	my $veryLastRound    = $FALSE;
	my $firstRound       = $TRUE;

	my $countOfComponentes = @componentenVersionListe;
	my $countOfLevels      = @toLevelListe;
	
	foreach my $toLevel (@toLevelListe) {
		foreach my $oneComponentVersion (@componentenVersionListe) {
			if (($toLevel             eq getLastArrayElement(@toLevelListe)) && 
			    ($oneComponentVersion eq getLastArrayElement(@componentenVersionListe))) { $veryLastRound = $TRUE; } else { $veryLastRound = $FALSE; } 
			if  ($oneComponentVersion eq getLastArrayElement(@componentenVersionListe))  { $lastRound     = $TRUE; } else { $lastRound     = $FALSE; }

			if ($doDebug) { 
				print("lastRound:${lastRound}:    veryLastRound:${veryLastRound}:\n");
			}
			
			$retStr = $retStr."\n".deploySingleComponent($oneComponentVersion, $toLevel, ($doDeploymentImmediate && $lastRound), $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease);
			$firstRound   = $FALSE;
			if ($doDebug) {
				print("\n");
			}
		}
		$retStr = $retStr."\n"."    Deployed to ${toLevel} total ${countOfComponentes} component(s)\n";
	}
	$retStr = $retStr."\n"."  Deployment done to total ${countOfLevels} level(s)\n\n";
	return $retStr;
}


sub purgeReleaseLogFiles {
	my $nowDate = substr(getTimeStamp(),0,8);
	my $keepToDate = subSomeWorkingDays($nowDate,"",2);
	# print("nowDate:${nowDate}:    keepToDate:${keepToDate}:\n");
	purgeUnixDir(getReleaseLogBasePath(),"",$TRUE,$TRUE);
}


# NEW
# e.g. 
#   deploySingleComponent("eod-11.3.0.7","ET");
sub deploySingleComponent {
	my($component_version, $toLevel, $doDeploymentImmediate, $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease) = @_;
	$toLevel               = setDefault($toLevel              , $ENV{CSG_CURRENT_TEST_LEVEL});
	$doDeploymentImmediate = setDefault($doDeploymentImmediate, $FALSE);
	$simulateOnly          = setDefault($simulateOnly         , $TRUE);
	$verbal                = setDefault($verbal               , $FALSE);
	$detailedVerbal        = setDefault($detailedVerbal       , $FALSE);
	$doDebug               = setDefault($doDebug              , $FALSE);
	$belongsToRelease      = setDefault($belongsToRelease     , "DefaultRelease");

	my $retStr = "";
	
	if ($doDebug) {
		print("deploySingleComponent($component_version, $toLevel, $doDeploymentImmediate, $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease)\n");
	}
	
	if (($component_version eq "") || ($toLevel eq "")) {
	
	} else {
		my $myMode = "";
		if ($eMailBatchMode ne "") {
			$myMode = "EMAIL_BATCHMODE=${eMailBatchMode}";
		}
		if ($emailLogFile) {
			$myMode = "${myMode} EMAIL_CONTENT_FILE=${emailLogFile}";
		}
		if ($activationGreaterModeOnly) {
			$myMode = "${myMode} ACTIVATION_GREATER_MODE_ONLY=${TRUE}";
		}
		
	if ($belongsToRelease ne "") {
		$myMode = "${myMode} CURR_DPLY_LOGS=".getReleaseLogPath($belongsToRelease);
		$deployActivateTopLogPath = getReleaseLogPath($belongsToRelease);
		purgeReleaseLogFiles();
		mkUnixDir(getReleaseLogPath($belongsToRelease));
	}
		
		my $pComponentName		= strip(getFieldFromString("-",0,$component_version));
		my $pComponentVersion   = strip(getFieldFromString("-",1,$component_version));
		
		my $unixCmdDeploy           = "BATCHMODE=1 ${myMode} ".padString("qDeployment" ,-15).padString($pComponentName,-30)." ".padString($pComponentVersion,-20)." ${toLevel}              2>&1";
		my $unixCmdDeployImmediate  = "BATCHMODE=1 ${myMode} ".padString("deploy"      ,-15)."                                                                    2>&1";
		my $prioStr = ""; # padString(getPriorityForComponent($release, $pComponentName, $FALSE),5," ");
		$retStr = "Deploy  : ${prioStr}: ".padString($pComponentName,-30," ").padString($pComponentVersion,-20," ")." to ${toLevel}";
		
		my $cmdRetMsg  = "";
		if (!$simulateOnly)                    { $cmdRetMsg  = `$unixCmdDeploy`; } else { $cmdRetMsg  = "Simulated only"; }
		if (($verbal) || ($simulateOnly))      { print("unixCmd:${unixCmdDeploy}: ==> msg:${cmdRetMsg}:\n"); }
		elsif ($detailedVerbal)                { print(formatUNIXActivateOrDeploymentCmd($unixCmdDeploy)."\n"); }
		
		if ($doDeploymentImmediate) {
			if ($toLevel eq $ENV{CSG_CURRENT_TEST_LEVEL}) {
			    $retStr = $retStr."    ==> Do Deploy now!";
				if ($doDebug)                      { print("Perform deployment immediately!\n"); }
				if (!$simulateOnly)                { $cmdRetMsg  = `$unixCmdDeployImmediate`; } else { $cmdRetMsg  = "Simulated only"; }
				if (($verbal) || ($simulateOnly))  { print("unixCmd:${unixCmdDeployImmediate}: ==> msg:${cmdRetMsg}:\n"); }
				elsif ($detailedVerbal)            { print(formatUNIXActivateOrDeploymentCmd($unixCmdDeployImmediate)."\n"); }
			} else {
				print("WARNING: Immediate deployment on ${toLevel} not possible from ".$ENV{CSG_CURRENT_TEST_LEVEL}."\n");
			}
		}
	}
	return $retStr;
}


# NEW
# e.g. 
# my @comVerList = (
# 	"eod-11.3.0.7",
# 	"eoy-11.1.0.2",
# );
#	
#		
# my @instLinelevelList = (
# 	"LHX_A_ET",
# 	"LHX_B_ET",
# );
#		
#   activateMultipleComponentsToMultipleInst_Line_Levels(\@comVerList, \@instLinelevelList);
sub activateMultipleComponentsToMultipleInst_Line_Levels {
	my($component_versionListRef, $toInstLineLevelRef, $doActivationImmediate, $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease, $skipComponentActivationScript) = @_;
	$doActivationImmediate = setDefault($doActivationImmediate, $FALSE);
	$simulateOnly          = setDefault($simulateOnly         , $TRUE);
	$verbal                = setDefault($verbal               , $FALSE);
	$detailedVerbal        = setDefault($detailedVerbal       , $FALSE);
	$doDebug               = setDefault($doDebug              , $FALSE);
	
	my $retStr = "";
	
	my @componentenVersionListe = ();
	my @toInstLineLevelListe    = ();
	
	if (ref($component_versionListRef) eq "ARRAY") {
		@componentenVersionListe = @$component_versionListRef;
	} else {
		@componentenVersionListe = ($component_versionListRef);
	}
	
	if (ref($toInstLineLevelRef) eq "ARRAY") {
		@toInstLineLevelListe = @$toInstLineLevelRef;
	} else {
		@toInstLineLevelListe = ($toInstLineLevelRef);
	}
	
	if ($doDebug) {
		print("activateMultipleComponentsToMultipleInst_Line_Levels...\n");
		print("    componentenVersionListe:\n"); displayArrayEnhanced("","","      ","\n",@componentenVersionListe);
		print("    toInstLineLevelListe:\n");    displayArrayEnhanced("","","      ","\n",@toInstLineLevelListe);
	}
	
	my $veryLastRound    = $FALSE;
	my $firstRound       = $TRUE;
	my $i                = 0;
	
	my $countOfComponentes = @componentenVersionListe;
	my $countOfInstances   = @toInstLineLevelListe;
	
	foreach my $toInstLineLevel (@toInstLineLevelListe) {
		my $currLevel       = strip(getFieldFromString("_",2,$toInstLineLevel));
		my $nextCurrLevel   = "";
		my $levelWillChange = $FALSE;
		if ($toInstLineLevel ne getLastArrayElement(@toInstLineLevelListe)) {
			$nextCurrLevel = strip(getFieldFromString("_",2,$toInstLineLevelListe[$i+1]));
			$levelWillChange = ($currLevel ne $nextCurrLevel);
		} else {
			$levelWillChange = $TRUE;
		}
		
		foreach my $oneComponentVersion (@componentenVersionListe) {
			my $lastCompVersion = ($oneComponentVersion eq getLastArrayElement(@componentenVersionListe));
		
			if (($toInstLineLevel     eq getLastArrayElement(@toInstLineLevelListe)) && 
			    ($oneComponentVersion eq getLastArrayElement(@componentenVersionListe)))    { $veryLastRound = $TRUE; } else { $veryLastRound = $FALSE; }
			if  ($veryLastRound) {
				$levelWillChange     = $TRUE;
			}

			if ($doDebug) {
				print("i:${i}:   currLevel:${currLevel}:                nextCurrLevel:${nextCurrLevel}:    toInstLineLevel:${toInstLineLevel}\n");
				print("          levelWillChange:${levelWillChange}:    veryLastRound:${veryLastRound}:\n");
			}

			$retStr = $retStr."\n".activateSingleComponent($oneComponentVersion, $toInstLineLevel, ($doActivationImmediate && $levelWillChange && $lastCompVersion), $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease, $skipComponentActivationScript);
			$firstRound   = $FALSE;
			if ($doDebug) {
				print("\n");
			}
		}
		$retStr = $retStr."\n"."    Activated on ${toInstLineLevel} total ${countOfComponentes} component(s)\n";
		
		$i = $i + 1;
	}
	$retStr = $retStr."\n"."  Activation done on total ${countOfInstances} instance(s)\n\n";
	return $retStr;
}

sub getReleaseLogBasePath {
	my $retVal = strip($ENV{"CSG_RELEASE_LOGS"});
	if ($retVal eq "") {
		$retVal = strip($ENV{"CSG_SHARE_LEVEL"})."/logs/release";
	}
	return $retVal;
}

sub getReleaseLogPath {
	my($releaseName) = @_;
	$releaseName =~ s/-/ /g;
	$releaseName =~ s/\s+/_/g;
	## print("=====> getReleaseLogPath:::releaseName:${releaseName}:   releaseLogDirectory:${releaseLogDirectory}:\n");
	my $timeStamp = getTimeStamp();
	my $timeStampStr = substr($timeStamp,0,8)."_".substr($timeStamp,8,6);
	if ($releaseLogDirectory eq "") {
		$releaseLogDirectory = getReleaseLogBasePath()."/".$releaseName."_".$timeStampStr;
		## print("=====>                     created (1):${releaseLogDirectory}:\n");
	} else {
		if (!(stringContains($releaseLogDirectory,"/${releaseName}_"))) {
			$releaseLogDirectory = getReleaseLogBasePath()."/".$releaseName."_".$timeStampStr;
			## print("=====>                     created (2):${releaseLogDirectory}:\n");
		}
	}
	return $releaseLogDirectory;	
}

sub getReleaseLogPathForEnv {
	my($releaseName, $fullEnv) = @_;
	my $retVal = getReleaseLogPath($releaseName)."/".$fullEnv;
	return $retVal;
}

sub getActivationLogFileName {
	my($releaseName, $fullEnv, $cmpName, $version) = @_;
	my $retVal = getReleaseLogPathForEnv($releaseName, $fullEnv)."/".$cmpName."_".$version.".log";
	return $retVal;
}

# NEW
# e.g.
#   activateSingleComponent("eod-11.3.0.7","LHX_A_ET");
sub activateSingleComponent {
	my($component_version, $toInstanceLineLevel, $doActivationImmediate, $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease, $skipComponentActivationScript) = @_;
	$doActivationImmediate         = setDefault($doActivationImmediate        , $FALSE);
	$simulateOnly                  = setDefault($simulateOnly                 , $TRUE);
	$verbal                        = setDefault($verbal                       , $FALSE);
	$detailedVerbal                = setDefault($detailedVerbal               , $FALSE);
	$doDebug                       = setDefault($doDebug                      , $FALSE);
	$belongsToRelease              = setDefault($belongsToRelease             , "DefaultRelease");
	$skipComponentActivationScript = setDefault($skipComponentActivationScript, $FALSE);
	
	my $retStr = "";
	
	my $myMode = "";
	if ($eMailBatchMode ne "") {
		$myMode = "EMAIL_BATCHMODE=${eMailBatchMode}";
	}
	if ($emailLogFile) {
		$myMode = "${myMode} EMAIL_CONTENT_FILE=${emailLogFile}";
	}
	if ($activationGreaterModeOnly) {
		$myMode = "${myMode} ACTIVATION_GREATER_MODE_ONLY=${TRUE}";
	}
	if ($skipComponentActivationScript) {
		$myMode = "${myMode} SKIP_COMPONENT_ACTIVATION_SCRIPTS=${TRUE}";
	}
	
	if ($belongsToRelease ne "") {
		$myMode = "${myMode} CURR_DPLY_LOGS=".getReleaseLogPath($belongsToRelease);
		$myMode = "${myMode} CURR_ACT_LOGS=".getReleaseLogPathForEnv($belongsToRelease, $toInstanceLineLevel);
		purgeReleaseLogFiles();
		mkUnixDir(getReleaseLogPathForEnv($belongsToRelease, $toInstanceLineLevel));
	}
	
	if ($doDebug) {
		print("activateSingleComponent($component_version, $toInstanceLineLevel, $doActivationImmediate, $simulateOnly, $verbal, $detailedVerbal, $doDebug, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $belongsToRelease, $skipComponentActivationScript)\n");
	}
	
	if (($component_version eq "") || ($toInstanceLineLevel eq "")) {
	
	} else {
		my $pComponentName	   = strip(getFieldFromString("-",0,$component_version));
		my $pComponentVersion  = strip(getFieldFromString("-",1,$component_version));
		
		my ($pInstance, $pLine, $pLevel) = splitFullEnvName($toInstanceLineLevel);
		
		my $unixCmdActivate           = "BATCHMODE=1 ${myMode} ".padString("qActivation" ,-15).padString($pComponentName,-30)." ".padString($pComponentVersion,-20)." ${pLevel} ".padString($pInstance ,-8).padString($pLine ,-4)." 2>&1";
		my $unixCmdActivateImmediate  = "BATCHMODE=1 ${myMode} ".padString("activate"    ,-15)."                                                                    2>&1";
		my $prioStr = ""; # padString(getPriorityForComponent($release, $pComponentName, $FALSE),5," ");
        $retStr = "Activate: ${prioStr}: ".padString($pComponentName,-30," ").padString($pComponentVersion,-20," ")." to ${toInstanceLineLevel}";
		
		if (!$simulateOnly)                    { $msg  = `$unixCmdActivate`; } else { $msg  = "Simulated only"; }
		if (($verbal) || ($simulateOnly))      { print("unixCmd:${unixCmdActivate}: ==> msg:${msg}:\n"); }
		elsif ($detailedVerbal)                { print(formatUNIXActivateOrDeploymentCmd($unixCmdActivate)."\n"); }

		if ($doActivationImmediate) {	
			if ($pLevel eq $ENV{CSG_CURRENT_TEST_LEVEL}) {
				$retStr = $retStr."    ==> Do Activate now!";
				if ($doDebug)                      { print("Perform activation immediately!\n"); }
				if (!$simulateOnly)                { $msg  = `$unixCmdActivateImmediate`; } else { $msg  = "Simulated only"; }
				if (($verbal) || ($simulateOnly))  { print("unixCmd:${unixCmdActivateImmediate}: ==> msg:${msg}:\n"); }
				elsif ($detailedVerbal)            { print(formatUNIXActivateOrDeploymentCmd($unixCmdActivateImmediate)."\n"); }
			} else {
				print("WARNING: Immediate activation on ${pLevel} not possible from ".$ENV{CSG_CURRENT_TEST_LEVEL}."\n\n");
			}
		}
	}
	return $retStr;
}

sub formatUNIXActivateOrDeploymentCmd {
	my($aUNIX_CmdActivateOrDeployment) = @_;	
	# print("CMD (1):${aUNIX_CmdActivateOrDeployment}\n");
	
	$aUNIX_CmdActivateOrDeployment =~ s/\s+/;/g;					                                                                                                 # print("CMD (2):${aUNIX_CmdActivateOrDeployment}\n");
	$aUNIX_CmdActivateOrDeployment = removeFieldFromString(";",0,$aUNIX_CmdActivateOrDeployment,"");                                                                 # print("CMD (3):${aUNIX_CmdActivateOrDeployment}\n");
	my $cmd = getFieldFromString(";",0,$aUNIX_CmdActivateOrDeployment,"");
	$aUNIX_CmdActivateOrDeployment = removeFieldFromString(";",0,$aUNIX_CmdActivateOrDeployment,"");
	if ($cmd eq "qDeployment") { 
		$cmd = "   ==> ${cmd}";
	} elsif ($cmd eq "qActivation") { 
		$cmd = "   ->> ${cmd}";
	} else {
		$cmd = "   -   ${cmd}";
	}
	$aUNIX_CmdActivateOrDeployment = $cmd . ";" . removeFieldFromString(";",getCountOfFieldsInstring(";",$aUNIX_CmdActivateOrDeployment)-1,$aUNIX_CmdActivateOrDeployment,"");    # print("CMD (4):${aUNIX_CmdActivateOrDeployment}\n");
	
	
	my @fieldLen  = (-30,-30,-10,-5,-8,-5);
	my @padStr    = (" "," "," "," "," "," ");
	return padFieldsIndividualyInString(";",$aUNIX_CmdActivateOrDeployment,$FALSE,\@fieldLen,\@padStr,$TRUE);
}

sub menu_DoDeploy {
	my($doDeploy) = @_;
	if ($doDeploy eq "") {
		return setBooleanFromYesNoStr(readln("Do deploy it?","Y"));
	} else {
		return $doDeploy;
	}
}

sub menu_DoDeployImmediately {
	my($selectedLevel, $doDeploymentImmediate) = @_;
	if ($doDeploymentImmediate eq "") {
		if ($selectedLevel eq $ENV{CSG_CURRENT_TEST_LEVEL}) {
			$doDeploymentImmediate = setBooleanFromYesNoStr(readln("Perform deployment immediate?","Y"));
		} else {
			$doDeploymentImmediate = $FALSE;
		}
	} 
	return $doDeploymentImmediate
}

sub menu_DoDeployAndImmediately {
	my($selectedLevel, $doDeploy, $doDeploymentImmediate) = @_;
	if ($doDeploy eq "") {
		$doDeploy = menu_DoDeploy();
	}
	if ($doDeploy) {
		if ($doDeploymentImmediate eq "") {
			$doDeploymentImmediate = menu_DoDeployImmediately($selectedLevel);
		} 
	} else {
		$doDeploymentImmediate = $FALSE;
	}
	return ($doDeploy, $doDeploymentImmediate);
}


sub menu_DoActivate {
	my($doActivate) = @_;
	if ($doActivate eq "") {
		return setBooleanFromYesNoStr(readln("Do activate it?","Y"));
	} else {
		return $doActivate;
	}
}

sub menu_DoActivateImmediately {
	my($selectedLevel, $doActivateImmediate) = @_;
	if ($doActivateImmediate eq "") {
		if ($selectedLevel eq $ENV{CSG_CURRENT_TEST_LEVEL}) {
			$doActivateImmediate = setBooleanFromYesNoStr(readln("Perform activate immediate?","Y"));
		} else {
			$doActivateImmediate = $FALSE;
		}
	} 
	return $doActivateImmediate
}

sub menu_DoActivateAndImmediately {
	my($selectedLevel, $doActivate, $doActivateImmediate) = @_;
	if ($doActivate eq "") {
		$doActivate = menu_DoActivate();
	}
	if ($doActivate) {
		if ($doActivateImmediate eq "") {
			$doActivateImmediate = menu_DoActivateImmediately($selectedLevel);
		}
	} else {
		$doActivateImmediate = $FALSE;
	}
	return ($doActivate, $doActivateImmediate);
}

sub menu_DoDeployActivateAndImmediately {
	my($selectedLevel, $doDeploy, $doDeploymentImmediate, $doActivate, $doActivateImmediate) = @_;
	($doDeploy  , $doDeploymentImmediate) = menu_DoDeployAndImmediately  ($selectedLevel,$doDeploy,$doDeploymentImmediate);
	($doActivate, $doActivateImmediate)   = menu_DoActivateAndImmediately($selectedLevel,$doActivate,$doActivateImmediate);
	return ($doDeploy  , $doDeploymentImmediate, $doActivate, $doActivateImmediate);

}


sub menu_DoSimulate {
	my($simulate) = @_;
	if ($simulate eq "") {
		return setBooleanFromYesNoStr(readln("Only simulate deployment/activation?","Y"));
	} else {
		return $simulate;
	}
}

sub menu_DoVerbal {
	my($verbal) = @_;
	if ($verbal eq "") {
		return setBooleanFromYesNoStr(readln("Verbal?","N"));
	} else {
		return $verbal;
	}
}

sub menu_DoDetailedVerbal {
	my($detailedVerbal) = @_;
	if ($detailedVerbal eq "") {
		return setBooleanFromYesNoStr(readln("Detailed verbal?","N"));
	} else {
		return $detailedVerbal;
	}
}

sub menu_DoSimulateVerbal {
	my($simulate, $verbal, $detailedVerbal) = @_;
	$simulate       = menu_DoSimulate($simulate);
	$verbal         = menu_DoVerbal($verbal);
	$detailedVerbal = menu_DoDetailedVerbal($detailedVerbal);
	return ($simulate, $verbal, $detailedVerbal);
}

sub getEmailNotificationModes {
	return ("ALL_REQUESTS","CHANGED_COMPONENTS_ONLY","NO_EMAILS_AT_ALL","");
}

sub getEmailNotificationModesMenuTexts {
	return ("Summarized email for all requests","Summarized email for only executed changes","No email notifications at all","Single emails for each request");
}

sub menu_eMailMode {
	my($eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript) = @_;
	## print("(0):    eMailBatchMode:${eMailBatchMode}:   emailLogFile:${emailLogFile}:    activationGreaterModeOnly:${activationGreaterModeOnly}:\n");
	
	my @menuItems = getEmailNotificationModes();
	if ($eMailBatchMode eq "") {
		$eMailBatchMode = $menuItems[createAsciiMenuExtended("","eMail notification options","Select",1,"","","",getEmailNotificationModesMenuTexts()) - 1];
	}
	$eMailBatchMode =~ s/\s//g;
	if (($eMailBatchMode ne "NO_EMAILS_AT_ALL") && ($emailLogFile eq "")) {
		if ($eMailBatchMode ne "") {
			$emailLogFile = readln("eMail Logfilename","/tmp/lhManageComponent_email_".getMyUnixPid()."_".getTimeStamp().".log",$dontAsk);
		}
	}
	
	if ($activationGreaterModeOnly eq "") {
		$activationGreaterModeOnly = uc(readln("Only activate if version to activate is newer than current activated version","N",$dontAsk));
		if ($activationGreaterModeOnly eq "N") { $activationGreaterModeOnly = ""; }
	}
	$activationGreaterModeOnly =~ s/\s//g;
	
	if ($skipComponentActivationScript eq "") {
		$skipComponentActivationScript = uc(readln("Skip component activation script","N",$dontAsk));
		if ($skipComponentActivationScript eq "N") { $skipComponentActivationScript = ""; } else {$skipComponentActivationScript = $TRUE; }
	}
	$activationGreaterModeOnly =~ s/\s//g;
	## print("(1):    eMailBatchMode:${eMailBatchMode}:   emailLogFile:${emailLogFile}:    activationGreaterModeOnly:${activationGreaterModeOnly}:    skipComponentActivationScript:${skipComponentActivationScript}:\n");
	return ($eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript);
}

sub menu_selectLevel {
	my($withAll,$pLevel) = @_;
	$withAll  = setDefault($withAll, $FALSE);
	
	my $loggedInLevel = $ENV{"CSG_LEVEL"};
	
	if ($pLevel eq "") {
		my @tmpArray = ();
		if ($withAll) {
			@tmpArray = ("ALL");
		}
		@tmpArray = concatArray(@tmpArray,getLevelsForArtifactDeployment());
		my $firstMenuPoint = 1;
		return $tmpArray[createAsciiMenuExtended("","List of available levels","  Select",$firstMenuPoint,"N",5,"",@tmpArray)-$firstMenuPoint];
	} else {
		return $pLevel;
	}
}

sub menu_selectRelease {
	my($pRelease, $filter) = @_;
	$filter  = setDefault($filter, ".+"); # readln("Regular-expression filter for releases",".+");
	
	my $firstMenuPoint = 1;
	if ($pRelease eq "") {
		my @tmpArray = getReleases($filter);
		$pRelease = $tmpArray[createAsciiMenuExtended("","List of available releases","  Select",$firstMenuPoint,"N",5,"",@tmpArray)-$firstMenuPoint];
	}
}

sub menu_selectComponent {
	my($pComponentName, $filter) = @_;
	$filter  = setDefault($filter, readln("Regular-expression filter for component","^(?!TP_)"));
	
	my $firstMenuPoint = 1;
	if ($pComponentName eq "") {
		my @tmpArray = getComponentsInArtifactStore($filter);
		$pComponentName = $tmpArray[createAsciiMenuExtended("","List of available components from artifacts","  Select",$firstMenuPoint,"N",5,"",@tmpArray)-$firstMenuPoint];
	}
	return $pComponentName;
}

sub menu_selectComponentVersion {
	my($pComponentName, $pComponentVersion) = @_;
	
	my $firstMenuPoint = 1;
	if ($pComponentVersion eq "") {
		my @tmpArray = getComponentVersionsInArtifactStore($pComponentName);
		$pComponentVersion = $tmpArray[createAsciiMenuExtended("","List of available versions from artifacts of ${pComponentName}","  Select",$firstMenuPoint,"N",5,"",@tmpArray)-$firstMenuPoint];
	}
	return $pComponentVersion;
}

sub menu_selectComponentWithVersion {
	my($pComponentName, $pComponentVersion, $filter) = @_;
	$pComponentName    = menu_selectComponent($pComponentName, $filter);
	$pComponentVersion = menu_selectComponentVersion($pComponentName, $pComponentVersion);
	return ($pComponentName, $pComponentVersion);
}

sub deployActivateReleaseMenu {
	my($pRelease, $pInstanceLineLevel, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript) = @_;
	
	## print("deployActivateReleaseMenu.....\n");
	my ($pLevel, $pInstance, $pLine) = splitFullEnvName($pInstanceLineLevel, $notFoundStr);
	
	my $firstMenuPoint = 1;
	$pLevel = menu_selectLevel("",$pLevel);
	my @listOfEnvironments = ("X_X_${pLevel}");
	
	$pRelease = menu_selectRelease($pRelease);
	print("\n\n");
	
	($doDeploy, $doDeploymentImmediate, $doActivate, $doActivateImmediate) = menu_DoDeployActivateAndImmediately  ($pLevel,$doDeploy,$doDeploymentImmediate,$doActivate,$doActivateImmediate,);
	print("\n\n");
	($simulateOnly, $verbal, $detailedVerbal)                              = menu_DoSimulateVerbal                ($simulateOnly, $verbal, $detailedVerbal);

	if (($doDeploy) ||  ($doActivate)) {
		($eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript) = menu_eMailMode($eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript);
		if ($doActivate) {
			my @tmpArray   = getEnvironmentsForArtifactActivation($pLevel,"", "", $TRUE);   # getEnvironmentsForArtifactActivation($pLevel);
			## displayArray(@tmpArray); halt();
			my $selections = createAsciiMenuMultipleSelectionWithComments("All","List of available environment for ${pLevel}","  Multiple-Select separated by , or ; or space",$firstMenuPoint,"0",5,"",$TRUE,"#",@tmpArray);
			## print("selections:${selections}:\n");
			if ($selections eq "0") {
				## print("All has been selected!!\n");
				@listOfEnvironments = trimRemoveEmptiesAndCommentsInArray(@tmpArray);
			} else {
				@listOfEnvironments = getArrayElements($selections,"",1,trimRemoveEmptiesAndCommentsInArray(@tmpArray));
			}
		} 
	} else {
		@listOfEnvironments = ("X_X_X");
	}
	## displayArray(@listOfEnvironments); halt();
	print("\n");

	return ($pRelease, \@listOfEnvironments, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript);
}


# Called by NOLIO
#
# deployActivateReleaseTop
#	--> deployActivateRelease
#         --> deployActivateComponents
#				--> deployMultipleComponentsToMultipleLevels
#					  --> deploySingleComponent
#				--> activateMultipleComponentsToMultipleInst_Line_Levels
#					  --> activateSingleComponent
sub deployActivateReleaseTop {
	my($pRelease, $destinations, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript) = @_;
	$doDeploy                      = setDefault($doDeploy,                        $TRUE);
	$doActivate                    = setDefault($doActivate,                      $TRUE);
	$doDeploymentImmediate         = setDefault($doDeploymentImmediate,           $TRUE);
	$doActivateImmediate           = setDefault($doActivateImmediate,             $TRUE);
	$simulateOnly                  = setDefault($simulateOnly,                    $TRUE);  # FALSE
	$verbal                        = setDefault($verbal,                          $FALSE);
	$detailedVerbal                = setDefault($detailedVerbal,                  $FALSE);
	$eMailBatchMode                = setDefault($eMailBatchMode,                  "ALL_REQUESTS");
	$emailLogFile                  = setDefault($emailLogFile,                    getReleaseLogPath($pRelease)."/summerizedLogForDeployActivate_".getTimeStamp().".log");
	$activationGreaterModeOnly     = setDefault($activationGreaterModeOnly,       $FALSE);
	$skipComponentActivationScript = setDefault($skipComponentActivationScript,   $FALSE);

	if (stringStartsWith($destinations,"ALL_ALL_")) {
		my $aLevel = getFieldFromString("_",2,$destinations);
		## print("aLevel:${aLevel}:\n");
		$destinations = makeQuotedStrFromArray(";","",getEnvironmentsForArtifactActivation($aLevel));
		## print("destinations:${destinations}:\n");
	}
	
	my @destinationList = split(";",$destinations);
	my $retStr = deployActivateRelease($pRelease, \@destinationList, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript);
	if (isFileExists($emailLogFile)) {
		my $retMsg = `rm  -f $emailLogFile  2>&1`;
	}
	return $retStr;
}

sub deployActivateRelease {
	my($release, $destinationListRef, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $skipComponentActivationScript) = @_;
	
	my @compNameVersionList = getComponentVersionForReleaseSortedByPrio($release);
	my $retStr = deployActivateComponents(\@compNameVersionList, $destinationListRef, $doDeploy, $doActivate, $doDeploymentImmediate, $doActivateImmediate, $simulateOnly, $verbal, $detailedVerbal, $eMailBatchMode, $emailLogFile, $activationGreaterModeOnly, $release, $skipComponentActivationScript);
	
	return $retStr;
}

sub createRelease {
	my($releaseName, $releaseComment, $managerFirstName, $managerLastName, $createdBy, $plannedReleaseDate, $verbal) = @_;
	$verbal       = setDefault($verbal,     $FALSE);

	my $managerId = getUserID_FromAtrifactDB($managerFirstName, $managerLastName);

	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\n"); }
	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }

	if ($verbal) {
		print("releaseName        :${releaseName}:\n");
		print("releaseComment     :${releaseComment}:\n");
		print("managerId          :${managerId}:\n");
		print("createdBy          :${createdBy}:\n");
		print("plannedReleaseDate :${plannedReleaseDate}:\n");
	}
	my $sth    = $releaseDB_Handle->prepare("BEGIN release.create_release(:P_REL_NAME, :P_REL_DESC, :P_REL_MANAGER_ID, :P_CHANGED_BY, :P_PLANNED_DATE ); END;");
	$sth->bind_param(":P_REL_NAME",         $releaseName);
	$sth->bind_param(":P_REL_DESC",         $releaseComment);
	$sth->bind_param(":P_REL_MANAGER_ID",   $managerId);
	$sth->bind_param(":P_CHANGED_BY",       $createdBy);
	$sth->bind_param(":P_PLANNED_DATE",     $plannedReleaseDate);
	$sth->execute();
}

sub addComponentToRelease {
	my($releaseName, $cmpName, $compVersion, $changedBy, $verbal) = @_;
	$verbal       = setDefault($verbal,     $FALSE);

	my $artifactID = getArtifactID($cmpName, $compVersion);
	my $releaseID  = getReleaseID($releaseName);

	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\n"); }
	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }
	if ($verbal) {
		print("releaseName   :${releaseName}:\n");
		print("cmpName       :${cmpName}:\n");
		print("compVersion   :${compVersion}:\n");
		print("ArtifactId    :${artifactID}:\n");
		print("ReleaseId     :${releaseID}:\n");
	}

	my $sth    = $releaseDB_Handle->prepare("BEGIN release.add_to_release(:P_RELEASE_ID, :P_ARTIFACT_ID, :P_CHANGED_BY  ); END;");
	$sth->bind_param(":P_RELEASE_ID",       $releaseID);
	$sth->bind_param(":P_ARTIFACT_ID",      $artifactID);
	$sth->bind_param(":P_CHANGED_BY",       $changedBy);
	$sth->execute();
}

sub removeComponentFromRelease {
	my($releaseName, $cmpName, $compVersion, $verbal) = @_;
	$verbal        = setDefault($verbal,     $FALSE);

	my $releaseID  = getReleaseID($releaseName);
	# my $artifactID = getArtifactID($cmpName, $compVersion);
	my $cmpID      = getComponentID($cmpName);

	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\n"); }
	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }
	if ($verbal) {
		print("releaseName   :${releaseName}:\n");
		print("cmpName       :${cmpName}:\n");
		print("compVersion   :${compVersion}:\n");
		# print("ArtifactId    :${artifactID}:\n");
		print("ComponentId   :${cmpID}:\n");
		print("ReleaseId     :${releaseID}:\n");
	}

	my $sth    = $releaseDB_Handle->prepare("BEGIN release.remove_from_release(:P_RELEASE_ID, :P_CMP_ID ); END;");
	$sth->bind_param(":P_RELEASE_ID",       $releaseID);
	$sth->bind_param(":P_CMP_ID",           $cmpID);
	$sth->execute();
}


sub copyComponentsFromReleaseToRelease {
	my($fromRelease, $toRelease, $copiedBy, $verbal) = @_;
	$copiedBy      = setDefault($copiedBy, getLoggingUser());
	$verbal        = setDefault($verbal, $FALSE);

	my $fromReleaseID  = getReleaseID($fromRelease);
	my $toReleaseID    = getReleaseID($toRelease);

	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\n"); }
	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }
	if ($verbal) {
		print("fromRelease (id)   :${fromRelease}: ($fromReleaseID)\n");
		print("toRelease   (id)   :${toRelease}:   ($toReleaseID)\n");
	}

	my $sth    = $releaseDB_Handle->prepare("BEGIN release.copy_release_artifacts(:P_FROM_RELEASE_ID, :P_TO_RELEASE_ID, :P_CHANGED_BY  ); END;");
	$sth->bind_param(":P_FROM_RELEASE_ID", $fromReleaseID);
	$sth->bind_param(":P_TO_RELEASE_ID",   $toReleaseID);
	$sth->bind_param(":P_CHANGED_BY",      $copiedBy);
	$sth->execute();
}

sub compareTwoReleases {
	my($firstRelease, $secondRelease, $verbal) = @_;
	$verbal        = setDefault($verbal, $FALSE);

	my %firstReleaseDetails     = getReleaseDetails($firstRelease);
	my %secondReleaseDetails    = getReleaseDetails($secondRelease);

	if ($verbal) {
		print("\n\nfirstRelease  Details (${firstRelease}):\n"); displayHashTable(%firstReleaseDetails);
		print("\n\nsecondRelease Details (${secondRelease}):\n");displayHashTable(%secondReleaseDetails);
	}

	my @components1Release = keys %firstReleaseDetails;
	my @components2Release = keys %secondReleaseDetails;

	my @removedIn2Release = getExclutionOfArrays(\@components1Release,\@components2Release);
	my @addedIn2Release   = getExclutionOfArrays(\@components2Release,\@components1Release);
	my @inBothRelease     = getUnionOfArrays(\@components1Release,\@components2Release);
	my $maxComponentNameLength = length(getLongestValFromArray(@inBothRelease));

	my $differencesFound = $FALSE;
	my $count = @removedIn2Release;
	if ($count > 0) {
		print("\n\n${count} component removed from \"${secondRelease}\" (compare to ${firstRelease}):\n");
		displayArrayEnhanced($TRUE,$FALSE,"      ","\n",(sort @removedIn2Release));
		$differencesFound = $TRUE;
	}

	$count = @addedIn2Release;
	if ($count > 0) {
		print("\n\n${count} component added to \"${firstRelease}\" (compare to ${secondRelease}):\n");
		displayArrayEnhanced($TRUE,$FALSE,"      ","\n",(sort @addedIn2Release));
		$differencesFound = $TRUE;
	}

	my $diffStr = "";
	$count = 0;
	foreach my $aComponent (sort @inBothRelease) {
		if ($firstReleaseDetails{$aComponent} ne $secondReleaseDetails{$aComponent}) {
			$count = $count + 1;
			$diffStr = $diffStr . "\n      ". padString($aComponent,-$maxComponentNameLength," ").":".padString($firstReleaseDetails{$aComponent},-10," ")."      -->   ". padString($secondReleaseDetails{$aComponent},-10," ");
			$differencesFound = $TRUE;
		}
	}
	if ($diffStr ne "") {
		print("\n\n${count} differences between versions:");
		print("  \n       ".padString($aComponent,-$maxComponentNameLength," ")."${firstRelease}      ${secondRelease}");
		print("${diffStr}\n\n");
	}
	return $differencesFound
}

sub changeStatusOfRelease {
	my($releaseName, $status, $verbal) = @_;
	$status        = setDefault($status,     $FALSE);
	$verbal        = setDefault($verbal,     $FALSE);

	my $releaseID  = getReleaseID($releaseName);

	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\n"); }
	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }
	if ($verbal) {
		print("ReleaseName (id)   :${releaseName}: (${releaseID})\n");
		print("status             :${status}:\n");
	}

	my $sth    = $releaseDB_Handle->prepare("BEGIN release.set_release_status(:P_RELEASE_ID, :P_STATUS); END;");
	$sth->bind_param(":P_RELEASE_ID",       $releaseID);
	$sth->bind_param(":P_STATUS",           $status);
	$sth->execute();
}

sub removeRelease {
	my($releaseName, $verbal) = @_;
	$verbal        = setDefault($verbal,     $FALSE);

	my $releaseID  = getReleaseID($releaseName);

	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\n"); }
	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }
	if ($verbal) {
		print("releaseName   :${releaseName}:\n");
		print("ReleaseId     :${releaseID}:\n");
	}

	my $sth    = $releaseDB_Handle->prepare("BEGIN release.delete_release(:P_RELEASE_ID); END;");
	$sth->bind_param(":P_RELEASE_ID",       $releaseID);
	$sth->execute();
}

sub renameRelease {
	my($releaseName, $releaseNewName, $verbal) = @_;
	$verbal         = setDefault($verbal,$TRUE);
	
	my $releaseID   = getReleaseID($releaseName);
	$releaseNewName = strip($releaseNewName);
	my $retVal      = $releaseNewName;
	
	if ($verbal) { print("---> ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\n"); }
	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }
	if ($verbal) {
		print("Updating release name from \"${releaseName}\" (${releaseID})\n");
		print("                      to   \"${releaseNewName}\"\n");
	}

	my $sth    = $releaseDB_Handle->prepare("BEGIN release.rename_release(:P_RELEASE_ID, :P_NEW_NAME); END;");
	$sth->bind_param(":P_RELEASE_ID",       $releaseID);
	$sth->bind_param(":P_NEW_NAME",         $releaseNewName);
	$sth->execute();
	if ( $sth->err ) {
		$retVal = "ERROR: renameRelease failed!blick.ch";
	}
	
	return $retVal;
}


sub selectRelease {
	my($filter, $filterPrompt, $reqiredStates, $menuTitle, $withDetails,  $verbal) = @_;
	$filterPrompt        = setDefault($filterPrompt,     "Regular-expression filter for releases");
	$reqiredStates       = setDefault($reqiredStates,    "ALL");
	$menuTitle           = setDefault($menuTitle,        "List of available releases");
	$withDetails         = setDefault($withDetails,      $FALSE);
	$verbal              = setDefault($verbal,           $FALSE);

	if ($filter eq "") { $filter    = readln($filterPrompt,".+"); }

	my @tmpArray  = getReleases($filter,$reqiredStates,$withDetails);
	if ($withDetails) {
		my @fieldLen_1  = (4);
		my @padStr_1    = (" ");
		@tmpArray = padFieldsInFieldStringArray(";",$TRUE,$FALSE,\@tmpArray,\@fieldLen_1,\@padStr_1,$FALSE);
	}
	my $releaseName  = $tmpArray[createAsciiMenuExtended("",$menuTitle,"  Select",1,"N",5,"",@tmpArray)-1];
	if ($withDetails) {
		$releaseName = strip(getFieldFromString(";",0,$releaseName,$notFoundStr));
	}
	return $releaseName;
}

sub selectLevels {
	my($filter, $filterPrompt, $menuTitle, $verbal, @additionalOptions) = @_;
	$filterPrompt        = setDefault($filterPrompt,     "Regular-expression filter for levels");
	$menuTitle           = setDefault($menuTitle,        "List of LH parameters in ".getPackageDB_Details("","ONLYUSERNAME"));
	$verbal              = setDefault($verbal,           $FALSE);
	$filter = ".+";
	if ($filter eq "") { $filter    = readln($filterPrompt,".+"); }

	my @tmpArray  = (@additionalOptions,getLevelsForArtifactDeployment());
	
	my $retVal  = $tmpArray[createAsciiMenuExtended("",$menuTitle,"  Select",1,"N",5,"",@tmpArray)-1];
	return $retVal;
}

sub selectPkgParameterNames {
	my($filter, $filterPrompt, $menuTitle, $verbal) = @_;
	$filterPrompt        = setDefault($filterPrompt,     "Regular-expression filter for pkg-parameter");
	$menuTitle           = setDefault($menuTitle,        "List of available pkg-parameter");
	$verbal              = setDefault($verbal,           $FALSE);
	if ($filter eq "") { $filter    = readln($filterPrompt,".+"); }

	my @tmpArray  = listParameter($filter,"","",0,"**--","*");
	my $releaseName  = $tmpArray[createAsciiMenuExtended("",$menuTitle,"  Select",1,"N",5,"",@tmpArray)-1];
	return $releaseName;
}

# password in DB
# --------------
sub doTest_deletePasswordDB {
	deletePasswordDB("rothlin","TESTCASE","ET","LHX","A",$doDebug); 
	deletePasswordDB("rothlinxxx","TESTCASE","ET","LHX","A",$doDebug); 
}

sub deletePasswordDB {
	my($user,$recource,$level,$instance,$line,$doDebug)  = @_;
	$doDebug     = setDefault($doDebug,$FALSE);
	$level       = uc($level);
	$line        = uc($line);

	writeTrace($doDebug,"deletePasswordDB:: user:${user}, resource:${recource}, level:${level}, instance:${instance}, line:${line}");

	# check parameters
	if  (($user eq "") || 
		 ($recource eq "") || 
		 ($instance eq "") || 
		 (($level ne "ET") && ($level ne "IT") && ($level ne "PT") && ($level ne "PR") && ($level ne "ALL"))  ||
		 (($line ne "A") && ($line ne "B") && ($line ne "C") && ($line ne "D") && ($line ne "E") && ($line ne "F") && ($line ne "ALL"))) {
		my $retStr = "ERROR: Parameter missing or wrong values!\nUsage: deletePasswordDB user recource level instance line";
				$retStr = $retStr ."\n" . "      level:   [ET, IT, PT, PR, ALL]  ";
				$retStr = $retStr ."\n" . "      line:    [A,B,C,D,E,F,ALL]  ";
		return $retStr;
	}

	if ($configDB_Handle eq "") {
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	my $sql = qq {
		delete from CMP_CFG_PASSWORDS
		where
			     INST_NAME   = '${instance}'
			and  LEVEL_NAME  = '${level}'
			and  LINE_NAME   = '${line}'
			and  SYSTEM_NAME = '${recource}'
			and  USER_NAME   = '${user}'
	};

	return sqlExecute_dbh($sql, $configDB_Handle);
}

sub deleteAllPasswordDB {
	if ($configDB_Handle eq "") {
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}
	
	my $sql = qq {
		delete from CMP_CFG_PASSWORDS
	};
	return sqlExecute_dbh($sql, $configDB_Handle);
}

sub getPasswordDB_withDefault {
	my($user, $recource, $level, $instance, $line, $resourceIsEqual, $doDebug)  = @_;
	$level           = setDefault($level,           $ENV{CSG_LEVEL});
	$instance        = setDefault($instance,        $ENV{CSG_INSTANCE});
	$line            = setDefault($line,            $ENV{CSG_LINE});
	$resourceIsEqual = setDefault($resourceIsEqual, $FALSE);
	$doDebug         = setDefault($doDebug,         $FALSE);

	if ($doDebug) { print("INFO:getPasswordDB_withDefault(${user},${recource},${level},${instance},${line},${resourceIsEqual},${doDebug})\n"); }
	my $password = "";
	if ($password eq "") { $password = getPasswordDB($user, $recource, $level, $instance, $line,"",$TRUE,$FALSE,$resourceIsEqual,$doDebug); }
	if ($password eq "") { $password = getPasswordDB($user, $recource, $level, $instance, "ALL","",$TRUE,$FALSE,$resourceIsEqual,$doDebug); }
	if ($password eq "") { $password = getPasswordDB($user, $recource, "ALL" , $instance, $line,"",$TRUE,$FALSE,$resourceIsEqual,$doDebug); }
	if ($password eq "") { $password = getPasswordDB($user, $recource, "ALL" , $instance, "ALL","",$TRUE,$FALSE,$resourceIsEqual,$doDebug); }
	if ($password eq "") { $password = getPasswordDB($user, $recource, $level, "ALL"    , $line,"",$TRUE,$FALSE,$resourceIsEqual,$doDebug); }
	if ($password eq "") { $password = getPasswordDB($user, $recource, $level, "ALL"    , "ALL","",$TRUE,$FALSE,$resourceIsEqual,$doDebug); }
	if ($password eq "") { $password = getPasswordDB($user, $recource, "ALL" , "ALL"    , $line,"",$TRUE,$FALSE,$resourceIsEqual,$doDebug); }
	if ($password eq "") { $password = getPasswordDB($user, $recource, "ALL" , "ALL"    , "ALL","",$TRUE,$FALSE,$resourceIsEqual,$doDebug); }

	return $password;
}

sub getPasswordDB_byID {
	my($id)  = @_;

	if ($configDB_Handle eq "") {
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	if ($useDefaultKey) { $cookieCryptKey = $DefaultCryptKey; }

	my $sql = qq {
		select
			INST_NAME                                 INST_NAME,
			LEVEL_NAME                                LEVEL_NAME,
			LINE_NAME                                 LINE_NAME,
			SYSTEM_NAME                               SYSTEM_NAME,
			USER_NAME                                 USER_NAME,
			PASSWORD                                  PASSWORD,
			REMARK                                    REMARK,
			CHANGED_BY                                CHANGED_BY,
			TO_CHAR(CHANGED_TS,'YYYYMMDDHH24MISS')    CHANGED_TS
		from CMP_CFG_PASSWORDS
		where
			ID   = '${id}'
	};

	my $preparedSql = $configDB_Handle->prepare($sql);
	my @recSet = dbExecutePreparedSelectSttmnt($preparedSql);

	my $retStr = "";
	foreach my $aRec (@recSet) {
		$retStr =              $aRec->{"INST_NAME"};
		$retStr = $retStr .";".$aRec->{"LEVEL_NAME"};
		$retStr = $retStr .";".$aRec->{"LINE_NAME"};
		$retStr = $retStr .";".$aRec->{"SYSTEM_NAME"};
		$retStr = $retStr .";".$aRec->{"USER_NAME"};
		if ($lhManageComponentsRootMode) {
			$retStr = $retStr .";".decryptString($aRec->{"PASSWORD"},$cookieCryptKey); 
		} else {
			$retStr = $retStr .";".$aRec->{"PASSWORD"}; 
		}
		$retStr = $retStr .";".$aRec->{"REMARK"};
		$retStr = $retStr .";".$aRec->{"CHANGED_BY"};
		$retStr = $retStr .";".$aRec->{"CHANGED_TS"};
		last;

	}
	return $retStr
}

sub getPasswordDB {
	my($user, $recource, $level, $instance, $line, $cookieCryptKey, $useDefaultKey, $allDetails, $resourceIsEqual, $doDebug)  = @_;
	$doDebug         = setDefault($doDebug,         $FALSE);
	$allDetails      = setDefault($allDetails,      $FALSE);
	$useDefaultKey   = setDefault($useDefaultKey,   $TRUE);
	$resourceIsEqual = setDefault($resourceIsEqual, $FALSE);
	$level           = uc($level);
	$line            = uc($line);

	if ($doDebug) { print("INFO:getPasswordDB(${user},${recource},${level},${instance},${line},${cookieCryptKey},${useDefaultKey},${allDetails},${resourceIsEqual},${doDebug})\n"); }

	# check parameters
	if  (($user eq "") || 
		 (($level ne "ET") && ($level ne "IT") && ($level ne "PT") && ($level ne "PR") && ($level ne "ALL"))  ||
		 (($line ne "A") && ($line ne "B") && ($line ne "C") && ($line ne "D") && ($line ne "E") && ($line ne "F") && ($line ne "ALL"))) {
		my $retStr = "ERROR: Parameter missing or wrong values!\nUsage: getPasswordDB user recource level instance line";
		$retStr = $retStr ."\n" . "      level:   [ET, IT, PT, PR, ALL]  ";
		$retStr = $retStr ."\n" . "      line:    [A,B,C,D,E,F,ALL]  ";
		return $retStr;
	}

	if ($configDB_Handle eq "") {
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	if ($useDefaultKey) { $cookieCryptKey = $DefaultCryptKey; }

	my $resourceWherePart = "";
	if ($recource ne "") { 
		if ($resourceIsEqual) {
			$resourceWherePart = "and  SYSTEM_NAME = '${recource}'";
		} else {
			$resourceWherePart = "and  SYSTEM_NAME like '${recource}\%'";
		}
	}
	my $sql = qq {
		select
			PASSWORD                                  PASSWORD,
			REMARK                                    REMARK,
			CHANGED_BY                                CHANGED_BY,
			TO_CHAR(CHANGED_TS,'YYYYMMDDHH24MISS')    CHANGED_TS
		from CMP_CFG_PASSWORDS
		where
			     INST_NAME   = '${instance}'
			and  LEVEL_NAME  = '${level}'
			and  LINE_NAME   = '${line}' $resourceWherePart 
			and  USER_NAME   = '${user}'
			order by ID
	};
	if ($doDebug) { print("sql:\n${sql}\n"); }
	my $preparedSql = $configDB_Handle->prepare($sql);
	my @recSet = dbExecutePreparedSelectSttmnt($preparedSql);

	my $retStr = "";
	foreach my $aRec (@recSet) {
		my $aVal = $aRec->{"PASSWORD"};
		if ($cookieCryptKey ne "") { $aVal = decryptString($aVal,$cookieCryptKey); } # entschluesselt

		if ($allDetails) {
			$aVal = $aVal .";".$aRec->{"REMARK"};
			$aVal = $aVal .";".$aRec->{"CHANGED_BY"};
			$aVal = $aVal .";".$aRec->{"CHANGED_TS"};
		}
		if ($retStr eq "") {
			$retStr = $aVal;
			last;
		} else {
			$retStr = "MULTIPLE: \n".$retStr . "\n" . $aVal;
		}
	}

	return $retStr
}

sub listAllPasswordInDB {
	my($formatIt, $fieldDelimiter, $cookieCryptKey, $useDefaultKey, $doDebug)  = @_;
	$formatIt        = setDefault($formatIt,       $TRUE);
	$doDebug         = setDefault($doDebug,        $FALSE);
	$useDefaultKey   = setDefault($useDefaultKey,  $TRUE);
	$fieldDelimiter  = setDefault($fieldDelimiter, ";");

	writeTrace($doDebug,"listAllPasswordInDB:: cookieCryptKey:${cookieCryptKey}, useDefaultKey:${useDefaultKey}");

	if ($configDB_Handle eq "") {
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	if ($useDefaultKey) { $cookieCryptKey = $DefaultCryptKey; }

	my $sql = qq {
		select
			ID                                        ID,
			USER_NAME                                 USER_NAME,
			SYSTEM_NAME                               RESOURCE_NAME,
			LEVEL_NAME                                LEVEL_NAME,
			INST_NAME                                 INST_NAME,
			LINE_NAME                                 LINE_NAME,
			PASSWORD                                  PASSWORD,
			REMARK                                    REMARK,
			CHANGED_BY                                CHANGED_BY,
			TO_CHAR(CHANGED_TS,'YYYYMMDDHH24MISS')    CHANGED_TS
		from CMP_CFG_PASSWORDS
		order by ID
	};
	my $preparedSql = $configDB_Handle->prepare($sql);
	my @recSet = dbExecutePreparedSelectSttmnt($preparedSql);

	my $headerLine = "ID${fieldDelimiter}USER_NAME${fieldDelimiter}RESOURCE_NAME${fieldDelimiter}LEVEL_NAME${fieldDelimiter}INST_NAME${fieldDelimiter}LINE_NAME${fieldDelimiter}PASSWORD${fieldDelimiter}REMARK${fieldDelimiter}CHANGED_BY${fieldDelimiter}CHANGED_TS";
	my @retStr = ($headerLine);
	foreach my $aRec (@recSet) {
		my $aVal = $aRec->{"ID"};
		$aVal = $aVal.$fieldDelimiter.$aRec->{"USER_NAME"};
		$aVal = $aVal.$fieldDelimiter.$aRec->{"RESOURCE_NAME"};
		$aVal = $aVal.$fieldDelimiter.$aRec->{"LEVEL_NAME"};
		$aVal = $aVal.$fieldDelimiter.$aRec->{"INST_NAME"};
		$aVal = $aVal.$fieldDelimiter.$aRec->{"LINE_NAME"};
		my $password = $aRec->{"PASSWORD"};
		if ($cookieCryptKey ne "") { $password = decryptString($password,$cookieCryptKey); } # entschluesselt
		$aVal = $aVal.$fieldDelimiter.$password;
		$aVal = $aVal.$fieldDelimiter.$aRec->{"REMARK"};
		$aVal = $aVal.$fieldDelimiter.$aRec->{"CHANGED_BY"};
		$aVal = $aVal.$fieldDelimiter.formatTimeStamp($aRec->{"CHANGED_TS"});
		push(@retStr,$aVal);
	}
	
	# format it
	if ($formatIt) {
		my @fieldLen_1  = (4);
		my @padStr_1    = (" ");
		my @res_1 = padFieldsInFieldStringArray($fieldDelimiter,$TRUE,$FALSE,\@retStr,\@fieldLen_1,\@padStr_1,$TRUE,"-");
		@retStr = @res_1;
	}

	return @retStr;
}

sub addModPasswordDB {
	my($user, $password, $recource, $level, $instance, $line, $comment, $cookieCryptKey, $useDefaultKey, $doDebug)  = @_;
	$doDebug        = setDefault($doDebug,$FALSE);
	$useDefaultKey  = setDefault($useDefaultKey, $TRUE);

	$level          = uc($level);
	$line           = uc($line);
	my $loggingUser = getLoggingUser();

	writeTrace($doDebug,"addModPasswordDB:: user:${user}, password:${password}, resource:${recource}, level:${level}, instance:${instance}, line:${line}, comment:${comment}:");

	# check parameters
	if  (($user     eq "") || 
		 ($password eq "") || 
		 ($recource eq "") || 
		 ($instance eq "") || 
		 (($level ne "ET") && ($level ne "IT") && ($level ne "PT") && ($level ne "PR") && ($level ne "ALL"))  ||
		 (($line ne "A") && ($line ne "B") && ($line ne "C") && ($line ne "D") && ($line ne "E") && ($line ne "F") && ($line ne "ALL"))  ||
		 (length($comment) <  5)) {
		my $retStr = "ERROR: Parameter missing or wrong values!\nUsage: addModPasswordDB user password recource level instance line comment";
				if ($user eq "")                                                                                                                  { $retStr = $retStr ."\n" . "      user:     must be defined ";                        }
				if ($password eq "")                                                                                                              { $retStr = $retStr ."\n" . "      password: must be defined ";                        }
				if ($recource eq "")                                                                                                              { $retStr = $retStr ."\n" . "      recource: must be defined ";                        }
				if ($instance eq "")                                                                                                              { $retStr = $retStr ."\n" . "      instance: must be defined ";                        }
				if (($level ne "ET") && ($level ne "IT") && ($level ne "PT") && ($level ne "PR") && ($level ne "ALL"))                            { $retStr = $retStr ."\n" . "      level:   [ET, IT, PT, PR, ALL]  ";                  }
				if (($line ne "A") && ($line ne "B") && ($line ne "C") && ($line ne "D") && ($line ne "E") && ($line ne "F") && ($line ne "ALL")) { $retStr = $retStr ."\n" . "      line:    [A,B,C,D,E,F,ALL]  ";                      }
				if (length($comment) <  5)                                                                                                        { $retStr = $retStr ."\n" . "      commend: length of commend has to be more than 5 "; }
		return $retStr;
	}

	if ($configDB_Handle eq "") {
		$configDB_Handle = dbConnect($configDB_DbName,$configDB_Username,$configDB_Password,"",$FALSE,$TRUE,$TRUE);
	}

	if ($useDefaultKey) { $cookieCryptKey = $DefaultCryptKey; }
	my $encryptedPassword = $password;
	if ($cookieCryptKey ne "") { $encryptedPassword = encryptString($password, $cookieCryptKey); } # verschluesseln

	my $oldEntry = getPasswordDB($user,$recource,$level,$instance,$line, "", $TRUE,$TRUE);
	my ($oldPassword,$oldRemark,$oldChandedBy,$oldModDate) = split(";",$oldEntry);

	my $nowTS   = getTimeStamp();
	my $sql     = "";
	my $caseStr = "";
	if ($oldEntry eq "") {
		$caseStr = "Insert";
		$sql = qq {
			insert into CMP_CFG_PASSWORDS (
				INST_NAME,
				LEVEL_NAME,
				LINE_NAME,
				SYSTEM_NAME,
				USER_NAME,
				PASSWORD,
				REMARK,
				CHANGED_BY,
				CHANGED_TS
			)
			values (
				'${instance}',
				'${level}',
				'${line}',
				'${recource}',
				'${user}',
				'${encryptedPassword}',
				'${comment}',
				'${loggingUser}',
				TO_DATE('${nowTS}','YYYYMMDDHH24MISS')
			)
		};
	} else {
			print("\nUpdate existing entry!\n\n");
			print("oldPassword:${oldPassword}:   oldRemark:${oldRemark}:   oldChandedBy:${oldChandedBy}:   oldModDate:${oldModDate}:\n");
			print("newPassword:${password}:   newRemark:${comment}:  \n");
			if  (($oldPassword eq $password) && ($oldRemark eq $comment) && (uc(strip(readln("\nThe entries are the same!\nTake this entry over anyway ","N"))) eq "N")) {
				$caseStr = "New and old are the same!";
			} else {
				$caseStr = "Update";
				$sql = qq {
					update CMP_CFG_PASSWORDS
					set 
						PASSWORD   = '${encryptedPassword}',
						REMARK     = '${comment}',
						CHANGED_BY = '${loggingUser}',
						CHANGED_TS = TO_DATE('${nowTS}','YYYYMMDDHH24MISS')
					where 
							INST_NAME       = '${instance}'
						and LEVEL_NAME      = '${level}'
						and LINE_NAME       = '${line}'
						and SYSTEM_NAME     = '${recource}'
						and USER_NAME       = '${user}'
					};
			}
	}

	if ($sql eq "") {
		return $caseStr;
	} else {
		return $caseStr." ".sqlExecute_dbh($sql, $configDB_Handle);
	}
}

sub copyPasswordsFromFileToDB {
	$fullCryptedFileName   = getFtpLoginFileCryptedFilename();
	$fullDecryptedFileName = getFtpLoginFileDecryptedFilename();
	decryptFtpLoginPasswordFile();
	print("fullCryptedFileName   :${fullCryptedFileName}\n");
	print("fullDecryptedFileName :${fullDecryptedFileName}\n\n\n");

	my $countPasswordsRead = 0;
	my $countPasswordsWritten = 0;
	my @myEntries = getAllMatchesFromFltFileAsHashes($fullDecryptedFileName,$ftpLoginFile_FieldSep);
	foreach my $aRecord (@myEntries) {
		print("Hash:       ".$aRecord->{Hash}.":\n");
		print("HostName:   ".$aRecord->{HostName}.":\n");
		print("UserId:     ".$aRecord->{UserId}.":\n");
		print("Password:   ".$aRecord->{Password}.":\n");
		print("Instance:   ".$aRecord->{Instance}.":\n");
		print("TestLevel:  ".$aRecord->{TestLevel}.":\n");
		print("Line:       ".$aRecord->{Line}.":\n");
		print("ModDate:    ".$aRecord->{ModDate}.":\n");
		print("ModBy:      ".$aRecord->{ModBy}.":\n");
		print("Comment:    ".$aRecord->{Comment}.":\n\n");
		my $antwort = strip(readln("Take this entry over to DB ","Y"));
		if ($antwort eq "Y") {
			my $level = $aRecord->{TestLevel};
			if ($level eq "PTA")  { $level = "PT"; }
			if ($level eq "PROD") { $level = "PR"; }
			my $user       = $aRecord->{UserId};
			my $password   = $aRecord->{Password};
			my $res        = $aRecord->{HostName};
			my $inst       = $aRecord->{Instance};
			my $level      = $level;
			my $line       = $aRecord->{Line};
			my $comment    = $aRecord->{Comment};
			my $returnStr  = addModPasswordDB($user, $password, $res, $level, $inst, $line, $comment, $cookieCryptKey, $TRUE);
			print("\n --> :".$returnStr.":\n\n");
			if ($returnStr ne "New and old are the same!") {
				$countPasswordsWritten = $countPasswordsWritten + 1;
			}
		}
		$countPasswordsRead = $countPasswordsRead + 1;
	}

	print("countPasswordsRead:${countPasswordsRead}:    countPasswordsWritten:${countPasswordsWritten}:\n");
	unlink($fullDecryptedFileName);
}

sub getComponentNameFromDirEntry {
	my($aDirEntry)  = @_;
	return getFieldFromString("/",5,$aDirEntry);
}

sub getComponentVersionFromDirEntry {
	my($aDirEntry)  = @_;
	return getFieldFromString("/",6,$aDirEntry);
}



#  Crypter function for Java Crypter Tester
sub doTest_cryptVersionCompare {
   my($myFullName,$debugThisFct) = @_;
   $debugThisFct = setDefault($debugThisFct,$FALSE);
   	my $testCases = qq {
		Nr|PrefixVersion  |ConfigVersion |Expected
		01|V1.3.0.0       |V1.3.1.0      |TRUE
		02|V3.3.0.0       |V1.3.1.0      |FALSE
		03|V1.3.2.0       |V1.3.1.0      |FALSE
	};
	
	for (my $i = 2; $i <= getCountOfLinesFromQQ($testCases); $i++) {
		my $testCaseNr     = getFieldFromQQ($testCases,$i,1);
		my $preVersion     = getFieldFromQQ($testCases,$i,2);
		my $confVersion    = getFieldFromQQ($testCases,$i,3);
		my $expectedRes    = getFieldFromQQ($testCases,$i,4);

		if ($debugThisFct) {
			print("\n==> ${myFullName}: Test-Case:${i}:${testCaseNr}\n");
			print("       preVersion   :${preVersion}:\n");
			print("       confVersion  :${confVersion}:\n");
			print("       expectedRes  :${expectedRes}:\n");
			print("       cryptVersionCompare(${preVersion},${confVersion})=".cryptVersionCompare($preVersion,$confVersion)."\n");
		}
		if (!(cryptVersionCompare($preVersion,$confVersion) == ($expectedRes eq "TRUE"))) { print("ERROR: Test-Case ${testCaseNr}\n"); print("       cryptVersionCompare(${preVersion},${confVersion})=".cryptVersionCompare($preVersion,$confVersion)."        Expected:${expectedRes}:\n");}
	}
   
}

sub cryptVersionCompare {
	my($versionFromPrefix,$versionFromConfig)  = @_;
	
	# print("... in cryptVersionCompare::  versionFromPrefix:${versionFromPrefix},   versionFromConfig:${versionFromConfig}\n");
	
	my $retVal = $FALSE;
	$versionFromPrefix = strip($versionFromPrefix);
	$versionFromConfig = strip($versionFromConfig);
	my @prefixParts = split("\\.",$versionFromPrefix);
	my @configParts = split("\\.",$versionFromConfig);
	
	# displayArray(@prefixParts);
	# displayArray(@configParts);
	if ($prefixParts[2] eq "0") {
		if (($prefixParts[0] eq $configParts[0]) &&
		    ($prefixParts[1] eq $configParts[1]) &&
			($prefixParts[3] eq $configParts[3])) {
			$retVal = $TRUE;
		} else {
			$retVal = $FALSE;
		}
	} else {
		if ($versionFromPrefix eq $versionFromConfig) {
			$retVal = $TRUE;
		} else {
			$retVal = $FALSE;
		}
	}
	return $retVal;
}

sub sendCS_Email {
	my($toList, $subject, $fileContent, $fromAdr, $ccList, $bccList, $disclaimer)  = @_;
	$toList  = setDefault($toList , getEmailAdressForPid());   # "walter.rothlin\@credit-suisse.com,pavithira.pathmanathan\@credit-suisse.com"
	$subject = setDefault($subject,"TEST-MAIL from csfbPerlLib.pm sub sendCS_Email!! Pls ignore!!!");
	$fromAdr = setDefault($fromAdr, "deploy.lh\@credit-suisse.com");   # old was build.lh\@credit-suisse.com
	
	if ($disclaimer eq "") {
		$disclaimer = "***************Internet Email Confidentiality Footer***************\nDISCLAIMER: This e-mail contains proprietary and confidential information some or all of which may be legally privileged. It is intended only for the stated addressee(s) and access to it by any other person is unauthorised. If you are not the intended recipient and an addressing or transmission error has misdirected this e-mail, please notify the author IMMEDIATELY, by replying to this e-mail, then delete this message and all copies from all locations in your system. You should not use, disseminate, disclose, distribute, copy, print, or rely on this e-mail: to do so may be unlawful. CS Group and all its affiliates reserve the right to monitor all e-mail communications through their networks.\n***********************************************************";
	}

	# $CSG_SCRIPTS/sitebin/sendmail.ksh \"${subject}\" \"${fileContent}\" \"${toList}\" \"${ccList}\" \"${bccList}\" ";
	# lh_wrapper/..../sendMail
	
	return sendMailwithAttachments($fromAdr,$toList,$subject,"${fileContent}\n${disclaimer}",$attachmentFileList,$ccList,$bccList,$delim,$tmpDir,$TRUE,$href_FileDelimeter,$href_ExtReplacement,$href_DelimeterReplace,$TRUE);
}

sub getPriviligedMgmFunctions {
	my($pUserId, $pLevel, $verbal)  = @_;
	$pUserId  = setDefault($pUserId, getLoggingUser($FALSE));
	$pLevel   = setDefault($pLevel, $ENV{"CSG_LEVEL"});
	$verbal   = setDefault($verbal, $FALSE);

	my @returnSet = ();
	if ($verbal) { 
		print("releaseDB_DbName   :${releaseDB_DbName}:\n");
		print("releaseDB_Username :${releaseDB_Username}:\n");
		print("releaseDB_Password :${releaseDB_Password}:\n");
	}

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }
	if (dbTablesExists_dbh($releaseDB_Handle, "USER_MENUFUNCTIONS_V")) {
		my $sql = qq {
			select distinct
				MENU_FUNCTION_NAME
			from
				USER_MENUFUNCTIONS_V
			where
				((LEVEL_NAME   = '${pLevel}') or (LEVEL_NAME   = 'ANY')) and 
				  PID          = '${pUserId}'
			order by MENU_FUNCTION_NAME
		};
		if ($verbal) { print("---> getPriviligedMgmFunctions:  ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
		my $prepared_sql = $releaseDB_Handle->prepare($sql);
		my @recordSet   = dbExecutePreparedSelectSttmnt($prepared_sql);
		foreach my $aRec (@recordSet) {
			push(@returnSet,$aRec->{"MENU_FUNCTION_NAME"});
			if ($verbal) { print("--> ".$aRec->{"MENU_FUNCTION_NAME"}."\n"); }
		}
	}
	return @returnSet;
}

sub getDefinedUsers {

}

sub showPriviligedMgmFunctions {
	my($pUserId, $pLevel)  = @_;
	$pUserId  = setDefault($pUserId, getLoggingUser($FALSE));
	
	my ($pid,$fName,$mName,$lName,$emailAdr) = split(":",selectUser(".+","","Select the manager of the release"));
	
	my $locWhereClause = qq {
			where
				((LEVEL_NAME = '${pLevel}') or (LEVEL_NAME   = 'ANY')) and 
				  PID        = '${pUserId}'
		};
	$locWhereClause = qq {
			where 
				PID          = '${pid}'
		};

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }
	if (dbTablesExists_dbh($releaseDB_Handle, "USER_MENUFUNCTIONS_V")) {
		my $sql = qq {
			select
				PID,
				LEVEL_NAME,
				FIRST_NAME,
				LAST_NAME,
				ROLE_NAME,
				ACTIVITY_NAME,
				MENU_FUNCTION_NAME
			from
				USER_MENUFUNCTIONS_V
			${locWhereClause} order by MENU_FUNCTION_NAME
		};
		if ($verbal) { print("---> getPriviligedMgmFunctions:  ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
		my $prepared_sql = $releaseDB_Handle->prepare($sql);
		my @recordSet   = dbExecutePreparedSelectSttmnt($prepared_sql);
		my %fieldTitleOrderHash = (
			"1:PID"                => "PID;Left;String;Descending",
			"2:FIRST_NAME"         => "FIRST_NAME;Left;String;Descending",
			"3:LAST_NAME"          => "LAST_NAME;Left;String;Ascending",
			"4:ROLE_NAME"          => "ROLE_NAME;Left;String;Descending",
			"5:ACTIVITY_NAME"      => "ACTIVITY_NAME;Left;String;Descending",
			"6:LEVEL_NAME"         => "LEVEL_NAME;Left;String;Descending",
			"7:MENU_FUNCTION_NAME" => "MENU_FUNCTION_NAME;Left;String;Descending",
		);
		displayArrayEnhanced($FALSE,$FALSE,"","\n",displayRecSetAsTable(\@recordSet, \%fieldTitleOrderHash,$TRUE,$TRUE, "","","","","\|","\n","","",$FALSE));
		my $recCount = @recordSet;
		print("\n   Records found:${recCount}\n");
		halt();
	}
}

sub getLoggedInUserName {
	my($pUserId, $pLevel, $format, $verbal)  = @_;
	$pUserId  = setDefault($pUserId, getLoggingUser($FALSE));
	$verbal   = setDefault($verbal, $FALSE);

	my @returnSet = ();
	if ($verbal) { 
		print("releaseDB_DbName   :${releaseDB_DbName}:\n");
		print("releaseDB_Username :${releaseDB_Username}:\n");
		print("releaseDB_Password :${releaseDB_Password}:\n");
	}

	if ($releaseDB_Handle eq "") { $releaseDB_Handle = dbConnect($releaseDB_DbName,$releaseDB_Username,$releaseDB_Password,"",$FALSE,$TRUE,$TRUE); }
	if (dbTablesExists_dbh($releaseDB_Handle, "USER_MENUFUNCTIONS_V")) {
		my $sql = qq {
			select distinct
				LAST_NAME,
				FIRST_NAME
			from
				USER_MENUFUNCTIONS_V
			where
				PID          = '${pUserId}'
		};
		if ($verbal) { print("---> getPriviligedMgmFunctions:  ${releaseDB_Username}/${releaseDB_Password}\@${releaseDB_DbName}\nSelect:\n${sql}\n"); }
		my $prepared_sql = $releaseDB_Handle->prepare($sql);
		my @recordSet   = dbExecutePreparedSelectSttmnt($prepared_sql);
		foreach my $aRec (@recordSet) {
			push(@returnSet,$aRec->{"FIRST_NAME"});
			if ($verbal) { print("--> ".$aRec->{"FIRST_NAME"}."\n"); }
			push(@returnSet,$aRec->{"LAST_NAME"});
			if ($verbal) { print("--> ".$aRec->{"LAST_NAME"}."\n"); }
		}

		if ($format eq "") {
			return @returnSet;
		} elsif ($format eq "First Last") {
			return ($returnSet[0]." ".$returnSet[1])
		}
	} else {
		return "";
	}

}

sub setToPkgTest {
	my $unixCmd = "export USE_LHPKGTEST=1";
	print("Exit lhManageComponent and type in...\n");
	print("${unixCmd}\n");halt();
	my $retMsg = `${unixCmd}`;
	return $retMsg;
}

sub setToPkgProd {
	my $unixCmd = "unset USE_LHPKGTEST";
	print("Exit lhManageComponent and type in...\n");
	print("${unixCmd}\n");halt();
	my $retMsg = `${unixCmd}`;
	return $retMsg;
}

sub isAccessControlEnabled {
	my($pLevel)  = @_;
	$pLevel      = setDefault($pLevel, $ENV{"CSG_LEVEL"});

	my $isEnabledStr = getParameter($pLevel, "AccessControl");
	print("isAccessControlEnabled::isEnabledStr:${isEnabledStr}:\n");

	return (uc($isEnabledStr) eq "TRUE");
}


return 1;