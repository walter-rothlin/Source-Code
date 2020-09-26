#!/usr/bin/python3
import piplates.DAQCplate as DAQC


# https://pi-plates.com/daqc-users-guide/
# https://pi-plates.com/downloads/DAQCplate%20Quick%20Reference%20Guide.pdf
	

class KaelteMacherMaschine:

   def __init__(self, piPlateAdr):
      self.piPlateAdr = piPlateAdr
      DAQC.setDOUTall(self.piPlateAdr,0)

   # Analog Inputs
   def getVorhandeneEnergie(self):
      measure = DAQC.getADC(self.piPlateAdr,0)
      retVal = 100 * measure / 4.092
      print("getVorhandeneEnergie: {t1:4.2f}V   ({t2:-6.1f}%)".format(t1=measure,t2=retVal))
      return retVal

   def getNiederdruck(self):
      measure = DAQC.getADC(self.piPlateAdr,1)
      retVal = 100 * measure / 4.092
      print("getNiederdruck      : {t1:4.2f}V   ({t2:-6.1f}%)".format(t1=measure,t2=retVal))
      return retVal
	  
   def getHochdruck(self):
      measure = DAQC.getADC(self.piPlateAdr,2)
      retVal = 100 * measure / 4.092
      print("getHochdruck        : {t1:4.2f}V   ({t2:-6.1f}%)".format(t1=measure,t2=retVal))
      return retVal


   # Digital Inputs
   def getNiederdruckStoerung(self):
      measure = DAQC.getDINbit(self.piPlateAdr,0)
      if (measure == 1):
          retVal = True
      else:
          retVal = False
      print("getNiederdruckStoerung  :", measure,"  (",retVal,")")
      return retVal

   def getHochdruckStoerung(self):
      measure = DAQC.getDINbit(self.piPlateAdr,1)
      if (measure == 1):
          retVal = True
      else:
          retVal = False
      print("getHochdruckStoerung    :", measure,"  (",retVal,")")
      return retVal

   def getEinschaltVerzoegerung(self):
      measure = DAQC.getDINbit(self.piPlateAdr,2)
      if (measure == 1):
          retVal = True
      else:
          retVal = False
      print("getEinschaltVerzoegerung:", measure,"  (",retVal,")")
      return retVal

   # Verdichter
   def setVerdichter_Speed(self,verdichterNr,speed):
      print("==> setVerdichter_Speed({x1:1s})  : {x2:4.0f}%".format(x1=verdichterNr, x2=speed))
      DAQC.setDAC(self.piPlateAdr,int(verdichterNr) - 1,speed * 4.092 / 100)	  

   def setVerdichter_On(self,verdichterNr,isOn):
      print("==> setVerdichter_On({x1:1s})     : {x2:5s}".format(x1=verdichterNr, x2=str(isOn)))
      if (isOn):
          DAQC.setDOUTbit(self.piPlateAdr,int(verdichterNr) - 1)	 
      else:
          DAQC.clrDOUTbit(self.piPlateAdr,int(verdichterNr) - 1)	 	  
	  
   # Absperrventil
   def closeAbsperrVentil(self,closeIt):
      print("==> closeAbsperrVentil:",closeIt)
      if (closeIt):
          DAQC.setDOUTbit(self.piPlateAdr,2)	 
      else:
          DAQC.clrDOUTbit(self.piPlateAdr,2)

   # Lüfter
   def setLuefter(self,stufe1,stufe2):
      print("==> setLuefter:",stufe1,stufe2)
      if (stufe1):
          DAQC.setDOUTbit(self.piPlateAdr,3)	 
      else:
          DAQC.clrDOUTbit(self.piPlateAdr,3)
      if (stufe2):
          DAQC.setDOUTbit(self.piPlateAdr,4)	 
      else:
          DAQC.clrDOUTbit(self.piPlateAdr,4)				  

   # Heartbeat indicator
   def setHeartbeatInicator(self,on):
      if (on):
          DAQC.setDOUTbit(self.piPlateAdr,6)	 
      else:
          DAQC.clrDOUTbit(self.piPlateAdr,6)
		  
   def toggleHeartbeatInicator(self):
      DAQC.toggleDOUTbit(self.piPlateAdr,6)	 


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
