import time
from threading import Timer


def hello(firstname="No", lastName="Name", anz=3, delay=3.0):
    for i in range(anz):
        print(i, "Hello", firstname, lastName)
        time.sleep(delay)


# Testfälle
hello()
# hello("Felix")
# hello("Felix", "Muster", 1)

delayTime = float(input("Delay-Time [s] *6:"))
anzLoops = int(input("Anzahl Loops *3: "))
fName = input("Vorname :")
lName = input("Nachname:")

t = Timer(delayTime, hello, args=[fName, lName, anzLoops])
t.start()
hello("Max", "Meier")
print("....main is waiting for termination")
t.join()
hello("Claudia", "Collet", 5, 0.5)
print("....main finished!!!")
