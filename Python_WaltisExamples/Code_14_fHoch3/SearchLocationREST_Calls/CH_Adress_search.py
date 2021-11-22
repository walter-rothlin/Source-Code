# ------------------------------------------------------------------
# Name: CH_Adress_search.py
#
# Description: Does a search via REST request to geo.admin (JSON), tel.search (XML) and google
#
# Autor: Walter Rothlin
#
# History:
# 14-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

from waltisLibrary import *


doTrace = False
resultsFound = 10000


while resultsFound > 1:
    searchCriteria = input("Suchkriterium:")
    if len(searchCriteria) == 0:
        print("Application stopped!")
        break

    searchCriteriaEncoded = urllib.parse.quote_plus(searchCriteria)

    # results = getResults_search_ch(searchCriteriaEncoded, doTrace=False)
    # resultsFoundInTelSearch = results['count']
    # print("Records found with search.ch   :{recCount:2d}".format(recCount=resultsFoundInTelSearch))
    # print(json.dumps(results, indent=4))
    #
    # results = getResults_geoAdmin(searchCriteriaEncoded, doTrace=False)
    # resultsFoundInMapGeoAdmin = results['count']
    # print("Records found with geo.admin.ch:{recCount:2d}".format(recCount=resultsFoundInMapGeoAdmin))
    # print(json.dumps(results, indent=4))

    results = getResultsFromAdressSearch(searchCriteriaEncoded, doTrace=False)
    resultsFoundInAdressSearch = results['count']
    print("Records found with AdressSearch   :{recCount:2d}".format(recCount=resultsFoundInAdressSearch))
    print(json.dumps(results, indent=4))
