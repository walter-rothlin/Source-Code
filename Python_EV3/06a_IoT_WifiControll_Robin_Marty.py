from grobot import *

html = """<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <form method = "Get" action = "/">
    <label for="rot">Rot:</label><br>
    <input type="number" id="rot" name="rot"><br>
    <label for="gruen">Gruen:</label><br>
    <input type="number" id="gruen" name="gruen"><br>
    <label for="blau">Blau:</label><br>
    <input type="number" id="blau" name="blau">
    <input type='submit' value='Submit Form'>
</form>
</html>
"""
print("Saving HTML")
saveHTML(html)

clearDisplay()

multRot = 360
multGruen = 360
multBlau = 360

def onRequest(clientIP, state, params):
    drawString(params,0,0)
    if params != {}:
        drawString(params["gruen"],0,0)
        gruen = int(params["gruen"])*multGruen
        drawString(gruen,0,0)
        motA.rotateTo(gruen)
    return
    
startHTTPServer(onRequest)
print("Server starting")
while not button_escape.was_pressed():
    delay(100)
exit()