# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert und User Input ist möglich
#      - Nur User-Eingabe der Pooling-Time möglich
#      - Unsinnige User-Eingaben können zum Absturz führen
#
# Class Design und Implementation:
#      + Eigene Klasse
#      - Notwendige (__eq__ __str__ ) Methoden nicht vorhanden
#      + __init__ wichtige Parameter vorhanden (OnlyChanges, FixedSlices, Ringbuffersize, New/Append,....)
#      + __init__ Parameter haben alle sinnvolle Defaultwerte
#      - Alle Instance Variablen sind public oder protected (nicht private)
#      - file-extension ohne Prüfung (rest.log.csv!!)
#      + OnlyChanges funktioniert (mit runden / Toleranz)
#      + Ein Ringbuffer implementiert (fixed Slices)
#      - check_ringbuffer() muss private sein und von log() intern aufgerufen werden
#      - Einigen Methoden könnten private oder private static sein (bessere encapsulation)
#      - Kein Exceptionhandling in der Klasse
#      + comprehensions verwendet (Wo?)
#      - ungenügend dokumentiert (docStrings)
#
# Test:
#      - Nur zwei Test mit geringer Test-Abdeckung implementiert
#
# Note: 4.5
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wo wird unterschieden zwischen changesOnly True/False?
# ------------------------------------------------------------------
from datetime import datetime
import requests
import json
import time

class Logger:
    def __init__(self,
                full_filename="rest.log",
                time_format="%c",
                delimiter="|",
                num_entries = 10,
                fixed_slices = True,               #if not true log onlychanges
                create_new_file = True             # if not true then append to file
            ):
        self._full_filename = full_filename + ".csv"
        self.time_format = time_format
        self._delimiter = delimiter
        self._num_entries = num_entries
        self._fixed_slices = fixed_slices
        self._create_new_file = create_new_file
        self.start_time = datetime.now().strftime(time_format)
        self._last_message = None


        if create_new_file:
            self.write_header()

    # create/overwrite file and write header
    def write_header(self):
        log_file = open(self._full_filename, "w")  # create or rewrite
        line1 = "# <Name>" + self._full_filename + self._delimiter + self.start_time + "</Name>" + "\n"  # define my headline
        log_file.write(line1)

        csv_syntax = ","
        line2 = "Time-Stamp" + self._delimiter + "Log Level" + self._delimiter + "Message\n"  # define my 2nd headline
        log_file.write(line2)
        log_file.close()

    #Getters
    @property
    def delimiter(self):
        return self._delimiter

    @property
    def full_filename(self):
        return self._full_filename

    @property
    def num_entries(self):
        return self._num_entries

    @property
    def fixed_slices(self):
        return self._fixed_slices

    @property
    def create_new_file(self):
        return self._create_new_file


    #Setters

    @delimiter.setter
    def delimiter(self, value):
        self._delimiter = value

    @full_filename.setter
    def full_filename(self,value):
        self._full_filename = value

    @num_entries.setter
    def num_entries(self,value):
        self._num_entries = value

    @fixed_slices.setter
    def fixed_slices(self,value):
        self._fixed_slices = value

    @create_new_file.setter
    def create_new_file(self,value):
        return self._create_new_file


    def log(self,level,message):
        # if I choose to "only changes" and the line before is equal to the last logged line then do not log (nothing to do)
        if not self._fixed_slices and self._last_message == message:
            return
        # print("last line:",self._last_line)               # for testings / troubleshooting
        # print("message:",message)                            # for testings / troubleshooting
        log_file = open(self._full_filename, "a")       #append

        time_stamp = datetime.now().strftime(self.time_format)
        logline = time_stamp + self.delimiter + level + self.delimiter+ message +"\n"
        log_file.write(logline)
        log_file.close()
        # save my last line in the object:
        self._last_message = message

    def check_ringbuffer(self):
        lines = []
        with open(self.full_filename, "r") as f:
            lines = f.readlines()
        length_of_lines = len(lines)

        if length_of_lines > self._num_entries:
            new_lines = lines[-self._num_entries:]  # it creates a new list where it slices from the "3rd" position on from backwards
            self.write_header()
            with open(self.full_filename,"a") as f:
                f.writelines(new_lines)


x = Logger(create_new_file=True)
assert(x.num_entries == 10)     #TESTING GETTER
x.num_entries = 15              #TESTING SETTER
assert (x.num_entries == 15)


# CLI Application
#================

l = Logger(create_new_file=True, )     #set an instance


pollingTime = float(input("Please add the Polling-Time [s]:"))
serviceURL = "https://api.openweathermap.org/data/2.5/weather"
appId = "a57516a433d91e035d9f5ac3a435111c"
location = str(input("Give me the name of the location you wanna have the infos: "))

while True:
    responseStr = requests.get(serviceURL + "?q=" + location + "&lang=de&appid=" + appId)
    jsonResponse = json.loads(responseStr.text)

    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']
    cloud = jsonResponse['weather'][0]['description']
    int_values = temp, pressure, humidity, lon, lat
    int_to_str = [str(round(i, 1)) for i in int_values]    # WR comprehension verwendet, super!
    log_line = l.delimiter.join(int_to_str) + l.delimiter + cloud
    print(log_line)
    l.log("Info", log_line)              #do logging / create instanz
    l.check_ringbuffer()
    time.sleep(pollingTime)