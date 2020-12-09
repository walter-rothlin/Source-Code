
# START------------------------------------------------------------------------
# Author:        Walter Rothlin
# Description:   Include file for all SI maintenance functions
#
#
# Calling:       siMaintenance.pm  (LIB)
#
# History:
# 01/21/99       V1.0   Walter Rothlin     First Version for Leuenberger
# 02/15/99       V1.1   Walter Rothlin     Using littlePerlLib
# 17-Apr-2015    V1.2   Walter Rothlin     Migrated to latest littlePerlLib and added new stuff
# 26-Apr-2015    V1.3   Walter Rothlin     Added Studenten Zugriff
#
# END--------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Common definitions
# -----------------------------------------------------------------------------
$debug                  = "FALSE";
$tabSepChr              = ";";
$keyFieldName           = "Hash";
$language               = $LangGerman;
$fullFunction           = $FALSE;
$qbeFunction            = $FALSE;
$dataDir                = "Daten/";
$datenPath              = $dataDir;
$templatesPath          = "Templates/";


# Definitions for password file
# -----------------------------
$passwordFile          = "${dataDir}passwordFile.flt";
$passwordSepChar       = ";";
$passwordHashFNam      = $keyFieldName;
$passwordModAtFNam     = "ModDate";
$passwordModByFNam     = "ModBy";
$passwordUserIdFNam    = "UserId";
$passwordPasswordFNam  = "Passwd";
$passwordPrivFNam      = "Privilege";
$useServerLogin        = $TRUE;    ### change here to use server login
$maintainHtPasswd      = $useServerLogin;
$privSep               = "&";
$passPath              = "$ENV{DOCUMENT_ROOT}/cgi-bin/SI";  # where to keep .htpasswd

$userIdFieldName    = $passwordUserIdFNam;
$passwordFieldName  = $passwordPasswordFNam;
$privFieldName      = $passwordPrivFNam;


$fontFace        = "face='helvetica,arial'";
$fontSizeDefault = "-2";

%spezFormat = (
           "ModDate"    => "Date",
		   "Privilege"  => "privilege",
 		  );

		  
$dirNormal   = "/hwz/cgi-bin/scripting";
$dirNormal_1 = "/hwz/studenten";

sub siNotAutorized {
	printf("Leider sind Sie fuer diese Funktion nicht berechtigt");
	printf (" <FORM> <INPUT TYPE=BUTTON  VALUE=\"Back to Login\" onClick=window.history.back()></FORM>\n");
}

sub displayFctOverview {
	my($privilege) = @_;
	print("<!-- displayFctOverview: privilege:${privilege}:-->\n");
	my $paramStr = "loginUserId=${loginUserId}&loginPassword=${loginPassword}&loginAction=Login";


	if (($privilege eq "normal") || ($privilege eq $ROOT_ID)) {
		print("<TABLE BORDER=0 cellpadding=\"3\" cellspacing=\"4\"><TR>\n");
		$privilege = getPrivileges($passwordFile,$tabSepChr,$loginUserId,$loginPassword,"passwordTool",$userIdFieldName,$passwordFieldName,$privFieldName,"&",$TRUE);
		if ($privilege eq $ROOT_ID) {
			## printf ("Privilege: ${privilege}\n");
			print("<TD>");
			makeFormLink("","Passwort Tool","","passwordTool.pl",$paramStr);
			print("</TD>");
		}
		$privilege = getPrivileges($passwordFile,$tabSepChr,$loginUserId,$loginPassword,"unixCommander",$userIdFieldName,$passwordFieldName,$privFieldName,"&",$TRUE);
		if ($privilege eq $ROOT_ID) {
			## printf ("Privilege: ${privilege}\n");
			print("<TD>");
			makeFormLink("","Unix-Commander","","unixCommander.pl",$paramStr);
			print("</TD>");
		}
		$privilege = getPrivileges($passwordFile,$tabSepChr,$loginUserId,$loginPassword,"fileEditor",$userIdFieldName,$passwordFieldName,$privFieldName,"&",$TRUE);
		if ($privilege eq $ROOT_ID) {
			## printf ("Privilege: ${privilege}\n");
			print("<TD>");
			makeFormLink("","File-Editor","","fileEditor.pl",$paramStr);
			print("</TD>");
		} elsif ($privilege eq "normal") {
			print("<TD>");
			makeFormLink("","File-Editor (${dirNormal})","","fileEditor.pl",$locParamList);
			print("</TD>");	
			print("<TD>");
			makeFormLink("","File-Editor (${dirNormal_1})","","fileEditor_1.pl",$locParamList);
			print("</TD>");	
		}
	
		$privilege = getPrivileges($passwordFile,$tabSepChr,$loginUserId,$loginPassword,"fileUploader",$userIdFieldName,$passwordFieldName,$privFieldName,"&",$TRUE);
		if ($privilege eq $ROOT_ID) {
			## printf ("Privilege: ${privilege}\n");
			print("<TD>");
			makeFormLink("","File Uploader","","fileUploader.pl",$paramStr);
			print("</TD>");
		} elsif ($privilege eq "normal") {	  
			print("</TR><TR><TD>");
			makeFormLink("","File Uploader (${dirNormal})","","fileUploader.pl",$paramStr);
			print("</TD>");
			print("<TD>");
			makeFormLink("","File Uploader (${dirNormal_1})","","fileUploader_1.pl",$paramStr);
			print("</TD>");	
		}
		# $privilege = getPrivileges($passwordFile,$tabSepChr,$loginUserId,$loginPassword,"updateStatistics",$userIdFieldName,$passwordFieldName,$privFieldName,"&",$TRUE);
		# if ($privilege eq $ROOT_ID) {
		# print("Privilege: ${privilege}\n");
		# print("<TD>");
		# makeFormLink("","Update Statistics","","updateStatistics.pl",$paramStr);
		# print("</TD>");
		# }
		# $privilege = getPrivileges($passwordFile,$tabSepChr,$loginUserId,$loginPassword,"releaseTool",$userIdFieldName,$passwordFieldName,$privFieldName,"&",$TRUE);
		# if ($privilege eq $ROOT_ID) {
		# print("Privilege: ${privilege}\n");
		# print("<TD>");
		# makeFormLink("","Release-Tool","","releaseTool.pl",$paramStr);
		# print("</TD>");
		# }
		$privilege = getPrivileges($passwordFile,$tabSepChr,$loginUserId,$loginPassword,"diskUsedTool",$userIdFieldName,$passwordFieldName,$privFieldName,"&",$TRUE);
		if ($privilege eq $ROOT_ID) {
			## print("Privilege: ${privilege}\n");
			print("</TR><TR><TD>");
			makeFormLink("","Disk-Used","","diskUsedTool.pl",$paramStr);
			print("</TD>");
		}
		$privilege = getPrivileges($passwordFile,$tabSepChr,$loginUserId,$loginPassword,"gifViewer",$userIdFieldName,$passwordFieldName,$privFieldName,"&",$TRUE);
		if ($privilege eq $ROOT_ID) {
			## print("Privilege: ${privilege}\n");
			print("<TD>");
			makeFormLink("","Gif-Viewer","","gifViewer.pl",$paramStr);
			print("</TD>");
		}
		print("</TR></TABLE>\n");
		print("<font size=\"-1\">Logged in as:<B>${loginUserId} (${privilege})</B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Last Updated:<B>".formatTimeStamp(getTimeStamp(), "", "", "", $language)."</B></font><BR/>\n");
	} else {
		siNotAutorized();
	}
}