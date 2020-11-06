# Python_EV3: 05b_IoT_WifiControll_Bambauer.py

# Code von Julian Bambauer <julian.bambauer@bluewin.ch> vom 6.11.20

from grobot import *

setSpeed(50)

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

def onRequest(clientIP, state, params):
    if "btn" in params:
        state = params["btn"]
    if state == "forward":
        forward()
    elif state == "stop":
        stop()
    elif state == "backward":
        backward()
    elif state == "left":
        left(275)
    elif state == "right":
        right(275)

startHTTPServer(onRequest)
while not button_escape.was_pressed():
    delay(100)
exit()
