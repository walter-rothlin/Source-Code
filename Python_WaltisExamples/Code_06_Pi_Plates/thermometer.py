#!/usr/bin/python3
# http://pi-plates.com/daqc-users-guide
# Run with watch to get updating results e.g.
# watch thermometer.py
import piplates.DAQCplate as DAQC
print("Thermometer 1\tThermometer 2")

print(str(DAQC.getTEMP(2,0,'c'))+"°C\t"+str(DAQC.getTEMP(2,1,'c'))+"°C")
print(str(DAQC.getTEMP(2,0,'k'))+"°K\t"+str(DAQC.getTEMP(2,1,'k'))+"°K")
print(str(DAQC.getTEMP(2,0,'f'))+"°F\t"+str(DAQC.getTEMP(2,1,'f'))+"°F")
