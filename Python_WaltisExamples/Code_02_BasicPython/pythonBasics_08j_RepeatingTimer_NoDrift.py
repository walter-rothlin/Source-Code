#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_08j_RepeatingTimer_NoDrift.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08j_RepeatingTimer_NoDrift.py
#
# Description: Ruft eine Usr-Funktion in einem festen (ohne drift) Intervall auf.
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
        # Vor dem ersten Aufruf: bis zum nächsten Intervall warten
        now = datetime.now()
        epoch_seconds = int(now.timestamp())
        next_epoch = ((epoch_seconds // interval_seconds) + 1) * interval_seconds
        next_tick = datetime.fromtimestamp(next_epoch)

        delay = (next_tick - datetime.now()).total_seconds()
        if delay > 0:
            print(f"Warte {delay:.3f}s bis zum ersten Tick bei {next_tick.strftime('%Y-%m-%d %H:%M:%S')}")
            if stop_event.wait(timeout=delay):
                print("Timer wurde vor dem ersten Tick gestoppt.")
                return

        while not stop_event.is_set():
            now = datetime.now()
            print(f"{now.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]}: Tick! (User-Function wird aufgerufen)")

            try:
                func(*args, **kwargs)
            except Exception as e:
                print(f"Fehler beim Aufruf der User-Function: {e}")

            # Nächsten Tick berechnen
            now = datetime.now()
            epoch_seconds = int(now.timestamp())
            next_epoch = ((epoch_seconds // interval_seconds) + 1) * interval_seconds
            next_tick = datetime.fromtimestamp(next_epoch)

            delay = (next_tick - datetime.now()).total_seconds()
            if delay < 0:
                delay = 0

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
