# ------------------------------------------------------------------
# Name: REST_Ampel.py
#
# Description: REST-Service fuer LED Farben wechseln
#
# Autor: Walter Rothlin
#
# History:
# 04-Jul-2022    Walter Rothlin        Initial Version
# ------------------------------------------------------------------
from grobot import *

# Evenbthandler definition
# ------------------------
def onRequest(clientIP, state, params):
    # 0: aus, 1: rot, 2: gruen, 3: orange, 
    # 4: gruen blinkend, 5: rot blinkend, 
    # 6: rot blinkend hell, 
    # 7: gruen doppelblinkend, 8: rot doppelblinkend, 
    # 9: rot doppelblinkend hell
    if state == "/red":
        setLED(1)
    elif state == "/green":
        setLED(2)
    elif state == "/orange":
        setLED(3)
    elif state == "/off":
        setLED(0)

def showDefaultScreen():
    print("\n\nWaiting for order requests..")
    clearDisplay()
    drawString("Select Color V2.0",0,1)
    drawString("-----------------",0,2)
    drawString("Farbe?",0,4)
    
# HTML-Page
# ---------
html_simple = """
<!DOCTYPE html>
<html>
  <head> 
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <head>
  <body> 
  <h2>IoT REST for LED Colors V1.0</h2> 
     <p>Press to change the state:</p>
     <p><a href="red">RED</a></p>
     <p><a href="orange">ORANGE</a></p>
     <p><a href="green">GREEN</a></p>
     <p><a href="off">Light OFF</a></p>
  </body> 
</html>
"""

html_ampel = """
<!DOCTYPE html>
<html>
  <head> 
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <head>
  <body> 
  <h2>IoT REST for LED Colors 2.0</h2> 

     <!-- https://cdn-icons-png.flaticon.com/512/5900/5900454.png -->
     <img src="http://peterliwiese.ch/LegoBilder/ampel.png" alt="signal_light" usemap="#signal_demo"/>
     <map name="signal_demo">
         <area shape="rect" coords="200,310,312,430" href="green" alt="green">
         <area shape="rect" coords="200,170,312,279" href="orange" alt="orange">
         <area shape="rect" coords="200,50,312,149" href="red" alt="red">
     </map>

     <p>Click the color you want to apply to the signal light.</p>

  </body> 
</html>
"""

# Saving HTML File
# ----------------
print("Saving orderForm..")
saveHTML(html_ampel)
print("..done saving!")


# Web-Server starten und Event-Hanlder registrieren
# -------------------------------------------------
print("Starting Server..")
startHTTPServer(onRequest)
print(".. Server started!")

showDefaultScreen()

# Wait for exit
# -------------
while not button_escape.was_pressed():
    delay(100)
exit()
