#!/usr/bin/perl

# START------------------------------------------------------------------------
# Author:        Walter Rothlin
# Description:   convertKML_Plaene.pl
#
#
# Calling:       convertKML_Plaene.pl
#
# History:
# 02-Feb-2020    V1.0   Walter Rothlin	Initial Version
#
# END--------------------------------------------------------------------------
use CGI qw(param);
use lib "$ENV{DOCUMENT_ROOT}/cgi-bin";
use littlePerlLib;

print("Content-type: text/html\n\n");

$mandant     = getParam("Mandant","");

$templateStr = readFileIntoStr("$ENV{DOCUMENT_ROOT}/KML_Template.xml");
$headerStr   = readFileIntoStr("$ENV{DOCUMENT_ROOT}/KML_Header.xml");
$footerStr   = readFileIntoStr("$ENV{DOCUMENT_ROOT}/KML_Footer.xml");

my @dirList = dirListExtended("$ENV{DOCUMENT_ROOT}/${mandant}/Plan_*.csv");
displayArrayHTML(@dirList);
print("<BR/>$ENV{DOCUMENT_ROOT}/HydrantenTemplate.xml<BR/><BR/>\n");
foreach my $dataInfileName (@dirList) {
    $dataOutfileName = getPathNameOutOfFullName($dataInfileName)."/".getFilenameWithoutExtension(getFileNameOutOfFullName($dataInfileName)).".xml";
	%transList_1 = (
		   "{planName}"  => getFilenameWithoutExtension(getFileNameOutOfFullName($dataInfileName)),

	);
	$headerStrTmp = replacePlaceholdersStr($headerStr,%transList_1);
	writeStringToFile($dataOutfileName,"",$headerStrTmp);

	@records = getAllMatchesFromFltFileAsHashes($dataInfileName,"\\|","","");
	$count = 1;
	print("Reading data from: ${dataInfileName}<BR/>\n");
	foreach my $aRecord (@records) {
	   # print("Name       :",$aRecord->{Name},"<BR/>\n");
	   # print("Desc       :",$aRecord->{Beschreibung},"<BR/>\n");
	   # print("Icon       :",$aRecord->{Icon},"<BR/>\n");
	   # print("Farbe      :",$aRecord->{Farbe},"<BR/>\n");
	   # print("Koordinaten:",$aRecord->{Koordinaten},"<BR/>\n<BR/>\n");

	   %transList = (
		   "{placemark_id}"            => "marker_1".padString($count,12,"0"),
		   "{name}"                    => $aRecord->{Name},
		   "{description}"             => $aRecord->{Beschreibung},
		   "{icon}"                    => $aRecord->{Icon},
		   "{lblColor}"                => $aRecord->{Farbe},
		   "{coordinates}"             => $aRecord->{Koordinaten},
		   "{iconScale}"               => $aRecord->{IconScale},
		);
	   
		$templateStrReplaced = replacePlaceholdersStr($templateStr,%transList);
		writeStringToFile($dataOutfileName,$TRUE,$templateStrReplaced);
		$count = $count + 1;
	}
	writeStringToFile($dataOutfileName,$TRUE,$footerStr);


	print("Count of objects converted: ${count}<BR/>\n");
	print("Writing data to: ${dataOutfileName}<BR/><BR/>\n");
}
