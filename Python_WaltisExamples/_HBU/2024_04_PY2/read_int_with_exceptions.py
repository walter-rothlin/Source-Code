
# source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2024_04_PY2/read_int_with_exceptions.py
class TooMany_Tries(Exception):
    def __init__(self, *args):
        if args:
            self.message = args[0]
        else:
            self.message = 'Nothing to say!'

    def __str__(self):
        return self.message


class OutOfRange(Exception):
    def __init__(self, *args):
        if args:
            self.message = args[0]
        else:
            self.message = 'Ausserhalb des Erlaubten Bereiches'

    def __str__(self):
        return self.message




def read_int(prompt, max_tries=None, min=None, max=None):

    tries = 0
    has_error = True
    while has_error:
        value_str = input(prompt)

        try:
            value = int(value_str)
            if min is not None and value >= min:
                if max is not None and value <= max:
                    has_error = False
                else:
                    if max_tries is not None:
                        tries += 1
                        print(f'ERROR: {tries} Fehlversuche und {value} > {max}')
                    if max_tries - tries < 1:
                        raise OutOfRange(f'{max_tries} Versuche sind zuviel und {value} > {max}')
            else:
                if max_tries is not None:
                    tries += 1
                    print(f'ERROR: {tries} Fehlversuche und {value} < {min}')
                if max_tries - tries < 1:
                    raise OutOfRange(f'{max_tries} Versuche sind zuviel und {value} < {min}')



        except ValueError:
            if max_tries is not None:
                tries += 1
                print(f'ERROR: Kein Integer! Versuche es nochmals!!! Versuche übrig: {max_tries - tries}')
                if max_tries - tries < 1:
                    raise TooMany_Tries(f'{max_tries} Versuche sind zuviel! Ich gebe auf!!!')
            else:
                print(f'ERROR: Kein Integer! Versuche es nochmals!!!')

    return value


# ===========================================================
# MAIN
# ===========================================================
if __name__ == '__main__':
    stueckpreis = 2.30
    try:
        anzahl_aepfel = read_int('Anzahl Aepfel:', max_tries=5, min=2, max=9)
    except TooMany_Tries as e:
        print(f'Zuviele Versuche!! Fehler:{e}')
    except OutOfRange as e:
        print(f' Out of Range:{e}')
    else:
        print(f'Gekaufte Aepfel: {anzahl_aepfel} zu {stueckpreis:0.2f} = {anzahl_aepfel*stueckpreis:0.2f}CHF')

