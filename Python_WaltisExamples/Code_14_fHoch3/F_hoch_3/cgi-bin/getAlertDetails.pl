#!/usr/bin/perl

# START------------------------------------------------------------------------
# Author:        Walter Rothlin
# Description:   getAlertDetails
#
#
# Calling:       getAlertDetails.py
# REST service to get more details about a mailing adress pattern (Peterliwiese 33 8855 --> Walter Rothlin Peterliwiese 33 8855 Wangen SZ +41 55 460 14 40 47 47.1723 / 8.8674
# History:
# 04-Mar-2020    V1.0   Walter Rothlin	Initial Version
#
# END--------------------------------------------------------------------------
use CGI qw(param);
use lib "$ENV{DOCUMENT_ROOT}/cgi-bin";
use littlePerlLib;
use LWP::Simple;

print("HTTP/1.1 200 OK\n");
print("Access-Control-Allow-Origin: *\n");
print("Content-type: application/json\n\n");

$searchPattern  = getParam("searchPattern","Peterliwiese+33+8855+Wangen");

$searchXMLResponse = getHttpSimple("https://tel.search.ch/api/?wo=".${searchPattern}."&key=8e8a84fd0f10d3b44920e49bc3b06a37");

$tel_name      = getTagValueFromXML("tel:name",      $searchXMLResponse);
$tel_firstname = getTagValueFromXML("tel:firstname", $searchXMLResponse);
$tel_street    = getTagValueFromXML("tel:street",    $searchXMLResponse);
$tel_streetno  = getTagValueFromXML("tel:streetno",  $searchXMLResponse);
$tel_zip       = getTagValueFromXML("tel:zip",       $searchXMLResponse);
$tel_city      = getTagValueFromXML("tel:city",      $searchXMLResponse);
$tel_canton    = getTagValueFromXML("tel:canton",    $searchXMLResponse);
$tel_country   = getTagValueFromXML("tel:country",   $searchXMLResponse);
$tel_phone     = getTagValueFromXML("tel:phone",     $searchXMLResponse);
$tel_extra     = getTagValueFromXML("tel:extra ",    $searchXMLResponse);

## print($tel_name);
print("{\n");
print("   \"Name\"     :\"".$tel_name."\",\n");
print("   \"FirstName\":\"".$tel_firstname."\",\n");
print("   \"Street\"   :\"".$tel_street."\",\n");
print("   \"No\"       :\"".$tel_streetno."\",\n");
print("   \"Zip\"      :\"".$tel_zip."\",\n");
print("   \"City\"     :\"".$tel_city."\",\n");
print("   \"Canton\"   :\"".$tel_canton."\",\n");
print("   \"Country\"  :\"".$tel_country."\",\n");
print("   \"Phone\"    :\"".$tel_phone."\",\n");
print("   \"Mobile\"   :\"".$tel_extra."\"\n");

print("}\n");