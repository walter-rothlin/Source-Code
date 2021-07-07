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
# 01-Mar-2020    V1.1	Walter rothlin	Changed it to REST
# END--------------------------------------------------------------------------
use CGI qw(param);
use lib "$ENV{DOCUMENT_ROOT}/cgi-bin";
use littlePerlLib;

print("HTTP/1.1 200 OK\n");
print("Access-Control-Allow-Origin: *\n");
print("Content-type: application/json\n\n");

# {
#   "Mandant": "8855_Wangen",
#   "Plaene": [{"Name":"Plan_Div","Count":9},{"Name":"Plan_EW","Count":20}]
# }


$mandant     = getParam("Mandant","");

$templateStr = readFileIntoStr("$ENV{DOCUMENT_ROOT}/KML_Template.xml");
$headerStr   = readFileIntoStr("$ENV{DOCUMENT_ROOT}/KML_Header.xml");
$footerStr   = readFileIntoStr("$ENV{DOCUMENT_ROOT}/KML_Footer.xml");

my @dirList = dirListExtended("$ENV{DOCUMENT_ROOT}/${mandant}/Plan_*.csv");
# displayArrayHTML(@dirList);
# print("<BR/>$ENV{DOCUMENT_ROOT}/HydrantenTemplate.xml<BR/><BR/>\n");
print("\{\n  \"Mandant\":\"${mandant}\",\n  \"Plaene\":[");
$firstLoop = $TRUE;
foreach my $dataInfileName (@dirList) {
    if ($firstLoop) {
	   $firstLoop = $FALSE;
    } else {
	   print(",");
    }
	$planName = getFilenameWithoutExtension(getFileNameOutOfFullName($dataInfileName));
    $dataOutfileName = getPathNameOutOfFullName($dataInfileName)."/".getFilenameWithoutExtension(getFileNameOutOfFullName($dataInfileName)).".xml";
	%transList_1 = (
		   "{planName}"  => $planName,

	);
	$headerStrTmp = replacePlaceholdersStr($headerStr,%transList_1);
	writeStringToFile($dataOutfileName,"",$headerStrTmp);

	@records = getAllMatchesFromFltFileAsHashes($dataInfileName,"\\|","","");
	$count = 1;
	# print("Reading data from: ${dataInfileName}<BR/>\n");

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
    print("\n     \{\"Plan_Name\": \"${planName}\",\"Object_Count\": ${count}\}");

	# print("Count of objects converted: ${count}<BR/>\n");
	# print("Writing data to: ${dataOutfileName}<BR/><BR/>\n");
}
print("\n    ]\n\}");  
