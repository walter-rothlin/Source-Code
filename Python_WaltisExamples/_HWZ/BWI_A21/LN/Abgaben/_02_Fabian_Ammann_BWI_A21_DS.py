import os

import requests
import json
import time
import datetime


def get_formatted_timestamp():
    return datetime.datetime.now().isoformat(sep=" ", timespec="seconds")


class Logger:
    """
    This is a reusable Logger Class with an easy interface
    Following Properties can be set via setter or initializer overloading:
    delimiter (Default: "|")
    file_to_write_path (Default: "./log.csv)
    scroll_after (Default: 0 -> No scrolling)
    only_changes (Default: True)
    append_or_new (Default: append)
    """

    def __init__(self, delimiter=';', append_or_new='a', only_changes=True, scroll_after=0,
                 file_to_write_path='.//log.csv'):
        self.__delimiter = delimiter
        self.__only_changes = only_changes
        self.__append_or_new = append_or_new
        self.__file_to_write_path = file_to_write_path
        self.__scroll_after = scroll_after

    def set_file_to_write_path(self, file_to_write_path):
        self.__file_to_write_path = file_to_write_path

    def set_delimiter(self, delimiter):
        self.__delimiter = delimiter

    def set_append_or_new(self, append_or_new):
        self.__append_or_new = append_or_new

    def set_scroll_after(self, scroll_after):
        self.__scroll_after = scroll_after

    def set_only_changes(self, only_changes):
        self.__only_changes = only_changes

    def log_to_file(self, log_lvl, log_string):
        """
        This is the main Logger function
        It logs new content to the file, defined in the logger settings
        It has multiple logging strategies, f.e. scrolling or onlyChanges
        """
        string_to_write = log_lvl + self.__delimiter + log_string

        # Scrolling functionality
        if self.__scroll_after > 0:
            with open(self.__file_to_write_path, "r") as file:
                lines = file.readlines()
            if len(lines) > self.__scroll_after:
                with open(self.__file_to_write_path, "w") as file:
                    # Write Header
                    file.write(lines[0])
                    file.write(lines[1])
                    # Write Lines
                    counter = len(lines) - (self.__scroll_after - 1)
                    while counter < len(lines):
                        file.write(lines[counter])
                        counter = counter + 1

        # Only Changes functionality
        if self.__only_changes:
            with open(self.__file_to_write_path) as f:
                for line in f:
                    pass
                if self.__delimiter in line:
                    last_line = line.split(self.__delimiter, 1)[1].replace('\n', '')
                    if last_line == string_to_write:
                        return
        file_to_write = open(self.__file_to_write_path, self.__append_or_new)
        file_to_write.write(get_formatted_timestamp() + self.__delimiter + string_to_write + '\n')

    def log_header(self, header_to_log):
        file_to_write = open(self.__file_to_write_path, 'a')
        file_to_write.write(header_to_log + '\n')

    def prepare_file(self):
        if not os.path.isfile(self.__file_to_write_path):
            open(self.__file_to_write_path, 'x')

    def delete_content(self):
        open(self.__file_to_write_path, 'w').close()

    def header_exists(self):
        print(os.path.isfile(self.__file_to_write_path))
        if not os.path.isfile(self.__file_to_write_path):
            open(self.__file_to_write_path, 'x')
            return False
        print(os.stat(self.__file_to_write_path).st_size == 0)
        if os.stat(self.__file_to_write_path).st_size == 0:
            return False
        else:
            return True

    def log_string_builder(self, value_list):
        value_string = ''
        for value in value_list:
            value_string += str(value)
            value_string += self.__delimiter

        return value_string

    def get_header_prefix(self):
        return 'timestamp' + self.__delimiter + 'Log Level' + self.__delimiter

    def get_header_title(self):
        return '# <Filename>' + self.__file_to_write_path + '</Filename>' + \
               '<Date>' + get_formatted_timestamp() + '</Date> '

    def debug(self, value_list):
        self.log_to_file('debug', value_list)

    def info(self, value_list):
        self.log_to_file('info', value_list)

    def warning(self, value_list):
        self.log_to_file('warning', value_list)

    def error(self, value_list):
        self.log_to_file('error', value_list)

    def critical(self, value_list):
        self.log_to_file('critical', value_list)


class WeatherResponseDomain:
    """
    This is the WeatherResponseDomain Object
    It is a simple Object with the information and basic functionalities of the weather request information
    """
    def __init__(self, json_response):
        self.placeName = json_response['name']
        self.land = json_response['sys']['country']
        self.temp = json_response['main']['temp']
        self.pressure = json_response['main']['pressure']
        self.humidity = json_response['main']['humidity']
        self.lon = json_response['coord']['lon']
        self.lat = json_response['coord']['lat']
        self.cloud = json_response['weather'][0]['description']
        self.windSpeed = json_response['wind']['speed']
        self.windDirection = json_response['wind']['deg']

    def get_values_as_list(self):
        return [self.placeName, self.land, self.temp, self.pressure, self.humidity, self.lon, self.lat,
                self.cloud, self.windSpeed, self.windDirection]

    @staticmethod
    def get_header_as_list():
        return ['placeName', 'land', 'temp', 'pressure', 'humidity', 'lon', 'lat',
                'cloud', 'windSpeed', 'windDirection']


class WeatherApiService:
    """
    This is the WeatherApiService
    Its a service which does simple request to the weather api
    """
    # Config of WeatherService
    api_url = "https://api.openweathermap.org/data/2.5/weather"
    place_prefix = "?q="
    path_variables = "&units=metric&lang=de&appid="
    app_id = "44ab77490cd2f2ca7954986aaad2e13c"

    @staticmethod
    def get_url(reqeust_place):
        return WeatherApiService.api_url + \
               WeatherApiService.place_prefix + \
               reqeust_place + \
               WeatherApiService.path_variables + \
               WeatherApiService.app_id

    @staticmethod
    def get_weather_data_of_place(request_url):
        return requests.get(request_url)


if __name__ == '__main__':
    """
    This is the main program. It brings everything together
    """
    # User Inputs
    user_number_requests = int(input('How many API Request should be done (number):\t\t\t\t\t\t\t\t'))
    user_polling_time = int(input('How many seconds between the requests (number):\t\t\t\t\t\t\t\t'))
    user_place = input('For which place do you want todo the api call (string):\t\t\t\t\t\t')

    if user_place == '':
        user_place = 'Uster'
        print('Taking default place -> Uster')

    user_delimiter = input('Which delimiter do you want (string):\t\t\t\t\t\t\t\t\t\t')
    if user_delimiter == '':
        user_delimiter = '|'
        print('Taking default delimiter -> |')

    user_file_output = input('In which File should be logged (string):\t\t\t\t\t\t\t\t\t')
    if user_file_output == '':
        user_file_output = './/log.csv'
        print('Taking default File  -> .//log.csv')

    user_append_or_new = input('Press x to create a new File or a for appending to an existing (x or a):\t')
    if user_append_or_new == '':
        user_append_or_new = 'a'
        print('Taking default -> a')

    user_only_changes = input('Type y if only changes should be logged to the logging file (y or n):\t\t')
    if user_only_changes == '':
        user_only_changes = 'n'
        print('Taking default -> n')

    if user_only_changes == 'y':
        user_only_changes = True
    else:
        user_only_changes = False

    user_scroll_after = int(input('After how many lines should be scrolled, 0 for no scrolling (number):\t\t'))

    # New Logger with User or Default Settings
    logger = Logger(user_delimiter, user_append_or_new, user_only_changes, user_scroll_after, user_file_output)

    # Create Request URL
    url = WeatherApiService.get_url(user_place)

    # Prepare File
    if user_append_or_new == 'x':
        logger.delete_content()

    # Create Header if not exists for every case
    if not logger.header_exists():
        title = logger.get_header_title()
        header = logger.get_header_prefix() + logger.log_string_builder(WeatherResponseDomain.get_header_as_list())
        # write Header to log
        logger.log_header(title)
        logger.log_header(header)
        # Console output for Header
        print('Header Printed')

    # Set append mode
    logger.set_append_or_new('a')

    # Do Weather Api Requests and Log to File
    for x in range(0, user_number_requests):
        # Get Weather Data
        response = WeatherApiService.get_weather_data_of_place(url)
        # Load Content of Response
        json_string = json.loads(response.text)
        # Create Weather Domain Object with Content of Response
        weather_domain = WeatherResponseDomain(json_string)
        # Create String for Log
        values_with_delimiter = logger.log_string_builder(weather_domain.get_values_as_list())
        # Log Object Content to File via Logger
        logger.info(values_with_delimiter)
        # Console output for the current counter
        print('Request: ' + str(x + 1))
        # Polling Time sleeper
        time.sleep(user_polling_time)

# ---------------------------------------------------------
# Review / Beurteilung
# ---------------------------------------------------------
# 1. Lauffähiger Code abgegeben (2 Punkte)                                  2
#    Alles in einem File (ausnahmsweise für diese Aufgabenstellung)
#    Filename: Vorname_Nachname_A19_DS.py (z.B. Rea_Vogel_A19_DS.py)
# 2. CLI Applikation schreibt ein Log-File (2 Punkte)                       2
# 3. Für den Weather REST Service wurde ein eigener Token verwendet         2
# 4. Eine eigene, reusable Klasse mit
#    einfachem Interface implementiert (4 Punkte)                           2 (header_exists,....)
# 5. Nur absolut Notwendiges ist public (2 Punkte)                          1 (header_exists,....)
# 6. Kommentare in Form von doc_strings sind enthalten                      1
# 7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                   1
# 8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)              1
#    Log-Entries enthalten formatierten Time-Stamp und Level                1
# 9. Scrolling Strategie implementiert                                      1
# 10. Anzahl Zeilen für Scrollbereich definierbar                           1
# 11. ChangesOnly implementiert                                             1
# 12. Append / New implementiert                                            1
# 13. Delimiter via __init__ setzbar (mit Default-Wert)                     1
# 14. Strategie via __init__ setzbar (mit Default-Wert)                     1
# 15. Scrolling area via __init__ setzbar (mit Default-Wert)                1
#                                                                       ---------
#                                                                          20
#                                                                       =========