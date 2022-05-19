# Walter Rothlin 19.05.2022

# coding=utf8
# Probe Programmier - Aufgabe
# Passwort muss länger als 6 Zeichen lang sein.
# Passwort muss mindestens eine Zahl enthalten
# Rückgabe: entweder Passwort ist valid: True, Passwort ist ungültig: False

def howManyDigitsAreInString_Classic(aString, trace=False):
    count = 0
    for c in aString:
        if ord(c) >= ord('0') and ord(c) <= ord('9'):
            count += 1
    if trace:
        print("howManyDigitsAreInString:", aString, count)
    return count

def howManyDigitsAreInString_WithComprehension(aString, trace=False):
    count = len([d for d in aString if ord(d) >= ord('0') and ord(d) <= ord('9')])
    if trace:
        print("howManyDigitsAreInString:", aString, "--> ", count)
    return count

def howManyDigitsAreInString(aString, trace=False):
    return howManyDigitsAreInString_Classic(aString, trace=False)


def valid_passwort(password, trace=False):
    retVal = False
    if len(password) > 6:
        if howManyDigitsAreInString(password) >= 1:
            retVal = True
        else:
            retVal = False
    else:
        retVal = False
    if trace:
        print(password, len(password), howManyDigitsAreInString(password), "-->", retVal)
    return retVal


if __name__ == '__main__':
    print("Passwort prüfen:")
    howManyDigitsAreInString("01Walti9", True)
    howManyDigitsAreInString("Walti", True)
    howManyDigitsAreInString("123456", True)

    # Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
    assert valid_passwort('kurz') == False
    assert valid_passwort('muchlonger') == False
    assert valid_passwort('12345') == False
    assert valid_passwort('längerse45') == True
    assert valid_passwort('sha5') == False
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")
