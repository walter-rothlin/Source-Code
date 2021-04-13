from grobot import *

# Bestell-Software für den Lego-Selecta Automat entwickelt von Robin Marty/Kilian Wagner
html = """<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
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
</html>
"""
print("Saving HTML")
saveHTML(html)
print("Done Saving")
clearDisplay()
drawString("Bestellung?",0,0)

def onRequest(clientIP, state, params):
    if params != {}:
        clearDisplay()
        drawString("Gruen: "+params["gruen"],0,0)
        drawString("Blau: "+params["blau"],0,1)
        drawString("Rot: "+params["rot"],0,2)
        
        motD.rotate(50)
        moveBrick(-72,params["gruen"],motB)
        moveBrick(-72,params["blau"],motC)
        moveBrick(-72,params["rot"],motA)
        motD.rotateTo(1800)
        
        clearDisplay()
    drawString("Bestellung?",0,0)
    return

def moveBrick(mult, amnt, mot):
    if amnt == "":
        return
    print(mult*int(amnt))
    mot.rotateTo(mult*int(amnt))
    return
    
startHTTPServer(onRequest)
print("Server starting")
while not button_escape.was_pressed():
    delay(100)
exit()
