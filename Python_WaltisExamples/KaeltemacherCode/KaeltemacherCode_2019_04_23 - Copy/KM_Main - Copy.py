#!/usr/bin/python3
import math
import time
import datetime
import re
import piplates.DAQCplate as DAQC

from Class_Hysterese            import *
from Class_Tiefpass             import *
from Class_IncDec               import *
from Class_Verdichter           import *
from Class_KaelteMacherMaschine import *
from sense_hat                  import SenseHat

# Set-Up Values
# --------------------------------------------------
schwellwert_N_On  = 20
schwellwert_N_Off = 10

schwellwert_H_On  = 90
schwellwert_H_Off = 80

schwellwert_H1_On  = 60
schwellwert_H1_Off = 50

schwellwert_H2_On  = 90
schwellwert_H2_Off = 80

wiedereinschaltverzoegerung = "0:00:10"
minVorhandeneEnergie        =   5 # %
minVerdichterLeistung       =  10 # %
maxVerdichterLeistung       = 100 # %

# Objects
# --------------------------------------------------
energieFilter     = Tiefpass(0,1,1)
verdichter_1_TP   = Tiefpass(0,1,99)
verdichter_2_TP   = Tiefpass(0,1,99)
#-- drehzahl_1_Filter = Tiefpass(0,1,99)
#-- drehzahl_2_Filter = Tiefpass(0,1,99)
hsrKaelteMaschine = KaelteMacherMaschine(1)
verdichter_1      = Verdichter("Verdichter_1",minVorhandeneEnergie,maxVerdichterLeistung,verdichter_1_TP)
verdichter_2      = Verdichter("Verdichter_2",minVorhandeneEnergie,maxVerdichterLeistung,verdichter_2_TP)

qIncDec           = IncDec()
niederDruckOff    = Hysterese(schwellwert_N_On,   schwellwert_N_Off)
hochDruckOff      = Hysterese(schwellwert_H_On,   schwellwert_H_Off,inverse=True)
luefter_1_On      = Hysterese(schwellwert_H1_On,  schwellwert_H1_Off)
luefter_2_On      = Hysterese(schwellwert_H2_On,  schwellwert_H2_Off)
sense             = SenseHat()


# Aktoren / Output
# --------------------------------------------------
f1                       = 0
#-- l1                       = 0
#-- verdichter_1_On          = False
f2                       = 0
#--l2                       = 0
#-- verdichter_2_On          = False
drehzahlVerdichter_1     = 0
drehzahlVerdichter_2     = 0
absperrVentilEVR3_closed = True
wasserpumpe_On           = False
luefterDrehzahl_1        = False
luefterDrehzahl_2        = False
#-- lastTimeVerdichter_1_Off = datetime.datetime.now()
#-- lastTimeVerdichter_2_Off = datetime.datetime.now()

# Functions
# --------------------------------------------------
def f1x(vorhandeneEnergie):
    calculatedDrehzahl = vorhandeneEnergie * 2
    if (calculatedDrehzahl > 100):
        return 100
    if (calculatedDrehzahl < minVerdichterLeistung):
        return 0
    return calculatedDrehzahl

def f2x(vorhandeneEnergie):
    return f1x(vorhandeneEnergie - 50)


# True if (old-young > limit)
def checkTimeDiff(oldTimestamp, youngTimestamp, limit, gt=True):
    timeDiff =  youngTimestamp - oldTimestamp
    secStr = str(timeDiff)[:7]
    # secStr = re.findall("\d:\d\d:\d\d",secStr)
    # secStr = re.sub(":","",secStr)
    ##DEBUG print(str(youngTimestamp)[11:19],"  -  ",str(oldTimestamp)[11:19],"  -->  ",secStr,limit)
    if (gt):
        return (secStr > limit)
    else:
        return (secStr < limit)

# --------------------------------------------------
# main Loop
# --------------------------------------------------
doLoop = True
loopsForTesting =2000
currLoops = 0

vorhandeneEnergie = 0
qIncDec.setValue(vorhandeneEnergie)
startUpTime = datetime.datetime.now()

DAQC.setDOUTbit(1,0)
while (doLoop):
    currTime = datetime.datetime.now()
    print("\n=====================================",currTime)
	
    # Sensorwerte / Input
    # vorhandeneEnergie = qIncDec.inc()
    vorhandeneEnergie           = hsrKaelteMaschine.getVorhandeneEnergie()
    if (vorhandeneEnergie < minVorhandeneEnergie):
        vorhandeneEnergie = 0
    hochdruck                   = hsrKaelteMaschine.getHochdruck()
    niederdruck                 = hsrKaelteMaschine.getNiederdruck()
    hochdruckStoerung           = hsrKaelteMaschine.getHochdruckStoerung()
    niederdruckStoerung         = hsrKaelteMaschine.getNiederdruckStoerung()
    einschaltVerzoegerungAktiv  = hsrKaelteMaschine.getEinschaltVerzoegerung()

    
    # Absperrventil_EVR_3
    # -------------------
    stoerung = (niederdruckStoerung or hochdruckStoerung)
    # print("stoerung                :",stoerung)
    if (stoerung or ((verdichter_1.getVerdichterOn() == False) and (verdichter_2.getVerdichterOn() == False))):
        absperrVentilEVR3_closed = True
    else:
        absperrVentilEVR3_closed = False
    print("absperrVentilEVR3_closed:",absperrVentilEVR3_closed,"    ",stoerung,verdichter_1.getVerdichterOn(),verdichter_2.getVerdichterOn())



    # Tiefpass vorhandeneEnergie q
    # ----------------------------
    qGefiltert = energieFilter.setNewInValue(vorhandeneEnergie)
    
    # Verdichter_1
    # ------------
    ndOff = niederDruckOff.setState(niederdruck)
    f1=f1x(qGefiltert)
    verdichter_1.setValues(f1,((stoerung) or (ndOff)),einschaltVerzoegerungAktiv)

	
    # if (f1 < minVerdichterLeistung):
        # f1 = 0
        # if (verdichter_1_On):
            # lastTimeVerdichter_1_Off = datetime.datetime.now()
        # verdichter_1_On = False

    # wiederEinschaltungMoeglich_1 = ((einschaltVerzoegerungAktiv == False) or ((einschaltVerzoegerungAktiv == True) and (checkTimeDiff(lastTimeVerdichter_1_Off, currTime, wiedereinschaltverzoegerung))))
    
    # print("-->1)","wiederEinschaltungMoeglich_1:",wiederEinschaltungMoeglich_1,"     niederDruckOff:",ndOff,"{x1:4.2f}%".format(x1=niederdruck),niederDruckOff.getOff(),niederDruckOff.getOn())
    # if ( (wiederEinschaltungMoeglich_1  == True)         
          # and (stoerung == False)
          # and (ndOff == False)
       # ):
        # print("l1 == True  ==> f1 durchschalten")
        # l1 = f1
        # verdichter_1_On = True
    # else:
        # l1 = 0
        # if (verdichter_1_On):
            # lastTimeVerdichter_1_Off = datetime.datetime.now()
        # verdichter_1_On = False
			
    # drehzahlVerdichter_1 = drehzahl_1_Filter.setNewInValue(l1)
    
    
    # Verdichter_2
    # ------------
    hdOff = hochDruckOff.setState(hochdruck)
    f2=f2x(qGefiltert)
    verdichter_2.setValues(f2,((stoerung) or (hdOff)),einschaltVerzoegerungAktiv)
 

    # if (f2 < minVerdichterLeistung):
        # f2 = 0
        # if (verdichter_2_On):
            # lastTimeVerdichter_2_Off = datetime.datetime.now()
        # verdichter_2_On = False

    # wiederEinschaltungMoeglich_2 = ((einschaltVerzoegerungAktiv == False) or ((einschaltVerzoegerungAktiv == True) and (checkTimeDiff(lastTimeVerdichter_2_Off, currTime, wiedereinschaltverzoegerung))))

    # print("-->2)","wiederEinschaltungMoeglich_2:",wiederEinschaltungMoeglich_2,"     hochDruckOff  :",hdOff,"{x1:4.2f}%".format(x1=hochdruck),hochDruckOff.getOff(),hochDruckOff.getOn())
    # if ( (wiederEinschaltungMoeglich_2  == True)         
          # and (stoerung == False)
          # and (hdOff == False)
       # ):
        # print("l2 == True  ==> f2 durchschalten")
        # l2 = f2
        # verdichter_2_On = True
    # else:
        # l2 = 0
        # if (verdichter_2_On):
            # lastTimeVerdichter_2_Off = datetime.datetime.now()
        # verdichter_2_On = False
			
    # drehzahlVerdichter_2 = drehzahl_2_Filter.setNewInValue(l2)
    
    # Aktoren setzen
    # --------------
    
    # print(startUpTime,"::",currTime,":  =>  ",checkTimeDiff(startUpTime, currTime, "23:59:58"))
    # print("q :{q:4.1f}    ".format(q=vorhandeneEnergie),end="")
    # print("qf:{qf:4.1f};  ".format(qf=qGefiltert),end="")
    
    # print("f1:{f1:4.2f}   ".format(f1=f1),end="")
    # print("l1:{l1:4.2f}   ".format(l1=l1),end="")
    # print("dx:{d1:4.2f};  ".format(d1=drehzahl_1_Filter.getValue()),end="")
    # print("d1:{d1:4.2f};  ".format(d1=drehzahlVerdichter_1),end="")

    
    # print("f2:{f2:4.2f}   ".format(f2=f2),end="")
    # print("l2:{l2:4.2f}   ".format(l2=l2),end="")
    # print("dx:{d2:4.2f};  ".format(d2=drehzahl_2_Filter.getValue()),end="")
    # print("d2:{d2:4.2f};  ".format(d2=drehzahlVerdichter_2),end="")
    
    # print("\n")

    print(verdichter_1.toString())
    print(verdichter_2.toString())
	
    # hsrKaelteMaschine.setVerdichter_1_Speed(drehzahlVerdichter_1)
    # hsrKaelteMaschine.setVerdichter_2_Speed(drehzahlVerdichter_2)
    # hsrKaelteMaschine.closeAbsperrVentil(absperrVentilEVR3_closed)

    currLoops = currLoops + 1
    if (currLoops > loopsForTesting):
        doLoop = False
    else:
        time.sleep(1)
                                                    