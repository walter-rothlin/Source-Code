#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_08j_RepeatingTimer.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08j_RepeatingTimer.py
#
# Description: Ruft eine Usr-Funktion in einem festen (with drift depending on processing time of the Usr-Function) Intervall auf.
#
# Autor: Walter Rothlin
#
# History:
# 03-Aug-2025   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import threading
import time
from datetime import datetime

def tick_every(func, interval_seconds=60, *args, **kwargs):
    stop_event = threading.Event()

    def run():

        delay = interval_seconds

        while not stop_event.is_set():
            now = datetime.now()
            print(f"{now.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]}: Tick! (User-Function wird aufgerufen)")

            try:
                func(*args, **kwargs)
            except Exception as e:
                print(f"Fehler beim Aufruf der User-Function: {e}")

            if stop_event.wait(timeout=delay):
                print("Timer wurde gestoppt.")
                break

    thread = threading.Thread(target=run, daemon=True)
    thread.start()
    return stop_event, thread



def meine_aktion(name, wert=2.1):
    print(f">> Aktion für {name} mit delay {wert}s (with drift) gestartet.")
    time.sleep(wert)
    print(f"   ...fertig für {name}!\n")

if __name__ == "__main__":
    stop_event, thread = tick_every(
        meine_aktion,
        interval_seconds=60,
        name="Sensor A",        # keyword-arg
        wert=5.1                # keyword-arg
    )

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Beendet durch Nutzer, stoppe Timer...")
        stop_event.set()
        thread.join()
        print("Timer beendet.")
