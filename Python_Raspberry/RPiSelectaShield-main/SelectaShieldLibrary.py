import RPi.GPIO as GPIO
import time

nX1EN, nX2EN, nX3EN = 2, 3, 4
LED_WRITE, MOT_WRITE = 17, 27

D0, D1, D2, D3, D4, D5 = 7, 8, 25, 24, 23, 18
DataBus = (D0, D1, D2, D3, D4, D5)

class SelectaPi:
    def __init__(self, HomeAllMotors=True, DrinkNames=("", "", "", "", "", "")):
        self.SlotNames = DrinkNames

        self.__MotValues = [0, 0, 0, 0, 0, 0]
        self.__LEDValues = [0, 0, 0, 0, 0, 0]
        
        self.FULL = True
        self.EMPTY = False
        
        self.ENCODER_BUTTON = nX1EN
        self.LEVEL_BUTTON = nX2EN
        self.SELECT_BUTTON = nX3EN
        
        self.ON = GPIO.HIGH
        self.OFF = GPIO.LOW
        
        GPIO.setmode(GPIO.BCM)
        
        self.__setDataDir(GPIO.IN)
        for EnablePin in (nX1EN, nX2EN, nX3EN):
            GPIO.setup(EnablePin, GPIO.OUT, initial = GPIO.HIGH)
        for WritePin in (LED_WRITE, MOT_WRITE):
            GPIO.setup(WritePin, GPIO.OUT, initial = GPIO.LOW)
        
        #Turn off all LEDs
        self.setLEDs((0, 0, 0, 0, 0, 0))
        #Turn off all Motors
        self.setMotors((0, 0, 0, 0, 0, 0))
        
        if (HomeAllMotors == True):
            for MotorNum in range(6):
                if(self.readButton(self.ENCODER_BUTTON, MotorNum) == GPIO.HIGH):
                    self.setMotor(GPIO.HIGH, MotorNum)
                    time.sleep(0.01)
                    
                    while(self.readButton(self.ENCODER_BUTTON, MotorNum) == GPIO.HIGH):
                        time.sleep(0.01)
                    
                    self.setMotor(GPIO.HIGH, MotorNum)
                time.sleep(1)
    
    def __setDataDir(self, DataDirection): #USE OF THIS FUNCTION AT YOUR OWN RISK
        for DataPin in DataBus:
            GPIO.setup(DataPin, DataDirection, initial = GPIO.LOW)
   
    def readData(self):
        Data = []
        for Bit in range(6):
            Data[Bit] = GPIO.input(list(DataBus)[Bit])
        return Data
    
    def getSlotName(self, SlotNumber):
        if (SlotNumber >= 1) and (SlotNumber <= 6):
            return list(self.SlotNames)[(SlotNumber - 1)]
        else:
            return ""
    
    def getSlotNumber(self, SlotName):
        SlotNumber = 1
        for _SlotName in self.SlotNames:
            if _SlotName == SlotName:
                return SlotNumber
            else:
                SlotNumber += 1
        return 0
    
    def setSlotName(self, SlotNumber, SlotName):
        if (SlotNumber >= 1) and (SlotNumber <= 6):
            SlotNamesList = list(self.SlotNames)
            SlotNamesList[(SlotNumber - 1)] = SlotName
            self.SlotNames = tuple(SlotNamesList)
    
    def checkSlotLevels(self):
        return self.readButtons(self.LEVEL_BUTTON)
    
    def checkSlotLevel(self, SlotNumber):
        if ((SlotNumber >= 1) and (SlotNumber <= 6)):
            return self.checkSlotLevels()[(SlotNumber - 1)]
        else:
            return -1
    
    def readButtons(self, SwitchFunction):
        GPIO.output(SwitchFunction, GPIO.LOW)
        
        Data = self.readData()
        
        GPIO.output(SwitchFunction, GPIO.HIGH)
        
        return Data
    
    def readButton(self, SwitchFunction, ButtonNum):
        return self.readButtons(SwitchFunction)[(ButtonNum - 1)]
    
    def setLEDs(self, LEDValues):
        self.__setDataDir(GPIO.OUT)
        
        if (str(type(LEDValues)) == "<class 'tuple'>"):
            LEDValues = list(LEDValues)

        self.__LEDValues = LEDValues
        
        for Bit in range(6):
            GPIO.output(list(DataBus)[Bit], self.__LEDValues[Bit])
        
        GPIO.output(LED_WRITE, GPIO.HIGH)
        time.sleep(0.001)
        GPIO.output(LED_WRITE, GPIO.LOW)
        time.sleep(0.001)
        
        for Bit in range(6):
            GPIO.output(list(DataBus)[Bit], GPIO.LOW)
        
        self.__setDataDir(GPIO.IN)
    
    def setLED(self, LEDValue, LEDNum):
        self.__setDataDir(GPIO.OUT)

        self.__LEDValues[LEDNum - 1] = LEDValue
        
        for Bit in range(6):
            GPIO.output(list(DataBus)[Bit], self.__LEDValues[Bit])
        
        GPIO.output(LED_WRITE, GPIO.HIGH)
        time.sleep(0.001)
        GPIO.output(LED_WRITE, GPIO.LOW)
        time.sleep(0.001)
        
        for Bit in range(6):
            GPIO.output(list(DataBus)[Bit], GPIO.LOW)
        
        self.__setDataDir(GPIO.IN)
    
    def setMotors(self, MotorValues):
        self.__setDataDir(GPIO.OUT)
        
        if (str(type(MotorValues)) == "<class 'tuple'>"):
            MotorValues = list(MotorValues)
        
        self.__MotValues = MotorValues

        for Bit in range(6):
            GPIO.output(list(DataBus)[Bit], self.__MotValues[Bit])
        
        GPIO.output(MOT_WRITE, GPIO.HIGH)
        time.sleep(0.001)
        GPIO.output(MOT_WRITE, GPIO.LOW)
        time.sleep(0.001)
        
        for Bit in range(6):
            GPIO.output(list(DataBus)[Bit], GPIO.LOW)
        
        self.__setDataDir(GPIO.IN)
    
    def setMotor(self, MotorValue, MotorNum):
        self.__setDataDir(GPIO.OUT)

        self.__MotValues[MotorNum - 1] = MotorValue
        
        for Bit in range(6):
            GPIO.output(list(DataBus)[Bit], self.__MotValues[Bit])
        
        GPIO.output(MOT_WRITE, GPIO.HIGH)
        time.sleep(0.001)
        GPIO.output(MOT_WRITE, GPIO.LOW)
        time.sleep(0.001)
        
        for Bit in range(6):
            GPIO.output(list(DataBus)[Bit], GPIO.LOW)
        
        self.__setDataDir(GPIO.IN)
    
    def executeMotorCycles(self, Cycles, MotorNum):
        for cycleNum in range(Cycles):
            self.setMotor(GPIO.HIGH, MotorNum)
            time.sleep(0.01)
            
            while(self.readButton(self.ENCODER_BUTTON, MotorNum) == GPIO.HIGH):
                time.sleep(0.01)
            
            self.setMotor(GPIO.LOW, MotorNum)
