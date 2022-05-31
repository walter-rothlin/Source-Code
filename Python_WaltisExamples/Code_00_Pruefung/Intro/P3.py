# coding=utf8
# Programmier - Aufgabe 3


def index2_WR(text, symbol):
    """
        Gib den 2.ten Index des gesuchten Zeichen zurück.
        Wenn nichts gefunden wird, dann soll 'None' zurückgegeben werden.
    """
    pos = -1
    for i in range(len(text)):
        if text[i] == symbol:
            # print(i, text[i], pos)
            if pos > -1:
                # print("return i:", i)
                return i
            else:
                pos = i
    # print("return NONE:")
    return None

def index2(text, symbol):
    secondIndex = text.find(symbol, text.find(symbol)+len(symbol), len(text))
    if secondIndex == -1:
        return None
    else:
        return secondIndex

def index2_B(text, symbol):

    index_list = []
    counter = 0
    for i in text:
        if i == symbol:
            index_list.append(counter)
        counter += 1

    if len(index_list) > 1:
        return index_list[1]
    else:
        return None

if __name__ == '__main__':
    print('Beispiel für index2:')

    # Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
    assert index2("sms", "s") == 2, "1"
    assert index2("Stockholm", "o") == 6, "2"
    assert index2("Hallo", "l") == 3, "3"
    assert index2("Hallo Meier", " ") is None, "4"
    assert index2("Hallo Herr Meier", " ") == 10, "5"
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")