# coding=utf8
# Probe Programmier - Aufgabe
# Passwort muss länger als 6 Zeichen lang sein.
# Passwort muss mindestens eine Ziffer enthalten
# Rückgabe: entweder Passwort ist valid: True, Passwort ist ungültig: False
def countFiguresInString(aString):
    count = 0
    for aChar in aString:
        if '0' <= aChar <= '9':
            count = count + 1
    return count


def valid_passwort(password):
    if len(password) > 6:
        if countFiguresInString(password) >= 1:
            return True
        else:
            return False
    else:
        return False


if __name__ == '__main__':
    print("Passwort prüfen:")
    # print(valid_passwort('kurz'))

    # Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
    assert valid_passwort('kurz') == False
    assert valid_passwort('muchlonger') == False
    assert valid_passwort('12345') == False
    assert valid_passwort('12345678') == True
    assert valid_passwort('längerse45') == True
    assert valid_passwort('sha5') == False
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")