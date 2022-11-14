# ---------------------------------------
# Walter Rothlin
# ---------------------------------------


def ascii_shifter(buchstabeP, shifterP):
    return chr(ord(buchstabeP) + shifterP)

print("Hello", 'BZU', "!!!!??????")

eineZahl = 123.45    # float (rationale Zahlen)
anzahl = 12          # int (Ganze Zahl)
wasBinIch = 12.0     # float

vorname = "Walti"
nachname = "Rothlin"

print(vorname + ' ' + nachname)

print(eineZahl, eineZahl * 10)

buchstabe = 'A'
shifter = 5

print(buchstabe, ord(buchstabe), hex(ord(buchstabe)), oct(ord(buchstabe)), bin(ord(buchstabe)))


print(buchstabe, "(", shifter, ")   ==>", chr(ord(buchstabe) + shifter))

buchstabe = '*'
shifter = 9
print(buchstabe, "(", shifter, ")   ==>", chr(ord(buchstabe) + shifter))


print(buchstabe, "(", shifter, ") ==> ", ascii_shifter(buchstabe, shifter))
print('A', "(", 5, ") ==> ", ascii_shifter('A', 5))

test1_chr = "3"
test1_shifter = 4
test1_expected = "7"
print("ascii_shifter(" + test1_chr + ", " + str(test1_shifter) + ") = ", ascii_shifter(test1_chr, test1_shifter), "   Expected: " + test1_expected)

test1_chr = "A"
test1_shifter = 5
test1_expected = "F"
print("ascii_shifter(" + test1_chr + ", " + str(test1_shifter) + ") = ", ascii_shifter(test1_chr, test1_shifter), "   Expected: " + test1_expected)