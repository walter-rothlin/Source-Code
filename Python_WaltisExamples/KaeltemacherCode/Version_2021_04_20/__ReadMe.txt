==================
Version_2020_09_11
==================


Vorbereitung
============
pip3 install simple_pid
sudo apt-get install screen

usr: pi
passwort: raspberry

PATH to Python Libs setzen
--------------------------
im /etc/profile:
PYTHONPATH=".:/home/pi/Documents/BZU_Code/Python_WaltisExamples/_Libraries/"
export PYTHONPATH


Install it
==========
mkdir /home/pi/Kaeltemacher
copy alle files into this dir and change mod as required

pi@newpi:~/Kaeltemacher $ pwd
/home/pi/Kaeltemacher
pi@newpi:~/Kaeltemacher $ ls -lrt
insgesamt 144
-rw-r--r-- 1 pi pi   746 Feb 23 14:01 Set-Up_Values.txt
-rwxr-xr-x 1 pi pi 20120 Feb 23 14:01 KM_Main.py
-rw-r--r-- 1 pi pi   718 Feb 23 14:01 Class_WR_Logfile.py
-rw-r--r-- 1 pi pi  3805 Feb 23 14:01 Class_Verdichter.py
-rw-r--r-- 1 pi pi   565 Feb 23 14:01 CLASS_ValueLogger.py
-rw-r--r-- 1 pi pi  1532 Feb 23 14:01 Class_TimerState.py
-rw-r--r-- 1 pi pi  1166 Feb 23 14:01 Class_Tiefpass.py
-rw-r--r-- 1 pi pi  1871 Feb 23 14:01 CLASS_TemperaturSensor.py
-rw-r--r-- 1 pi pi  2652 Feb 23 14:01 Class_TemperaturSensorPT1000.py
-rw-r--r-- 1 pi pi  2506 Feb 23 14:01 Class_TemperaturSensorDigital.py
-rw-r--r-- 1 pi pi  1093 Feb 23 14:01 Class_StromSensorLEM.py
-rw-r--r-- 1 pi pi 18296 Feb 23 14:01 Class_KaelteMacherMaschine.py
-rw-r--r-- 1 pi pi  1182 Feb 23 14:01 Class_IncDec.py
-rw-r--r-- 1 pi pi  2543 Feb 23 14:01 Class_Hysterese.py
-rw-r--r-- 1 pi pi  1151 Feb 23 14:01 Class_Energiemessung.py
-rw-r--r-- 1 pi pi  1127 Feb 23 14:01 CLASS_DAQC_LedLine.py
-rw-r--r-- 1 pi pi  3809 Feb 23 14:01 Class_4_20mA_Sensor.py
-rw-r--r-- 1 pi pi  9077 Feb 23 14:01 waltisLibrary.py
-rwxr-xr-x 1 pi pi  1263 Feb 23 14:01 Test_TemperaturSensorDigital.py
-rwxr-xr-x 1 pi pi    78 Feb 23 14:01 test.py
-rwxr-xr-x 1 pi pi   680 Feb 23 14:01 Test_MixingValve.py
-rwxr-xr-x 1 pi pi  3495 Feb 23 14:01 Test_Kaeltemaschine.py
-rwxr-xr-x 1 pi pi  3683 Feb 23 14:01 Test_Fan.py
-rwxr-xr-x 1 pi pi   647 Feb 23 14:01 Test_4_20mA_Sensor_Class.py
-rwxr-xr-x 1 pi pi   582 Feb 23 14:01 Test_1_IncDec_Class.py
-rwxr-xr-x 1 pi pi   157 Feb 23 14:01 startup.sh

Create Log-file directory on Web-Server
=======================================
cd /var/www/html/
sudo mkdir KM
sudo chmod 777 KM/

Lesen von Logfiles via Browser
------------------------------
http://192.168.1.159/KM/     


Autostart
=========

Create startup.sh
-----------------
pi@raspberrypi:~/kaeltemacher $ nano startup.sh

folgende Zeile eingeben:
screen -dmS "kaeltemacher" bash -c 'python3 /home/pi/kaeltemacher/KM_Main.py'

mit Ctrl-x beenden
und mit Shift-j oder Shift-y speichern (abhängig von der eingestellten Sprache des Systems)

Berechtigung auf execute ändern
-------------------------------
pi@raspberrypi:~/kaeltemacher $ chmod +x startup.sh
macht das startup.sh script ausführbar

Crontab kreieren / erweitern
----------------------------
pi@raspberrypi:~/kaeltemacher $ crontab -e

sämtliche aktuellen Zeilen müssen mit # beginnen! (Zeilen die so beginnen, sind auskommentiert.)

ganz unten folgende Zeile (ohne # !!!) einfügen:
@reboot /home/pi/Kaeltemacher/startup.sh > /tmp/KM.log 2>&1

mit Ctrl-x beenden
und mit Shift-j oder Shift-y speichern (abhängig von der eingestellten Sprache des Systems)

pi@raspberrypi:~/kaeltemacher $ sudo reboot
startet das System neu...warten...warten...warten...
...das Python-Script KM_Main.py sollte nun automatisch gestartet werden.

...neue ssh Verbindung aufbauen


pi@raspberrypi:~/kaeltemacher $ screen -r
öffnet eine screen-Session zum laufenden KM_Main.py Programm

mit Ctrl-a -d kann man die Session verlassen ohne das Programm zu beenden

