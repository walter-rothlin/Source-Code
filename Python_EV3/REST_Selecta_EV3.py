# ------------------------------------------------------------------
# Name: REST_Selecta_EV3.py
#
# Description: REST-Service for Lego Selecta Automat
#
# Autor: Walter Rothlin
#
# History:
# 08-Dec-2020    Robin Marty        Initial Version
# 04-Jul-2022    Walter Rothlin     Changed Look&Feel, Added Trace
# ------------------------------------------------------------------
from grobot import *

# Evenbthandler and other functions
# ---------------------------------
def onRequest(clientIP, state, params):
    if params != {}:
        print("request received!")
        print("     Gruen: " + params["gruen"])
        print("     Blau : " + params["blau"])
        print("     Rot  : " + params["rot"])
        clearDisplay()
        drawString("Gruen: " + params["gruen"],0,0)
        drawString("Blau : " + params["blau"] ,0,1)
        drawString("Rot  : " + params["rot"]  ,0,2)

        motD.rotate(50)
        moveBrick(-72,params["gruen"], motB)
        moveBrick(-72,params["blau"] , motC)
        moveBrick(-72,params["rot"]  , motA)
        motD.rotateTo(1800)

    showDefaultScreen()
    return

def moveBrick(mult, amnt, mot):
    if amnt == "":
        return
    # print(mult*int(amnt))
    mot.rotateTo(mult*int(amnt))
    return

def showDefaultScreen():
    print("\n\nWaiting for order requests..")
    clearDisplay()
    drawString("Selecta V1.1",0,1)
    drawString("------------",0,2)
    drawString("Web-Bestellung?",0,4)


# HTML-Page (Bestellformular)
# ---------------------------
orderForm = """<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
      <H1>Selecta-Automat V1.1</H1>
      <form method = "Get" action = "/">
        <label for="gruen"><img src="http://peterliwiese.ch/LegoBilder/Gruener_LEGOBlock.jpg"width="50"heigh="50"><br>
        <br>
        <input type="number" id="gruen" name="gruen"><br>
        <br>
        <label for="blau"><img src="http://peterliwiese.ch/LegoBilder/Blau_LEGOBlock.jpg"width="50"height="50"><br>
        <br>
        <input type="number" id="blau" name="blau"><br>
        <br>
        <label for="rot"><img src="http://peterliwiese.ch/LegoBilder/Rot_LEGOBlock.jpg"width="50"height="50"><br>
        <br>
        <input type="number" id="rot" name="rot"><br>
        <input type='submit' value='Bestellen'>
      </form>
  </body>
</html>
"""


# Saving HTML File
# ----------------
print("Saving orderForm..")
saveHTML(orderForm)
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
