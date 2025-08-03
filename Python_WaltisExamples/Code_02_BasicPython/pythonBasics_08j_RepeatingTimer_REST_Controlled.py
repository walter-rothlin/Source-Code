#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_08j_RepeatingTimer_REST_Controlled.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08j_RepeatingTimer_REST_Controlled.py
#
# Description: Ruft eine Usr-Funktion in einem festen (ohne drift) Intervall auf und kann über ein REST-Interface gesteuert werden.
#
# Autor: Walter Rothlin
#
# History:
# 03-Aug-2025   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import threading
import time
from datetime import datetime
from flask import Flask, request, jsonify

# === Globale Variablen ===
tick_controler = None
aktion_aktiv = True

last_timer_config = {
    "func": None,
    "interval_seconds": 60,
    "args": (),
    "kwargs": {"name": "Sensor A", "wert": 5.1}
}

# === Timer-Klasse ===
class timer_controler:
    def __init__(self, func, interval_seconds=60, *args, **kwargs):
        self.func = func
        self.interval_seconds = interval_seconds
        self.args = args
        self.kwargs = kwargs
        self.stop_event = threading.Event()
        self.thread = threading.Thread(target=self.run, daemon=True)
        self.thread.start()
        self.next_tick = None

    def run(self):
        now = datetime.now()
        epoch_seconds = int(now.timestamp())
        next_epoch = ((epoch_seconds // self.interval_seconds) + 1) * self.interval_seconds
        self.next_tick = datetime.fromtimestamp(next_epoch)

        delay = (self.next_tick - datetime.now()).total_seconds()
        if delay > 0:
            print(f"Warte {delay:.3f}s bis zum ersten Tick bei {self.next_tick.strftime('%Y-%m-%d %H:%M:%S')}")
            if self.stop_event.wait(timeout=delay):
                print("Timer wurde vor dem ersten Tick gestoppt.")
                return

        while not self.stop_event.is_set():
            now = datetime.now()
            print(f"{now.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]}: Tick! (User-Function wird aufgerufen)")

            try:
                self.func(*self.args, **self.kwargs)
            except Exception as e:
                print(f"Fehler beim Aufruf der User-Function: {e}")

            now = datetime.now()
            epoch_seconds = int(now.timestamp())
            next_epoch = ((epoch_seconds // self.interval_seconds) + 1) * self.interval_seconds
            self.next_tick = datetime.fromtimestamp(next_epoch)

            delay = (self.next_tick - datetime.now()).total_seconds()
            if delay < 0:
                delay = 0

            if self.stop_event.wait(timeout=delay):
                print("Timer wurde gestoppt.")
                break

    def stop(self):
        self.stop_event.set()
        self.thread.join()


# === Beispiel einer User-Funktion ===
def meine_aktion(name, wert=2.1):
    global aktion_aktiv
    if not aktion_aktiv:
        print(f">> Aktion für {name} übersprungen (Status: suspendiert)")
        return

    print(f">> Aktion für {name} mit delay {wert}s gestartet.")
    time.sleep(wert)
    print(f"   ...fertig für {name}!\n")


# === Flask Webserver ===
app = Flask(__name__)

@app.route('/')
def index():
    return '''
    <h1>Flask Application with Repeating Timer</h1>
    <p>Diese Anwendung steuert einen wiederholenden Timer über ein REST-Interface.</p>
    Source-Code: <a target="_new" href='https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08j_RepeatingTimer_REST_Controlled.py'>pythonBasics_08j_RepeatingTimer_REST_Controlled.py</a></br></br>
        <form action="/status_JSON" method="get"><button type="submit">Status as JSON</button></form></br></br>
        <table>
        <tr>
            <td><form action="/start_timer" method="post"><button type="submit">Start Timer</button></form></td> 
            <td><form action="/stop_timer" method="post"><button type="submit">Stop Timer</button></form></td>
        </tr>
        <tr>
            <td><form action="/suspend" method="post"><button type="submit">Suspend Aktion</button></form></td> 
            <td><form action="/activate" method="post"><button type="submit">Activate Aktion</button></form></td> 
        </tr>
        </table>
    '''

@app.route('/start_timer', methods=['POST'])
def start_timer():
    global tick_controler, last_timer_config
    if tick_controler and not tick_controler.stop_event.is_set():
        return {"status": "already running", "message": "Timer läuft bereits."}

    tick_controler = timer_controler(
        last_timer_config["func"],
        last_timer_config["interval_seconds"],
        *last_timer_config["args"],
        **last_timer_config["kwargs"]
    )
    return {"status": "started", "message": "Timer wurde gestartet."}

@app.route('/stop_timer', methods=['POST'])
def stop_timer():
    global tick_controler
    if tick_controler and not tick_controler.stop_event.is_set():
        tick_controler.stop()
        return {"status": "stopped", "message": "Timer wurde gestoppt."}
    return {"status": "already stopped", "message": "Timer ist bereits gestoppt."}

@app.route('/suspend', methods=['POST'])
def suspend():
    global aktion_aktiv
    aktion_aktiv = False
    return {"status": "suspended", "message": "Aktionen werden nicht mehr ausgeführt."}

@app.route('/activate', methods=['POST'])
def activate():
    global aktion_aktiv
    aktion_aktiv = True
    return {"status": "active", "message": "Aktionen werden wieder ausgeführt."}

@app.route('/status_JSON', methods=['GET'])
def status_JSON():
    global tick_controler, aktion_aktiv, last_timer_config
    status = "stopped"
    next_tick = "N/A"
    interval = last_timer_config["interval_seconds"]
    if tick_controler and not tick_controler.stop_event.is_set():
        status = "running"
        next_tick = tick_controler.next_tick.strftime('%Y-%m-%d %H:%M:%S') if tick_controler.next_tick else "N/A"

    aktion_status = "aktiv" if aktion_aktiv else "suspendiert"
    return {
        "01_current_time": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        "02_next_tick": next_tick,
        "03_timer_status": status,
        "04_aktion_status": aktion_status,
        "05_interval_seconds": interval,
    }


# === Start ===
if __name__ == "__main__":
    # Initialisiere Standard-Konfiguration
    last_timer_config["func"] = meine_aktion

    try:
        app.run(debug=True, host='127.0.0.1', port=5001, use_reloader=False)
    except KeyboardInterrupt:
        print("Beendet durch Nutzer, stoppe Timer...")
        if tick_controler:
            tick_controler.stop()
        print("Timer beendet.")
