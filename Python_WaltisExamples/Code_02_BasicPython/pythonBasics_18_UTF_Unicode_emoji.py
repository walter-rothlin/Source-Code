# ------------------------------------------------------------------
# Name: pythonBasics_18_UTF_Unicode_emoji.py
#
# Description: Example to work with Hex, Bin, Oct and Dezimals
# UTF-8: https://realpython.com/python-encodings-guide/
#
# Autor: Walter Rothlin
#
# History:
# 29-Dec-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import emoji

whitespace = ' \t\n\r\v\f'
ascii_lowercase = 'abcdefghijklmnopqrstuvwxyz'
ascii_uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
greek_alphabet  = 'αβγδεζηθικλμνξοπρςστυφχψ'
ascii_letters = ascii_lowercase + ascii_uppercase
digits = '0123456789'
hexdigits = digits + 'abcdef' + 'ABCDEF'
octdigits = '01234567'
punctuation = r"""!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~"""
printable = digits + ascii_letters + punctuation + whitespace

print()
print("    0 to     127 	\\u0000     to \\u007F      U.S. ASCII                                      :", "A \\n 7 &")
print("  128 to    2047 	\\u0080     to \\u07FF 	    Most Latinic alphabets                          :", "ę ± ƌ ñ")
print(" 2048 to   65535 	\\u0800     to \\uFFFF      Additional parts of the multilingual plane (BMP):", "ത ᄇ ᮈ ‰")
print("65536 to 1114111 	\\U00010000 to \\U0010FFFF  Other                                           :", "𝕂 𐀀 😓 🂲")
print("Spezial-Zeichen: 📌 🌡️ 🌪 ⛅ ☁ 🌞 📅 α β γ δ")
print("Emoji:", '\u1F642')
print("greek_alphabet :", greek_alphabet)

print()
def make_bitseq(s: str) -> str:
   if not s.isascii():
        raise ValueError("ASCII only allowed")
   return " ".join(f"{ord(i):08b}b" for i in s)

def make_hexseq(s: str) -> str:
   if not s.isascii():
        raise ValueError("ASCII only allowed")
   return " ".join(f"{ord(i):02x}x" for i in s)

print('make_bitseq("bits")   -->', make_bitseq("bits"))
'01100010 01101001 01110100 01110011'
print('make_hexseq("bits")   -->', make_hexseq("bits"))
'62x 69x 74x 73x'

print('make_bitseq("CAPS")   -->', make_bitseq("CAPS"))
'01000011 01000001 01010000 01010011'

print('make_bitseq("$25.43") -->', make_bitseq("CAPS"))
'00100100 00110010 00110101 00101110 00110100 00110011'

print('make_bitseq("~5")     -->', make_bitseq("~5"))
'01111110 00110101'
print()
print("int base")
print("int('11')         :", int('11'))
print("int('11', base=10):", int('11', base=10))  # 10 is already default
print("int('11', base=2) :", int('11', base=2))  # Binary
print("int('11', base=3) :", int('11', base=3))  # Binary
print("int('11', base=8) :", int('11', base=8))  # Octal
print("int('11', base=16):", int('11', base=16))  # Hex
print()

print("UTF-8")
print('"résumé".encode("utf-8") :', "résumé".encode("utf-8"))
# b'r\xc3\xa9sum\xc3\xa9'
print('"El Niño".encode("utf-8"):', "El Niño".encode("utf-8"))
# b'El Ni\xc3\xb1o'

print('b"r\\xc3\\xa9sum\\xc3\\xa9".decode("utf-8"):', b"r\xc3\xa9sum\xc3\xa9".decode("utf-8"))
# 'résumé'
print('b"El Ni\\xc3\\xb1o".decode("utf-8")      :', b"El Ni\xc3\xb1o".decode("utf-8"))
# 'El Niño'
print("b'\\xf0\\x9f\\x98\\x93 :'", b'\xf0\x9f\x98\x93'.decode("utf-8"))

print()
print('Encoding 	Bytes Per Character (Inclusive) 	Variable Length')
print('UTF-8 	    1 to 4 	                             Yes')
print('UTF-16 	    2 to 4 	                             Yes')
print('UTF-32 	    4 	                                  No')
print()

print("Emojis")
print("      https://unicode-table.com/de/emoji/smileys-and-emotion/")
print("      https://unicode.org/emoji/charts/emoji-list.html")
print('"😓".encode("utf-8") :', "😓".encode("utf-8"))
print('\\U0001F600:', '\U0001F600 😀, \U0001F610 😐, \U0001F563 🕣, \U0001F326 🌦, \U0001F9ED 🧭, \U0001F30E 🌎')



print(emoji.emojize('Python :thumbs_up:'))
