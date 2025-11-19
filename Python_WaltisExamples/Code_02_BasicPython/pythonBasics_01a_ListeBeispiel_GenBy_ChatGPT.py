#!/usr/bin/python

# ------------------------------------------------------------------
# Name  : pythonBasics_01a_ListeBeispiel_GenBy_ChatGPT.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01a_ListeBeispiel_GenBy_ChatGPT.py
#
# Description: Introduction to Lists
#
# List is a collection which is ordered and changeable. Allows duplicate members.
# Tuple is a collection which is ordered and unchangeable. Allows duplicate members.
# Set is a collection which is unordered and unindexed. No duplicate members.
# Dictionary is a collection which is unordered and changeable. No duplicate members.
#
# Autor: Walter Rothlin
#
# History:
# 19-Nov-2025   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------

# Listen in Python
numbers = [1, 2, 3, 4, 5]

# Zugriff auf Liste
# =================
print(f"Die Liste der Zahlen lautet:{numbers}   Anzahl Elemente:{len(numbers)}")

# via Index: start = 0; bei negativen Indexen wird vom Ende her gegangen -1 letztes Element
print(f"Erstes Element:{numbers[0]}    Letztes Element:{numbers[-1]}  Letztes Element:{numbers[len(numbers) - 1]}")

# via Ranges
print(f"numbers[1:3]  :{numbers[1:3]}")
print(f"numbers[1:]   :{numbers[1:]}")
print(f"numbers[1:-2] :{numbers[1:-2]}")
print(f"numbers[-4:-2]:{numbers[-4:-2]}")

# Liste verändern
# ===============
numbers[2] = 10
print(f"numbers[2] = 10            ==> Liste:{numbers}   Anzahl Elemente:{len(numbers)}")

# Hinzufügen eines Elements am Ende der Liste
numbers.append(6)
print(f"numbers.append(6)          ==> Liste:{numbers}   Anzahl Elemente:{len(numbers)}")

# Hinzufügen eines Elements an einer bestimmten Position in der Liste
numbers.insert(2, 7)
print(f"numbers.insert(2, 7)       ==> Liste:{numbers}   Anzahl Elemente:{len(numbers)}")

# Entfernen eines Elements aus der Liste
numbers.remove(4)
print(f"numbers.remove(4)          ==> Liste:{numbers}   Anzahl Elemente:{len(numbers)}")

# Method	    Description
# -------------------------
# append()	    Adds an element at the end of the list
# clear()	    Removes all the elements from the list
# copy()	    Returns a copy of the list
# count()	    Returns the number of elements with the specified value
# extend()	    Add the elements of a list (or any iterable), to the end of the current list
# index()	    Returns the index of the first element with the specified value
# insert()	    Adds an element at the specified position
# pop()	        Removes the element at the specified position
# remove()	    Removes the first item with the specified value
# reverse()	    Reverses the order of the list
# sort()	    Sorts the list

# Sortieren der Liste in aufsteigender Reihenfolge
numbers.sort()
print(f"numbers.sort()             ==> Liste:{numbers}   Anzahl Elemente:{len(numbers)}")

# Sortieren der Liste in absteigender Reihenfolge
numbers.sort(reverse=True)
print(f"numbers.sort(reverse=True)  ==> Liste:{numbers}   Anzahl Elemente:{len(numbers)}")

# Durch Liste iterieren
# =====================
for a_number in numbers:
    if a_number % 2 == 0:
        print(f"a_number:{a_number}  Quadrat:{a_number ** 2}")

# mittels Comprehension
result = [f"a_number:{n}  Quadrat:{n ** 2}" for n in numbers if n % 2 == 0]
print(result)
for a_result in result:
    print(a_result)

[print(f"a_number:{n}  Quadrat:{n ** 2}") for n in numbers if n % 2 == 0]

print('\n\n')
a_number = 4711
eine_wilde_liste = [23,
                    3.1415,
                    [True, False],
                    'HFU', (f'{a_number}', a_number), ]
print(eine_wilde_liste[2][-1])

for a_element in eine_wilde_liste:
    print(a_element, type(a_element))

# Tuples (unveränderbare List)
a_tuples = (6, 9, 12)
print(a_tuples[-1])
# a_tuples.append(15) # führt zu einem Error!!
print(a_tuples[-1])

# Dictonary
capitols = {
    "Schweiz": "Bern",
    "Deutschland": "Berlin",
    "PLZ": 8855,
    "pi": 3.1415926,
    "Kantone": ['SZ', 'ZH'],
    "KantHauptorte": {'SZ': 'Schwyz', 'ZH': 'Zürich'}
}

print(f'{capitols}    Schweiz:{capitols["Schweiz"]}  Anz:{len(capitols)}')

capitols['Oestereich'] = "Wien"
capitols['Schweiz'] = "Uster"
print(f'{capitols}    Schweiz:{capitols["Schweiz"]}  Anz:{len(capitols)}')

print(capitols["KantHauptorte"]['ZH'])
for a_kanton in capitols["Kantone"]:
    print(a_kanton, capitols["KantHauptorte"][a_kanton])