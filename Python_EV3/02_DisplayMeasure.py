from grobot import *

clearDisplay()
drawString("012345678901234567", 0, 0)  # 18 Zeichen * 8 Zeilen
drawString("1   18 Zeichen   1", 0, 1)  # x = 0..17 Zeichen
drawString("2                2", 0, 2)  # y = 0..7  Zeilen
drawString("3                2", 0, 3)
drawString("4                2", 0, 4)
drawString("5                2", 0, 5)
drawString("6                2", 0, 6)
drawString("7................7", 0, 7)
delay(4000)
drawString("7 Zeilen", 5, 7)            # Ganze Zeile wird zuerst gelöscht
delay(4000)
drawString("7....7 Zeilen....7", 0, 7)
delay(4000)