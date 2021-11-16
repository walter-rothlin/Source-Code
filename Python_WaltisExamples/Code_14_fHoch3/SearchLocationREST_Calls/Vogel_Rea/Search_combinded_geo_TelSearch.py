"""
als erstes TelSearch
danach geo.admin

OO gestaltet

proxy klasse erstellen mit Methoden
"""

# API Dokumentation: https://api3.geo.admin.ch/services/sdiservices.html

#############################################################
# Fragen:
# - Wie kann ich bei dem Input String in Zeile 59 wenn ein Abstand eingegeben wird diesen anschliessend aufsplitten
#   damit korrektes Suchkriterium übergeben wird?
# - Wie kriege ich in Zeile 122/123 die Liste so heraus damit ich darauf zugreifen kann für die Geo Anfrage?
#   ---> Weitere Möglichkeit wäre die Suchergebnisse aus dem TelSearch in DB zu schreiben und in der Geo Anfrage
#        darauf zuzugreifen, korrekt?
# - Wie müsste der Code aussehen damit ich die Liste bspw. in Zeile 122/123 direkt in die DB schreiben kann?
# - Zurzeit stecke ich bei dem schreiben der DB Abfrage Klasse an. Kannst Du mir hier einen Anstoss geben,
#   damit ich weiter komme?
# - Zudem möchte ich meine SQL Query analog dem CRUD File aus dem Unterricht hier im Code einbauen.
#   Mein Gedanke ist, dies ebenfalls über eine Klasse zu machen. Was ist Deine Meinung dazu?
#############################################################

import json
import mysql.connector
from lxml import etree
from waltisLibrary import *

appId = "8e8a84fd0f10d3b44920e49bc3b06a37"
serviceURL = "https://tel.search.ch/api/?q={search:2s}&key={appId:2s}"
namespaces = {'tel': 'http://tel.search.ch/api/spec/result/1.0/',
              'openSearch': 'http://a9.com/-/spec/opensearchrss/1.0/'}  # add more as needed


class TelSearch:

    def __init__(self, resultlist = "{}", appId="8e8a84fd0f10d3b44920e49bc3b06a37", searchCriteria="Unknown",
                 serviceURL="https://tel.search.ch/api/?q={search:2s}&key={appId:2s}", dbCon=None, dbCursor=None):
        self.__resultlist = resultlist
        self.__appId = appId
        self.__searchCriteria = searchCriteria
        self.__serviceURL = serviceURL
        self.__conn = dbCon
        self.__cursor = dbCursor

    # def __str__(self):

    # def toString(self):

    def criteria(self):
        while True:
            try:
                print("Besteht Ihr Suchbegriff aus einer Unternehmung [1] oder einer Person [2]?")
                choice = int(input("Eingabe (1 oder 2): "))
                searchInput = ""
                if choice == 1:
                    searchInput = input("Suchbegriff: ")

                elif choice == 2:
                    search1 = input("Vorname: ")
                    search2 = input("Nachname: ")
                    searchInput = search1 + "%20" + search2
                return searchInput

            except ValueError:
                print("Keine Zahl eingegeben!")
                exit()

    def createURL(self, searchCriteria, appId, serviceURL):
        self.__appId = appId
        self.__searchCriteria = searchCriteria
        self.__serviceURLTelSearch = serviceURL
        requestStr = serviceURL.format(search=searchCriteria, appId=appId)  # request zusammenstellen
        return requestStr

class TelSearchResults:

    def __init__(self, recNr=None, type=None, name=None, firstname=None, street=None, streetNr=None, telNr=None, zip=None, dbCon=None, dbCursor=None):
        self.__recNr = recNr
        self.__type = type
        self.__name = name
        self.__firstname = firstname
        self.__street = street
        self.__streetNr = streetNr
        self.__telNr = telNr
        self.__zip = zip
        self.__conn = dbCon
        self.__cursor = dbCursor

    def request(self, requestStr=None):
        responseStr = requests.get(requestStr).content  # XML in response string drin
        print("Response:\n", responseStr, "\n")
        return responseStr

    def parse(self, requestStr=None):

        print(unterstreichen("Parsed values:"))
        dom = etree.HTML(self.request(requestStr))
        value = dom.xpath('//entry')
        recNr = 1
        for aEntry in value:
            type = aEntry.find("type", namespaces).text
            telNr = aEntry.find("phone", namespaces).text
            zip = aEntry.find("zip", namespaces).text
            street = aEntry.find("street", namespaces).text
            streetNr = aEntry.find("streetno", namespaces).text
            name = aEntry.find("name", namespaces).text
            firstname = ""
            if type == "Organisation":
                print("  aEntry     :", aEntry)
                print("  RecNr      :", recNr)
                print("  Type       :", type)
                print("  Name       :", name)
                print("  Zusatz     :", firstname)
                print("  Strasse    :", street)
                print("  StrassenNr :", streetNr)
                print("  telNr      :", telNr)
                print("  Zip        :", zip)
                print()
                resultlist = recNr, type, name, firstname, street, streetNr, telNr, zip
                print("ResListe:", resultlist)
                print()
                recNr += 1

            else:
                firstname = aEntry.find("firstname", namespaces).text
                print("  aEntry     :", aEntry)
                print("  RecNr      :", recNr)
                print("  Type       :", type)
                print("  Name       :", name)
                print("  Vorname    :", firstname)
                print("  Strasse    :", street)
                print("  StrassenNr :", streetNr)
                print("  telNr      :", telNr)
                print("  Zip        :", zip)
                print()
                resultlist = recNr, type, name, firstname, street, streetNr, telNr, zip
                print(resultlist)
                print()
                recNr += 1

    def getType(self):
        return self.__type

def Test_Telsearch():
    print("\n")
    print(unterstreichen("Test-TelSearch"))
    searchRequest = TelSearch()
    print("API Key: ", appId, "\n")

    searchInput = searchRequest.criteria()

    url = searchRequest.createURL(searchInput, appId, serviceURL)
    print("URL", url, "\n")

    myResults = TelSearchResults()

    myResults.parse(url)


if __name__ == '__main__':
    if True:
        Test_Telsearch()

print("-----------------------------------------------------------------")


class GeoAdminSearch:

    def __init__(self, searchCriteriaGeo="Unknown", serviceURL="https://api3.geo.admin.ch/1912100956/rest/services/ech/SearchServer?sr=2056&searchText={search:2s}&lang=en&type=locations"):
        self.__searchCriteriaGeo = searchCriteriaGeo
        self.__serviceURL = serviceURL

    # def __str__(self):

    # def toString(self):

    def criteriaGeo(self):
        while True:
            try:
                print("Suchbegriff besteht nur aus einer Strasse [1] oder einer Strasse und Strassen-Nr. [2]?")
                choice = int(input("Eingabe (1 oder 2): "))
                searchCriteria = ""
                if choice == 1:
                    searchCriteria = input("Strasse: ")

                elif choice == 2:
                    search1 = input("Strasse: ")
                    search2 = input("Strassen-Nr.: ")
                    searchCriteria = search1 + "%20" + search2
                return searchCriteria

            except ValueError:
                print("Keine Zahl eingegeben!")
                exit()


    def parseJSON(self, responseStr):
        recNr = 0
        jsonResponse = json.loads(responseStr.text)  # Multiline string / am einfachsten so verarbeiten wenn JSON Struktur
        print("Parsed values (Records found: {recCount:2d}):".format(recCount=len(jsonResponse['results'])))
        for entry in jsonResponse['results']:
            print("\nRecord No.:", recNr)
            print("  detail  :", entry['attrs']['label'])
            print("  lon     :", entry['attrs']['lon'])
            print("  lat     :", entry['attrs']['lat'])
            recNr += 1

def Test_GeoAdmin():
    print("\n")
    print(unterstreichen("Test-TelSearch"))
    serviceURL = "https://api3.geo.admin.ch/1912100956/rest/services/ech/SearchServer?sr=2056&searchText={search:2s}&lang=en&type=locations"
    geoRequest = GeoAdminSearch()

    searchCriteria = geoRequest.criteriaGeo()
    requestStr = serviceURL.format(search=searchCriteria)
    responseStr = requests.get(requestStr)  # Aufruf der URL
    print("Response:\n", responseStr, "\n")

    geoRequest.parseJSON(responseStr)

if __name__ == '__main__':
    if True:
        Test_GeoAdmin()


print("-----------------------------------------------------------------")

# DB Class
class TelSearchListe:
    def __init__(self, type="Unknown", dbServer = "localhost", dbSchema = "MySearch", userName = "reavo", password = "adminHost732!"):
        self.__type = type
        self.__searchlist = {}
        self.__dbServer = dbServer
        self.__dbSchema = dbSchema
        self.__userName = userName
        self.__password = password

        print(f"Connecting to '{dbSchema:s}' with user '{userName:s}'....", end="", flush=True)
        # https://dev.mysql.com/doc/connector-python/en/connector-python-connectargs.html
        self.__conn = mysql.connector.connect(
            host=self.__dbServer,   # __ = private - nur über Methode kann darauf zugegriffen werden
            database=self.__dbSchema,
            user=self.__userName,
            passwd=self.__password,
            auth_plugin='mysql_native_password'
        )
        print("completed!")
        self.__conn.autocommit = False   # explicit commit and rollback by the application (Front-End) / Check
        self.__cursor = self.__conn.cursor()  # instanzvariabel
        # load kontoliste from DB / where clause = string conncatination
        sql_show_results_query = """
             select 
                  recNr,
                  type,
                  name,
                  firstname,
                  street,
                  streetNr,
                  telNr,
                  zip,
            from searchlist
            where type = '""" + self.__type + """'; 
        """
        self.__cursor.execute(sql_show_results_query)
        myresult = self.__cursor.fetchall()
        for aRec in myresult:
            # print("| {id:4d} | {saldo:10.2f} |".format(id=aRec[0], saldo=aRec[1]))
            self.addSearch(TelSearchResults(recNr=aRec[0], type=aRec[1], name=aRec[2], firstname=aRec[3],
                                            street=aRec[4], streetNr=aRec[5], telNr=aRec[6], zip=aRec[7],
                                            dbCon=self.__conn, dbCursor=self.__cursor))
            # Search kreieren direkt aus DB heraus

    def __str__(self):
        retStr = "type: " + str(self.__type) + "\n"
        for aType in self.__searchlist:
            retStr += "    " + str(self.__searchlist[aType]) + "\n"
        return retStr

    def addSearch(self, newSearch):
        self.__searchlist[newSearch.getType()] = newSearch

    def getResultViaType(self, resulttype):
        return self.__searchlist[resulttype]

    def showResultUebersicht(self, title=None):  # None = defaultwert --> Parameter kann leer gelassen werden
        if title is not None:
            print("\n\n--->" + title)
        print(unterstreichen("Resultatübersicht von " + str(self.__type)))
        firstTime = True
        aResult = None
        for aResultType in self.__searchlist:
            aResult = self.__searchlist[aResultType]
            if firstTime:
                firstTime = False
                print(aResult.toString("title"), end="")
            print(aResult.toString(), end="")
        bilanzSumme = self.getBilanzSumme()
        print(aResult.toString("footer", bilanzSumme), end="")

    def doKontoUebertrag(self, withdrawAmount, fromKontoId, toKontoId, trace=True):
        try:
            effWithDraw = self.getResultViaType(fromKontoId).bezug(withdrawAmount, False)
            self.getResultViaType(toKontoId).deposit(effWithDraw, False)  # kein Commit
            self.__conn.commit()
        except:
            self.__conn.rollback()  # verwirf alle Daten bis zum letzten Commit

    def getBilanzSumme(self):
        bilanzSumme = 0
        for aKontoKey in self.__searchlist:
            aKonto = self.__searchlist[aKontoKey]
            bilanzSumme += aKonto.getSaldo()
        return bilanzSumme


def Test_TelSearchListe():
    print("\n")
    print(unterstreichen("Test-TelSearchListe"))

    entity = int(input("Ich suche nach einer Unternehmung [1] oder einer Person [2]: "))
    if entity == 1:
        type = "Organisation"
    else:
        type = "Person"

    mySearch = TelSearchListe(type)
    print(mySearch)

if __name__ == '__main__':
    if False:
        Test_TelSearchListe()


"""
    mySearch.showResultUebersicht(title="Nach Initialisierung (lesen von DB)")

    # Test Konto-Classe
    print("\n ---> Test Konto")
    kontoWalti_1 = mySearch.getKontoViaID(1)
    print(kontoWalti_1)
    kontoWalti_1.setSaldo(2345)
    print("Bezug   2000:", kontoWalti_1.bezug(2000))
    print("Bezug   2000:", kontoWalti_1.bezug(2000))
    print("Deposit 2000:", kontoWalti_1.deposit(2000))

    kontoWalti_2 = mySearch.getKontoViaID(2)
    print(kontoWalti_2)
    kontoWalti_2.setSaldo(10234)
    mySearch.showResultUebersicht(title="Nach manuellem Konto setzen")

    # Test Kontouebertrag
    print("\n ---> Test Kontoübertrag")
    fromKonto = readInt("Belastungskonto (From): ", min=1, max=2)
    toKonto = readInt("Gutschriftskonto (To) : ", min=1, max=2)
    transferAmount = readFloat("Uebertrags-Betrag: ", min=10, max=10000)

    mySearch.doKontoUebertrag(transferAmount, fromKonto, toKonto)
    mySearch.showResultUebersicht(
        title=" After: {fff:3d} --> {tAm:1.2f} --> {ttt:3d}".format(fff=fromKonto, ttt=toKonto, tAm=transferAmount))

    mySearch.doKontoUebertrag(transferAmount, toKonto, fromKonto)
    mySearch.showResultUebersicht(
        title=" After: {ttt:3d} --> {tAm:1.2f} --> {fff:3d}".format(fff=fromKonto, ttt=toKonto, tAm=transferAmount))

    # Set back to original amounts
    kontoWalti_1.setSaldo(2000)
    kontoWalti_2.setSaldo(5000)
    mySearch.showResultUebersicht(title="After set back to original amounts")


INSERT INTO `searchlist` VALUES 
         (1, 'Person', 'Vogel', 'Roland', 'Gartenstrasse', 11, '+41447501634', 8102),
         (2, 'Person', 'Rothlin', 'Walter', 'Peterliwiese', 33, '+41554601440', 8855),
         (3, 'Person', 'Heinemann', 'Antonietta', 'Promenadenstrasse', 35, '+41318395138', 3076);
"""

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------

