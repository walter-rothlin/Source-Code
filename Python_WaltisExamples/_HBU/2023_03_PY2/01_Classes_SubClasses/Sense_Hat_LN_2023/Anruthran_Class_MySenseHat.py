#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_MySenseHat.py
#
# Description: 
#
# Autor: Anruthran Chiwacumar
#
# History:
# 04-Okt-2023   Anruthran Chiwacumar      Initial Version (Menu-Text)

# Sub Class
# ------------------------------------------------------------------
from sense_hat import SenseHat

#Unterklasse Override
class MySenseHat(SenseHat):
    def __init__(self):
        #sense = SenseHat()
        #sense.show_message("Hello world!")  
        super().__init__()
    def set_pixel(self, x, y, color):

        if isinstance (x,str) or isinstance (y,str):
            print("Falsche Eingabe es ist ein String") 
        elif 0 < x < 7 and 0 < y < 7: 
            if isinstance(x,float) or isinstance(y,float):
                try:
                    print("Success")
                    x = int(round(float(x)))
                    y = int(round(float(y)))
                    super().set_pixel(x,y,color)
                    
                except Exception as e:
                    print("Fehler 2: {}".format(e))   
            else:
                print("Success")
                super().set_pixel(x,y,color)
        else:
            pass
            
    def draw_line(self, x_Startpoint, x_Endpoint, y_Startpoint, y_Endpoint,color):         
             
        a = (y_Startpoint - y_Endpoint)/(x_Startpoint - y_Endpoint)
        b = y_Startpoint - a * x_Startpoint
        
        for y in range(min(y_Startpoint, y_Endpoint), max(y_Startpoint, y_Endpoint) + 1):
            self.set_pixel(x_Startpoint, y, color)
        return
        
        print (a,b)


if __name__ == "__main__":
    my_sense = MySenseHat()
    #my_sense.show_message("Test")

    try:
        my_sense.set_pixel(4, 5, (255, 0, 0))  # rot
        my_sense.set_pixel(5, 6, (0, 0, 255))  # blau
        my_sense.set_pixel(8, 5, (0, 255, 0))  # gruen  ==> was zum Fehler führt ausserhalb Grid wird ignoriert
        my_sense.set_pixel(2, 0.3, (0,255,255))# dezimalzahl y werden gerundet
        my_sense.set_pixel(0.2, 3, (0,255,255)) # dezimalzahl x werden gerundet
        my_sense.set_pixel("Hallo", 3, (0,255,255)) # string wird ignoriert und gibt fehler meldung aus.
        my_sense.draw_line(1,2,7,5,(255,255,255))
    except Exception as e:
        print("Fehler: {}".format(e))
        super().clear()
        
   
        
    
        
    