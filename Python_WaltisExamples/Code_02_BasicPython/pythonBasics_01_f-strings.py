#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_01_f_strings.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01_f_strings.py
#
# Description: Examples and explanations regarding f-strings
#
# Autor: Walter Rothlin
#
# History:
# 22-Aug-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

print('''
# 1.Beispiel
# ==========''')
user = "Alice"
welcome_message = f"Willkommen, {user}!"
print(welcome_message)


name = "Max"
age = 25

# Einfacher f-String
greeting = f"Hallo, mein Name ist {name} und ich bin {age} Jahre alt."

# Mit einem Ausdruck
next_year_age = f"Nächstes Jahr werde ich {age + 1} Jahre alt sein."
print(greeting)
print(next_year_age)
ein_text = '''
Dies ist ein langer
mehrzeiliger Text mit Umlauten wie äöü drin!!
'''
print(f'{ein_text}:  ASCII         :{ein_text!a}')
print(f'{ein_text}:  Repräsentation:{ein_text!r}')

print('''
# 2.Links-, rechtsbündig, zenteriert
# ==================================''')
user = "Alice"
plz = 8855
ort = 'Wangen'
temp = 2700.8345
print(f"Ich bin '{user:10s}' aus '{plz:10d}' '{ort:20s}' Temp:'{temp:10.2f}'!   Default ist linksbündig String, rechtsbündig bei float resp decimals")
print(f"Ich bin '{user:<10s}' aus '{plz:<10d}' '{ort:<20s}' Temp:'{temp:<10.2f}'!   Mit < linksbündig")
print(f"Ich bin '{user:>10s}' aus '{plz:>10d}' '{ort:>20s}' Temp:'{temp:>10.2f}'!   Mit > rechtsbündig")
print(f"Ich bin '{user:^10s}' aus '{plz:^10d}' '{ort:^20s}' Temp:'{temp:^10.2f}'!   Mit ^ zentriert")
print()

print(f"Ich bin '{user:10s}' aus '{plz:010d}' '{ort:20s}' Temp:'{temp:010.2f}'!   Mit padding character 0 bei Zahlen (funktioniert nicht bei Strings)")
print(f"Ich bin '{user:10s}' aus '{plz:<010d}' '{ort:20s}' Temp:'{temp:<010.2f}'!   Mit padding character 0 und links/rechts")
print(f"Ich bin '{user:10s}' aus '{plz:>010d}' '{ort:20s}' Temp:'{temp:>010.2f}'!   Mit padding character 0 und links/rechts")
print(f"Ich bin '{user:10s}' aus '{plz:^010d}' '{ort:20s}' Temp:'{temp:^010.2f}'!   Mit padding character 0 und links/rechts")
print()

print(f"Ich bin '{user:10s}' aus '{plz: 10d}' '{ort:20s}' Temp:'{temp: 10.2f}'!   Mit padding character space und links/rechts")
print(f"Ich bin '{user:10s}' aus '{plz:< 10d}' '{ort:20s}' Temp:'{temp:< 10.2f}'!   Mit padding character space und links/rechts")
print(f"Ich bin '{user:10s}' aus '{plz:> 10d}' '{ort:20s}' Temp:'{temp:> 10.2f}'!   Mit padding character space und links/rechts")
print(f"Ich bin '{user:10s}' aus '{plz:^ 10d}' '{ort:20s}' Temp:'{temp:^ 10.2f}'!   Mit padding character space und links/rechts")
print()

print(f"'{12345.6789:,}'  '{12345:,}'!   Mit , Tausender Trenner")
print(f"'{12345.6789:+}' '{-12345.6789:+}'  '{12345:+}' '{-12345:+}'!   Mit + Vorzeichen zeigt +/- an")
print(f"'{12345.6789:-}'  '{-12345.6789:-}'   '{12345:-}' '{-12345:-}'!   Mit - Vorzeichen zeigt nur - an (Default)")

print()
print('''
# 3.Zahlensysteme (Dezimal, Binär, Octal, Hexadezimal)
# ===================================================''')
a = 5
b = 10
print(f'{a} {b}')
print(f'{a:d} {b:d}')
print(f'{a:b} {b:b}')
print(f'{a:o} {b:o}')
print(f'{a:x} {b:x}')
print(f'{a:X} {b:X}')
print()
print(f'{a:d} {b:d}')
print(f'{a:10b} {b:10b} {b:010b}')
print(f'{a:10o} {b:10o} {b:010o}')
print(f'{a:10x} {b:10x} {b:010x}')
print(f'{a:10X} {b:10X} {b:010X}')

print('''
# 4.Formatierung von Float-Werten
# ===============================''')
pi = 3.141592653589793
formatted_pi = f"Pi auf zwei Dezimalstellen gerundet: {pi:.2f}"
print(formatted_pi)

print(str(pi) + ' --> {pi:5.2f}:' + f'{pi:5.2f}' +':      #5 Stellen für Zahl inkl . und 2 Nachkommastellen' )
print(str(pi) + ' --> {pi:9.4f}:' + f'{pi:9.4f}' +':  #9 Stellen für Zahl inkl . und 4 Nachkommastellen' )
print(str(pi) + ' --> {pi:0.4f}:' + f'{pi:0.4f}' +':  #Der minimal nötige Platz wird genommen' )
print(str(pi) + ' --> {pi:.4e}:' + f'{pi:.4e}' +':  #Exponenten-Darstellung mit 4 Nachkommastellen' )
print(str(pi) + ' --> {pi:.5E}:' + f'{pi:.5E}' +':  #Exponenten-Darstellung mit 5 Nachkommastellen' )
print(str(pi) + ' --> {pi:E}:' + f'{pi:E}' +':  #Exponenten-Darstellung' )
pi = 3.141
print(str(pi) + ' --> {pi:5.2f}:' + f'{pi:5.2f}' +':      #5 Stellen für Zahl inkl . und 2 Nachkommastellen' )
print(str(pi) + ' --> {pi:9.4f}:' + f'{pi:9.4f}' +':  #9 Stellen für Zahl inkl . und 4 Nachkommastellen' )
print(str(pi) + ' --> {pi:9.4%}:' + f'{pi:9.4%}' +':  #Prozent-Darstellung' )

print('''
# 5.Anwendung von Methoden
# ========================''')
name = "max"
formatted_name = f"Dein Name groß geschrieben: {name.upper()}"
print(formatted_name)

print('''
# 6.Mit Containers und Klassen
# ============================''')
# Beispiel mit einer Liste
items = ["Apfel", "Banane", "Kirsche"]
message = f"Heute habe ich {len(items)} verschiedene Früchte gekauft: {', '.join(items)}."
print(message)

# Beispiel mit einer Klasseninstanz
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

person = Person("John", 30)
introduction = f"Hallo, ich heiße {person.name} und bin {person.age} Jahre alt."
print(introduction)

print('''
# 5.Mit Logik
# ===========''')
is_student = True
message = f"Es ist {'wahr' if is_student else 'falsch'}, dass ich ein Student bin."
print(message)

print('''
# 6.None-Type
# ===========''')
value = None
message = f"Der Wert ist {value}."  # None wird als 'None' im String dargestellt
print(message)

print('''
# 37.Einfügen von Ausdrücken
# =========================''')
a = 5
b = 10
result = f"Die Summe von {a} und {b} ist {a + b}."
print(result)


r'''
Numerische Platzhalter

    Integer (Ganzzahl)
        d: Dezimalzahl (Ganzzahl)
        Beispiel: {value:d}

    Float (Gleitkommazahl)
        f: Festkommadarstellung
        .Nf: Gleitkommazahl mit N Dezimalstellen
        Beispiel: {value:.2f} (Rundet auf 2 Dezimalstellen)

    Exponentialdarstellung
        e: Exponentialdarstellung in Kleinbuchstaben (z. B. 1.23e+03)
        E: Exponentialdarstellung in Großbuchstaben (z. B. 1.23E+03)
        Beispiel: {value:e}

    Binärdarstellung
        b: Binärdarstellung (z. B. 1011)
        Beispiel: {value:b}

    Oktaldarstellung
        o: Oktaldarstellung (z. B. 17)
        Beispiel: {value:o}

    Hexadezimaldarstellung
        x: Hexadezimaldarstellung in Kleinbuchstaben (z. B. 1f)
        X: Hexadezimaldarstellung in Großbuchstaben (z. B. 1F)
        Beispiel: {value:x}

    Prozentdarstellung
        %: Prozentdarstellung (z. B. 12.34%)
        Beispiel: {value:.2%} (Gibt den Wert als Prozentsatz aus, mit 2 Dezimalstellen)

Allgemeine Platzhalter

    String (Zeichenkette)
        s: String-Darstellung (Wird standardmäßig verwendet, wenn kein anderer Typ angegeben wird)
        Beispiel: {value:s}

    Repräsentation
        r: Verwendet die repr()-Darstellung des Wertes
        Beispiel: {value!r}

    ASCII-Darstellung
        a: Verwendet die ascii()-Darstellung des Wertes (entspricht repr(), aber mit nicht-ASCII-Zeichen in \x, \u oder \U umgewandelt)
        Beispiel: {value!a}

    Strukturierte Darstellung
        {}: Platzhalter ohne expliziten Formatierungscode; Python verwendet automatisch den entsprechenden Typ und die Darstellung
        Beispiel: {value}

Formatierungsoptionen

    Breite und Ausrichtung
        :<width>: Linksbündig
        >:<width>: Rechtsbündig
        ^:<width>: Zentriert
        Beispiel: {value:<10} (Linksbündig mit einer Breite von 10 Zeichen)

    Füllzeichen
        0: Auffüllen mit Nullen
        Beispiel: {value:05d} (Ganzzahl mit mindestens 5 Stellen, links mit Nullen aufgefüllt)

    Tausendertrennzeichen
        ,: Fügt ein Tausendertrennzeichen hinzu
        Beispiel: {value:,} (z. B. 1,000,000)

    Vorzeichen
        +: Zeigt das Vorzeichen für positive und negative Zahlen an
        -: Zeigt nur das Vorzeichen für negative Zahlen an (Standard)
        : Leerzeichen für positive Zahlen, - für negative Zahlen
        Beispiel: {value:+d} (Zeigt + vor positiven Zahlen)

Diese Platzhalter und Optionen ermöglichen es dir, Ausgaben präzise und leserlich zu formatieren, basierend auf den spezifischen Anforderungen deiner Anwendung.
'''




