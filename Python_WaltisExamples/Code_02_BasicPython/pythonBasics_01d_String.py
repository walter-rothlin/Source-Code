#!/usr/bin/python3

print("\n\n")
print("# String operations")
print("# -----------------")
print("multiLineStr:\n", """\
Usage: thingy [OPTIONS]
     -h                        Display this usage message
     -H hostname               Hostname to connect to
""")


word = 'Python'
print(" " + len(word) * "+---", end='')
print("+")

print(" ", end='')
for aChar in word:
    print("| " + aChar + " ", end='')
print("|")
print(" " + len(word) * "+---", end='')
print("+")

print(" ", end='')
for i in range(0, len(word)):
    print('  ', end='')
    print(i, end=' ')
print("")

print(" ", end='')
for i in range(0, len(word)):
    print(' -', end='')
    print(len(word) - i, end=' ')
print("\n")

print("0       -->" + word[0])  # character in position 0
print("5       -->" + word[5])  # character in position 5
print("-1      -->" + word[-1])  # last character
print("-2      -->" + word[-2])  # second-last character
print("-6      -->" + word[-6])

print("\n")
print(" +---+---+---+---+---+---+")
print(" | P | y | t | h | o | n |")
print(" +---+---+---+---+---+---+")
print("   0   1   2   3   4   5")
print("  -6  -5  -4  -3  -2  -1")
print("")
print("word[0:2]             -->" + word[0:2])  # characters from position 0 (included) to 2 (excluded)
print("word[2:5]             -->" + word[2:5])  # characters from position 2 (included) to 5 (excluded)
print("word[:2] + word[2:]   -->" + word[:2] + word[3:])
print("word[:2]              -->" + word[:2])   # character from the beginning to position 2 (excluded)
print("word[4:]              -->" + word[4:])   # characters from position 4 (included) to the end
print("word[-2:]             -->" + word[-2:])  # characters from the second-last (included) to the end
print("word[:-2]             -->" + word[:-2])  # characters
print("\n")

print("String trimming")
print("---------------")
vorname = "     Walti    "
print("vorname         :", vorname, ":", sep="")
print("vorname.lstrip():", vorname.lstrip(), ":", sep="")
print("vorname.rstrip():", vorname.rstrip(), ":", sep="")
print("vorname.strip() :", vorname.strip(), ":", sep="")
print("\n")

print("Find")
print("----")
s = 'abcd1234dcba'
print(s, "s.find('a')        :", s.find('a'))  # 0
print(s, "s.s.find('cd')     :", s.find('cd'))  # 2
print(s, "s.find('1', 0, 5)  :", s.find('1', 0, 5))  # 4
print(s, "s.find('1', 0, 2)  :", s.find('1', 0, 2))  # -1
print(s, "s.rfind('a')       :", s.rfind('a'))  # 11
print(s, "s.rfind('a', 0, 20):", s.rfind('a', 0, 20))  # 11
print(s, "s.rfind('cd')      :", s.rfind('cd'))  # 2
print(s, "s.rfind('1', 0, 5) :", s.rfind('1', 0, 5))  # 4
print(s, "s.rfind('1', 0, 2) :", s.rfind('1', 0, 2))  # -1
print("\n")

def find_all_indexes(input_str, search_str):
    l1 = []
    length = len(input_str)
    index = 0
    while index < length:
        i = input_str.find(search_str, index)
        if i == -1:
            return l1
        l1.append(i)
        index = i + 1
    return l1


s = 'abaacdaa12aa2'
print("find all  a in:", s, find_all_indexes(s, 'a'))
print("find all aa in:", s, find_all_indexes(s, 'aa'))
print("\n")

print("replace")
print("-------")
aString = "geeks for geeks geeks geeks geeks"
print(aString, ":", aString.replace("geeks", "Geeks"))
print(aString, ":", aString.replace("geeks", "GeeksforGeeks", 3))
print("\n")


print("String splitting")
print("----------------")
csvDaten = "Walti;Rothlin;Peterliwiese 33;8855;Wangen"
print("csvDaten:  ", csvDaten)
splits = csvDaten.split(";")
print("splits  :  ", splits)
print("Type is:", type(splits))
print("\n")

print("String operators")
print("----------------")
anz = 5
str1 = "Walti"
str2 = "Claudia"
print(str1, "+", str2, "+ str(5):", str1 + str2 + str(anz))
print(str1, "* 5               :", str1 * anz)
print("5 *", str1, "              :", anz * str1)
print("\n")

print("RegEx (TBC)")
print("-----")

import re
pattern = "A+"
aString = "Alle meine Entlein"
prog = re.compile(pattern)
result = prog.match(aString)
print(prog, result)

result = re.match(pattern, aString)
print(result)
print("\n")

import sys
print("# commandline-parameter")
print("# ---------------------")
print("arguments: ", sys.argv)
print("Type is:", type(sys.argv))