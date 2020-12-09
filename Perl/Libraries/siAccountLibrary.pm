package main;        #has to be "main"

#
# START---------------------------------------------------------------------
# Author:        Walter Rothlin
# Description:   Framework for maintaining a "Doppelte-Buchhaltung" via web
#
#
# Calling:       siAccountLibrary.pm
#
# History:
# 08/13/99    V1.0  Walter Rothlin     Initial Version
# END-----------------------------------------------------------------------
#
############################################################################
# Do not make any local changes to that code. It will be overwritten by the
# next release. Please submit a change request to Walter.Rothlin@WriteMe.com
############################################################################
sub initModule_siAccountLibrary {
$siAccountLibrarySccsId        = "%W% %G% %U% %P%";
$siAccountLibraryLatestVersion = "V1.1";
$siAccountLibraryLibKey        = reverseStr("{XXXXyeKbilXXXX}");
############################################################################
# General definitions
############################################################################
$dateWithWeekday            = $FALSE;
$dateUseMonthByName         = $FALSE;
$currFormat                 = "curr:6.2";
$currCommaSep               = ".";
$currMilSep                 = "'";

$strOeffnen             = "Oeffnen";

$debug                  = "FALSE";
$tabSepChr              = ";";
$keyFieldName           = "Hash";
$modifyDateFieldName    = "ModDate";
$autoFireAutofilter     = $TRUE;

$funcBooking            = "1";
$funcAccountOpen        = "2";
$funcAccountChange      = "3";
$funcAccountDelete      = "4";
$funcBookingModify      = "5";
$funcBookingDelete      = "6";
$funcAccountReport      = "7";
$funcSettlementReport   = "8";
$funcJournal            = "9";
$funcDisplayAccountPlan = "10";
$funcCryptFiles         = "11";
$funcDecryptFiles       = "12";

$language       = getParam("language","$LangGerman");
$accountAction  = getParam("accountAction","");
$loginAction    = getParam("loginAction","");

$externalParam  = sprintf("language=${language}&accountAction=${accountAction}",);

$fullFunction  = $FALSE;
$builtInInsert = $TRUE;
$qbeFunction   = $FALSE;
$markAsDelete  = $TRUE;
$sortFunction  = $TRUE;
$autoFilter    = $TRUE;

$insertFunction= $TRUE;
$deleteFunction= $TRUE;
$modifyFunction= $TRUE;
$displayTable  = $TRUE;

$displayDetail = $TRUE;

%myTableAttr = (
         "Amount"       => "ALIGN=RIGHT",
         );

%spezFormat = (
          "ModDate"    => "Date",
          "Amount"     => $currFormat,
          "SollName"   => "userDefined:setSollName",
          "HabenName"  => "userDefined:setHabenName",
          "Text"       => "userDefined:setTextName:detailLink",
          );

%myFixedValues = (
       "ChangeBy"   => getParam("loginUserId",""),
       );

%bilanzHash = ();
$profit     = 0;
############################################################################
# Definitions for Journal
############################################################################
$journal_tabName    = "journal.flt";
$fullJournalTabName = "${dataDir}${journal_tabName}";
$fullJournalCryName = setNewFilenameExtension($fullJournalTabName,"cry");

%journal_Titles = (
         "Hash"      => "Hash",
         "ModDate"   => "Gebucht am",
         "ModBy"     => "Gebucht durch",
         "Text"      => "Buchungstext",
         "Amount"    => "Betrag",
         "Soll"      => "Soll",
         "SollName"  => "Soll",
         "Haben"     => "Haben",
         "HabenName" => "Haben",
         "Beleg"     => "Beleg",
         "Comment"   => "Kommentar",
         );

@journal_DisplayOrder            = ("ModDate","Text","Beleg","SollName","HabenName","Amount");
@journal_AutofilterFields        = ();
@journal_SorterFields            = ("ModDate","Text","Beleg","Amount");
@journal_DeleteNotificationOrder = ("ModDate","Text","Beleg","SollName","HabenName","Amount");
@journal_EditFieldOrder          = ("Hash","ModDate","Beleg","Text","Soll","SollName","Haben","HabenName","Amount","ModBy","Comment");
%journal_EditFieldFormat = (
       "ModDate"  => "static",
       "ModBy"    => "static",
       "Text"     => "30",
       "Soll"     => "1",  # will be overwritten
       "Haben"    => "1",  # will be overwritten
       "Amount"   => "15",
       "Beleg"    => "9",
       "Comment"  => "3*30",
       );

%journal_DefaultValues = (
       "ModDate"  => formatTimeStamp(getTimeStamp(), "",$dateWithWeekday,$dateUseMonthByName,$language),
       "ModBy"    => getParam("loginUserId",""),
       );

@kontoauszugDisplayFields   = ("ModDate","Text","Beleg","Amount");
$kontoauszugTitleFormat     = "<TD  bgcolor=silver>";

############################################################################
# Definitions for Kontoplan
############################################################################
$kontoplan_tabName    = "kontoplan.flt";
$fullKontoPlanTabName = "${dataDir}${kontoplan_tabName}";
$fullKontoPlanCryName = setNewFilenameExtension($fullKontoPlanTabName,"cry");



%kontoplan_Titles = (
         "Hash"      => "Hash",
         "ModDate"   => "Datum",
         "ModBy"     => "Geaendert durch",
         "Name"      => "Kontoname",
         "Nummer"    => "Konto-Nummer",
         "Art"       => "Konto-Art",
         "LiqRanc"   => "Verfuegbarkeit",
         );

@kontoplan_DisplayOrder            = ("Name","Nummer","Art","ModBy","ModDate");
@kontoplan_AutofilterFields        = ("Name","Nummer","Art","ModBy","ModDate");
@kontoplan_SorterFields            = ("Name","Nummer","Art","ModBy","ModDate");
@kontoplan_DeleteNotificationOrder = ("Name","Nummer","Art","ModBy","ModDate");
@kontoplan_EditFieldOrder          = ("Hash","Name","Nummer","Art","ModBy","ModDate","LiqRanc");
%kontoplan_EditFieldFormat = (
       "Name"       => "23",
       "Nummer"     => "9",
       "Art"        => "[Aktiv,Passiv,Aufwand,Ertrag]",
       "LiqRanc"    => "4",
       );

%kontoplan_DefaultValues = (
       );



%kontoplanNoNameHash      = ();
%kontoplanNameNoHash      = ();
%kontoplanArtHash         = ();
%kontoplanLiqRanc_No_Hash = ();
$kontoPlanLoaded          = $FALSE;

}

############################################################################
# Functions for Journal
############################################################################
sub switchTo_journal {
  $tabName                   = "${dataDir}${journal_tabName}";
  %myTitles                  = %journal_Titles;
  @myDisplayOrder            = @journal_DisplayOrder;
  @myAutofilterFields        = @journal_AutofilterFields;
  @mySorterFields            = @journal_SorterFields;
  @myDeleteNotificationOrder = @journal_DeleteNotificationOrder;
  @myEditFieldOrder          = @journal_EditFieldOrder;
  %myEditFieldFormat         = %journal_EditFieldFormat;
  %myDefaultValues           = %journal_DefaultValues;
  $insertTitleStr            = "Buchungs-Formular";
  $strInsert                 = "Buchen";
  loadAccountInfo();
}


sub displayAccount {
  my($priv,$accountNo,$from,$to) = @_;
  my($locWhereClause) = "Haben=${accountNo} OR Soll=${accountNo}";
  my(@userParam)    = ("0",$accountNo);
  printf("<TABLE cellspacing=\"3\"><TR><TD valign=\"top\">Kontoauszug:</TD><TD valign=\"top\">%s",getAccountName($accountNo));
  ## displayKontoSelector($priv,$TRUE,$accountNo);

  printf("</TD><TD valign=\"top\">(%s)</TD></TR></TABLE>\n",getAccountKind($accountNo));
  printf("<TABLE cellpadding=\"3\" cellspacing=\"3\" border=\"0\">\n");
  my($title) = "";
  printf("<TR>\n");
  foreach $title (@kontoauszugDisplayFields) {
     printf("  ${kontoauszugTitleFormat}%s</TD>\n",$journal_Titles{$title});
  }
  printf("</TR>\n");

  selectHashInFltFile("${dataDir}${journal_tabName}",$tabSepChr,$locWhereClause,"ModDate",$FALSE,\&displayAccountCbf,"",$FALSE,\@userParam);
  printf("<TR>\n");
  foreach $title (@kontoauszugDisplayFields) {
     if ($title eq "Text") {
        printf("  <TD><B>Total:</B></TD>\n");
     } elsif ($title eq "Amount") {
        printf("  <TD><B>%s</B></TD>\n",currFormat($userParam[0],2,"0",$currCommaSep,$currMilSep,$TRUE));
     } else {
        printf("  <TD></TD>\n");
     }
  }
  printf("</TR>\n");
  printf("</TABLE>\n");
}


sub displayAccountCbf {
  my($recCount, $refToRecord, $refUserParam) = @_;
  my(%aRecord) = derefHref($refToRecord);

  my $displayField  = "";
  my $aEntry        = "";
  my $leftAlign     = "";
  my $fontColor     = "";

  foreach $displayField (@kontoauszugDisplayFields) {
    my($aFieldStr) = "";
        $leftAlign     = "";
    if ($displayField eq "ModDate") {
        $aFieldStr = formatTimeStamp($aRecord{$displayField}, "",$dateWithWeekday,$dateUseMonthByName,$language);
    } elsif ($displayField eq "Amount") {
        my($localAmount) = $aRecord{$displayField};
        printf("<!-- Hash:%s: KontoArt:%s: KontoNr:%s: Soll-Konto:%s: Haben-Konto:%s:-->\n",$aRecord{"Hash"},getAccountKind($refUserParam->[1]),$refUserParam->[1],$aRecord{"Soll"},$aRecord{"Haben"});
        if ( ((getAccountKind($refUserParam->[1]) eq "Aktiv")   && ($refUserParam->[1] eq $aRecord{"Haben"})) ||
             ((getAccountKind($refUserParam->[1]) eq "Aufwand") && ($refUserParam->[1] eq $aRecord{"Haben"})) ||
             ((getAccountKind($refUserParam->[1]) eq "Passiv")  && ($refUserParam->[1] eq $aRecord{"Soll"} )) ||
             ((getAccountKind($refUserParam->[1]) eq "Ertrag")  && ($refUserParam->[1] eq $aRecord{"Soll"} ))
           )  {
           $localAmount = -1*$localAmount;
           $fontColor   = "<FONT color='red'>";
           printf("<!-- Negativ Amount:  ${localAmount} -->\n");
        }
        $aFieldStr = currFormat($localAmount,2,"0",$currCommaSep,$currMilSep,$TRUE);
        $refUserParam->[0] += $localAmount;
        $leftAlign = " align=\"right\"";
    } else {
        $aFieldStr = $aRecord{$displayField}
    }

    if ($aEntry eq "") {
        $aEntry = $aFieldStr;
    } else {
        $aEntry = "${aEntry}</TD><TD${leftAlign}>${fontColor}${aFieldStr}";
    }
  }
  ## $aEntry =~ s/;/\</TD\>\<TD\>/g;
  printf("  <TR><TD${leftAlign}>${aEntry}</TD></TR>\n");
}

sub setSollName {
  my($inVal) = @_;
  my($soll) = $parts[$colNameToIndex{"Soll"}];
  return sprintf ("%s",getAccountName($soll));
}

sub setHabenName {
  my($inVal) = @_;
  my($haben) = $parts[$colNameToIndex{"Haben"}];
  return sprintf ("%s",getAccountName($haben));
}


sub setTextName {
  my($inVal) = @_;
  my($hasComment) = ($parts[$colNameToIndex{"Comment"}] ne "");
  if ($hasComment) {
      return "<B>${inVal}</B>";
  } else {
      return $inVal;
  }
}

sub buchungsFormCheck {
print <<javaScript;
<script language="JavaScript">
function buchungsFormCheck(form) {
  if ((form.Amount.value.length == 0) || (isNaN(parseInt(form.Amount.value)))) {
     alert ("Kein Betrag oder flasche Zeichen eingegeben");
     form.Amount.focus();
     return (false);
  }
  if (form.Text.value.length < 3 ) {
     alert ("Buchungstext sollte mindestens 3 Buchstaben enthalten");
     form.Text.focus();
     return (false);
  }
  if (form.Soll.selectedIndex ==  form.Haben.selectedIndex) {
     alert ("Die Konti sollten unterschiedlich sein");
     form.Soll.focus();
     return (false);
  }

  return (true);
}
//-->
</SCRIPT>
javaScript
}

############################################################################
# Functions for Kontoplan
############################################################################
sub switchTo_kontoplan {
  $tabName                   = "${dataDir}${kontoplan_tabName}";
  %myTitles                  = %kontoplan_Titles;
  @myDisplayOrder            = @kontoplan_DisplayOrder;
  @myAutofilterFields        = @kontoplan_AutofilterFields;
  @mySorterFields            = @kontoplan_SorterFields;
  @myDeleteNotificationOrder = @kontoplan_DeleteNotificationOrder;
  @myEditFieldOrder          = @kontoplan_EditFieldOrder;
  %myEditFieldFormat         = %kontoplan_EditFieldFormat;
  %myDefaultValues           = %kontoplan_DefaultValues;
}

# returns a hash with all the account-infos according
# to the account name or account number
sub getAccountInfo {
  my($accountNumberOrName) = @_;
  my($locWhereClause) = "Name=${accountNumberOrName} OR Nummer=${accountNumberOrName}";
  return getSingleRecInHash("${dataDir}${kontoplan_tabName}",$tabSepChr,"",$locWhereClause,"",$FALSE);
}

sub loadAccountInfo {
  if (!$kontoPlanLoaded) {
    printf("<!-- loadAccountInfo starting to load -->\n");
    my(@kontoplanEntries) = getColumnValues("${dataDir}${kontoplan_tabName}",$tabSepChr,"Name;Nummer;Art;LiqRanc","","",$FALSE);
        my($aKontoDefRec) = "";
        foreach $aKontoDefRec (@kontoplanEntries) {
           my(@defRecParts) = split($tabSepChr,$aKontoDefRec);
           %kontoplanNoNameHash         = (%kontoplanNoNameHash,        ($defRecParts[1],$defRecParts[0]));
           %kontoplanNameNoHash         = (%kontoplanNameNoHash,        ($defRecParts[0],$defRecParts[1]));
           %kontoplanArtHash            = (%kontoplanArtHash,           ($defRecParts[0],$defRecParts[2]));
           %kontoplanArtHash            = (%kontoplanArtHash,           ($defRecParts[1],$defRecParts[2]));
           %kontoplanLiqRanc_No_Hash    = (%kontoplanLiqRanc_No_Hash,   ($defRecParts[3],$defRecParts[1]));
        }
        $kontoPlanLoaded     = $TRUE;
        printf("<!-- loaded done -->\n");
 }
}

sub getAccountKind {
   my($accountNoOrName) = @_;
   loadAccountInfo();
   return $kontoplanArtHash{$accountNoOrName};
}

sub getAccountName {
   my($accountNo) = @_;
   loadAccountInfo();
   return $kontoplanNoNameHash{$accountNo};
}

sub getAccountNo {
   my($accountName) = @_;
   loadAccountInfo();
   return $kontoplanNameNoHash{$accountName};
}

sub displayKontoSelector {
   my($priv,$autoFire,$selected) = @_;
   $autoFire = setDefault($autoFire,$TRUE);
   $selected = setDefault($selected,$FIRST);

   my(@kontos) = getColumnValues("${dataDir}${kontoplan_tabName}",$tabSepChr,"Nummer;Name","","Art;Nummer",$FALSE);
   printf("<TABLE><TR><TD valign=\"top\"><FORM Name=\"KontoSelection\" METHOD=POST ACTION=${myCgiFormName}>\n");
   printf("%s</TD><TD valign=\"top\">\n",getSelectorWidgetForValueTextPair($tabSepChr,1,"accountName",$selected,$autoFire,@kontos));
   if (!$autoFire) {
      if ($siAccLibGifAccRep eq "") {
          printf ("<BR><INPUT TYPE=SUBMIT Name=submitted          VALUE=\"$strOeffnen\">\n");
      } else {
          printf("<A HREF=\"javascript:document.KontoSelection.submit()\"><IMG SRC=\"${siAccLibGifAccRep}\" alt=\"Kontoauszug\" border=0></A>\n");
      }
   }
   printf ("</TD></TR></TABLE><INPUT TYPE=HIDDEN Name=accountAction      VALUE=\"${funcAccountReport}\" >\n");
   printf ("<INPUT TYPE=HIDDEN Name=loginUserId        VALUE=\"${loginUserId}\" >\n");
   printf ("<INPUT TYPE=HIDDEN Name=loginPassword      VALUE=\"${loginPassword}\">\n");
   printf ("<INPUT TYPE=HIDDEN Name=loginAction        VALUE=\"Login\">\n");
   printf("</FORM>\n");
}

############################################################################
# Functions for aspecial filters
############################################################################
sub createKontoSelectorRegeln {
    my(@kontos)  = @_;
    my(@retVal)  = ();
    my($aEntry)  = "";

    foreach $aEntry (@kontos) {
        push(@retVal,sprintf("Soll=%s OR Haben=%s",$aEntry,$aEntry));
    }
    return @retVal;
}

############################################################################
# Functions for accounting managment
############################################################################
sub manageAccounting {
  my($priv) = @_;
  my($isShowFunction) = $TRUE;
  $isCrypted = $FALSE;
  if (isFileExists($fullJournalCryName) && isFileExists($fullKontoPlanCryName)) {
     $isCrypted = TRUE;
     if (($accountAction eq  $funcDecryptFiles)    && (isFunctionGranted($priv))) {
       $entredKey  = getParam("CryptKey","");
       if ($entredKey eq $cryptKey) {
          cryptUNIXFile($fullKontoPlanCryName,$fullKontoPlanTabName,$cryptKey,$TRUE);
          cryptUNIXFile($fullJournalCryName,$fullJournalTabName,$cryptKey,$TRUE);
          $isCrypted = $FALSE;
       } else {
          sendMailwithAttachments("Walter\@Rothlin.com",$alertEmailAdr,"ALERT Einbruchversuch bei ${myCgiFormName}",$alertMsg,"",$ccAdr,$bccAdr);
          printf("<font color=red>Key war falsch!!</font><BR> Die Daten wurden zerstört und eine Alarm Meldung abgesetzt<BR><BR>");
       }
     }
  } 

  if (!($isCrypted)) {
  if (($accountAction eq $funcBooking) && (isFunctionGranted($priv))) {
       switchTo_journal();
       $deleteFunction= $FALSE;
       $modifyFunction= $FALSE;
       $displayTable  = $FALSE;
       setNextBelegNr();
       setKontoSelektor();
       $checkInsertModformJS = "buchungsFormCheck";
       $insertTemplateName = $journal_insertTemplateName;
       prepareHTML_StandardFormForIt();
 } elsif (($accountAction eq  $funcJournal)      && (isFunctionGranted($priv))) {
       switchTo_journal();
       $deleteFunction= $FALSE;
       $modifyFunction= $FALSE;
       $displayDetail = $FALSE;
       $insertFunction= $FALSE;
       $autoFilter    = $FALSE;

       $detailViewWidth  = $journal_detailViewWidth;
       $detailViewHeight = $journal_detailViewHeight;
       $showDetailTemplateName = $journal_showDetailTemplateName;

       # Add some special filters
       if (!(((index($action,"For") == 0) || ($action eq "ShowDetail")))) {
         printf("<TABLE cellspacing=3><TR>\n");
         loadAccountInfo();
         my(%extParam) = ("accountAction",$accountAction);
         my(@kontos) = keys %kontoplanNoNameHash;
         my(@regeln) = createKontoSelectorRegeln(@kontos);
         my(@kontoNames) = ();
         foreach my $aKontoNo (@kontos) {
           push(@kontoNames,$kontoplanNoNameHash{$aKontoNo});
         }
         printf("<TD valign=\"top\">Konto-Auswahl:</TD><TD valign=\"top\">\n");
         addSpezFilterSelector("KontoSelector",\@kontoNames,\@regeln,$myCgiFormName,$language,\%extParam);

         ## printf("</TD></TR><TR><TD valign=\"top\">Buchungstext:</TD><TD valign=\"top\">\n");
         ## my(@searchFieldNames) = ("Text");
         ## addSpezFilterSearchBox("SearchFilter",$myCgiFormName,$language,\@searchFieldNames,"like",$TRUE,\%extParam);

         ## printf("</TD></TR><TR><TD valign=\"top\">Betrags-Limite:</TD><TD valign=\"top\">\n");
         ## my($aWhereClause) = "Amount gt ' + %s";
         ## addSpezFilterTextbox("BetragsFilter",$myCgiFormName,$language,$aWhereClause,$FALSE,$FALSE,\%extParam);
         printf("</TD></TR></TABLE>\n");
       }
       prepareHTML_StandardFormForIt();
 } elsif (($accountAction eq  $funcAccountOpen)      && (isFunctionGranted($priv))) {
       switchTo_kontoplan();
       $deleteFunction= $FALSE;
       $modifyFunction= $FALSE;
       $displayTable  = $FALSE;
       $displayDetail = $TRUE;

       prepareHTML_StandardFormForIt();
 } elsif (($accountAction eq  $funcAccountChange)    && (isFunctionGranted($priv))) {
       switchTo_kontoplan();
       $deleteFunction= $FALSE;
       $displayDetail = $FALSE;
       $insertFunction= $FALSE;

       prepareHTML_StandardFormForIt();
  } elsif (($accountAction eq  $funcDisplayAccountPlan)    && (isFunctionGranted($priv))) {
       switchTo_kontoplan();
       $deleteFunction= $FALSE;
       $displayDetail = $FALSE;
       $insertFunction= $FALSE;
       $modifyFunction= $FALSE;

       prepareHTML_StandardFormForIt();
  } elsif (($accountAction eq  $funcAccountDelete)    && (isFunctionGranted($priv))) {
       switchTo_kontoplan();
       $displayDetail = $FALSE;
       $insertFunction= $FALSE;

       prepareHTML_StandardFormForIt();
  } elsif (($accountAction eq  $funcBookingModify)    && (isFunctionGranted($priv))) {
       switchTo_journal();
       $deleteFunction= $FALSE;
       $insertFunction= $FALSE;
       @myAutofilterFields        = ("ModDate","Text","Beleg","Soll","Haben","Amount");
       setKontoSelektor();
       $checkInsertModformJS = "buchungsFormCheck";

       $detailViewWidth  = $journal_detailViewWidth;
       $detailViewHeight = $journal_detailViewHeight;
       $showDetailTemplateName = $journal_showDetailTemplateName;

       $modifyTemplateName = $journal_modifyTemplateName;

       prepareHTML_StandardFormForIt();
  } elsif (($accountAction eq  $funcBookingDelete)    && (isFunctionGranted($priv))) {
       switchTo_journal();
       $insertFunction= $FALSE;
       @myAutofilterFields        = ("ModDate","Text","Beleg","Soll","Haben","Amount");

       $detailViewWidth  = $journal_detailViewWidth;
       $detailViewHeight = $journal_detailViewHeight;
       $showDetailTemplateName = $journal_showDetailTemplateName;

       $modifyTemplateName = $journal_modifyTemplateName;

       prepareHTML_StandardFormForIt();
  } elsif (($accountAction eq  $funcAccountReport)    && (isFunctionGranted($priv))) {
       $accountName  = getParam("accountName","");
       if ($accountName eq "") {
          displayKontoSelector($priv,$TRUE,"");
          $isShowFunction = $FALSE;
       } else {
          displayAccount($priv,$accountName,$from,$to);
       }
  } elsif (($accountAction eq  $funcCryptFiles)    && (isFunctionGranted($priv))) {
       cryptUNIXFile($fullKontoPlanTabName,$fullKontoPlanCryName,$cryptKey,$TRUE);
       cryptUNIXFile($fullJournalTabName,$fullJournalCryName,$cryptKey,$TRUE);
       $isCrypted = TRUE;
  } elsif (($accountAction eq  $funcSettlementReport) && (isFunctionGranted($priv))) {
       displaySettlement($priv);
  }
  } ## end crypted part
  if (($isShowFunction) && ($action ne "ShowDetail")) {
    displayFunctions($priv,$isCrypted);
  }
}




sub displayFunctions {
   my($priv,$isCrypted) = @_;
   printf("<HR><BR>\n");
   printf("<BR>\n");
   if (!($isCrypted)) {
   if ($siAccLibGifBuchen eq "") {
      printf("<A HREF=\"${myCgiFormName}?accountAction=${funcBooking}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Buchung machen</A> \n");
   } else {
      printf("<A HREF=\"${myCgiFormName}?accountAction=${funcBooking}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\"><IMG SRC=\"${siAccLibGifBuchen}\" alt=\"Buchung machen\" border=0></A> \n");
   }
   if ($siAccLibGifJournal eq "") {
      printf("<A HREF=\"${myCgiFormName}?accountAction=${funcJournal}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Journal</A> \n");
   } else {
      printf("<A HREF=\"${myCgiFormName}?accountAction=${funcJournal}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\"><IMG SRC=\"${siAccLibGifJournal}\" alt=\"Journal\" border=0></A> \n");
   }
   if ($siAccLibGifSettlRep eq "") {
      printf("<A HREF=\"${myCgiFormName}?accountAction=${funcSettlementReport}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Bilanz</A> \n");
   } else {
      printf("<A HREF=\"${myCgiFormName}?accountAction=${funcSettlementReport}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\"><IMG SRC=\"${siAccLibGifSettlRep}\" alt=\"Bilanz\" border=0></A> \n");
   }
   printf("<BR>\n");
   printf("<TABLE cellspacing=\"3\"><TR><TD>\n");
   printf("</TD><TD>");
   displayKontoSelector($priv,$FALSE,"");
   printf("</TD></TR></TABLE>\n");
   printf("<BR>\n");
   printf("<A HREF=\"${myCgiFormName}?accountAction=${funcDisplayAccountPlan}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Konto-Plan anschauen</A> \n");
   printf("<A HREF=\"${myCgiFormName}?accountAction=${funcAccountOpen}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Konto eroeffnen</A> \n");
   printf("<A HREF=\"${myCgiFormName}?accountAction=${funcAccountChange}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Konto aendern</A> \n");
   printf("<A HREF=\"${myCgiFormName}?accountAction=${funcAccountDelete}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Konto loeschen</A> \n");
   printf("<BR>\n");
   printf("<A HREF=\"${myCgiFormName}?accountAction=${funcBookingModify}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Buchung aendern</A> \n");
   printf("<A HREF=\"${myCgiFormName}?accountAction=${funcBookingDelete}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Buchung loeschen</A> \n");
   printf("<BR>\n");
   printf("<A HREF=\"${myCgiFormName}?accountAction=${funcCryptFiles}&loginUserId=${loginUserId}&loginPassword=${loginPassword}\">Crypte Files</A> \n");
   } else {

   printf("<TABLE><TR><TD valign=\"top\"><FORM Name=\"KontoSelection\" METHOD=POST ACTION=${myCgiFormName}>\n");
   printf("%s</TD><TD valign=\"top\">\n");
   printf ("<INPUT TYPE=TEXT name=\"CryptKey\" size=\"30\" value=\"\">");
   printf ("<BR><INPUT TYPE=SUBMIT Name=submitted          VALUE=\"Decrypt\">\n");
   printf ("</TD></TR></TABLE><INPUT TYPE=HIDDEN Name=accountAction      VALUE=\"${funcDecryptFiles}\" >\n");
   printf ("<INPUT TYPE=HIDDEN Name=loginUserId        VALUE=\"${loginUserId}\" >\n");
   printf ("<INPUT TYPE=HIDDEN Name=loginPassword      VALUE=\"${loginPassword}\">\n");
   printf ("<INPUT TYPE=HIDDEN Name=loginAction        VALUE=\"Login\">\n");
   printf("</FORM>\n");
   }
   printf("<BR>\n");
}


sub isFunctionGranted {
   my($priv) = @_;

   return $TRUE;
}

sub calculateSettlementCbf {
  my($recCount, $refToRecord, $refUserParam) = @_;
  my(%aRecord) = derefHref($refToRecord);
  my($amount)   = $aRecord{"Amount"};
  my($sollAcc)  = $aRecord{"Soll"};
  my($habenAcc) = $aRecord{"Haben"};
  if (exists($bilanzHash{$sollAcc})) {
      $bilanzHash{$sollAcc} = $bilanzHash{$sollAcc} + $amount;
  } else {
      %bilanzHash = (%bilanzHash,($sollAcc,$amount));
  }


  if (exists($bilanzHash{$habenAcc})) {
      $bilanzHash{$habenAcc} = $bilanzHash{$habenAcc} - $amount;
  } else {
      %bilanzHash = (%bilanzHash,($habenAcc,-1*$amount));
  }
}

sub calculateProfit {
   my(@accountNoList) = (); @accountNoList = keys %bilanzHash;
   my($aAccountNo)    = "";
   foreach $aAccountNo (@accountNoList) {
      if ((getAccountKind($aAccountNo) eq "Aktiv") || (getAccountKind($aAccountNo) eq "Passiv")) {
            $profit += $bilanzHash{$aAccountNo};
          }
   }
}

sub displaySettlement {
   my($priv) = @_;
   selectHashInFltFile("${dataDir}${journal_tabName}",$tabSepChr,"","",$FALSE,\&calculateSettlementCbf,"",$FALSE);
   calculateProfit();


   my @sortedAccNoList = ();
   foreach my $aKey (sort(keys %kontoplanLiqRanc_No_Hash)) {
     if ($aKey ne "") {
        push(@sortedAccNoList,$kontoplanLiqRanc_No_Hash{$aKey});
     }
   }
   my @allAccountNoList = (); @allAccountNoList = keys %bilanzHash;
   my @accountNoList    = getUnionOfArrays(\@sortedAccNoList,\@allAccountNoList);

   my($aAccountNo)    = "";

   printf("<TABLE cellpadding=\"3\" cellspacing=\"3\" border=2>\n");
   printf("<TR><TD bgcolor=\"teal\"><FONT color=\"silver\"><CENTER>Bilanz\n");
   printf("  <TABLE cellpadding=\"5\" cellspacing=\"5\" border=0>\n");
   printf("  <TR><TD valign=\"top\"><FONT color=\"white\"><CENTER><U>Aktiv</U>\n");
   printf("    <TABLE cellpadding=\"3\" cellspacing=\"3\" border=0>\n");
   foreach $aAccountNo (@accountNoList) {
      if (getAccountKind($aAccountNo) eq "Aktiv") {
        my($amount) = $bilanzHash{$aAccountNo};
        printf("    <TR><TD><FONT color=\"yellow\">%s</TD><TD align=\"right\"><FONT color=\"yellow\">%s</TD></TR>\n",getAccountName($aAccountNo),currFormat($amount,2,"0",$currCommaSep,$currMilSep,$TRUE));
      }
   }
   if ($profit < 0) {
     printf("    <TR><TD><FONT color=\"red\"><B>Verlust</B></TD><TD align=\"right\"><FONT color=\"red\"><B>%s</B></TD></TR>\n",currFormat(-1*$profit,2,"0",$currCommaSep,$currMilSep,$TRUE));
   }
   printf("    </TABLE>\n");
   printf("  </CENTER></TD>\n");
   printf("  <TD valign=\"top\"><FONT color=\"white\"><CENTER><U>Passiv</U>\n");
   printf("    <TABLE cellpadding=\"3\" cellspacing=\"3\" border=0>\n");
   foreach $aAccountNo (@accountNoList) {
     if (getAccountKind($aAccountNo) eq "Passiv") {
      my($amount) = $bilanzHash{$aAccountNo};
      $amount = -1*$amount;
      printf("    <TR><TD><FONT color=\"yellow\">%s</TD><TD align=\"right\"><FONT color=\"yellow\">%s</TD></TR>\n",getAccountName($aAccountNo),currFormat($amount,2,"0",$currCommaSep,$currMilSep,$TRUE));
     }
   }
   if ($profit > 0) {
     printf("    <TR><TD><FONT color=\"yellow\"><B>Reingewinn</B></TD><TD align=\"right\"><FONT color=\"yellow\"><B>%s</B></TD></TR>\n",currFormat($profit,2,"0",$currCommaSep,$currMilSep,$TRUE));
   }
   printf("    </TABLE>\n");
   printf("  </CENTER></TD></TR>\n");
   printf("  </TABLE>\n");
   printf("</CENTER></TD></TR>\n");

   printf("<TR><TD bgcolor=\"olive\"><FONT color=\"silver\"><CENTER>Erfolgsrechnung\n");
   printf("  <TABLE cellpadding=\"5\" cellspacing=\"5\" border=0>\n");
   printf("  <TR><TD valign=\"top\"><FONT color=\"white\"><CENTER><U>Aufwand</U>\n");
   printf("    <TABLE cellpadding=\"3\" cellspacing=\"3\" border=0>\n");
   foreach $aAccountNo (@accountNoList) {
      if (getAccountKind($aAccountNo) eq "Aufwand") {
            my($amount) = $bilanzHash{$aAccountNo};
        printf("    <TR><TD><FONT color=\"yellow\">%s</TD><TD align=\"right\"><FONT color=\"yellow\">%s</TD></TR>\n",getAccountName($aAccountNo),currFormat($amount,2,"0",$currCommaSep,$currMilSep,$TRUE));
          }
   }
   if ($profit > 0) {
     printf("    <TR><TD><FONT color=\"yellow\"><B>Reingewinn</B></TD><TD align=\"right\"><FONT color=\"yellow\"><B>%s</B></TD></TR>\n",currFormat($profit,2,"0",$currCommaSep,$currMilSep,$TRUE));
   }
   printf("    </TABLE>\n");
   printf("  </CENTER></TD>\n");
   printf("  <TD valign=\"top\"><FONT color=\"white\"><CENTER><U>Ertrag</U>\n");
   printf("    <TABLE cellpadding=\"3\" cellspacing=\"3\" border=0>\n");
   foreach $aAccountNo (@accountNoList) {
      if (getAccountKind($aAccountNo) eq "Ertrag") {
            my($amount) = $bilanzHash{$aAccountNo};
                $amount = -1*$amount;
        printf("    <TR><TD><FONT color=\"yellow\">%s</TD><TD align=\"right\"><FONT color=\"yellow\">%s</TD></TR>\n",getAccountName($aAccountNo),currFormat($amount,2,"0",$currCommaSep,$currMilSep,$TRUE));
          }
   }
   if ($profit < 0) {
     printf("    <TR><TD><FONT color=\"red\"><B>Verlust</B></TD><TD align=\"right\"><FONT color=\"red\"><B>%s</B></TD></TR>\n",currFormat(-1*$profit,2,"0",$currCommaSep,$currMilSep,$TRUE));
   }
   printf("    </TABLE>\n");
   printf("  </CENTER></TD></TR>\n");
   printf("  </TABLE>\n");
   printf("</CENTER></TD></TR>\n");
   printf("</TABLE>\n");
}

sub setNextBelegNr {
  my(@belegNumbers) = getColumnValues("${dataDir}${journal_tabName}",$tabSepChr,"Beleg","","",$TRUE);
  my($belegNr) = getMaxValFromArray(@belegNumbers);
  $belegNr++;

  if (exists($myDefaultValues{"Beleg"})) {
      $myDefaultValues{"Beleg"} = $belegNr;
  } else {
      %myDefaultValues = (%myDefaultValues,("Beleg",$belegNr));
  }
}

sub setKontoSelektor {
   loadAccountInfo();
   my(@kontoNumbers) = keys %kontoplanNoNameHash;
   my($aKontoNo)     = "";
   my($editFormatstr)= "";

   foreach $aKontoNo (sort @kontoNumbers) {
      if ($editFormatstr eq "") {
         $editFormatstr = $aKontoNo.";".$kontoplanNoNameHash{$aKontoNo};
      } else {
         $editFormatstr = "${editFormatstr},${aKontoNo};".$kontoplanNoNameHash{$aKontoNo};
      }
   }
   %myEditFieldFormat = (%myEditFieldFormat,("Haben","[${editFormatstr}]"));
   %myEditFieldFormat = (%myEditFieldFormat,("Soll", "[${editFormatstr}]"));
}

return 1;