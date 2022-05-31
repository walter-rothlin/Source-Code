# Walter Rothlin 19.05.2022
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_00_Pruefung/Intro/P2.py

# coding=utf8

# Programmier - Aufgabe 2
# Input: ein String mit 'Worten'
# Bedingungen: Der String ist korrekt, wenn der String aus 3 oder mehr Worten besteht. Zahlen sind keine Worte.
# Output: Die Ausgabe ist ein Boolean
# Vorbedingungen: Die Eingabe enthält Worte oder Zahlen. Es gibt keine Worte die aus Zahlen und Buchstaben bestehen
# 0 < len(words) < 100

def containsWordDigits(aWort):
    if len([d for d in aWort if '0' <= d <= '9']) >= 1:
        return False
    else:
        return True

def check_wort(words):
    wordList = [aWord for aWord in words.split(" ") if containsWordDigits(aWord)]
    if len(wordList) >= 3:
        return True
    else:
        return False

from string import digits
def check_wort_2(words):
    remove_digits = str.maketrans('', '', digits)
    res = words.translate(remove_digits)
    print(res)
    split = res.split()
    if len(split) >= 3:
        return True
    return False

def check_wort_3(words):
    word_list = words.split()
    if len(word_list) >= 3:
        counter = 0
        for i in word_list:
            if i.isnumeric() == False:
                counter += 1
        if counter >= 3:
            return True
        else:
            return False
    else:
        return False

from itertools import islice
def check_wort_NOK(words):
    split = words.split()
    for values in zip(split, islice(split, 1, None), islice(split, 2, None)):
        if all(i.isalpha() for i in values):
            return True
    return False

# Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
if __name__ == '__main__':
    print('Beispiel Wortcheck:')

    assert check_wort("Hallo Welt Max") is True, "Hallo"
    assert check_wort("Er ist 007 Bond") is True, "007 Bond"
    assert check_wort("1 2 3 4") is False, "Zahlen"
    assert check_wort("bla bla bla bla") is True, "Bla Bla"
    assert check_wort("Hoi") is False, "Hoi"
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")
