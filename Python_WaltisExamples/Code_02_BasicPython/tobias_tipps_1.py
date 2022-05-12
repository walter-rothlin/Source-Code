#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : tobias_tipps_1.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/tobias_tipps_1.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

#Abstraktionen / Comprehensions

a = [1,3,4,5,6,7,8]
b = [3,4,5,12,33]
#Sortierte Liste mit schnittmengen der elementen

my_list =[("tobias", 14), ("walti",234)]

dic = {person[0] : person[1] for person in my_list}

l = [name + "is" + str(age) for name,age in dic.items()]

print(l)

def schnittmenge(a, b):
    return sorted([number for number in a if number in b])

print(schnittmenge(a,b))

#Tupel unpacking
def random():
    return [1,3,4]

a,b,c = random()

print(a,b,c, sep="|")

#https://www.geeksforgeeks.org/args-kwargs-python/
def func(*args,**kwargs):
    print(args)
    print(kwargs)


func("A","B", 3, 4.5, hello= "Hi", one= 1)
a = "hello"
b = 3.423423
print(f"hasdfasdf{a:} number {b:10.2f}")

numbers = [5,7,2,-6,-7]

def add_1(a,b):
    return a + b

print(add_1(1,2))

add_2 = lambda a,b : a+b
print(add_2(1,2))

i = 2
m = -2

print(f"{i:+3d}x\u00b2{m:+3d}x")
print(f"{i:-3d}x\u00b2{m:-3d}x")
print(f"{i:3d}x\u00b2{m:3d}x")
print(f"{i:d}x\u00b2{m:d}x")


