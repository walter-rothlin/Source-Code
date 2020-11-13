# Python_EV3: 05c_IoT_WifiControll_Direction_Rothlin.py

from grobot import *


html = """
<html>
<head>
</head>
<body>
    <h1>Robi Remote</h1>

    <form method="get">
        <p><a><input type="submit" style="font-size:18px; height:40px; width:100px" name="btn" value="forward" /></a></p>
        <p><b><input type="submit" style="font-size:18px; height:40px; width:100px" name="btn" value="backward" /></b></p>
        <p><c><input type="submit" style="font-size:18px; height:40px; width:100px" name="btn" value="stop" /></c></p>
        <p><d><input type="submit" style="font-size:18px; height:40px; width:100px" name="btn" value="left" /></d></p>
        <p><e><input type="submit" style="font-size:18px; height:40px; width:100px" name="btn" value="right" /></e></p>
    </form>
</body>

<style>
    form { /*background*/
        width: 345px;
        height: 170px;
        font-family: sans-serif;
        color: white;
        background: darkblue;
        /*padding: 4em;*/
        border-radius: 3em;
    }

    a { /*forward*/
        position: fixed;
        top: 80;
        left: 130;
        background-color: red;
    }

    b { /*backword*/
        position: fixed;
        top: 180;
        left: 130;
    }

    c { /*stop*/
        position: fixed;
        top: 130;
        left: 130;
    }

    d { /*left*/
        position: fixed;
        top: 130;
        left: 20;
    }

    e { /*right*/
        position: fixed;
        top: 130;
        left: 240;
    }
</style>
</html>
"""
print("Saving HTML")
saveHTML(html)

direction = "stop"
LED_Color = 6
speed = 50
setSpeed(speed)
setLED(LED_Color)


clearDisplay()


def onRequest(clientIP, state, params):
    clearDisplay()
    drawString("EV:" + getIPAddresses()[1], 0, 3)
    drawString("RC:" + clientIP, 0, 4)
    drawString(state, 0, 5)
    drawString(params, 0, 6)
    
    if state == "/cmd":
        if "setSpeed" in params:
            speed = params["setSpeed"]    # http://192.168.107.251:81/cmd?setSpeed=100
        if "setLED" in params:
            LED_Color = params["setLED"]  # http://192.168.107.251:81/cmd?setLED=4
    if "btn" in params:
        direction = params["btn"]
    
    drawString("speed:" + str(speed), 0, 1)
    drawString(direction, 0, 2)
    drawString("LED  :" + str(LED_Color), 0, 3)
    setSpeed(speed)
    setLED(LED_Color)
    if direction == "forward":
        forward()
    elif direction == "stop":
        stop()
    elif direction == "backward":
        backward()
    elif direction == "left":
        left(275)
    elif direction == "right":
        right(275)

startHTTPServer(onRequest)
while not button_escape.was_pressed():
    delay(100)
exit()
