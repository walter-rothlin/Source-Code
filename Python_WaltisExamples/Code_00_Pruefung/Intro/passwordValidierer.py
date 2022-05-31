# Walter Rothlin 19.05.2022

# coding=utf8
# Probe Programmier - Aufgabe
# Passwort muss länger als 6 Zeichen lang sein.
# Passwort muss mindestens eine Zahl enthalten
# Rückgabe: entweder Passwort ist valid: True, Passwort ist ungültig: False

def howManyDigitsAreInString_Classic(aString, trace=False):
    count = 0
    for c in aString:
        if c >= '0' and c <= '9':
            count += 1
    if trace:
        print("howManyDigitsAreInString_Classic:", aString, count)
    return count

def howManyDigitsAreInString_WithComprehension(aString, trace=False):
    count = len([d for d in aString if d >= '0' and d <= '9'])
    if trace:
        print("howManyDigitsAreInString_WithComprehension:", aString, "--> ", count)
    return count

def howManyDigitsAreInString_WithRegEx(aString, trace=False):
    import re

    copmiledRe = re.compile(r'\d')
    count = len(copmiledRe.findall(aString))
    if trace:
        print("howManyDigitsAreInString_WithRegEx:", aString, "--> ", count)
    return count


def howManyDigitsAreInString(aString, trace=False):
    # return howManyDigitsAreInString_Classic(aString, trace=trace)
    # return howManyDigitsAreInString_WithComprehension(aString, trace=trace)
    return howManyDigitsAreInString_WithRegEx(aString, trace=trace)

def valid_passwort(password, trace=False):
    retVal = False
    if len(password) > 6:
        if len([d for d in password if '0' <= d <= '9']) >= 1:   # using comprehensions
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

    # Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
    assert valid_passwort('kurz') is False
    assert valid_passwort('muchlonger') is False
    assert valid_passwort('12345') is False
    assert valid_passwort('längerse45') is True
    assert valid_passwort('sha5') is False
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")

