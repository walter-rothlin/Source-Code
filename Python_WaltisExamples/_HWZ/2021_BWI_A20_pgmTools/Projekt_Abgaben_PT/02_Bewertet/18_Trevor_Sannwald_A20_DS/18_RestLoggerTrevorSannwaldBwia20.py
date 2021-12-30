# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Reference-Applikation mit User-Input
#      - Titel ohne creation timestamp im Header
#      - Ungültie User-Einagben führen zum Absturtz
#
# Class Design und Implementation:
#      + Eigene Klassen vorhanden
#      - Notwendige (__eq__ __str__ ) Methoden nicht implementiert
#      - __init__ wichtige Parameter fehlen
#      - keine Default-Werte
#      - Alle Instance Variablen sind public
#      - OnlyChanges nicht implementiert
#      - Ringbuffer nicht implementiert
#      - Einigen Methoden könnten private (startlog) oder private static sein (bessere encapsulation)
#      - Exceptionhandling in der Klasse oder in der Applikation
#
# Test:
#      - keine Reusable Tests implementiert
#
# Note: 4.5
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wo haben Sie den Ringbuffer implementiert
#    Wo haben Sie den ChangeOnly Mode implementiert
# ------------------------------------------------------------------
import datetime
import json
import os
import requests
import time


# Da ich die Aufgabe nicht ganz verstanden habe, orientierte ich mich am Exampel,

# Hauptteil, damit Programm einiger massen läuft!
# 1. Header bauen Titel,datum etc. und 2 zeile spaltentitel generisch gehalten durch fremdargumente / Zeitaufwand 8h
# 2. Methode um daten aus applikation in logdatei zu schreiben implementieren / Zeitaufwand 7h
# 3. Ringbuffer implementieren / Zeitaufwand 10h /

# nachträglich erängzt:

# Headerzeile mit append ergänzt Auswahl zwischen write und append / Zeitaufwand 10 min
# Max Anzhal zeilen angeben / Zeitaufwand 5 min
# timestamp und log lvl implementieren / Zeitaufwand 2 h
# Eigene APi lösen bei openweathermap
# Input für stadt ohne exception

# noch zu tun doch endgültig keine Zeit mehr dafür!:

# Klassen attribute private machen und setter vollständig implementieren
# Json abfrage dynamische machen, also stadt selber eingeben
# CSV Syntax implementieren
# cleancode erstellen

# Testdokus:

# io.wrapper error bei 2ter Headerzeile gefixt mit *fremdeArgumente und str_listeFremdA = ("{}" * len(listeFremdA)).format(*listeFremdA)
# Auf die Fremdargumente zugreifen und diese in txt datei loggen, ohne timestamp und logging lvl ergab print Probleme gefixt durch / # print(str_liste2FremdA, file=self.f, flush=True)gelöscht
# Formatierungsfehler in Schreibdatei Logdatei.txt  gefixt / encoding="utf-8" gelöscht
# Ringbuffer mit for line in split gefixt.



class myLogging:
    def __init__(self, *fremdeArgumente, neuDatei, maxZeilen):
        datum = str(datetime.datetime.now())
        self.dateiPfad = os.path.abspath(datum)
        self.maxZeilen = maxZeilen
        self.fremdeArgumente = fremdeArgumente
        self.delimiter = '|'
        self.logLvl = "INFO"

        # erste headerzeile
        if neuDatei:
            self.f = open("Logdatei.txt", "w")
            print("# <Name>%s</Name>" % self.dateiPfad, file=self.f, flush=True)

        # zweite headerzeile + Fremde Argumente mit Trennzeichen füllen
            listeFremdA = list(self.fremdeArgumente)
            insertCounter = 1
            for i in range(len(listeFremdA) - 1):
                listeFremdA.insert(insertCounter, self.delimiter)
                insertCounter += 2

            # aus Liste wieder text machen und schreiben
            str_listeFremdA = ("{}" * len(listeFremdA)).format(*listeFremdA) # fügt jedes einzelne Elemente in der liste wieder als  einziger String aneinander
            print("test", str_listeFremdA)
            print(str_listeFremdA, file=self.f, flush=True)
        # Variante falls File schon existieren würde
        else:
            self.f = open("Logdatei.txt", "a")


    # Max Anzhal zeilen angeben
    def set_maxZeilen(self, maxZeilen):
        self.maxZeilen = maxZeilen

    # Applikation in logdatei schreiben inkl. einträge löschen
    def loggen(self, *fremdeArgument):

        # ab der 3 zeile einträge löschen "Ringbuffer"
        with open("Logdatei.txt", "r") as readfile:
            split = readfile.read().split("\n")[:-1]
            # print("test", (len(split)))
            anzahlZeilen = len(split)
        if anzahlZeilen >= self.maxZeilen:
            self.f = open("Logdatei.txt", "w")
            del split[2]
            for line in split:
                print(line, file=self.f)

        # Auf die Fremdargumente zugreifen und diese in txt datei loggen, ohne timestamp und logging lvl
        liste2FremdA = list(fremdeArgument)
        insertCounter = 1
        for i in range(len(liste2FremdA) - 1):
            liste2FremdA.insert(insertCounter, self.delimiter)
            insertCounter += 2

        # timestamp und log lvl implementieren
        datum_log = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        datumLoglvl = "{}{}{}{}".format(datum_log, self.delimiter, self.logLvl, self.delimiter)
        # print("testdatumLoglvl", datumLoglvl)
        print(datumLoglvl, file=self.f, end="", flush=True)
        finaltext = ("{}" * len(liste2FremdA)).format(*liste2FremdA )
        # print("testfi", finaltext)
        print(finaltext, file=self.f, flush=True)





m = myLogging("timestamp","levelname","temp","pressure", "humidity", "lon", "lat", "cloud",neuDatei=True, maxZeilen=12)


stadt = input(str("Gib eine gültige Stadt ein z.B. Kloten: "))


pollingTime = float(input("Polling-Time [s]:"))
serviceURL = "https://api.openweathermap.org/data/2.5/weather"
# appId = "144747fd356c86e7926ca91ce78ce170"
appIdTrevor = "5de295b5411b57677794856b2f378fd8"
while True:
  responseStr = requests.get(serviceURL + "?q=" + stadt +"&units=metric&lang=de&appid=" + appIdTrevor)
  # responseStr = requests.get(serviceURL + "?q=Kloten&units=metric&lang=de&appid=" + appIdTrevor)
  jsonResponse = json.loads(responseStr.text)

  temp = jsonResponse["main"]["temp"]
  pressure = jsonResponse["main"]["pressure"]
  humidity = jsonResponse["main"]["humidity"]
  lon = jsonResponse["coord"]["lon"]
  lat = jsonResponse["coord"]["lat"]
  cloud = jsonResponse["weather"][0]["description"]
  print(temp, pressure, humidity, lon, lat, cloud)
  m.loggen(temp, pressure, humidity, lon, lat, cloud)  # Fremdargumente holen
  time.sleep(pollingTime)
