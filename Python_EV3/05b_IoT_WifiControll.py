# Python_EV3: 05b_IoT_WifiControll.py

from grobot import *

html = """<!DOCTYPE html>
<html>
  <head> <title>Web Rover</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body> 
    <h2>WebRobot</h2> 
    <form method="get">
       <p><input type="submit" style="font-size:18px; height:40px; 
           width:110px" name="btn" value="forward"/></p>
           
       <p><input type="submit" style="font-size:18px; height:40px; 
           width:110px" name="btn" value="stop"/></p>
    
       <p><input type="submit" style="font-size:18px; height:40px; 
           width:110px" name="btn" value="backward"/></p>
           
       <p><input type="submit" style="font-size:18px; height:40px; 
           width:110px" name="btn" value="left"/></p>
           
       <p><input type="submit" style="font-size:18px; height:40px; 
           width:110px" name="btn" value="right"/></p>
    </form>
  </body> 
</html>
"""
print("Saving html")
saveHTML(html)

def onRequest(clientIP, filename, params):
    if "btn" in params:
        state = params["btn"]
    if state == "forward":
        setSpeed(80)
        forward()
    elif state == "stop":
        stop()
    elif state == "backward":
        setSpeed(40)
        backward()
    elif state == "left":
        leftArc(0.2)
    elif state == "right":
        rightArc(0.2)
        
state = "stop"


startHTTPServer(onRequest) 
while not button_escape.was_pressed():
    delay(100)
exit()
