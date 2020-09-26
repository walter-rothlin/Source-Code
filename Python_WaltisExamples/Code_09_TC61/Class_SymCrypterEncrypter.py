#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_SymCrypterEncrypter.py
#
# Description: Symetrische en- / decryption
#
#
# Autor: Walter Rothlin
#
# History:
# 28-Apr-2020	Initial Version
#
# ------------------------------------------------------------------
import math

class SymCrypterEncrypter:

   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, key):
      self.key = key

   # Methoden (setter / getter)
   # --------------------------
   def setKey(self, key):
      self.key = key
      return self.key

   def shiftChr(self,aChar,shift):
      return chr(((ord(aChar) - ord(' ') + shift) % (ord('~') - ord(' ') + 1)) + ord(' '))
      # return chr(ord(aChar) + shift)

   def encrypt(self,klartext):
      keyIndex = 0
      geheimtext = ""
      for aChar in klartext:
         if (aChar >= "") and (aChar <= "~"):
            aKeyChr = self.key[keyIndex]
            shifter = ord(aKeyChr)
            aSecretChr = self.shiftChr(aChar, shifter)
            # print(aChar, " (Rigth-Shift: ord(", aKeyChr, ") ", shifter, ") --> ", aSecretChr, sep="")
            keyIndex = keyIndex + 1
            if (keyIndex >= len(self.key)):
               keyIndex = 0
            geheimtext = geheimtext + aSecretChr
      return geheimtext

   def decrypt(self,geheimtext):
      keyIndex = 0
      encryptedtext = ""
      for aChar in geheimtext:
         if (aChar >= "") and (aChar <= "~"):
            aKeyChr = self.key[keyIndex]
            shifter = ord(aKeyChr)
            decryptedChar = self.shiftChr(aChar, -shifter)
            # print(aChar, " (Left-Shift:        ", -shifter, ") --> ", decryptedChar, sep="", end="\n\n")
            keyIndex = keyIndex + 1
            if (keyIndex >= len(self.key)):
               keyIndex = 0
            encryptedtext = encryptedtext + decryptedChar
      return encryptedtext

   def generateAsciiList(self, lowChar = ' ', highChar = '~'):
      asciiList = []
      for aCharId in range(ord(lowChar), ord(highChar) + 1):
         asciiList.append(chr(aCharId))
      return asciiList

   def TEST_EinzelZeichen(self):
      TC61 = SymCrypterEncrypter("")

      print("Einzelzeichen Test")
      print("==================")
      shiftList     = ['1', '2', '3']
      wichtigeAscii = [' ', '0', '9', 'A', 'Z', 'a', 'z']
      shiftList = TC61.generateAsciiList()
      wichtigeAscii = TC61.generateAsciiList()

      testCount = 0
      testErrorCount = 0

      for shiftChar in shiftList:
         shift = ord(shiftChar)
         for klarChar in wichtigeAscii:
            testCount = testCount + 1
            geheimChr = TC61.shiftChr(klarChar, shift)
            encryptedChr = TC61.shiftChr(geheimChr, -shift)
            doTrace = True
            if ((klarChar != encryptedChr) or (doTrace)):
               testIsOk = "OK"
               if (klarChar != encryptedChr):
                  testIsOk = "NOK"
                  testErrorCount = testErrorCount + 1
               print("==> shift: {s:3d} ('{sc:1s}'):          '{k:1s}' ({ok:3d}) --> '{g:1s}' ({og:3d}) --> '{e:1s}' ({oe:3d})  ==> {t:3s}".format(s=shift, sc=chr(shift), k=klarChar, ok=ord(klarChar), g=geheimChr, og=ord(geheimChr), e=encryptedChr, oe=ord(encryptedChr), t=testIsOk), sep="")

      print("Test-Statistik: ", testCount, "Test-Cases  ", testErrorCount, "Errors")
      print("\n\n")

   def TEST_Strings(self):
      secretKey = "123456"
      klarText = "WWalter Rothlin"

      TC61 = SymCrypterEncrypter(secretKey)
      print("Text Test")
      print("=========")
      testCount = 0
      testErrorCount = 0

      geheimText = TC61.encrypt(klarText)
      encryptedText = TC61.decrypt(geheimText)
      doTrace = True
      if ((klarText != encryptedText) or (doTrace)):
         testIsOk = "OK"
         if (klarText != encryptedText):
            testIsOk = "NOK"
            testErrorCount = testErrorCount + 1
      print(klarText, "-->", geheimText, "-->", encryptedText, "    ", testIsOk)
      print("\n\n")

   def TEST_Stringshintertuer(self):
      hintertorKey = "P19"
      secretKey = "123456"
      klarText = "WWalter Rothlin"

      TC61 = SymCrypterEncrypter(secretKey)
      print("Text Test Hintertür")
      print("===================")
      testCount = 0
      testErrorCount = 0
      TC61_Sender = SymCrypterEncrypter(secretKey)
      TC61_Hintertuer = SymCrypterEncrypter(hintertorKey)
      keyCrypted = TC61_Hintertuer.encrypt(secretKey)
      geheimText = keyCrypted + ":" + TC61.encrypt(klarText)

      parts = geheimText.split(':')
      usedGeheimKey = TC61_Hintertuer.decrypt(parts[0])
      print(parts[0], ":", usedGeheimKey, parts[1])
      TC61_Receiver = SymCrypterEncrypter(usedGeheimKey)
      encryptedText = TC61_Receiver.decrypt(parts[1])

      doTrace = True
      if ((klarText != encryptedText) or (doTrace)):
         testIsOk = "OK"
         if (klarText != encryptedText):
            testIsOk = "NOK"
            testErrorCount = testErrorCount + 1
      print(klarText, "-->", geheimText, "-->", encryptedText, "    ", testIsOk)
      print("\n\n")

# Tester = SymCrypterEncrypter("")
# Tester.TEST_EinzelZeichen()
# Tester.TEST_Strings()
# Tester.TEST_Stringshintertuer()