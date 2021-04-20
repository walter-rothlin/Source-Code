#!/usr/bin/python3


from Class_4_20mA_Sensor  import *

# niederdruckSensor = CurrentLoop_4_20mA_Sensor("Niederdruck","bar",-0.5,5)
# print(niederdruckSensor.getR_ShuntSoll())
# niederdruckSensor.calc_physicalValue(4.092)
# print(niederdruckSensor.toString())
# niederdruckSensor.calc_physicalValue(2)
# print(niederdruckSensor.toString())
# print("\n\n")

hochdruckSensor = CurrentLoop_4_20mA_Sensor("Hochdruck","bar",0,25)
print(hochdruckSensor.toString())
print(hochdruckSensor.getR_ShuntSoll())
hochdruckSensor.calc_physicalValue(4.092)
print(hochdruckSensor.toString())
hochdruckSensor.calc_physicalValue(2)
print(hochdruckSensor.toString())