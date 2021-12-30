# coding=utf8
# Probe Programmier - Aufgabe
# Passwort muss länger als 6 Zeichen lang sein.
# Passwort muss eine Zahl enthalten
# Rückgabe: entweder Passwort ist valid: True, Passwort ist ungültig: False


def valid_passwort(password):
    if (password == 'längerse45'):
        return True
    else:
        return False


if __name__ == '__main__':
    print("Passwort prüfen:")
    print(valid_passwort('kurz'))

    # Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
    assert valid_passwort('kurz') == False
    assert valid_passwort('muchlonger') == False
    assert valid_passwort('12345') == False
    assert valid_passwort('längerse45') == True
    assert valid_passwort('sha5') == False
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")