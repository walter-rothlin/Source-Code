#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_01a_Lists.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01a_Lists.py
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
# 30-Dec-2021   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------

# Listen in Python
nameListe = ['Walti',
             "Felix",
             "Hans",
             'Lukas']
print(nameListe)
print(nameListe[1], len(nameListe))
for aName in nameListe:
    print("aName:", aName[0:3], aName[-1], aName[-3:], len(aName))




myAdressList   = nameListe          # 2. object reference
myAdressList_1 = nameListe.copy()   # clone

nameListe.sort()
print("\n", nameListe, "\n", myAdressList, "\n", myAdressList_1)

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


print("# List operations")
print("# ---------------")
squares = ["1", "4", "9", "16", "25"]
print("squares:", squares)
print("squares[0]      -->", squares[0])      # indexing returns the item:       1
print("squares[-1]     -->", squares[-1])     # indexing returns the last item: 25
print("squares[2:4]    -->", squares[2:4])    # slicing returns a new list [9, 16]
print("squares[2:]     -->", squares[2:])     # slicing returns a new list [9, 16, 25]
print("squares[:4]     -->", squares[:4])     # slicing returns a new list [1, 4, 9, 16]
print("squares[-3:]    -->", squares[-3:])    # slicing returns a new list [9, 16, 25]
print("squares[:-3]    -->", squares[:-3])    # slicing returns a new list [1, 4]
moreSquares = [36, 49, 64, 81, 100]
print("moreSquares     :", moreSquares)
squares = squares + moreSquares    # extend list
print("extended squares:", squares)
if (49 in squares):
    print("49 ist eine Quadratzahl!")
if (not (50 in squares)):
    print("50 ist keine Quadratzahl!")

squares_1 = squares.copy()
print("squares_1          -->", squares_1)
##  squares_1[3:5] = 99    # geht nicht! ERROR: TypeError: can only assign an iterable
squares_1.clear()
print("squares_1.clear()  -->", squares_1)
squares_1 = squares.copy()
del squares_1     # variable existiert nicht mehr
print("\n")


cubes = [1, 8, 27, 65, 125]  # something's wrong here
print("cubes                                  -->", cubes)
cubes[3] = 64                # replace the wrong value
print("cubes[3] = 64                          -->", cubes)

print("cubes.append(216) cubes.append(7 ** 3) --> ", end='')
cubes.append(216)     # add the cube of 6
cubes.append(7 ** 3)  # and the cube of 7
print(cubes)
print("\n")

letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
print("letters                             --> ", letters)      # ['a', 'b', 'c', 'd', 'e', 'f', 'g']

# replace some values
letters[2:5] = ['C', 'D', 'E', 'X']
print("letters[2:5] = ['C', 'D', 'E', 'X'] --> ", letters)      # ['a', 'b', 'C', 'D', 'E', 'f', 'g']

# now remove them
letters[2:5] = []
print("letters[2:5] = []                   --> ", letters)      # ['a', 'b', 'f', 'g']

# clear the list by replacing all the elements with an empty list
letters[:] = []
print("letters[:] = []                     --> ", letters)      # []
print("\n")


print("# Multidimensional lists")
print("# ----------------------")
a = ['a', 'b', 'c']
b = ['A', 'B']
n = [1, 2, 3]
x = [a, b, n]
print("x       :", x)         # [['a', 'b', 'c'], ['A', 'B'], [1, 2, 3]]
print("x[0]    :", x[0])      # ['a', 'b', 'c']
print("x[0][1] :", x[0][1])   # 'b'
print("\n")

cars = [["Ford", 12, 1960], ["Volvo", 13], ["BMW", 15]]
print("Whole List   :", cars)
print("1st car      :", cars[0])
print("1st car's Nr :", cars[0][1])
print("2nd car      :", cars[1])
print("2nd car's Nr :", cars[1][1])
print("Count of elemets in 1st car: ", len(cars[0]))
print("Count of elemets in 2nd car: ", len(cars[1]))
print("Count of cars:", len(cars))

print("Show all cars using for - in ")
for x in cars:
    print("    Car:", x)
print("Count:", len(cars))

print("Show all cars using for - in - range")
for i in range(len(cars)):
    print("    Car:", cars[i])

print("\nAdded new car...")
cars.append(["Honda", 77, 1960])

for x in cars:
    print("    Car:", x)
print("Count:", len(cars))

cars.pop(1)
print("Whole List (after remove first)  :", cars)


autos = ["Ford", "BMW", "Volvo", "BMW"]
print("Whole List (as it is)         :", autos)

autos.sort()
print("Whole List (sorted)           :", autos)

autos.reverse()
print("Whole List (reversed sorted)  :", autos)

neueAutos = autos[1:3]
print("Neue Autos [1:3]:", neueAutos)

print("Anzahl BMWs:", autos.count("BMW"))
print("Erster BMW :", autos.index("BMW"))
