# Beispiel 7.4
#
# Abfangen unterschiedlicher Exceptions - 1
#
while True:
    try:
        eingabe = int(input("Eingabe: "))
        ergebnis = 10/eingabe

        print(ergebnis)
        break
    except ValueError:
        print("Ungültige Eingabe!")
    except ZeroDivisionError:
        print("Division durch null ist nicht möglich!")
