#!/usr/bin/perl

use CGI qw(param);
use LWP::Simple;
use LWP::UserAgent;
use lib "$ENV{DOCUMENT_ROOT}/cgi-bin";
use littlePerlLib;

print("Content-type: text/html\n\n");

$reqUrl  = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Peterliwiese+33+8855+Wangen&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyDAKgrjrKNmBPu47TUFP-x8hY_jp2Ainbk";

$ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
$responseStr = $ua->get($reqUrl);

if ($responseStr->is_success) {
    print($responseStr->decoded_content);
} else {
    print("ERROR:",$responseStr->status_line);
}
