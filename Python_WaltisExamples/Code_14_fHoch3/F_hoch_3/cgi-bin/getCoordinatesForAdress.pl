#!/usr/bin/perl

# START------------------------------------------------------------------------
# Author:        Walter Rothlin
# Description:   getCoordinatesForAdress.pl
#
#
# Calling:       getCoordinatesForAdress.pl
#
# History:
# 05-Feb-2020    V1.0   Walter Rothlin	Initial Version
#
# END--------------------------------------------------------------------------
use CGI qw(param);
use LWP::Simple;
use LWP::UserAgent;
use lib "$ENV{DOCUMENT_ROOT}/cgi-bin";
use littlePerlLib;

print("Content-type: text/html\n\n");


# Place API aktivieren
# https://console.cloud.google.com/google/maps-apis/apis/places-backend.googleapis.com/metrics?project=f-hoch-3

$address  = getParam("Adresse","Peterliwiese+33+8855+Wangen");
$format   = getParam("Format","kml");
$reqUrl   = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${address}&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyDAKgrjrKNmBPu47TUFP-x8hY_jp2Ainbk";


$ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
$response = $ua->get($reqUrl);

if ($response->is_success) {
    $responseStr = $response->decoded_content;
	if ($format eq "kml") {
	     $responseStr =~ s/\s+//g;
		 $responseStr =~ s/\n//g;
		 $responseStr =~ s/\"//g;
		 $responseStr =~ s/\{//g;
		 $responseStr =~ s/\}//g;
		 $startPattern = "geometry:location:lat:";
		 $responseStr = substr($responseStr,index($responseStr,$startPattern) + length($startPattern));
		 $endPattern = "viewport:";
		 $responseStr = substr($responseStr,0,index($responseStr,$endPattern));
		 $responseStr =~ s/\,//g;
		 $responseStr =~ s/lng//g;
		 $responseStr = getFieldFromString(":",1,$responseStr).",".getFieldFromString(":",0,$responseStr)
	}
} else {
    print("ERROR:",$response->status_line);
}

print("${responseStr}");
