
from sense_hat import *
from decimal import Decimal



class MySenseHat(SenseHat):

    def __init__(self):
        super().__init__()


    def set_pixel(self, x, y, *args):

        checktX = self.__check_DataType(x)
        checktY = self.__check_DataType(y)

        if checktX >= 0 and checktX <= 7 and checktY >= 0 and checktY <= 7 :
            super().set_pixel(checktX,checktY, args)

    def __round_Decimal(self, inDecimal):
        return round(inDecimal)

    def __check_DataType(self, inNumberToCheck):
        roundetNumber = 0
        if isinstance(inNumberToCheck, str):
            try:
                comparedNumber = float(inNumberToCheck)
                roundetNumber = self.__round_Decimal(comparedNumber)
            except ValueError:
                roundetNumber = 0
            print(f'Input is a string. Nämlich:{inNumberToCheck} ergebniss:{roundetNumber}')
        elif isinstance(inNumberToCheck, float):
            roundetNumber = self.__round_Decimal(inNumberToCheck)
            print(f'Input is a Decimal Nämlich:{inNumberToCheck} gerundet auf: {roundetNumber}')
            roundetNumber = roundetNumber
        elif isinstance(inNumberToCheck, int):
            print(f'Input is a int Nämlich:{inNumberToCheck}')
            roundetNumber = inNumberToCheck
        return roundetNumber

    def draw_line(self, startx = 0, starty=0, endx =7, endy =7, r = 255, g = 0, b = 0 ):
        startX = self.__check_DataType(startx)
        startY = self.__check_DataType(starty)
        endX = self.__check_DataType(endx)
        endY = self.__check_DataType(endy)
        self.clear()


        if startX == endX:
            for y in range(min(startY, endY), max(startY, endY) + 1):
                self.set_pixel(startX, y, r,g,b)
        else:

            slope = (endY - startY) / (endX - startX)
            intercept = startY - slope * startX
            for x in range(min(startX, endX), max(startX, endX) + 1):
                y = int(slope * x + intercept)
                self.set_pixel(x, y, r, g, b)







if __name__ == '__main__':

    red   = (255, 0, 0)
    green = (0,255,0)
    blue  = (0,0,255)
    yellow= (255,255,0)
    mangenta = (255,0,255)
    cyan = (0,255,255)
    white = (255,255,255)
    black = (0,0,0)
    grey = (50,50,50)

    '''
    Aufgabe 1 
    Normaler SensHat Pixel OK 
    My Senshat keine Exception.
    '''
    hat = SenseHat()
    hat.set_pixel(4,5, 255, 0, 255)

    myHat = MySenseHat()
   
    myHat.set_pixel(8,5, red)
    myHat.set_pixel(9,8, red)

    '''
    Aufgabe 2.2 
    Runde Dezimalzahlen
    '''
    myHat.set_pixel(2.1, 3.4, 255, 0, 0)

    #Not working test 
    myHat.set_pixel(8.6, 9.9, 255, 0, 0)

    '''
    Aufgabe 2.3 
    Number als string 
    Valide int 
    Nicht Valide int 
    Valide Dezimal 
    Nicht valide Dezimal
    Valider String 
    Invalider String
    Mixed 
    '''
    myHat.set_pixel('3', '4', 255, 0, 0)
    myHat.set_pixel('9', '12', 255, 0, 0)
    myHat.set_pixel('3.4', '4.6', 255, 0, 0)
    myHat.set_pixel('8.2', '9.9', 255, 0, 0)
    myHat.set_pixel('5', '6', 255, 0, 0)
    myHat.set_pixel('Hallo', '4', 255, 0, 0)
    myHat.set_pixel(4, '4', 255, 0, 0)

    '''
    Start zu end punkt zeichen 
    '''
    myHat.draw_line(startx=1, starty=1, endx=7, endy=7, r=255, g=0, b= 0)

    myHat.draw_line(startx=1, starty=1, endx=7, endy=7, r=255, g=0, b= 0)

    myHat.draw_line(startx=0, starty=0, endx=0, endy=8, r=255, g=0, b= 0)

