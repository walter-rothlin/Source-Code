# ------------------------------------------------------------------
# Name  : Class_ArduinoDisplay.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Class_ArduinoDisplay.py
#
# Description: Wrapper-Class for LCD-Display controlled by an arduino via Serial (USB)
#
# Autor: Walter Rothlin
#
# History:
# 04-Dec-2021   Tobias Rothlin      Initial Version ()
# ------------------------------------------------------------------
from waltisLibrary import *
import serial
import serial.tools.list_ports as port_list


class ArduinoDisplay:
    def __init__(self, comPort=None):
        if comPort is None:
            comPort = ArduinoDisplay.selectComPort(showDetails = True)
        self.__arduino = serial.Serial(comPort)
        self.__arduino.write(b'h')
        sleep(1.5)

    def write(self, text):
        self.__arduino.write(text.encode())

    def clear(self):
        self.write(chr(127))

    def close(self):
        self.__arduino.close()

    @staticmethod
    def getComPorts(withDetails = False):
        if withDetails:
            return [str(p) for p in port_list.comports()]
        else:
            return [str(p).split(" ")[0] for p in port_list.comports()]

    @staticmethod
    def selectComPort(showDetails = True):
        comPorts = ArduinoDisplay.getComPorts(withDetails=showDetails)
        if len(comPorts) == 1:
            if showDetails:
                return comPorts[0].split(" ")[0]
            else:
                return comPorts[0]
        elif len(comPorts) == 0:
            return None
        else:
            print(getMenuStrFromList(comPorts, titel="Available ports:"))
            selected = readInt("\n         Which one:", min=1, max=len(comPorts))
            if showDetails:
                return comPorts[selected - 1].split(" ")[0]
            else:
                return comPorts[selected - 1]

    @staticmethod
    def TEST_class():
        pollingTime = 5
        print(ArduinoDisplay.getComPorts(withDetails=True))
        display = ArduinoDisplay()
        display.write("Hallo\nWalti")
        time.sleep(pollingTime)
        display.write("\nRothlin")
        time.sleep(pollingTime)
        display.clear()
        display.write("12345678901234567890")
        display.close()

    @staticmethod
    def getC_CodeForArduino():

        return """
            #include <LiquidCrystal.h>
        
            LiquidCrystal lcd(9, 8, 7, 6, 5, 4);
        
            int currentLine = 0;
            int posInLine = 0;
        
            void setup() {
              Serial.begin(9600);
              lcd.begin(16, 2);
              lcd.clear();
            }
        
            void loop() {
        
              while (!Serial.available())
              {
                delay(1);
              }
              while (Serial.available())
              {
                char currentChar = Serial.read();
                if(currentChar == '\n')
                {
                  currentLine ++;
                  if(currentLine >= 2)
                  {
                    currentLine = 1;
                  }
                  posInLine = 0;
                  lcd.setCursor(posInLine,currentLine);
                }
                else if(currentChar == '\r')
                {
                  posInLine = 0;
                  lcd.setCursor(posInLine,currentLine);
                }
        
                else if(currentChar == 8)
                {
                  posInLine --;
                  lcd.setCursor(posInLine,currentLine);
                }
                else if(currentChar == 127)
                {
                  lcd.clear();
                  posInLine = 0;
                  currentLine = 0;
                  lcd.setCursor(currentLine,posInLine);
                }
                else
                {
                  posInLine++;
                  lcd.print(currentChar);
                }
              }
            }
            """


if __name__ == "__main__":
    doTest = False
    ArduinoDisplay.TEST_class() if doTest else False


    display = ArduinoDisplay()
    textToDisplay = "Ready to write!\n1234567890123456"
    while textToDisplay != "\n":
        display.clear()
        display.write(textToDisplay)
        textToDisplay = input("1.Zeile:")
        textToDisplay += "\n" + input("2.Zeile:")

    display.close()
