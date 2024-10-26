#!/usr/bin/python3

import json
import requests
import time

app_id ='5adc5d6f8f63612bf4533215e9bffe72'

class DataLogger:
    __last_value = 0
    
    def __init__(self,file_name = 'Data_log.txt',file_path = None, new_file = True, delimiter = ';' , only_changes = True, fixed_slices = True, entries = 100, titel_entry = 'temp'):
        self.__file_name = file_name
        self.__new_file = new_file
        self.__delimiter = delimiter
        self.__only_changes = only_changes
        self.__fixed_slices = fixed_slices
        self.__entries = entries
        self.__titel_entry = titel_entry
        if self.__new_file == True:
            self.start_logging()
        if file_path is not None:
            self.__file_name = file_path + self.__file_name
    
    def __str__(self):
        return f'Ein Objekt der Klasse DataLogger: Filename = {self.__file_name} ; Neues File = {self.__new_file} ; Delimiter = {self.__delimiter} ; Only Changes = {self.__only_changes} ; Fixed Slices = {self.__fixed_slices} ; Eintragsname = {self.__titel_entry}; Einträge = {self.__entries}'

    #setter / getter Methoden
    #========================
    def set_file_name(self, new_file_name):
        self.__file_name = new_file_name
    
    def get_file_name(self):
        return self.__file_name
        
    def set_new_file(self, new_file):
        self.__new_file = new_file
    
    def get_new_file(self):
        return self.__new_file
    
    def set_delimiter(self, new_delimiter):
        self.__delimiter = new_delimiter
    
    def get_delimiter(self):
        return self.__delimiter
    
    def set_only_changes(self, new_only_changes):
        self.__only_changes = new_only_changes
    
    def get_only_changes(self):
        return self.__only_changes
    
    def set_fixed_slices(self,new_fixed_slices):
        self.__fixed_slices = new_fixed_slices
    
    def get_fixed_slices(self):
        return self.__fixed_slices
    
    def set_entries(self, new_entries):
        self.__entries = new_entries
    
    def get_entries(self):
        return self.__entries
    
    def set_titel_entry(self, new_titel_entry):
        self.__titel_entry = new_titel_entry
        
    def get_titel_enty(self):
        return self.__titel_entry
    
    #Business - Methoden
    #===================
    
    def localtime(self):
        return time.strftime("%d.%m.%Y %H:%M:%S", time.localtime(time.time()))
        
    def shift_logfile(self, max_lines):
        with open(self.__file_name, 'r') as f:
            lines = f.readlines()
        if len(lines) > max_lines +1:
            lines = lines[:2] + lines[3:] # lines[:2] gibt den Titel zurück, lines[3:] gibt alle Zeilen nach den ältesten Eintrag zurück.
        with open(self.__file_name, 'w') as f:
            f.writelines(lines)
            
        
    def writelog(self,log_level, entry):
        f = open(self.__file_name, 'a', encoding = 'utf-8')
        f.write(f'{self.localtime()}{self.__delimiter}{log_level}{self.__delimiter}{entry}')
        f.write('\n')
        f.close()
    
    def start_logging(self):
        f = open(self.__file_name, 'w', encoding = 'utf-8')
        f.write(f'{self.__file_name}: Erzeugt am {self.localtime()}')
        f.write('\n')
        f.write(f'Zeitstempel {self.__delimiter} Log-Level {self.__delimiter} {self.__titel_entry}')
        f.write('\n')
        f.close()               
        
    def log(self,log_level = 'INFO', entry = '0'):
        self.shift_logfile(self.__entries)
        if entry == DataLogger.__last_value:
            if self.__only_changes == False:
                self.writelog(log_level, entry)
                DataLogger.__last_value = entry
        else:
            self.writelog(log_level,entry)
            DataLogger.__last_value = entry

# ===========================================================
# MAIN
# ===========================================================    
    
if __name__ =='__main__':
    
    def weather_request(city_name,app_id):
        url_str = f"https://api.openweathermap.org/data/2.5/weather?q={city_name}&units=metric&lang=de&appid={app_id}"
        responseStr = requests.get(url_str)
        responseStr = responseStr.text
        return json.loads(responseStr)
        
    def weather_name_to_string(jsonResponse):
        return f"{jsonResponse['name']}"

    def weather_country_to_string(jsonResponse):
        return f"{jsonResponse['sys']['country']}"
        
    def weather_temp_to_string(jsonResponse):
        return f"{jsonResponse['main']['temp']}"
        
    def weather_humidity_to_string(jsonResponse):
        return f"{jsonResponse['main']['humidity']}"
        
    def weather_description_to_string(jsonResponse):
        return f"{jsonResponse['weather'][0]['description']}"

#Tests 
    jsonResponse = weather_request('Uster',app_id)
    
    datalogger_test = DataLogger(titel_entry = 'humidity', only_changes = False, entries = 4)
    datalogger_test.log(entry = weather_humidity_to_string(jsonResponse))
    datalogger_test.log(entry = weather_humidity_to_string(jsonResponse))
    datalogger_test.log(entry = weather_humidity_to_string(jsonResponse))
    datalogger_test.log(entry = weather_humidity_to_string(jsonResponse))
    datalogger_test.log(entry = weather_humidity_to_string(jsonResponse))
    
