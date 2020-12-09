from grobot import *

# run on console: ssh root (passowrd: "") pyrun 

html = """<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <form method = "Get" action = "/">
    <label for="gruen">Gruen:</label><br>
    <input type="number" id="gruen" name="gruen"><br>
    <label for="blau">Blau:</label><br>
    <input type="number" id="blau" name="blau"><br>
    <label for="rot">Rot:</label><br>
    <input type="number" id="rot" name="rot"><br>
    <input type='submit' value='Submit Form'>
</form>
</html>
"""
print("Saving HTML")
saveHTML(html)
print("Done Saving")
clearDisplay()

def onRequest(clientIP, state, params):
    drawString("Gruen: ",0,0)
    drawString("Blau: ",0,1)
    drawString("Rot: ",0,2)
    if params != {}:
        drawString("Gruen: "+params["gruen"],0,0)
        drawString("Blau: "+params["blau"],0,1)
        drawString("Rot: "+params["rot"],0,2)
        
        motD.rotate(50)
        moveBrick(-90,params["gruen"],motB)
        moveBrick(-90,params["blau"],motC)
        moveBrick(-90,params["rot"],motA)
        motD.rotateTo(1800)
        
        clearDisplay()
        drawString("Gruen: ",0,0)
        drawString("Blau: ",0,1)
        drawString("Rot: ",0,2)
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