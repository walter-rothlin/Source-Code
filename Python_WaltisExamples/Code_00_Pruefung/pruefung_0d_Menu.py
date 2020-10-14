#!/usr/bin/python3

'''pruefung_0d_Menu.py'''

doStop = False
while (not doStop):
    print("  Umrechnungen")
    print("  ============")
    print("  1: Grad in Bogenmass")  # rad  = grad*pi/180
    print("  2: Bogenmass in Grad")  # grad = rad*180/pi
    print()
    print("  0: Schluss")

    antwort = input("\n  Wähle:")
    if (antwort == "1"):
        print("")
    elif (antwort == "2"):
        print("")
    elif (antwort == "0"):
        doStop = True

print("Ende....Done")