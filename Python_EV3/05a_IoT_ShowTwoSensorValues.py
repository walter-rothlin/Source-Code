# Python_EV3: 05a_IoT_ShowTwoSensorValues.py

from grobot import *

html = """<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="refresh" content="3">
  </head>
  <body> 
    <h2>Sensirion Sensor</H2> 
    Current temperature, humidity: <br><br>
    %s, %s
  </body>
</body>
</html>
"""
print("Saving HTML")
saveHTML(html) 

def onRequest(clientIP, filename, params):
   temp = "26°C"
   humi = "65%"
   ### temp, humi = sht1.getValues()
   return [temp, humi]
    
startHTTPServer(onRequest)
print("Server running")
while not button_escape.was_pressed():
    delay(100)
exit()