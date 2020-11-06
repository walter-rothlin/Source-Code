# Python_EV3: 05a_IoT_ShowDist.py

from grobot import *

html = """<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="refresh" content="3">
  </head>
  <body> 
    <h2>WebRobot</H2> 
    Current distance: %s<br>
  </body>
</html>
"""
print("Saving HTML")
saveHTML(html) 

def onRequest(clientIP, state, params):
   d = us3.getDistance()
   return [d]
    
startHTTPServer(onRequest)
print("Server starting")
while not button_escape.was_pressed():
    delay(100)
exit()