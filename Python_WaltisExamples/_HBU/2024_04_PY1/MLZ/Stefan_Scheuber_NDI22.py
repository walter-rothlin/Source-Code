#!/usr/bin/python3


'''
Bewertung
========
1. Lauffähiger Code abgegeben (2 Punkte)                                                2
2. CLI Applikation schreibt ein Log-File (2 Punkte)                                     2
3. Für den Weather REST Service wurde ein eigener Token verwendet                       1
4. Eine eigene, reusable Klasse mit einfachem Interface implementiert (4 Punkte)        4
5. Nur absolut Notwendiges ist public (2 Punkte)                                        2
6. Kommentare in Form von doc_strings sind enthalten                                    0
7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                                 0 (Nicht als Kommentar markiert)
8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)                            1
9. Log-Entries enthalten formatierten Time-Stamp und Level                              1
9a. Scrolling Strategie implementiert                                                   1
10. Anzahl Zeilen für Scrollbereich definierbar                                         1
11. ChangesOnly implementiert                                                           1
12. Append / New implementiert                                                          1
13. Delimiter via __init__ setzbar (mit Default-Wert)                                   1
14. Strategie via __init__ setzbar (mit Default-Wert)                                   1
15. Scrolling area via __init__ setzbar (mit Default-Wert)                              1
                                                                -------------------------
                                                                Max. Punkte:22         20
                                                                =========================

- Falls das File noch nicht besteht, Exception!!!
+ initializer kreiert file
- Tests zu kompliziert, nicht mit Implementation gewachsen, nicht gekappselt (Zusammengefasst)


'''

import os
from datetime import datetime
from enum import Enum

class EntryLevel(Enum):
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARNING = "WARNING"
    ERROR = "ERROR"
    CRITICAL = "CRITICAL"

class Logger:
    #Klassen Variable
    #==================================================
    
    
    #Konstruktor
    #==================================================
    def __init__(self, file_path = './', file_name= 'Stefan_Scheuber_log.txt', maxEntrys = 100, onlyChanges = False, append = False, delimiter = ';', titel = '', formatTimeStamp = "%d.%m.%Y %H:%M:%S"):
        #Instanz Variable
        print('__init__() called!')
        self.__file_path = file_path
        self.__file_name = file_name
        self.__maxEntrys = maxEntrys
        self.__onlyChanges = onlyChanges #yes ohne Initialisieren
        self.__append = append #bestehndes File
        self.__delimiter = delimiter
        self.__titel = titel
        self.__formatTimeStamp = formatTimeStamp
        self.__filePathName = self.__GeneratePath()
        self.__lastEntry = ''
        self.__logEntrys = []

        self.__startTime = datetime.now().strftime(self.__formatTimeStamp)

        if not self.__append:
            self.__Initialize()
        else:
            self.__ReadExistingFile()

    #Setter/Getter
    #==================================================
    def setFile_path(self,file_path):
        #Bei Änderung des Pfades wird ein neuer Log erstellt
        if file_path != self.__file_path:
            self.__file_path = file_path
            self.__filePathName = self.__GeneratePath()
            self.__Initialize()

    def setFile_name(self,file_name):
        #Bei Änderung des Filenamens wird ein neuer Log erstellt
        if file_name != self.__file_name:
            self.__file_name = file_name
            self.__filePathName = self.__GeneratePath()
            self.__Initialize()

    def setMaxEintraege(self,max_eintraege):
        self.__maxEntrys = max_eintraege
        #Bei Kürzung der Maximalen Einträge soll die Liste entsprechend eingekürzt werden
        while self.__maxEntrys > 0 and len(self.__logEntrys) > self.__maxEntrys:
            self.__logEntrys.pop(0)
        
    def setOnlyChanges(self,onlyChanges):
        self.__onlyChanges = onlyChanges
    def setDelimiter(self,delimiter):
        self.__delimiter = delimiter 
    def getFilePathName(self):
        return self.__filePathName
        
    #Business Logik
    #==================================================    
    def __GeneratePath(self):
        return os.path.join(self.__file_path, self.__file_name)
    
    def __Initialize(self):
        #Initialisiert das LogFile (erstellt das File und generiert die ersten beiden Zeilen)
        f=open(self.__filePathName,'w',encoding='utf-8')
        f.write(f'<Name> {self.__file_name} </Name> <Date> {self.__startTime} </Date>\n')
        f.write(f'Zeitstempel {self.__delimiter} Log-Level {self.__delimiter} {self.__titel} {self.__delimiter} \n')
        f.close()

    def __ReadExistingFile(self):
        #Bestehendes File einlesen falls vorhanden
        try:
            with open(self.__filePathName, 'r') as file:
                lines = file.readlines()

                # Überspringe Header-Zeilen
                for line in lines[2:]:  # Ab Zeile 3, weil die ersten beiden Header-Zeilen sind
                    log_entry = line
                    self.__logEntrys.append(log_entry)

            print(f"Geladene Log-Einträge: {len(self.__logEntrys)}")
        
        except FileNotFoundError:
            print(f"Logfile '{self.__file_path}' nicht gefunden, ein neues wird erstellt.")
            self.__Initialize()

    def LogAddEntry (self, level: EntryLevel, value):
        #toDo value spliten
        timeStamp = datetime.now().strftime(self.__formatTimeStamp)
        entry = f"{timeStamp}{self.__delimiter}{level.value}{self.__delimiter}{value}{self.__delimiter}\n"

        #Nur Änderungen abspeichern
        if self.__onlyChanges and entry == self.__lastEntry:
          return
        
        self.__lastEntry = entry
        self.__logEntrys.append(entry)
        
        #Kontrolle, der maximalen Einträge
        if self.__maxEntrys > 0 and len(self.__logEntrys) > self.__maxEntrys:
            self.__ClearFirstEntry()
        else:
            f=open(self.__filePathName,'a',encoding='utf-8')
            f.write(entry)
            f.close()

    def __ClearFirstEntry(self):
        self.__logEntrys.pop(0)
        self.__Initialize()
        f=open(self.__filePathName,'a',encoding='utf-8')
        f.writelines(self.__logEntrys)
        f.close()


#ENDE Logger Klasse
#==================================================
if __name__ == '__main__':

#Tests
#==================================================
    def printLog(filePathName):
        f=open(filePathName,'r',encoding='utf-8')
        file_content = f.readlines()
        f.close
        for a_line in file_content:
            print(a_line, end='')


    log = Logger(titel='Test;Test2;Test3')
    printLog(log.getFilePathName())
    print('/n')
    log.LogAddEntry(EntryLevel.DEBUG,'23,24,53')
    log.LogAddEntry(EntryLevel.DEBUG,'23,24,53')
    log.LogAddEntry(EntryLevel.DEBUG,'23,24,53')
    log.LogAddEntry(EntryLevel.DEBUG,'23,24,53')
    printLog(log.getFilePathName())

    log.setOnlyChanges(True)
    log.LogAddEntry(EntryLevel.DEBUG,'23,24,54')
    log.LogAddEntry(EntryLevel.DEBUG,'23,24,53')
    log.LogAddEntry(EntryLevel.DEBUG,'23,24,53')
    log.LogAddEntry(EntryLevel.DEBUG,'23,24,53')
    printLog(log.getFilePathName())

    log.setMaxEintraege(5)
    log.LogAddEntry(EntryLevel.DEBUG,'23,24,54')
    printLog(log.getFilePathName())

    print('Append kontrollieren')

    log2 = Logger(titel='Test;Test2;Test3',append=True, maxEntrys=5)
    log2.LogAddEntry(EntryLevel.DEBUG,'28,24,53')
    printLog(log2.getFilePathName())

    log2 = Logger(titel='Test;Test2;Test3',append=True, maxEntrys=5, file_name='Test3')
    log2.LogAddEntry(EntryLevel.DEBUG,'28,24,53')
    printLog(log2.getFilePathName())

    log2 = Logger(titel='Test;Test2;Test3',append=False)
    printLog(log2.getFilePathName())

    input('Soll die WetterApp gestartet werden?')    

#WeatherApp
#==================================================
import json
import requests
import os
# from myLib import input_int
# from myLib import input_float
from datetime import datetime
import signal

def clearConsol():
    os.system('clear')

# Timeout handler function
def timeout_handler(signum, frame):
    raise TimeoutError("Time's up!")

# Set the signal handler for SIGALRM
signal.signal(signal.SIGALRM, timeout_handler)

def checkLocation(prompt,err_msg):
  error = True
  while error == True:
    Location = input(prompt)
    Location = Location.replace(',', '.')
    Location = Location.replace("'", '')
    Location = Location.replace(' ','')  

    wrongLocation,Location,Country = tryIsLocation(Location)
    if wrongLocation:
      print (f"ERROR: {Location} {err_msg}!!!")
    else:
      error = False
  return Location,Country

def tryIsLocation(Location):  
  url_city = f'https://api.openweathermap.org/geo/1.0/direct?q={Location}&limit=5&appid=ffcf4c598c2b2972edfbffbcf147433a'
  responseCity = requests.get(url_city)
  if responseCity.status_code == 200:
    try:
      jsonResponse = json.loads(responseCity.text)
      City = jsonResponse[0]['name']
      Country = jsonResponse[0]['country']
      return False,City,Country
    except:
       return True,'',''
  return True,'',''   
    
def checkString(prompt,err_msg,strList):
  error = True
  while error == True:
    inpStr = input(prompt)
    inpStr = inpStr.replace(',', '.')
    inpStr = inpStr.replace("'", '')
    inpStr = inpStr.replace(' ','')  

    for str in strList:
      if inpStr == str:
        error = False
        break
    if error:
      print (f"ERROR: {inpStr} {err_msg}!!!")  
  return inpStr

def weatherInfo(location,unit,language):
  url_city = f'https://api.openweathermap.org/data/2.5/weather?q={location}&units={unit}&lang={language}&appid=ffcf4c598c2b2972edfbffbcf147433a'
  responseCity = requests.get(url_city)
  if responseCity.status_code == 200:
    try:
      jsonResponse = json.loads(responseCity.text)
      return jsonResponse
    except:
       return '--'

def stringPreparation(response, log):
  main = response['main']
  weather = response['weather'][0]
  sys = response['sys']

  if log:
    return f'{response["name"]}; {sys["country"]}; {weather["description"]}; {main["temp"]}; {main["pressure"]}; {main["humidity"]}'
  else:
    return f'Ortsname: {response["name"]} Land: {sys["country"]} Wetterbeschreibung: {weather["description"]} Temp: {main["temp"]} Luftdruck: {main["pressure"]} Luftfeuchtigkeit: {main["humidity"]}'

def menue(location = None, country = None, unit = None, language = None):
  clearConsol()
  if location == None:
    location = "Uster"
  if country == None:
     country = "CH"
  if unit == None:
     unit = "metric"
  if language == None:
     language = "de"

  breite = 15
  menu = (f"""
    WeatherResponse Properties
    {'=' *2*breite}
    {'Location:'.ljust(breite)} {location.ljust(breite)}
    {'Country:'.ljust(breite)} {country.ljust(breite)}
    {'Unit:'.ljust(breite)} {unit.ljust(breite)}
    {'Language:'.ljust(breite)} {language.ljust(breite)}
    {'=' *2*breite}
  """)
  return menu
####################################################################


properties = (f"""
  1: Change Location
  2: Change Unit
  3: Change Language
              
  0: Start
  99: Schluss
              """)

location = "Uster"
country = "CH"
unit = "metric"
language = "de"
unitstr = ['imperial','standard','metric']
languageStr = ['de','en','fr']

activProperties = True
while activProperties:
  print (menue(location,country,unit,language))
  print (properties)
  auswahl = input('Do you want to change some properites? \n')

  if auswahl == 1:
    clearConsol()
    print(menue(location,country,unit,language))
    print ('Please type your Location: ')
    location,country = checkLocation('Location: ','Location not available')

  elif auswahl == 2:
    clearConsol()
    print(menue(location,country,unit,language))
    print (f'Please type the Unit {"," .join(unitstr)}: ')
    unit = checkString('Unit: ',f'Unit not available, only {",".join(unitstr)} are possible inputs',unitstr)

  elif auswahl == 3:
    clearConsol()
    print(menue(location,country,unit,language))
    print (f'Please type one of the following languages {",".join(languageStr)}:')
    language = checkString('Language: ',f'Language not available, only {",".join(languageStr)} are possible inputs',languageStr)
  
  elif auswahl == 0:

    clearConsol()
    actualizationTime = input('Please type the actualization time \n')
    user_input = ''
    log3 = Logger(file_name='WeatherLog.txt',maxEntrys=50,titel='ort; weather; temp; pressure; humidity')
    while user_input != 'q':
      actualWeather = weatherInfo(location,unit,language)
      log3.LogAddEntry(EntryLevel.INFO,stringPreparation(actualWeather, True))
      signal.alarm(int(actualizationTime))
      try:
        user_input = input (f'stop with "q" new data every {actualizationTime} seconds')
        # Disable the alarm
        signal.alarm(0)
        if user_input == 'q':
          print ('program ends')
        else:
          print(f'your Input was: {user_input}, commando not supported')
      except TimeoutError:
        print ('No Input... continue') 
      
  elif auswahl == 99:
      print ('Exit')
      activProperties = False
  else:
      print ('Bitte gültige Auswahl treffen')  
  clearConsol()