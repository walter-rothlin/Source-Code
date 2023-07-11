# Python_EV3: 05a_IoT_LightOnOff.py

from grobot import *

html = """
<!DOCTYPE html>
<html>
  <head> 
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <head>
  <body> 
  <h2>WebRobot</h2> 
     <p>Press to change the state:</p>
     <p><a href="on">Light ON</a></p>
     <p><a href="off">Light OFF</a></p>
  </body> 
</html>
"""
print("Saving HTML")
saveHTML(html)

def onRequest(clientIP, state, params):
    if state == "/on":
        setLED(2)
    elif state == "/off":
        setLED(0)


startHTTPServer(onRequest)

while not button_escape.was_pressed():
    delay(100)
exit()