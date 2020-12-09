
package main;        #has to be "main"

# %W% %G% %U% %P%

#
# START------------------------------------------------------------------------
# Author:        Walter Rothlin
# Description:   This contains all definitions used for Primarschule Wangen
#
#
# Calling:       psApplication.pm
#
# History:
# 05/08/08    V1.0   Walter Rothlin	    First Version
# 09/14/08    V1.1   Walter Rothlin     Add Comment
# 09/15/08    V1.2   Walter Rothlin     Add circularEmail
#
# END--------------------------------------------------------------------------
$psApplication_Version = "V1.2";
$psApplication_sccsId  = "%W% %G% %U%";
# -----------------------------------------------------------------------------

$sendMailPath      = "/usr/sbin/";
$useMailxAsDefault = $FALSE;

# Common definitions
# ------------------
$keyFieldName          = "Hash";
$dataDir               = "$ENV{DOCUMENT_ROOT}/cgi-bin/ps/Protected/Data/";
$templateDir           = "$ENV{DOCUMENT_ROOT}/cgi-bin/ps/Protected/Templates/";
$htmlHomeDir           = "$ENV{DOCUMENT_ROOT}/ps/";
$menuTreeDir           = "$ENV{DOCUMENT_ROOT}/ps/Menu/";
$menuTreeDir           = "$ENV{DOCUMENT_ROOT}/ps/Menu/";
$SSI_PATH              = "$ENV{DOCUMENT_ROOT}/formate";
$usePubUpMenus         = $TRUE;
$menuTreeTXT           = "menuTree.txt";
$menuTreeTXT_Full      = "${menuTreeDir}${menuTreeTXT}";
$useServerLogin        = $TRUE;    # Bei setzen auf FALSE delete the .htaccess file in the directory
$psDefaultLang         = $LangGerman;
$DefaultLang           = $psDefaultLang;
$fontSizeDefault       = "-1"; 
$fontFace              = "face='Arial, Helvetica, sans-serif' color='#000000'";
$tableFormatBig        = "<TABLE border=${DefaultTableBorder} cellpadding=${DefaultTableCellPadding} cellspacing=${DefaultTableCellSpacing} BGCOLOR='ffffff'>";
$emailPwdEnabled       = $TRUE;
$browserWindowTitle    = "Primarschule-Wangen";
$HTML_Title            = "Primarschule-Wangen";

# Application Names
# -----------------
$baseUrlProtected             = "www.pswangensz.ch/cgi-bin/ps/Protected";
$addressManagerTool           = "addressManager.pl";
$newsManager                  = "newsManager.pl";
$registerListControl          = "registerListControl.pl";
$registerList                 = "registerList.pl";
$einsatzplanManager           = "einsatzplanManager.pl";
$einsatzplaner                = "einsatzplaner.pl";
$einsatzManagerForRollen      = "einsatzManagerForRollen.pl";
$einsatzManagerForDatum       = "einsatzManagerForDatum.pl";
$veranstaltungsManager        = "veranstaltungsManager.pl";
$circularEmailDefinitions     = "circularEmailDefinitions.pl";


# Definitions for address manager
# -------------------------------
$addressTable        = "${dataDir}address.flt";
$addressTableSepChar = "\\|";
$addrTbl_Hash        = $keyFieldName;
$addrTbl_Anschreiben = "Anschreiben";
$addrTbl_Sex         = "Geschlecht";
$addrTbl_Name        = "Nachname";
$addrTbl_Vorname     = "Vorname";
$addrTbl_Strasse     = "Strasse";
$addrTbl_PLZ         = "PLZ";
$addrTbl_Ort         = "Ort";
$addrTbl_Land        = "Land";
$addrTbl_Email       = "Email";
$addrTbl_EmailSchule = "Email_Schule";
$addrTbl_TelP        = "TEL_P";
$addrTbl_TelG        = "TEL_G";
$addrTbl_Natel       = "NATEL";
$addrTbl_FaxP        = "FAX_P";
$addrTbl_FaxG        = "FAX_G";
$addrTbl_GebDate     = "Geburt";
$addrTbl_EntryDate   = "Eintritt";
$addrTbl_HeimatOrt   = "HeimatOrt";
$addrTbl_AHV         = "AHV";
$addrTbl_UserId      = "UserId";
$addrTbl_Password    = "Password";
$addrTbl_Privilege   = "Privilege";
$addrTbl_ModBy       = "ModBy";
$addrTbl_ModDate     = "MutDatum";
$addrTbl_IstLehrer   = "IstLehrer";
$addrTbl_IsSchulrat  = "IstSchulrat";
$addrTbl_Klassen     = "Klassen";
$addrTbl_IsTeilzeit  = "Teilzeit";
$addrTbl_Zustaendigkeit   = "Zustaendigkeit";
$addrTbl_Funktion    = "Funktion";
$addrTbl_Comment     = "Bemerkungen";
$addrTbl_MyPicture   = "MyPicture";
$addrTbl_Location    = "Location";


%addrTbl_Titles  = (
  $addrTbl_Hash        => "Hash",
  $addrTbl_Anschreiben => "Anschreiben",
  $addrTbl_Sex         => "Geschlecht",
  $addrTbl_Name        => "Nachname",
  $addrTbl_Vorname     => "Vorname",
  $addrTbl_Strasse     => "Strasse",
  $addrTbl_PLZ         => "PLZ",
  $addrTbl_Ort         => "Ort",
  $addrTbl_Land        => "Land",
  $addrTbl_Email       => "Email",
  $addrTbl_EmailSchule => "Email Schule",
  $addrTbl_TelP        => "TEL_P",
  $addrTbl_TelG        => "TEL_G",
  $addrTbl_Natel       => "NATEL",
  $addrTbl_FaxP        => "FAX_P",
  $addrTbl_FaxG        => "FAX_G",
  $addrTbl_GebDate     => "Geburt",
  $addrTbl_EntryDate   => "Eintritt",
  $addrTbl_HeimatOrt   => "HeimatOrt",
  $addrTbl_AHV         => "AHV",
  $addrTbl_UserId      => "UserId",
  $addrTbl_Password    => "Passwort",
  $addrTbl_Privilege   => "Privilege",
  $addrTbl_ModBy       => "ModBy",
  $addrTbl_ModDate     => "MutDatum",
  $addrTbl_IstLehrer   => "Lehrer",
  $addrTbl_IsSchulrat  => "Schulrat",
  $addrTbl_Klassen     => "Klassen",
  $addrTbl_IsTeilzeit  => "Teilzeit",
  $addrTbl_Zustaendigkeit   => "Zustaendigkeit",
  $addrTbl_Funktion    => "Funktion",
  $addrTbl_Comment     => "Bemerkungen",
  $addrTbl_MyPicture   => "MyPicture [300x400 Hoch]",
  "AddressRecord"      => "Adresse",
  $addrTbl_Location    => "Schulhaus",
);

%addrTbl_EditFieldFormat_Root = (
  $addrTbl_Anschreiben => "[Post,Mail,Nein]",
  $addrTbl_Sex         => "[Frau,Herr,Verein,Firma]",
  $addrTbl_Name        => "20",
  $addrTbl_Vorname     => "20",
  $addrTbl_Strasse     => "20",
  $addrTbl_PLZ         => "5",
  $addrTbl_Ort         => "20",
  $addrTbl_Land        => "4",
  $addrTbl_Email       => "30",
  $addrTbl_EmailSchule => "30",
  $addrTbl_TelP        => "15",
  $addrTbl_TelG        => "15",
  $addrTbl_Natel       => "15",
  $addrTbl_FaxP        => "15",
  $addrTbl_FaxG        => "15",
  $addrTbl_GebDate     => "10",
  $addrTbl_EntryDate   => "10",
  $addrTbl_HeimatOrt   => "30",
  $addrTbl_AHV         => "20",
  $addrTbl_UserId      => "20",
  $addrTbl_Password    => "20",
  $addrTbl_Privilege   => "10*50",
  $addrTbl_IstLehrer   => "[Ja,Nein]",
  $addrTbl_IsSchulrat  => "[Ja,Nein]",
  $addrTbl_Klassen     => "30",
  $addrTbl_IsTeilzeit  => "[Ja,Nein]",
  $addrTbl_Zustaendigkeit   => "30",
  $addrTbl_Funktion    => "30",
  $addrTbl_Comment     => "10*50",
  $addrTbl_MyPicture   => "60",
  $addrTbl_Location    => "20",
);



%addrTbl_EditFieldFormat_Normal = (
    $addrTbl_Anschreiben => "[Post,Mail,Nein]",
    $addrTbl_Sex         => "static",
    $addrTbl_Name        => "static",
    $addrTbl_Vorname     => "static",
    $addrTbl_Strasse     => "20",
    $addrTbl_PLZ         => "5",
    $addrTbl_Ort         => "20",
    $addrTbl_Land        => "4",
    $addrTbl_Email       => "30",
    $addrTbl_EmailSchule => "30",
    $addrTbl_TelP        => "15",
    $addrTbl_TelG        => "15",
    $addrTbl_Natel       => "15",
    $addrTbl_FaxP        => "15",
    $addrTbl_FaxG        => "15",
    $addrTbl_GebDate     => "static",
    $addrTbl_EntryDate   => "static",
    $addrTbl_HeimatOrt   => "30",
    $addrTbl_AHV         => "20",
    $addrTbl_UserId      => "static",
    $addrTbl_Password    => "20",
    $addrTbl_Privilege   => "static",
    $addrTbl_IstLehrer   => "static",
    $addrTbl_IsSchulrat  => "static",
    $addrTbl_Klassen     => "30",
    $addrTbl_IsTeilzeit  => [Ja,Nein],
    $addrTbl_Zustaendigkeit   => "30",
    $addrTbl_Funktion    => "30",
    $addrTbl_Comment     => "10*50",
    $addrTbl_MyPicture   => "60",
    $addrTbl_Location    => "20",
);

@addrTbl_DisplayOrder = (
  $addrTbl_Sex,
  $addrTbl_Name,
  $addrTbl_IstLehrer,
  $addrTbl_IsSchulrat,
  $addrTbl_IsTeilzeit,
  "AddressRecord",
  $addrTbl_Zustaendigkeit,
  $addrTbl_Funktion,
  $addrTbl_ModBy,
  $addrTbl_ModDate,
);

@addrTbl_SorterFields = (
  $addrTbl_Sex,
  $addrTbl_Name,
  $addrTbl_IstLehrer,
  $addrTbl_IsSchulrat,
  $addrTbl_IsTeilzeit,
  $addrTbl_ModBy,
  $addrTbl_ModDate,
);

@addrTbl_AutofilterFileds = (
  $addrTbl_Sex,
  $addrTbl_IstLehrer,
  $addrTbl_IsSchulrat,
  $addrTbl_IsTeilzeit,
  ## $addrTbl_Funktion,
  $addrTbl_ModBy,
);

@addrTbl_DeleteNotificationOrder = (
  $addrTbl_Name,
  $addrTbl_Vorname,
  $addrTbl_Strasse,
  $addrTbl_PLZ,
  $addrTbl_Ort,
);

@addrTbl_EditFieldOrder  = (
  $addrTbl_Hash,
  $addrTbl_Anschreiben,
  $addrTbl_Sex,
  $addrTbl_Name,
  $addrTbl_Vorname,
  $addrTbl_Strasse,
  $addrTbl_PLZ,
  $addrTbl_Ort,
  $addrTbl_Land,
  $addrTbl_Email,
  $addrTbl_EmailSchule,
  $addrTbl_TelP,
  $addrTbl_TelG,
  $addrTbl_Natel,
  $addrTbl_FaxP,
  $addrTbl_FaxG,
  $addrTbl_GebDate,
  $addrTbl_EntryDate,
  $addrTbl_HeimatOrt,
  $addrTbl_AHV,
  $addrTbl_UserId,
  $addrTbl_Password,
  $addrTbl_Privilege,
  $addrTbl_ModBy,
  $addrTbl_ModDate,
  $addrTbl_IstLehrer,
  $addrTbl_IsSchulrat,
  $addrTbl_Klassen,
  $addrTbl_IsTeilzeit,
  $addrTbl_Zustaendigkeit,
  $addrTbl_Funktion,
  $addrTbl_Comment,
  $addrTbl_MyPicture,
  $addrTbl_Location,
);


# Definitions for password file
# -----------------------------
$passwordFile            = $addressTable;
$passwordSepChar         = $addressTableSepChar;
$passwordUserIdFNam      = $addrTbl_UserId;
$passwordPasswordFNam    = $addrTbl_Password;
$passwordPrivFNam        = $addrTbl_Privilege;
$privSep                 = "&";
$maintainHtPasswd        = $useServerLogin;
$passPath                = "$ENV{DOCUMENT_ROOT}/ps";

$protPathMenuIntern      = "$ENV{DOCUMENT_ROOT}/ps/Menu";

$protPathAllgemein       = "$ENV{DOCUMENT_ROOT}/closedDir/Allgemein";
$protPathLehrer          = "$ENV{DOCUMENT_ROOT}/closedDir/Lehrer";
$protPathSchulrat        = "$ENV{DOCUMENT_ROOT}/closedDir/Schulrat";

$protPathAllgemeinCgi    = "$ENV{DOCUMENT_ROOT}/cgi-bin/ps/WebProtected/Allgemein";
$protPathLehrerCgi       = "$ENV{DOCUMENT_ROOT}/cgi-bin/ps/WebProtected/Lehrer";
$protPathSchulratCgi     = "$ENV{DOCUMENT_ROOT}/cgi-bin/ps/WebProtected/Schulrat";

# Definitions for sending dB file via e-mail attachment
# -----------------------------------------------------
$sendingDbFromAdr     = "info\@pswangensz.ch";
$sendingDbSubject     = "Aktuelle Liste";
$sendingDbMsg_root         = qq{
    In der Beilage erhältst Du eine aktuelle Liste

    
    Viele Grüsse
    Primarschule Wangen
    
};

$sendingDbMsg         = qq{
    In der Beilage erhältst Du eine aktuelle Liste
    
    
    Viele Grüsse
    Primarschule Wangen
    
};
$sendingDbCcAdr       = "";
$sendingDbBccAdr      = "";
@sendingDbColumns     = (
  $addrTbl_Anschreiben,
  $addrTbl_Sex,
  $addrTbl_Name,
  $addrTbl_Vorname,
  $addrTbl_Strasse,
  $addrTbl_PLZ,
  $addrTbl_Ort,
  $addrTbl_Land,
  $addrTbl_Email,
  $addrTbl_EmailSchule,
  $addrTbl_TelP,
  $addrTbl_TelG,
  $addrTbl_Natel,
  $addrTbl_FaxP,
  $addrTbl_FaxG,
  $addrTbl_IstLehrer,
  $addrTbl_IsSchulrat,
  $addrTbl_Klassen,
  $addrTbl_IsTeilzeit,
  $addrTbl_Zustaendigkeit,
  $addrTbl_Funktion,
  $addrTbl_MyPicture,
);

# Forgotten Password
# ------------------
$emailNotifyFromAdr = $sendingDbFromAdr;



# RegisterListControl-Definitions
# -------------------------------
$RegisterListControl_Table        = "${dataDir}registerListControl.flt";
$RegisterListMenuSubTree          = "${dataDir}anmeldeMenuTree.txt";
$RegisterListControl_TableSepChar = "\\|";
$countOfRegisterListControlArguments = 15;

$RegisterListControl_Hash                = "Hash";
$RegisterListControl_MutDatum            = "MutDatum";
$RegisterListControl_ModBy               = "ModBy";
$RegisterListControl_Title               = "Titel";
$RegisterListControl_Description         = "Beschreibung";
$RegisterListControl_Filename            = "Filename";
$RegisterListControl_Anmeldeschluss      = "Anmeldeschluss";
$RegisterListControl_ListRegPeople       = "ListRegPeople";
$RegisterListControl_EnableReg           = "EnableReg";
$RegisterListControl_EnableChanging      = "EnableMod";
$RegisterListControl_EnableDeleting      = "EnableDel";
$RegisterListControl_ShowFullAdr         = "ShowFullAdr";
$RegisterListControl_Organizer           = "Organizer";
$RegisterListControl_Berechtigte         = "Berechtigte";
$RegisterListControl_KindOfList          = "ArtDerListe";
$RegisterListControl_AnmeldeKnopf        = "AnmeldeKnopf";
$RegisterListControl_InMenuTree          = "InMenuTree";



%RegisterListControl_Titles  = (
      $RegisterListControl_Hash                => "Hash",
      $RegisterListControl_MutDatum            => "MutDatum",
      $RegisterListControl_ModBy               => "ModBy",
      $RegisterListControl_Title               => "Titel",
      $RegisterListControl_Description         => "Beschreibung",
      $RegisterListControl_Filename            => "Filename",
      $RegisterListControl_Anmeldeschluss      => "Anmeldeschluss<BR><font size=-2>[YYYYMMDDHHMMSS]</font>",
      $RegisterListControl_ListRegPeople       => "Registrierte anzeigen",
      $RegisterListControl_EnableReg           => "Eintragen Freigeben",
      $RegisterListControl_EnableChanging      => "Aendern erlauben",
      $RegisterListControl_EnableDeleting      => "Löschen erlauben",
      $RegisterListControl_ShowFullAdr         => "Zeige<BR>ganze Adresse",
      $RegisterListControl_Organizer           => "Organisator",
      $RegisterListControl_Berechtigte         => "Berechtigte</font>",
      $RegisterListControl_KindOfList          => "Art der Liste",
      $RegisterListControl_AnmeldeKnopf        => "Anmelde-Knopf",
      $RegisterListControl_InMenuTree          => "Menu Eintrag",
);
foreach (my $i=1; $i <= $countOfRegisterListControlArguments; $i++) {
    %RegisterListControl_Titles  = (%RegisterListControl_Titles,("Arg${i}_Label","Arg${i}_Label"));
    %RegisterListControl_Titles  = (%RegisterListControl_Titles,("Arg${i}_Editor","Arg${i}_Editor"));
}

%RegisterListControl_EditFieldFormat  = (
      $RegisterListControl_MutDatum            => "static",
      $RegisterListControl_ModBy               => "static",
      $RegisterListControl_Title               => "30",
      $RegisterListControl_Description         => "10*60NoWrap",
      $RegisterListControl_Filename            => "30",
      $RegisterListControl_Anmeldeschluss      => "30",
      $RegisterListControl_ListRegPeople       => "[Ja,Nein]",
      $RegisterListControl_EnableReg           => "[Ja,Nein]",
      $RegisterListControl_EnableChanging      => "[Ja,Nein]",
      $RegisterListControl_EnableDeleting      => "[Ja,Nein]",
      $RegisterListControl_ShowFullAdr         => "[Ja,Nein]",
      $RegisterListControl_Organizer           => "30",
      $RegisterListControl_Berechtigte         => "5*10NoWrap",
      $RegisterListControl_KindOfList          => "[Bestellung,Anmeldung]",
      $RegisterListControl_AnmeldeKnopf        => "40",
      $RegisterListControl_InMenuTree          => "[Ja,Nein]",
);
foreach (my $i=1; $i <= $countOfRegisterListControlArguments; $i++) {
   %RegisterListControl_EditFieldFormat  = (%RegisterListControl_EditFieldFormat,("Arg${i}_Label","30"));
   %RegisterListControl_EditFieldFormat  = (%RegisterListControl_EditFieldFormat,("Arg${i}_Editor","20"));
}

@RegisterListControl_DisplayOrder  = (
      $RegisterListControl_Title,
      $RegisterListControl_Description,
      $RegisterListControl_Organizer,
      $RegisterListControl_Berechtigte,
      $RegisterListControl_Anmeldeschluss,
      $RegisterListControl_InMenuTree,
      $RegisterListControl_ListRegPeople,
      $RegisterListControl_EnableReg,
      $RegisterListControl_EnableChanging,
      $RegisterListControl_EnableDeleting,
      $RegisterListControl_ShowFullAdr,
      $RegisterListControl_ModBy,
      $RegisterListControl_MutDatum,
);

@RegisterListControl_SorterFields = (
      $RegisterListControl_Title,
      $RegisterListControl_Description,
      $RegisterListControl_Organizer,
      $RegisterListControl_Filename,
      $RegisterListControl_ModBy,
      $RegisterListControl_MutDatum,
      $RegisterListControl_Anmeldeschluss,
      $RegisterListControl_InMenuTree,
      $RegisterListControl_ListRegPeople,
      $RegisterListControl_EnableReg,
      $RegisterListControl_EnableChanging,
      $RegisterListControl_EnableDeleting,
      $RegisterListControl_ShowFullAdr,
);

@RegisterListControl_AutofilterFileds  = (
      $RegisterListControl_Organizer,
      $RegisterListControl_InMenuTree,
      $RegisterListControl_ListRegPeople,
      $RegisterListControl_EnableReg,
      $RegisterListControl_EnableChanging,
      $RegisterListControl_EnableDeleting,
      $RegisterListControl_ShowFullAdr,
);

@RegisterListControl_DeleteNotificationOrder  = (
      $RegisterListControl_Title,
      $RegisterListControl_Description,
      $RegisterListControl_Organizer,
      $RegisterListControl_Berechtigte,
      $RegisterListControl_Filename,
      $RegisterListControl_ModBy,
      $RegisterListControl_MutDatum,
);

@RegisterListControl_EditFieldOrder = (
      $RegisterListControl_Hash               ,
      $RegisterListControl_Title,
      $RegisterListControl_Description,
      $RegisterListControl_Organizer,
      $RegisterListControl_Berechtigte,
      $RegisterListControl_Filename,
      $RegisterListControl_Anmeldeschluss,
      $RegisterListControl_KindOfList,
      $RegisterListControl_AnmeldeKnopf,
      $RegisterListControl_InMenuTree,
      $RegisterListControl_ShowFullAdr,
      $RegisterListControl_ListRegPeople,
      $RegisterListControl_EnableReg,
      $RegisterListControl_EnableChanging,
      $RegisterListControl_EnableDeleting,
      $RegisterListControl_ModBy,
      $RegisterListControl_MutDatum,
);
foreach (my $i=1; $i <= $countOfRegisterListControlArguments; $i++) {
    @RegisterListControl_EditFieldOrder  = (@RegisterListControl_EditFieldOrder,"Arg${i}_Label");
    @RegisterListControl_EditFieldOrder  = (@RegisterListControl_EditFieldOrder,"Arg${i}_Editor");
}


# RegisterList-Definitions
# ------------------------
$RegisterList_TableSepChar = "\\|";

$RegisterList_Hash                = "Hash";
$RegisterList_MutDatum            = "MutDatum";
$RegisterList_ModBy               = "ModBy";



%RegisterList_Titles  = (
      $RegisterList_Hash                => "Hash",
      $RegisterList_MutDatum            => "MutDatum",
      $RegisterList_ModBy               => "Anmelder",
);

%RegisterList_EditFieldFormat  = (
);


@RegisterList_DisplayOrder  = (
      $RegisterList_ModBy,
      $RegisterList_MutDatum,
);

@RegisterList_SorterFields = (
      $RegisterList_ModBy,
      $RegisterList_MutDatum,
);

@RegisterList_AutofilterFileds  = (
);

@RegisterList_DeleteNotificationOrder  = (
      $RegisterList_ModBy,
      $RegisterList_MutDatum,
);

@RegisterList_EditFieldOrder = (
      $RegisterList_Hash,
      $RegisterList_ModBy,
      $RegisterList_MutDatum,
);


# EinsatzplanManager-Definitions
# ------------------------------
$EinsatzplanManager_HTML_Title   = $HTML_Title;
$EinsatzplanManager_Table        = "${dataDir}einsatzplanControl.flt";
$EinsatzplanManagerMenuSubTree   = "${dataDir}einsatzplanMenuTree.txt";
$EinsatzplanManager_TableSepChar = "\\|";
$countOfEinsatzplanManagerArguments = 0;

$EinsatzplanManager_Hash                = "Hash";
$EinsatzplanManager_MutDatum            = "MutDatum";
$EinsatzplanManager_ModBy               = "ModBy";
$EinsatzplanManager_Title               = "Titel";
$EinsatzplanManager_Description         = "Beschreibung";
$EinsatzplanManager_Filename            = "Filename";
$EinsatzplanManager_Anmeldeschluss      = "Anmeldeschluss";
$EinsatzplanManager_ShowEntryDate       = "ShowEntryDate";
$EinsatzplanManager_ShowFullAdr         = "ShowFullAdr";
$EinsatzplanManager_AddEmailList        = "AddEmailList";
$EinsatzplanManager_bgColorAvail        = "bgColorAvail";
$EinsatzplanManager_bgColorOcupi        = "bgColorOcupi";
$EinsatzplanManager_Organizer           = "Organizer";
$EinsatzplanManager_Berechtigte         = "Berechtigte";
$EinsatzplanManager_InMenuTree          = "InMenuTree";



%EinsatzplanManager_Titles  = (
      $EinsatzplanManager_Hash                => "Hash",
      $EinsatzplanManager_MutDatum            => "MutDatum",
      $EinsatzplanManager_ModBy               => "ModBy",
      $EinsatzplanManager_Title               => "Titel",
      $EinsatzplanManager_Description         => "Beschreibung",
      $EinsatzplanManager_Filename            => "Filename",
      $EinsatzplanManager_Anmeldeschluss      => "Anmeldeschluss<BR><font size=-2>[YYYYMMDDHHMMSS]</font>",
      $EinsatzplanManager_ShowEntryDate       => "Zeige Eintrage-Zeit",
      $EinsatzplanManager_ShowFullAdr         => "Zeige<BR>ganze Adresse",
      $EinsatzplanManager_AddEmailList        => "Mit E-mail Liste",
      $EinsatzplanManager_bgColorAvail        => "Farbe frei",
      $EinsatzplanManager_bgColorOcupi        => "Farbe besetzt",
      $EinsatzplanManager_Organizer           => "Organisator",
      $EinsatzplanManager_Berechtigte         => "Berechtigte<BR><font site=-2>Mitglieder-Gruppe oder UserIds</font>",
      $EinsatzplanManager_InMenuTree          => "Menu Eintrag",
);
foreach (my $i=1; $i <= $countOfEinsatzplanManagerArguments; $i++) {
    %EinsatzplanManager_Titles  = (%EinsatzplanManager_Titles,("Arg${i}_Label","Arg${i}_Label"));
    %EinsatzplanManager_Titles  = (%EinsatzplanManager_Titles,("Arg${i}_Editor","Arg${i}_Editor"));
}

%EinsatzplanManager_EditFieldFormat  = (
      $EinsatzplanManager_MutDatum            => "static",
      $EinsatzplanManager_ModBy               => "static",
      $EinsatzplanManager_Title               => "30",
      $EinsatzplanManager_Description         => "10*60NoWrap",
      $EinsatzplanManager_Filename            => "30",
      ### $EinsatzplanManager_Anmeldeschluss      => "30",
      $EinsatzplanManager_ShowEntryDate       => "[Ja,Nein]",
      $EinsatzplanManager_ShowFullAdr         => "[Ja,Nein]",
      $EinsatzplanManager_AddEmailList        => "[Ja,Nein]",
      $EinsatzplanManager_bgColorAvail        => "30",
      $EinsatzplanManager_bgColorOcupi        => "30",
      $EinsatzplanManager_Organizer           => "30",
      $EinsatzplanManager_Berechtigte         => "7*25NoWrap",
      $EinsatzplanManager_InMenuTree          => "[Ja,Nein]",
);
foreach (my $i=1; $i <= $countOfEinsatzplanManagerArguments; $i++) {
   %EinsatzplanManager_EditFieldFormat  = (%EinsatzplanManager_EditFieldFormat,("Arg${i}_Label","30"));
   %EinsatzplanManager_EditFieldFormat  = (%EinsatzplanManager_EditFieldFormat,("Arg${i}_Editor","20"));
}

@EinsatzplanManager_DisplayOrder  = (
      $EinsatzplanManager_Title,
      $EinsatzplanManager_Description,
      $EinsatzplanManager_Organizer,
      $EinsatzplanManager_InMenuTree,
      $EinsatzplanManager_Berechtigte,
      $EinsatzplanManager_ShowFullAdr,
      $EinsatzplanManager_ModBy,
      $EinsatzplanManager_MutDatum,
);

@EinsatzplanManager_SorterFields = (
      $EinsatzplanManager_Title,
      $EinsatzplanManager_Description,
      $EinsatzplanManager_Organizer,
      $EinsatzplanManager_InMenuTree,
      $EinsatzplanManager_ShowFullAdr,
      $EinsatzplanManager_ModBy,
      $EinsatzplanManager_MutDatum,
);

@EinsatzplanManager_AutofilterFileds  = (
      $EinsatzplanManager_Organizer,
      $EinsatzplanManager_InMenuTree,
      $EinsatzplanManager_ShowFullAdr,
);

@EinsatzplanManager_DeleteNotificationOrder  = (
      $EinsatzplanManager_Title,
      $EinsatzplanManager_Description,
      $EinsatzplanManager_Organizer,
      $EinsatzplanManager_InMenuTree,
      $EinsatzplanManager_Berechtigte,
      $EinsatzplanManager_Filename,
      $EinsatzplanManager_ModBy,
      $EinsatzplanManager_MutDatum,
);

@EinsatzplanManager_EditFieldOrder = (
      $EinsatzplanManager_Hash               ,
      $EinsatzplanManager_Title,
      $EinsatzplanManager_Description,
      $EinsatzplanManager_Organizer,
      $EinsatzplanManager_InMenuTree,
      $EinsatzplanManager_Berechtigte,
      $EinsatzplanManager_Filename,
      $EinsatzplanManager_Anmeldeschluss,
      $EinsatzplanManager_ShowFullAdr,
      $EinsatzplanManager_ShowEntryDate,
      $EinsatzplanManager_AddEmailList,
      $EinsatzplanManager_bgColorAvail,
      $EinsatzplanManager_bgColorOcupi,
      $EinsatzplanManager_ModBy,
      $EinsatzplanManager_MutDatum,
);
foreach (my $i=1; $i <= $countOfEinsatzplanManagerArguments; $i++) {
    @EinsatzplanManager_EditFieldOrder  = (@EinsatzplanManager_EditFieldOrder,"Arg${i}_Label");
    @EinsatzplanManager_EditFieldOrder  = (@EinsatzplanManager_EditFieldOrder,"Arg${i}_Editor");
}

# Einsatzplan-Manager for Rollen Definitions
# ------------------------------------------
$EinsatzPlanRollen_Hash         = "Hash";
$EinsatzPlanRollen_Description  = "Beschreibung";
$EinsatzPlanRollen_Sorter       = "Sorter";
$EinsatzPlanRollen_MutDatum     = "ModAt";
$EinsatzPlanRollen_ModBy        = "ModBy";

%EinsatzPlanRollen_Titles  = (
      $EinsatzPlanRollen_Hash         => "Hash",
      $EinsatzPlanRollen_Description  => "Beschreibung",
      $EinsatzPlanRollen_Sorter       => "Sorter",
      $EinsatzPlanRollen_MutDatum     => "MutDatum",
      $EinsatzPlanRollen_ModBy        => "ModBy",
);

%EinsatzPlanRollen_EditFieldFormat  = (
      $EinsatzPlanRollen_MutDatum     => "static",
      $EinsatzPlanRollen_ModBy        => "static",
      $EinsatzPlanRollen_Description  => "10*60",
      $EinsatzPlanRollen_Sorter       => "5",
);

@EinsatzPlanRollen_DisplayOrder  = (
      $EinsatzPlanRollen_Description ,
      $EinsatzPlanRollen_Sorter,
      $EinsatzPlanRollen_MutDatum,
      $EinsatzPlanRollen_ModBy,
);

@EinsatzPlanRollen_SorterFields = (
      $EinsatzPlanRollen_Description ,
      $EinsatzPlanRollen_Sorter,
      $EinsatzPlanRollen_MutDatum,
      $EinsatzPlanRollen_ModBy,
);

@EinsatzPlanRollen_AutofilterFileds  = (
);

@EinsatzPlanRollen_DeleteNotificationOrder  = (
      $EinsatzPlanRollen_Description ,
      $EinsatzPlanRollen_Sorter,
      $EinsatzPlanRollen_MutDatum,
      $EinsatzPlanRollen_ModBy,
);

@EinsatzPlanRollen_EditFieldOrder = (
      $EinsatzPlanRollen_Hash        ,
      $EinsatzPlanRollen_Description ,
      $EinsatzPlanRollen_Sorter,
      $EinsatzPlanRollen_MutDatum,
      $EinsatzPlanRollen_ModBy,
);

# Einsatzplan-Manager for Datum Definitions
# -----------------------------------------
$EinsatzPlanDatum_Hash         = "Hash";
$EinsatzPlanDatum_Description  = "Beschreibung";
$EinsatzPlanDatum_Sorter       = "Sorter";
$EinsatzPlanDatum_MutDatum     = "ModAt";
$EinsatzPlanDatum_ModBy        = "ModBy";

%EinsatzPlanDatum_Titles  = (
      $EinsatzPlanDatum_Hash         => "Hash",
      $EinsatzPlanDatum_Description  => "Beschreibung",
      $EinsatzPlanDatum_Sorter       => "Sorter",
      $EinsatzPlanDatum_MutDatum     => "MutDatum",
      $EinsatzPlanDatum_ModBy        => "ModBy",
);

%EinsatzPlanDatum_EditFieldFormat  = (
      $EinsatzPlanDatum_MutDatum     => "static",
      $EinsatzPlanDatum_ModBy        => "static",
      $EinsatzPlanDatum_Description  => "10*60",
      $EinsatzPlanDatum_Sorter       => "5",
);

@EinsatzPlanDatum_DisplayOrder  = (
      $EinsatzPlanDatum_Description ,
      $EinsatzPlanDatum_Sorter,
      $EinsatzPlanDatum_MutDatum,
      $EinsatzPlanDatum_ModBy,
);

@EinsatzPlanDatum_SorterFields = (
      $EinsatzPlanDatum_Description ,
      $EinsatzPlanDatum_Sorter,
      $EinsatzPlanDatum_MutDatum,
      $EinsatzPlanDatum_ModBy,
);

@EinsatzPlanDatum_AutofilterFileds  = (
);

@EinsatzPlanDatum_DeleteNotificationOrder  = (
      $EinsatzPlanDatum_Description ,
      $EinsatzPlanDatum_Sorter,
      $EinsatzPlanDatum_MutDatum,
      $EinsatzPlanDatum_ModBy,
);

@EinsatzPlanDatum_EditFieldOrder = (
      $EinsatzPlanDatum_Hash        ,
      $EinsatzPlanDatum_Description ,
      $EinsatzPlanDatum_Sorter,
      $EinsatzPlanDatum_MutDatum,
      $EinsatzPlanDatum_ModBy,
);

# Veranstaltungenplan-Definitions
# -------------------------------
$Veranstaltungen_Table        = "${dataDir}Veranstaltungen.flt";
$Veranstaltungen_TableSepChar = "\\|";

$Veranstaltungen_Hash              = "Hash";
$Veranstaltungen_MutDatum          = "MutDatum";
$Veranstaltungen_ModBy             = "ModBy";
$Veranstaltungen_StartDatum        = "StartDatum";
$Veranstaltungen_EndDatum          = "EndDatum";
$Veranstaltungen_Titel             = "Titel";
$Veranstaltungen_Description       = "Beschreibung";
$Veranstaltungen_Kontaktperson     = "Kontakt";
$Veranstaltungen_FerienOrEvent     = "Fer_Event";

%Veranstaltungen_Titles  = (
      $Veranstaltungen_Hash            => "Hash",
      $Veranstaltungen_MutDatum        => "MutDatum",
      $Veranstaltungen_ModBy           => "ModBy",
      $Veranstaltungen_StartDatum      => "Von",
      $Veranstaltungen_EndDatum        => "Bis",
      $Veranstaltungen_Titel           => "Was?",
      $Veranstaltungen_Description     => "Beschreibung",
      $Veranstaltungen_Kontaktperson   => "Kontakt",
      $Veranstaltungen_FerienOrEvent   => "Ferien/<BR>Anlass",
);

%Veranstaltungen_EditFieldFormat  = (
      $Veranstaltungen_MutDatum          => "static",
      $Veranstaltungen_ModBy             => "static",
      $Veranstaltungen_StartDatum        => "50",
      $Veranstaltungen_EndDatum          => "50",
      $Veranstaltungen_Titel             => "50",
      $Veranstaltungen_Description       => "10*60",
      $Veranstaltungen_Kontaktperson     => "30",
      $Veranstaltungen_FerienOrEvent     => "[Ferien,Anlass]",
      $Veranstaltungen_Sorter            => "5",
);

@Veranstaltungen_DisplayOrder  = (
      $Veranstaltungen_StartDatum,
      $Veranstaltungen_EndDatum,
      $Veranstaltungen_Titel,
      $Veranstaltungen_Kontaktperson,
      $Veranstaltungen_FerienOrEvent,
);

@Veranstaltungen_DisplayOrder_Umprotected  = (
      $Veranstaltungen_StartDatum,
      $Veranstaltungen_EndDatum,
      $Veranstaltungen_Titel,
);

@Veranstaltungen_SorterFields = (
      $Veranstaltungen_StartDatum,
      $Veranstaltungen_EndDatum,
      $Veranstaltungen_Titel,
      $Veranstaltungen_Kontaktperson      ,
      $Veranstaltungen_FerienOrEvent         ,
);

@Veranstaltungen_AutofilterFileds  = (
      $Veranstaltungen_FerienOrEvent         ,
);

@Veranstaltungen_DeleteNotificationOrder  = (
      $Veranstaltungen_StartDatum,
      $Veranstaltungen_EndDatum,
      $Veranstaltungen_Titel,
      $Veranstaltungen_Kontaktperson      ,
      $Veranstaltungen_FerienOrEvent         ,
);

@Veranstaltungen_EditFieldOrder = (
      $Veranstaltungen_Hash        ,
      $Veranstaltungen_MutDatum    ,
      $Veranstaltungen_ModBy       ,
      $Veranstaltungen_StartDatum,
      $Veranstaltungen_EndDatum,
      $Veranstaltungen_Titel,
      $Veranstaltungen_Description   ,
      $Veranstaltungen_Kontaktperson      ,
      $Veranstaltungen_FerienOrEvent         ,
);

# Circular Email Definitions
# --------------------------
$circularEmailDef_htmlSubTitle      = "Circular E-Mail definitions";
$circularEmailDef_Table             = "${dataDir}circularEmailDefinitions.flt";
$circularEmailDef_TableSepChar      = "\\|";

$circularEmailDef_Hash              = "Hash";
$circularEmailDef_MutDatum          = "MutDatum";
$circularEmailDef_ModBy             = "ModBy";
$circularEmailDef_Subject           = "Subject";
$circularEmailDef_SenderEmail       = "SenderEmail";
$circularEmailDef_EmailTemplate     = "EmailTemplate";
$circularEmailDef_TestLevels        = "TestLevels";
$circularEmailDef_SelCriteria       = "SelCriteria";
$circularEmailDef_LastStatus        = "LastStatus";
$circularEmailDef_EmailFieldNames   = "EmailFieldNames";
$circularEmailDef_PicFieldNames     = "PicFieldNames";
$circularEmailDef_TestReceiverAdr   = "TestReceiverAdr";
$circularEmailDef_Disabled          = "Disabled";

%circularEmailDef_Titles  = (
      $circularEmailDef_Hash            => "Hash",
      $circularEmailDef_MutDatum        => "MutDatum",
      $circularEmailDef_ModBy           => "ModBy",
      $circularEmailDef_Subject         => "Subject",
      $circularEmailDef_SenderEmail     => "Sender Adress",
      $circularEmailDef_EmailTemplate   => "E-Mail text",
      $circularEmailDef_TestLevels      => "Test Levels",
      $circularEmailDef_SelCriteria     => "Selection Criteria",  #  <BR><font size=-1>IstSchulrat eq Ja AND Nachname eq Giger<BR>MutDatum lt 20051010000000
      $circularEmailDef_LastStatus      => "Last Status",
      $circularEmailDef_EmailFieldNames => "Email Field Names",
      $circularEmailDef_PicFieldNames   => "Bild Field Name",
      $circularEmailDef_TestReceiverAdr => "Test Receiver Adr",
      $circularEmailDef_Disabled        => "Disabled",
);

$circEnumTestLevels_1 = "Show selected Adresses only";
$circEnumTestLevels_2 = "Single email to Test email-Adr";
$circEnumTestLevels_3 = "All emails to Test email-Adr";
$circEnumTestLevels_4 = "Do it real";

%circularEmailDef_EditFieldFormat  = (
      $circularEmailDef_MutDatum          => "static",
      $circularEmailDef_ModBy             => "static",
      $circularEmailDef_Subject           => "50",
      $circularEmailDef_SenderEmail       => "50",
      $circularEmailDef_EmailTemplate     => "20*60NoWrap",
      $circularEmailDef_TestLevels        => "[$circEnumTestLevels_1,$circEnumTestLevels_2,$circEnumTestLevels_3,$circEnumTestLevels_4]",
      $circularEmailDef_SelCriteria       => "20*60NoWrap",
      $circularEmailDef_EmailFieldNames   => "4*30",
      $circularEmailDef_PicFieldNames     => "30",
      $circularEmailDef_LastStatus        => "static",
      $circularEmailDef_TestReceiverAdr   => "50",
      $circularEmailDef_Disabled          => "[Ja,Nein]",
);

@circularEmailDef_DisplayOrder  = (
      $circularEmailDef_Subject,
      $circularEmailDef_SenderEmail,
      $circularEmailDef_TestLevels,
#      $circularEmailDef_SelCriteria,
      $circularEmailDef_Disabled,
);

@circularEmailDef_SorterFields = (
      $circularEmailDef_Subject,
      $circularEmailDef_SenderEmail,
      $circularEmailDef_TestLevels,
      $circularEmailDef_SelCriteria,
      $circularEmailDef_Disabled,
);

@circularEmailDef_AutofilterFileds  = (
      $circularEmailDef_TestLevels,
      $circularEmailDef_Disabled,
);

@circularEmailDef_DeleteNotificationOrder  = (
      $circularEmailDef_Subject,
      $circularEmailDef_SenderEmail,
      $circularEmailDef_TestLevels,
      $circularEmailDef_SelCriteria,
);

@circularEmailDef_EditFieldOrder = (
      $circularEmailDef_Hash,
      $circularEmailDef_MutDatum,
      $circularEmailDef_ModBy,
      $circularEmailDef_Subject,
      $circularEmailDef_SenderEmail,
      $circularEmailDef_SelCriteria,
      $circularEmailDef_EmailTemplate,
      $circularEmailDef_TestLevels,
      $circularEmailDef_EmailFieldNames,
      $circularEmailDef_PicFieldNames,
      $circularEmailDef_LastStatus,
      $circularEmailDef_TestReceiverAdr,
      $circularEmailDef_Disabled,
);



# News-Definitions
# ----------------
$newsTicker_Table        = "${dataDir}News.flt";
$newsTicker_TableSepChar = "\\|";

$newsTicker_Hash           = "Hash";
$newsTicker_NewsText       = "NewsText";
$newsTicker_PublishDate    = "PublishDate";
$newsTicker_ModAt          = "ModAt";
$newsTicker_ModBy          = "ModBy";
$newsTicker_AppletType     = "AppletType";


%newsTicker_Titles  = (
      $newsTicker_Hash           => "Hash",
      $newsTicker_NewsText       => "NewsText",
      $newsTicker_PublishDate    => "PublishDate",
      $newsTicker_ModAt          => "ModAt",
      $newsTicker_ModBy          => "ModBy",
      $newsTicker_AppletType     => "AppletType",
);

%newsTicker_EditFieldFormat  = (
      $newsTicker_NewsText       => "10*60",
      $newsTicker_PublishDate    => "30",
      $newsTicker_ModAt          => "static",
      $newsTicker_ModBy          => "static",
      $newsTicker_AppletType     => "[${newsTickerTypeEnum_LED},${newsTickerTypeEnum_Vertikal}]",
);

@newsTicker_DisplayOrder  = (
      $newsTicker_NewsText      ,
      $newsTicker_AppletType    ,
      $newsTicker_PublishDate   ,
      $newsTicker_ModAt         ,
      $newsTicker_ModBy         ,
);

@newsTicker_SorterFields = (
      $newsTicker_Hash          ,
      $newsTicker_NewsText      ,
      $newsTicker_AppletType    ,
      $newsTicker_PublishDate   ,
      $newsTicker_ModAt         ,
      $newsTicker_ModBy         ,
);

@newsTicker_AutofilterFileds  = (
      $newsTicker_Hash          ,
      $newsTicker_AppletType    ,
      $newsTicker_ModBy         ,
);

@newsTicker_DeleteNotificationOrder  = (
      $newsTicker_NewsText      ,
      $newsTicker_AppletType    ,
      $newsTicker_PublishDate   ,
      $newsTicker_ModAt         ,
      $newsTicker_ModBy         ,
);

@newsTicker_EditFieldOrder = (
      $newsTicker_Hash          ,
      $newsTicker_NewsText      ,
      $newsTicker_AppletType    ,
      $newsTicker_PublishDate   ,
      $newsTicker_ModAt         ,
      $newsTicker_ModBy         ,
);

# Einsatz-Plan
# ------------
$zuteilungFieldNameCoordinates = "Coordinates";
$zuteilungFieldNameAssigned    = "Zuteilung";
$zuteilungFieldNameModBy       = "ModBy";
$zuteilungFieldNameModAt       = "ModAt";
$zuteilungFieldNameCom         = "Comment";

$passwordFileEmailColumnName   = $addrTbl_Email;
$emailColumnName               = $addrTbl_Email;
$smsColumnName                 = $addrTbl_Natel;
$smsColumnName                 = "";
# -----------------------------------------------------------------------
# common functions
# -----------------------------------------------------------------------
############################################################################
# Functions
############################################################################
sub getAdresseByNameFirstName {
  my($vorname,$name) = @_;
  my($locWhereClause) = "${addrTbl_Name}=${name} AND ${addrTbl_Vorname}=${vorname}";
  ### printf("locWhereClause:${locWhereClause}<BR>\n");
  return getAdresse($locWhereClause);	
}

sub getAdresseByUserId {
  my($userId) = @_;
  my($locWhereClause) = "${addrTbl_UserId}=${userId}";
  ### printf("locWhereClause:${locWhereClause}<BR>\n");
  return getAdresse($locWhereClause);	
}


sub getSchulratAdresseByFunction {
  my($funktion,,$formatType) = @_;
  my($locWhereClause) = "${addrTbl_Funktion} starts ${funktion} OR ${addrTbl_Zustaendigkeit} starts ${funktion}";
  ### printf("locWhereClause:${locWhereClause}<BR>\n");
  return getSchulratAdresse($locWhereClause,$FALSE,$formatType);	
}

sub getAdresseByFunction {
  my($funktion) = @_;
  my($locWhereClause) = "${addrTbl_Funktion} starts ${funktion}";
  ### printf("locWhereClause:${locWhereClause}<BR>\n");
  return getAdresse($locWhereClause);	
}

sub displayInternExtern {
  my($inVal) = @_;
  my($retVal) = "";
  if ($inVal eq "Intern") {
     $retVal = "slrgLachenKlein.gif";
  } else {
     $retVal = "slrgKlein.gif";
  }
 
  return "<CENTER><IMG SRC='/slrg/Img/${retVal}'></CENTER>";
}

sub displayAddressRecordByUserId_AsLink {
  my($inVal) = @_;
  my($retVal) = "";
  ## printf("<!--displayAddressRecordByUserId_AsLink\n%s:%s:\n",$keyFieldName,$locNameToIndex{$keyFieldName});
  ## displayArray(@parts);
  ## my(@saveParts) = @parts; # TBS can be removed with littlePerlLib V2.96
  my(%addrHash) = getSingleRecInHash($addressTable,$addressTableSepChar,"","${addrTbl_UserId} eq ${inVal}","",$FALSE);
  ## @parts = @saveParts;     # TBS can be removed with littlePerlLib V2.96
  ## printf("    displayAddressRecordByUserId_AsLink\n%s:%s:\n",$keyFieldName,$locNameToIndex{$keyFieldName});
  ## displayArray(@parts);
  ## printf("-->\n");
  if (($addrHash{$addrTbl_UserId} eq $inVal) && ($inVal ne "")) { 
      my($label) = sprintf("%s %s",$addrHash{$addrTbl_Vorname},$addrHash{$addrTbl_Name});
      $retVal = "<CENTER><A href=\"javascript:displayAddress_fct('/cgi-bin/ps/showAdress.pl?whereClause=${addrTbl_UserId}%3D${inVal}')\">${label}</A>";
  } else {
      if ($inVal ne "") {
         $retVal = "<CENTER>${inVal}</CENTER>";
      }
  }
  $retVal = strip($retVal);
  if ($retVal eq "") {
    $retVal = "&nbsp;";
  }
  return $retVal;
}


sub getAdresse {
  my($locWhereClause,$updateEmailList) = @_;
  $updateEmailList = setDefault($updateEmailList,$FALSE);

  ### printf("locWhereClause:${locWhereClause}<BR>\n");
  my(%addrHash) = getSingleRecInHash($addressTable,$addressTableSepChar,"",$locWhereClause,"",$FALSE); 
  #### displayHashTableHTML(%addrHash);
  my $name     = $addrHash{$addrTbl_Name};
  if ($name eq "") { return ""; }

  my $vorname  = $addrHash{$addrTbl_Vorname};
  my $strasse  = $addrHash{$addrTbl_Strasse};
  my $plz      = $addrHash{$addrTbl_PLZ};
  my $ort      = $addrHash{$addrTbl_Ort};
  my $telp     = $addrHash{$addrTbl_TelP};
  my $telg     = $addrHash{$addrTbl_TelG};
  my $faxp     = $addrHash{$addrTbl_FaxP};
  my $faxg     = $addrHash{$addrTbl_FaxG};
  my $natel    = $addrHash{$addrTbl_Natel};

  my($email)         = $addrHash{$addrTbl_Email};
  my($myPic)         = $addrHash{$addrTbl_MyPicture};
  my($vornameName)   = "${name} ${vorname}";

  if ($updateEmailList) {
    if (($vornameName ne "") && ($email ne "")) {
      %emailList = (%emailList,($vornameName,$email));
    }
    
    if (($vornameName ne "") && ($natel ne "")) {
      my $smsStr = "${natel}";
      $smsStr    =~ s/\W//g; 
      $smsStr    = "${smsStr}\@sms.credit-suisse.ch";
      %smsList   = (%smsList,($vornameName,$smsStr));
    }
  }

  if ($telp ne "") {
     $telp = "Tel P:${telp}<BR>";
  }
  if ($telg ne "") {
     $telg = "Tel G:${telg}<BR>";
  }
  if ($faxp ne "") {
     $faxp = "Fax P:${faxp}<BR>";
  }
  if ($faxg ne "") {
     $faxg = "Fax G:${faxg}<BR>";
  }
  if ($natel ne "") {
     $natel = "Natel:${natel}<BR>";
  }

  if ($email ne "") {
     $email = "<A HREF=\"mailto:${email}\">${email}</A>";
  }

  if ($myPic ne "") {
     $vornameName = "<A HREF=\"javascript:displayPicture('${myPic}')\">${vornameName}</A>";
  }

  return "${firma}${vornameName}<BR>${strasse}<BR>${plz} <U>${ort}</U><BR>${telp}${faxp}${natel}${telg}${faxg}${email}";

}

sub getPublicAdresse {
  my($locWhereClause,$updateEmailList) = @_;
  $updateEmailList = setDefault($updateEmailList,$FALSE);

  ### printf("locWhereClause:${locWhereClause}<BR>\n");
  my(%addrHash) = getSingleRecInHash($addressTable,$addressTableSepChar,"",$locWhereClause,"",$FALSE); 
  #### displayHashTableHTML(%addrHash);
  my $name     = $addrHash{$addrTbl_Name};
  if ($name eq "") { return ""; }

  my $vorname  = $addrHash{$addrTbl_Vorname};
  my $strasse  = $addrHash{$addrTbl_Strasse};
  my $plz      = $addrHash{$addrTbl_PLZ};
  my $ort      = $addrHash{$addrTbl_Ort};
  my $telp     = $addrHash{$addrTbl_TelP};
  my $telg     = $addrHash{$addrTbl_TelG};
  my $faxp     = $addrHash{$addrTbl_FaxP};
  my $faxg     = $addrHash{$addrTbl_FaxG};
  ## my $natel    = $addrHash{$addrTbl_Natel};

  my($emailSchule)   = $addrHash{$addrTbl_EmailSchule};
  my($myPic)         = $addrHash{$addrTbl_MyPicture};
  my($vornameName)   = "${name} ${vorname}";

  if ($updateEmailList) {
    if (($vornameName ne "") && ($email ne "")) {
      %emailList = (%emailList,($vornameName,$emailSchule));
    }
    
    if (($vornameName ne "") && ($natel ne "")) {
      my $smsStr = "${natel}";
      $smsStr    =~ s/\W//g; 
      $smsStr    = "${smsStr}\@sms.credit-suisse.ch";
      %smsList   = (%smsList,($vornameName,$smsStr));
    }
  }

  if ($telp ne "") {
     $telp = "Tel P:${telp}<BR>";
  }
  if ($telg ne "") {
     $telg = "Tel G:${telg}<BR>";
  }
  if ($faxp ne "") {
     $faxp = "Fax P:${faxp}<BR>";
  }
  if ($faxg ne "") {
     $faxg = "Fax G:${faxg}<BR>";
  }
  if ($natel ne "") {
     $natel = "Natel:${natel}<BR>";
  }

  if ($emailSchule ne "") {
     $emailSchule = "<A HREF=\"mailto:${emailSchule}\">${emailSchule}</A>";
  }

  if ($myPic ne "") {
     $vornameName = "<A HREF=\"javascript:displayPicture('${myPic}')\">${vornameName}</A>";
  }

  return "${firma}${vornameName}<BR>${strasse}<BR>${plz} <U>${ort}</U><BR>${telp}${faxp}${natel}${telg}${faxg}${emailSchule}";

}

sub getSchulratAdresse {
  my($locWhereClause,$updateEmailList,$formatType) = @_;
  $updateEmailList = setDefault($updateEmailList,$FALSE);
  $formatType      = setDefault($formatType,"schulrat");

  ### printf("locWhereClause:${locWhereClause}<BR>\n");
  my(%addrHash) = getSingleRecInHash($addressTable,$addressTableSepChar,"",$locWhereClause,"",$FALSE); 
  #### displayHashTableHTML(%addrHash);
  my $name     = $addrHash{$addrTbl_Name};
  if ($name eq "") { return ""; }

  my $funktion = $addrHash{$addrTbl_Funktion};
  my $vorname  = $addrHash{$addrTbl_Vorname};
  my $strasse  = $addrHash{$addrTbl_Strasse};
  my $plz      = $addrHash{$addrTbl_PLZ};
  my $ort      = $addrHash{$addrTbl_Ort};
  my $telp     = $addrHash{$addrTbl_TelP};
  my $telg     = $addrHash{$addrTbl_TelG};
  my $faxp     = $addrHash{$addrTbl_FaxP};
  my $faxg     = $addrHash{$addrTbl_FaxG};
  ## my $natel    = $addrHash{$addrTbl_Natel};
  
  my $klassen        = $addrHash{$addrTbl_Klassen};
  $klassen =~ s/;/\<BR\>/g;
  $klassen =~ s/_/ /g;
  if ($klassen eq "") { $klassen = "&nbsp;"; }
  my $zustaendigkeit = $addrHash{$addrTbl_Zustaendigkeit};
  if ($funktion eq "Lehrervertretung")  { $klassen = "&nbsp;"; }
  
  my($email)         = $addrHash{$addrTbl_Email};
  my($myPic)         = $addrHash{$addrTbl_MyPicture};
  my($vornameName)   = "${name} ${vorname}";

  if ($telp ne "") {
     $telp = "Tel P:${telp}<BR>";
  }
  if ($telg ne "") {
     $telg = "Tel G:${telg}<BR>";
  }
  if ($faxp ne "") {
     $faxp = "Fax P:${faxp}<BR>";
  }
  if ($faxg ne "") {
     $faxg = "Fax G:${faxg}<BR>";
  }
  if ($natel ne "") {
     $natel = "Natel:${natel}<BR>";
  }

  if ($email ne "") {
     $email = "<A HREF=\"mailto:${email}\">${email}</A>";
  }

  if ($myPic ne "") {
     if ($formatType eq "schulrat") {
        $myPic = "<center><IMG SRC=${myPic} width=\"85\" border=\"0\"></center>";
     } elsif ($formatType eq "schulleitung") {
     	$myPic = "<center><IMG SRC=${myPic} width=\"123\" border=\"0\"></center>";
     }   
  } else {
     $myPic = "&nbsp;";	
  } 
  if ($formatType eq "schulrat") {
     return "<td>${myPic}</td><td><span class=\"psNormalSize_16_Schrift\"><B>${firma}${vornameName}</B><BR>${strasse}<BR>${plz} <U>${ort}</U><BR>${telp}${faxp}${natel}${telg}${faxg}${email}</span></td><td><span class=\"psNormalSize_16_Schrift\">$zustaendigkeit</span></td><td><span class=\"Stil2\"><font size=-2>$klassen</font></span></td>";
  } elsif ($formatType eq "schulleitung") {
     if ($zustaendigkeit eq "Teamleiter_1")  {$zustaendigkeit = "Teamleiter"; }
     if ($zustaendigkeit eq "Teamleiter_2")  {$zustaendigkeit = "Teamleiter"; }
     if ($zustaendigkeit eq "Teamleiter_10") {$zustaendigkeit = "Teamassistent"; }
     return "<td><span class=\"psTitle_2\">${zustaendigkeit}<BR><BR>${myPic}</td></span><td><span class=\"psNormalSchrift\"><B>${firma}${vornameName}</B><BR>${strasse}<BR>${plz} <U>${ort}</U><BR>${telp}${faxp}${natel}${telg}${faxg}${email}</span></td>";
  }
}

sub showVeranstaltungsDetailLink {
  my($inVal)  = @_;
  my $retVal  = "";
  my $hash    = $parts[$colNameToIndex{"Hash"}];
  my(%recHash) = getSingleRecInHash($Veranstaltungen_Table,$Veranstaltungen_TableSepChar,"","${$Veranstaltungen_Hash} eq ${hash}","",$FALSE);
  if (strip($recHash{$Veranstaltungen_Description}) eq "") {
      $retVal = ${inVal};
  } else {
      $retVal = "<A href=\"/cgi-bin/ps/showVeranstaltungsDetails.pl?veranstaltungsID=${hash}\">${inVal}</A>";
  }
  return $retVal;
}

sub displayAddressRecord {
  my($inVal) = @_;

  my($name)     = $parts[$colNameToIndex{$addrTbl_Name}];
  my($vorname)  = $parts[$colNameToIndex{$addrTbl_Vorname}];
  my($strasse)  = $parts[$colNameToIndex{$addrTbl_Strasse}];
  my($plz)      = $parts[$colNameToIndex{$addrTbl_PLZ}];
  ## $strasse      = "<A href=\"http://www.mapsearch.ch/${plz}/${strasse}\">".$parts[$colNameToIndex{$addrTbl_Strasse}]."</A>";
  $strasse      = "<A href=\"javascript:displayPicture('http://map.search.ch/${plz}/${strasse}')\">".$parts[$colNameToIndex{$addrTbl_Strasse}]."</A>";
  
  my($ort)      = $parts[$colNameToIndex{$addrTbl_Ort}];
  my($telp)     = $parts[$colNameToIndex{$addrTbl_TelP}];
  my($telg)     = $parts[$colNameToIndex{$addrTbl_TelG}];
  my($faxp)     = $parts[$colNameToIndex{$addrTbl_FaxP}];
  my($faxg)     = $parts[$colNameToIndex{$addrTbl_FaxG}];
  my($natel)    = $parts[$colNameToIndex{$addrTbl_Natel}];
  my($email)         = $parts[$colNameToIndex{$addrTbl_Email}];
  my($emailSchule)   = $parts[$colNameToIndex{$addrTbl_EmailSchule}];
  my($myPic)         = $parts[$colNameToIndex{$addrTbl_MyPicture}];
  my($vornameName)   = "${name} ${vorname}";


  if ($telp ne "") {
     $telp = "Tel P:${telp}<BR>";
  }
  if ($telg ne "") {
     $telg = "Tel G:${telg}<BR>";
  }
  if ($faxp ne "") {
     $faxp = "Fax P:${faxp}<BR>";
  }
  if ($faxg ne "") {
     $faxg = "Fax G:${faxg}<BR>";
  }
  if ($natel ne "") {
     $natel = "Natel:${natel}<BR>";
  }

  if ($email ne "") {
     $email = "<A HREF=\"mailto:${email}\">${email}</A>";
  }
  
  if ($emailSchule ne "") {
     $emailSchule = "<A HREF=\"mailto:${emailSchule}\">${emailSchule}</A>";
  }

  if ($myPic ne "") {
     $vornameName = "<A HREF=\"javascript:displayPicture('${myPic}')\">${vornameName}</A>";
  }

  return "${firma}${vornameName}<BR>${strasse}<BR>${plz} <U>${ort}</U><BR>${telp}${faxp}${natel}${telg}${faxg}${emailSchule}<BR>${email}";
}

sub showTitle {
  my($htmlTitle,$htmlSubTitle,$ssiPath) = @_;
  $action = getParam("Action","");
  if ($action ne "ShowDetail") {
     docDisplayHeader($htmlTitle,$htmlSubTitle,$ssiPath);
  } else {
     htmlMimeType();
  }
}


sub docDisplayHeader {
   my($htmlTitle,$htmlSubTitle,$ssiPath) = @_;
   if ($usePubUpMenus) {
     print ("Content-type: text/html\n\n"); # don't touch this line!!!
     $action  = getParam("Action","");
     $showTitleForDetailView = setDefault($showTitleForDetailView,$FALSE);
   
     if (($action ne "ShowDetail") &&
         ($action ne "ForUploadingDb") &&
         ($action ne "UploadDb")) {
       print("<HTML>\n");
       readFile("${ssiPath}/headbeg.html",1,-1,$TRUE);
       print(" <TITLE>${htmlTitle}</TITLE>\n");
       print("<link href=\"/formate/formate.css\" rel=\"stylesheet\" type=\"text/css\">\n");
       print("  <!-- Time now is ".formatTimeStamp(getTimeStamp())."\n");
       print("     Versions used\n");
       print("     =============\n");
       print("       ${myCgiFormName}:${myMainPgm_Version} (${myMainPgm_sccsId})\n");
       print("       Uses ".getLibDescription()."\n");
       print("       Uses ".getAnyDescription("psApplication")."-->\n");
       readFile("${ssiPath}/headend.html",1,-1,$TRUE);
       readFile("${ssiPath}/bodybeg.html",1,-1,$TRUE);
     	 if ($htmlSubTitle ne "") {
     	   print("<CENTER><H1>${htmlSubTitle}</H1>\n");
     	 }
     } else {
       simpleHtmlHeader($title,$subTitle,$showTitleForDetailView);
     }
    } else {
        htmlHeader($htmlTitle,"");
        print("<link href=\"/formate/formate.css\" rel=\"stylesheet\" type=\"text/css\">\n");
        print("<H1>${htmlSubTitle}</H1>\n<CENTER>");
    }
}


sub endOfDocument {
  my($ssiPath) = @_;
  if ($usePubUpMenus) {
    readFile("${ssiPath}/bodyend.html",1,-1,$TRUE);
  }
}

sub actionNotAllowed {
    my($msg) = @_;
    $msg     = setDefault($msg,"Nicht berechtigt");
    print("<CENTER>${msg}");
    print(" <FORM> <INPUT TYPE=BUTTON  VALUE=\"Zurück\" onClick=window.history.back()></FORM>\n",);
}

sub loginFailed {
    $loginFailureMsg  = setDefault($loginFailureMsg,      sprintf("%s<BR>",getLangStr("strNotAuthorized")));
    printf ("<CENTER>${loginFailureMsg}");
    printf (" <FORM> <INPUT TYPE=BUTTON  VALUE=\"%s\" onClick=window.history.back()></FORM>\n",$loginFailureBtnLabel);
}

sub addSearchFilter {
     if (!(((index($action,"For") == 0) || ($action eq "ShowDetail") || ($action eq "UploadDb") || ($action eq "PasswordForgotten")))) {
           @searchFieldNames = ($addrTbl_Name,$addrTbl_Vorname,$addrTbl_Strasse,$addrTbl_Email,$addrTbl_Privilege,$addrTbl_Comment,$addrTbl_Land,$addrTbl_PLZ,$addrTbl_Ort,$addrTbl_Klassen,$addrTbl_Zustaendigkeit,$addrTbl_Funktion);
           printf("<TABLE cellpadding=\"5\" cellspacing=\"5\"><TR><TD><font face='Comic Sans MS' color='#000000'><CENTER>Suchen nach...<BR>\n");
           addSpezFilterSearchBox("SearchFilter",$myCgiFormName,$language,\@searchFieldNames,"like",$TRUE);
	   printf("</TD>");
	   printf("</TR></TABLE>");
     }
     ($modAt,$modBy) = getLastModByAtFromFltFile($addressTable,$addressTableSepChar,$addrTbl_ModDate,$addrTbl_ModBy);
     printf("Letzte Aenderung durch <B>${modBy}</B> am <B>%s</B> gemacht<BR>\n",formatTimeStamp($modAt,"",$TRUE,$TRUE,$psDefaultLang));
}


sub displayNewsApplet {
  printf("<applet code=\"NewsBoard.class\" codebase=\"/JavaClasses/NewsBoard\" height=\"70\" width=\"180\">\n");
  printf("<param name=\"NEWS\" value=\"%s\">\n",getNewsFromFile());
  printf("</applet>\n");
}

sub displayLED_NewsApplet {
  my($filename) = @_;
  
  print(getLedNewsFromFile($filename));
}

sub getNewsFromFile { 
   my %newsRec = getLatestPublishedRecord($newsTicker_Table,$newsTicker_TableSepChar,$newsTicker_PublishDate,$newsTicker_AppletType,$newsTickerTypeEnum_Vertikal);
   ### displayHashTableHTML(%newsRec);
   my $newsText = $newsRec{$newsTicker_NewsText};
   return formatTextForNewsApplet($newsText);
}

sub getLedNewsFromFile {
   my($newsFileNameURL) = @_;
   $newsFileNameURL     = setDefault($newsFileNameURL,"/LED_Panel/exampleTextDelMe1.led");
   my $newsFileName     = $ENV{DOCUMENT_ROOT}.${newsFileNameURL};
   
   
   my %newsRec = getLatestPublishedRecord($newsTicker_Table,$newsTicker_TableSepChar,$newsTicker_PublishDate,$newsTicker_AppletType,$newsTickerTypeEnum_LED);
   ## displayHashTableHTML(%newsRec);
   my $newsText = formatTextForNewsLED_Applet($newsRec{$newsTicker_NewsText});
   ## print("newsText:${newsText}:\n");
   
   unlink($newsFileName);
   open(AFILE_LedAppletText,">${newsFileName}") || showError(sprintf("Error (getLedNewsFromFile): Can't open file: %s : %s",$fullFilename,$!));
   $newsText =~ s/\r//g;
   print(AFILE_LedAppletText "${newsText}");
   close(AFILE_LedAppletText);
     
   return $newsFileNameURL;
}

sub convertTree {
   my($filename) = @_;
   my $treeName = setNewFilenameExtension($filename,"js");
   my $backupFileName = putTimeStampInFileName($filename);
   textFileCopy($filename,$backupFileName);
   BuildMenuTreeJS_forHvMenu($filename,$treeName);
   BuildMenuTreeHTML($filename,getPathNameOutOfFullName($filename),"","${menuTreeDir}header.html","${menuTreeDir}footer.html");
   #### printf("Im Moment kann der ge&#228;nderte Menu-Tree wegen eines Fehler nicht automatisch aktiviert werden.<BR>Bitte sende ein e-mail an <A href=mailto:Walter\@rothlin.com>Walter\@Rothlin.com</A> und er wird es manuell freischalten.\n");
   printf("Converted MenuTree:${treeName}\n");
}

return $TRUE;