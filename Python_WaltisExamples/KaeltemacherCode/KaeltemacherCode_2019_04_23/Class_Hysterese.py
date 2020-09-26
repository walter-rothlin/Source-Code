#!/usr/bin/python3

class Hysterese:
   
   def __init__(self, levelOn, levelOff, onOff=False, inverse=False):
      self.levelOn  = levelOn
      self.levelOff = levelOff
      self.onOff    = onOff
      self.inverse  = inverse
   
   def setState(self,inValue):
     if (self.onOff):
        if (inValue < self.levelOff):
            self.onOff = False
     else:
        if (inValue > self.levelOn):
            self.onOff = True
            
     if (self.inverse):
         return not self.onOff
     else:
         return self.onOff

   def getValue(self):
      return self.onOff
    
   def setInverse(self,newValue):
      self.inverse = newValue
   
   def getInverse(self):
      return self.inverse
    
   def getOff(self):
      return self.levelOff
    
   def getOn(self):
      return self.levelOn
      
##hochDruckOff      = Hysterese(90,80)
##for aNumber in [50,70,80,90,91,100,91,90,81,80,79,50]:
##   print("{x1:4d}".format(x1=aNumber),hochDruckOff.setState(aNumber),"  (",hochDruckOff.getOn(),",",hochDruckOff.getOff(),")")      
##print()
##
##hochDruckOff      = Hysterese(80,90,inverse=True)
##for aNumber in [50,70,80,90,91,100,91,90,81,80,79,50]:
##   print("{x1:4d}".format(x1=aNumber),hochDruckOff.setState(aNumber),"  (",hochDruckOff.getOn(),",",hochDruckOff.getOff(),")")      
##print()