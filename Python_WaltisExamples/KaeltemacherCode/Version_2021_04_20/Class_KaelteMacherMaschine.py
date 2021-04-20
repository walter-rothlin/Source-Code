#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_KaelteMacherMaschine.py
#
# Description: Interface-Klasse zur PiPlate der Kälteanlage. Liest Sensoren und steuert Aktoren
#
# https://pi-plates.com/daqc-users-guide/
# https://pi-plates.com/downloads/DAQCplate%20Quick%20Reference%20Guide.pdf
#
# http://pi-plates.com/relayplate-users-guide
# https://pi-plates.com/downloads/RELAYplateQuickReferenceGuide.pdf
#
# Autor: Walter Rothlin
#
# History:
# 24-Apr-2019	Initial Version
# 26-Jun-2019	Reviewed Version
#
# ------------------------------------------------------------------

import piplates.DAQCplate                       as DAQC
import piplates.RELAYplate                      as RELAY

# import DAQCplate_pseudo                       as DAQC
# import RELAYplate_pseudo                      as RELAY

from   threading                                import Timer

from   time                                     import sleep
from   waltisLibrary                            import *
from   Class_4_20mA_Sensor                      import *
from   Class_TemperaturSensorDigital            import *
from   Class_TemperaturSensorPT1000             import *

from   Class_Energiemessung                     import *
from   Class_StromSensorLEM                     import *

from Class_TimerState           import *

class KaelteMacherMaschine:

   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, piPlateAdr1 = 1, piPlateAdr2 = 2, piRelayAdr = 3, simulate = False):
      self.compSpeeds       = [0,0]
      self.compIsOn         = [False,False]
      self.fanSpeed         = 0
      self.waterPump_On     = False
      self.shutOffValveOpen = False
      self.mixingValveOpen  = 0
      # self.mixingValveOpen  = 80

      # self.fandSpeed_1_Relais          = 1
      self.fandSpeed_1_Relais          = 7
      self.fandSpeed_2_Relais          = 2
      self.compressor_1_On_Relais      = 3 # hier random -> führt erst bei Systemneustart zu einer Änderung
      self.compressor_2_On_Relais      = 4 # hier random -> führt erst bei Systemneustart zu einer Änderung
      self.ShutOffValve_Relais         = 5
      self.WaterPump_Relais            = 6

      self.piPlateAdr1  = piPlateAdr1
      self.piPlateAdr2  = piPlateAdr2
      self.piRelayAdr   = piRelayAdr
      self.simulate     = simulate
      DAQC.setDOUTall(self.piPlateAdr1,0)
      DAQC.setDOUTall(self.piPlateAdr2,0)
      RELAY.relayALL(self.piRelayAdr,0)

      self.setSpeedComp(1,0,                False)
      self.setComp_On(1,False,              False)
      self.setSpeedComp(2,0,                False)
      self.setComp_On(2,False,              False)
      self.setFanSpeed(False,False,         False)
      self.setWaterPump_On(False,           False)
      self.setShutOffValveToOpen(False,     False)
      self.setMixingValve(0,                False)
      # self.setMixingValve(80,                False)

      self.hochdruckSensor            = CurrentLoop_4_20mA_Sensor("Hochdruck"          ,"bar", 0   , 25)
      self.niederdruckSensor          = CurrentLoop_4_20mA_Sensor("Niederdruck"        ,"bar",-0.5 ,  7)
      self.availableEnergySensor      = CurrentLoop_4_20mA_Sensor("Verfuegbare Energie","  %", 0   ,100)
      
      self.environmentTempSensor      = TemperaturSensorDigital("Umgebungs-Temperatur",2,1)
      self.environmentTempSensorP1000 = TemperaturSensorPT1000("Umgebungs-Temperatur PT1000",1,4,Temp_P1 = -5.242, U_P1 = 2.3109, Temp_P2 = 35.353, U_P2 = 2.9625)
      self.wasserTempSensor           = TemperaturSensorDigital("Wasser-Temperatur",2,0)
      self.wasserTempSensorP1000      = TemperaturSensorPT1000("Wasser-Temperatur PT1000",1,3,Temp_P1 = -5.242, U_P1 = 2.3109, Temp_P2 = 35.353, U_P2 = 2.9625)

      # self.stromSensorLEM = StromSensorLEM("Eingangsstrom", ?, ?)
      self.time_T3 = 5
      self.t3State = TimerState("T3")

   def T3Over(self, txState):
      oldState = txState.setState_TimeOver()
    # print("-------------------------> T3Over called:",oldState," -->",txState.toString())


   # Analog Inputs
   # -------------

   # Michi: E = U * I * t <- scheint mir nur sinnvoll mit Speicher, sonst Eingangsleistung
   def getExistingEnergy(self, verbal = False):
      measure = DAQC.getADC(self.piPlateAdr1,0)
      retVal = self.availableEnergySensor.calc_physicalValue(measure)
      if (verbal):
          print("getVorhandeneEnergie : {t1:4.2f}V   ({t2:-6.1f}{t3:1s})".format(t1=measure,t2=retVal,t3=self.availableEnergySensor.getPhysicalUnit()))
      return retVal

   # def getCurrentPower()


   def getLowPressure(self, verbal = False):
      measure = DAQC.getADC(self.piPlateAdr1,1)
      retVal = self.niederdruckSensor.calc_physicalValue(measure)
      if (verbal):
          print("getNiederdruck       : {t1:4.2f}V   ({t2:-6.1f}{t3:1s})".format(t1=measure,t2=retVal,t3=self.niederdruckSensor.getPhysicalUnit()))
      return retVal

   def getHighPressure(self, verbal = False):
      measure = DAQC.getADC(self.piPlateAdr1,2)
      retVal = self.hochdruckSensor.calc_physicalValue(measure)
      if (verbal):
          print("getHochdruck         : {t1:4.2f}V   ({t2:-6.1f}{t3:1s})".format(t1=measure,t2=retVal,t3=self.hochdruckSensor.getPhysicalUnit()))
      return retVal


   def getEnvironmentTemp_PT1000(self, verbal = False):
      if (self.simulate):
          measure = DAQC.getADC(self.piPlateAdr1,4)
          retVal = 100 * measure / 4.095
      else:
          retVal = self.environmentTempSensorP1000.getCurrentValue()
      if (verbal):
          print("EnvironmentTemp_PT1000:         ({t2:-6.1f}C)".format(t2=retVal))
      return retVal

   def getEnvironmentTemp(self, verbal = False):
      if (self.simulate):
          measure = DAQC.getADC(self.piPlateAdr1,4)
          retVal = 100 * measure / 4.095
      else:
          retVal = float(self.environmentTempSensor.getCurrentValue())
      if (verbal):
          print("EnvironmentTemp       :         ({t2:-6.1f}C)".format(t2=retVal))
      return retVal

   def getWaterTemp_PT1000(self, verbal = False):
      if (self.simulate):
          measure = DAQC.getADC(self.piPlateAdr1,3)
          # print(measure)
          retVal = 100 * measure / 4.095
      else:
          retVal = self.wasserTempSensorP1000.getCurrentValue()
      if (verbal):
          print("WaterTemp_PT1000      :         ({t2:-6.1f}C)".format(t2=retVal))
      return retVal

   def getWaterTemp(self, verbal = False):
      if (self.simulate):
          measure = DAQC.getADC(self.piPlateAdr1,3)
          retVal = 100 * measure / 4.095
      else:
          retVal = float(self.wasserTempSensor.getCurrentValue())
      if (verbal):
          print("WaterTemp             :         ({t2:-6.1f}C)".format(t2=retVal))
      return retVal

   # Digital Inputs
   # --------------
   def isCompressorReady(self,compNr, verbal = False):
      measure = DAQC.getDINbit(self.piPlateAdr1,compNr-1)
      if (measure == 1):
          retVal = True
      else:
          retVal = False
      if (verbal):
          print("isCompressorReady_", compNr,"  : ", measure,"  (",retVal,")", sep="")
      return retVal


   def isDelayedOn_Active(self, verbal = False):
      measure = DAQC.getDINbit(self.piPlateAdr1,2)
      if (measure == 1):
          retVal = True
      else:
          retVal = False
      if (verbal):
          print("isDelayedOn_Active   : ", measure,"  (",retVal,")", sep="")
      return retVal

   def isEmergencyOff_Active(self, verbal = False):
      measure = DAQC.getDINbit(self.piPlateAdr1,3)
      if (measure == 1):
          retVal = True
      else:
          retVal = False
      if (verbal):
          print("isEmergencyOff_Active: ", measure,"  (",retVal,")", sep="")
      return retVal


   # Verdichter (Relais: 3,4: Analog: 0,1))
   # ----------
   def setSpeedComp(self, verdichterNr, speed, verbal = True):
      if (verbal):
          print("==> setSpeedComp(",verdichterNr,",{x2:4.0f}%".format(x2=speed),")", sep="")
      self.compSpeeds[int(verdichterNr) - 1] = speed
      DAQC.setDAC(self.piPlateAdr1,int(verdichterNr) - 1,speed * 4.095 / 100)

   def getSpeedComp(self, verdichterNr, verbal = False):
      return self.compSpeeds[int(verdichterNr) - 1]

   def setComp_On(self, verdichterNr, isOn, verbal = False):
      if (verbal):
          print("==> setComp_On(",verdichterNr,",",str(isOn),")", sep="")
      self.compIsOn[int(verdichterNr) - 1] = isOn
      if (isOn):
          RELAY.relayON(self.piRelayAdr,int(verdichterNr) + 2)
      else:
          RELAY.relayOFF(self.piRelayAdr,int(verdichterNr) + 2)

   def getComp_On(self, verdichterNr, verbal = False):
      if (self.compIsOn[int(verdichterNr) - 1]):
          return "On"
      else:
          return "Off"


   # mixingValve (Analog: 0 [Karte 2]))
   # -----------
   def setMixingValve(self, valvePosition, verbal = False):
      # if (verbal):
      #     print("==> setMixingValve(",valvePosition,")", sep="")
      self.mixingValveOpen= valvePosition
      DAQC.setDAC(self.piPlateAdr2,0,valvePosition * 4.095 / 100)

   def getMixingValve(self, verbal = False):
      return self.mixingValveOpen


   # Absperrventil (Relais:5)
   # -------------
   def setShutOffValveToOpen(self, openIt, verbal = False):
      if (verbal):
          print("==> shutOffValve_Open:",openIt)
      self.shutOffValveOpen = openIt
      if (openIt):
          RELAY.relayON(self.piRelayAdr,5)
      else:
          RELAY.relayOFF(self.piRelayAdr,5)

   def getShutOffValve(self,verbal="True"):
       if (self.shutOffValveOpen):
           return "Opend"
       else:
           return "Closed"


   # WaterPump_On (Relais:6)
   # ------------
   def setWaterPump_On(self, state, verbal = False):
      if (verbal):
          print("==> setWaterPump_On  :",state)
      self.waterPump_On = state
      if (state):
          RELAY.relayON(self.piRelayAdr,6)
      else:
          RELAY.relayOFF(self.piRelayAdr,6)

   def getWaterPump_On(self, verbal = False):
       if (self.waterPump_On):
          return "On"
       else:
          return "Off"


   # Lüfter (Relais: 1,2)
   # ------
   def setFanSpeed(self, stufe1, stufe2, verbal = False):
      if (verbal):
          print("==> setFanSpeed:",stufe1,stufe2)
      if (stufe1 and stufe2):
          self.fanSpeed = 2
      elif((stufe1 == False) and (stufe2 == False)):
          self.fanSpeed = 0
      else:
          self.fanSpeed = 1
      if (stufe1):
          RELAY.relayON(self.piRelayAdr,self.fandSpeed_1_Relais)
          if (stufe2):
              # sleep(5)  # Stufe 2 Zuschaltverzoegerung von 5s
              if(self.t3State.isState_NotStarted()):
                  t3 = Timer(self.time_T3, self.T3Over, args=[self.t3State])
                  self.t3State.setState_Ticking()
                  t3.start()

              if (self.t3State.isState_TimeOver()):
                  RELAY.relayON(self.piRelayAdr,self.fandSpeed_2_Relais)
          else:
              RELAY.relayOFF(self.piRelayAdr,self.fandSpeed_2_Relais)
      else:
          RELAY.relayOFF(self.piRelayAdr,self.fandSpeed_1_Relais)
          RELAY.relayOFF(self.piRelayAdr,self.fandSpeed_2_Relais)

   def getFanSpeed(self,verbal="False"):
       retStr = ""
       if (verbal):
          if (self.fanSpeed == 1):
             retStr = "(R" + str(self.fandSpeed_1_Relais) + ")"
          if (self.fanSpeed == 2):
             retStr = "(R" + str(self.fandSpeed_1_Relais) + ",R" + str(self.fandSpeed_2_Relais) + ")"
       return str(self.fanSpeed) + retStr


   # Heartbeat indicator
   # -------------------
   def setHeartbeatInicator(self, on):
       if (on):
           DAQC.setDOUTbit(self.piPlateAdr1,6)
           DAQC.clrDOUTbit(self.piPlateAdr2,6)
       else:
           DAQC.clrDOUTbit(self.piPlateAdr1,6)
           DAQC.setDOUTbit(self.piPlateAdr2,6)

   def toggleHeartbeatInicator(self):
       DAQC.toggleDOUTbit(self.piPlateAdr1,6)
       DAQC.toggleDOUTbit(self.piPlateAdr2,6)

   # EmergenyOff (Not-Stop)
   # ----------------------
   def doEmergencyStop(self, verbal = False):
       if (verbal):
          print("Emergency Off Class_KaelteMacherMaschine activated!!!")
       self.setComp_On(2,False)
       self.setComp_On(1,False)
       self.setShutOffValveToOpen(False)
       self.setSpeedComp(2, 0)
       self.setSpeedComp(1, 0)
       sleep(2)
       self.setFanSpeed(False,False)
       ## self.setWaterPump_On(False) # Keep Waterpump on!!!
       self.setWaterPump_On(False)
       self.setMixingValve(0)

   # Debug / Test-Methods
   # --------------------
   def toString(self):
       fField = "{e:10.1f}"
       dField = "{e:10d}"
       sField = "{e:>11s}"
       self.getLowPressure(False)
       self.getHighPressure(False)
       self.getExistingEnergy(False)

       retStr = "Status Kaeltemaschine    at " + getTimestamp() + "\n"
       retStr = retStr + "=====================\n"
       if (self.isEmergencyOff_Active(False)):
           retStr = retStr + "Emergency Off (Compressors will not start!)\n"
       if (self.isDelayedOn_Active(False)):
           retStr = retStr + "Delayed On    (Compressors will start with a delay!)\n"
       else:
           retStr = retStr + "Delayed Off   (Compressors will start immedeately!)\n"

       retStr = retStr + "\n"
       if (self.isCompressorReady(1,False)):
           retStr = retStr + "Compressor 1            (K1/DI_0): Ready\n"
       else:
           retStr = retStr + "Compressor 1            (K1/DI_0): NOT Ready\n"

       if (self.isCompressorReady(2,False)):
           retStr = retStr + "Compressor 2            (K1/DI_1): Ready\n"
       else:
           retStr = retStr + "Compressor 2            (K1/DI_0): NOT Ready\n"

       retStr = retStr + "\n"
       retStr = retStr + ("Available Energy        (K1/AI_0):" + self.availableEnergySensor.toString(True, True, False) + "\n")
       retStr = retStr + ("Low Pressure            (K1/AI_1):" + self.niederdruckSensor.toString(True, True, False) + "\n")
       retStr = retStr + ("High Pressure           (K1/AI_2):" + self.hochdruckSensor.toString(True, True, False) + "\n")
       # retStr = retStr + ("Water Temperature               :" + fField + "C   \n").format(e=self.getWaterTemp(False))
       retStr = retStr + ("Water Temperature PT1000 (K1/AI_3):" + fField + "C   \n").format(e=self.getWaterTemp_PT1000(False))
       # retStr = retStr + ("Environment Temprature          :" + fField + "C   \n").format(e=self.getEnvironmentTemp(False))
       retStr = retStr + ("Env Temperature PT1000   (K1/AI_4):" + fField + "C   \n").format(e=self.getEnvironmentTemp_PT1000(False))

       retStr = retStr + "\n"
       retStr = retStr + ("ShutOff-Valve       (R" + str(self.ShutOffValve_Relais) + ")        :" + sField + "    \n").format(e=self.getShutOffValve(False))
       retStr = retStr + ("Water Pump          (R" + str(self.WaterPump_Relais) + ")        :"    + sField + "    \n").format(e=self.getWaterPump_On(False))
       retStr = retStr + ("Mixing Valve Open   (K2/AO_0))  :" + fField + "%   \n").format(e=self.getMixingValve(False))
       retStr = retStr + ("Fan Speed           (R" + str(self.fandSpeed_1_Relais) + ",R" + str(self.fandSpeed_2_Relais) +")     :" + sField + " \n").format(e=self.getFanSpeed(False))
       retStr = retStr + ("Compressor 1 Speed  (R" + str(self.compressor_1_On_Relais) + ",K1/AO_0):" + fField + "%  (").format(e=self.getSpeedComp(1)) + str(self.getComp_On(1)) + ")\n"
       retStr = retStr + ("Compressor 2 Speed  (R" + str(self.compressor_2_On_Relais) + ",K1/AO_1):" + fField + "%  (").format(e=self.getSpeedComp(2)) + str(self.getComp_On(2)) + ")\n"

       return retStr


   def toStringForLog(self,sep = ";", withHeader = False, onlyHeader = False):
       fField = "{e:10.1f}"
       dField = "{e:10d}"
       sField = "{e:>11s}"
       retStr = ""
       if (withHeader or onlyHeader):
           retStr =  retStr + sep + "Time               " + sep + "q [%] " + sep + "p_Low [bar]" + sep + "p_High [bar]"
           retStr =  retStr + sep + "T_Env [C] " + sep + "T_Water [C]" + sep + "Comp_1_Ready" + sep + "Comp_2_Ready" + sep + "EmergencyOff" + sep + "DelayedOn"
           retStr =  retStr + sep + "ShutOff-Valve" + sep + "Water Pump " + sep + "Mixing Valve Open"
           retStr =  retStr + sep + "Compressor 1   " + sep + "Compressor 2   " + sep + "Fan Speed"
       if (onlyHeader == False):
          retStr =  retStr + sep + getTimestamp() + sep + self.availableEnergySensor.toString(False, False, False, False) + sep + self.niederdruckSensor.toString(False, False, False, False) + "     " + sep + self.hochdruckSensor.toString(False, False, False, False) + "      "
          retStr =  retStr + sep + fField.format(e=self.getEnvironmentTemp_PT1000(False)) + sep + fField.format(e=self.getWaterTemp_PT1000(False)) + " " + sep +  "{e:>12s}".format(e=str(self.isCompressorReady(1,False))) + sep +  "{e:>12s}".format(e=str(self.isCompressorReady(2,False))) + sep +  "{e:>12s}".format(e=str(self.isEmergencyOff_Active(False)))  + sep +  "{e:>9s}".format(e=str(self.isDelayedOn_Active(False)))
          retStr =  retStr + sep + "  " + sField.format(e=self.getShutOffValve(False)) + sep + sField.format(e=self.getWaterPump_On(False)) + sep + "       " + fField.format(e=self.getMixingValve(False))
          retStr =  retStr + sep + fField.format(e=self.getSpeedComp(1)) + "  " + str(self.getComp_On(1)) + sep + fField.format(e=self.getSpeedComp(2)) + "  " + str(self.getComp_On(2)) + sep + sField.format(e=self.getFanSpeed(False))
       retStr = retStr[1:]
       return retStr

# print("Analog_0:",DAQC.getADC(1,0))
# print("Analog_1:",DAQC.getADC(1,1))
# print("Analog_2:",DAQC.getADC(1,2))
# print("Analog_3:",DAQC.getADC(1,3))
# print("Analog_4:",DAQC.getADC(1,4))
# print("Analog_5:",DAQC.getADC(1,5))
# print("Analog_6:",DAQC.getADC(1,6))
# print("Analog_7:",DAQC.getADC(1,7))

# print("Digital_0:",DAQC.getDINbit(1,0))
# print("Digital_1:",DAQC.getDINbit(1,1))
# print("Digital_2:",DAQC.getDINbit(1,2))
# print("Digital_3:",DAQC.getDINbit(1,3))
# print("Digital_4:",DAQC.getDINbit(1,4))
# print("Digital_5:",DAQC.getDINbit(1,5))
# print("Digital_6:",DAQC.getDINbit(1,6))
# print("Digital_7:",DAQC.getDINbit(1,7))

# DAQC.toggleDOUTbit(1,0)
# DAQC.setDAC(1,0,DAQC.getADC(1,2))
