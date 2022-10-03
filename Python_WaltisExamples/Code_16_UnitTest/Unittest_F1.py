# Definiert Unit Tests zu der Klasse F1
#
# Author: Mike Keller
#
# History:
# 19.10.2021 Initial Version
# ----------------------------------------------------------------------------------------------------------------------

import unittest

from F1 import F1

class TestF1(unittest.TestCase):
    def setUp(self):
        self.f1 = F1()

class TestInit(TestF1):
    def test_InitHeckfluegel(self):
        self.assertEqual(self.f1.heckFluegelType, "mittel")

    def test_Marke(self):
        self.assertEqual(self.f1.marke, "Mercedes")

    def test_InitFarbe(self):
        self.assertEqual(self.f1.farbe, "Schwarz")

    def test_InitPreviousOwner(self):
        self.assertEqual(self.f1.previousOwner.__name, "Hamilton")

    def test_InitPreviousOwnerFirstName(self):
        self.assertEqual(self.f1.previousOwner.firstName, "Lewis")

class TestSetMarke(TestF1):
    def test_SetMarkeCorrectly(self):
        self.f1.setMarke("Red Bull")
        self.assertEqual(self.f1.marke, "Red Bull")

class TestToString(TestF1):
    def test_ToStringNotNone(self):
        self.assertIsNotNone(str(self.f1))

    def test_ToStringValueComparison(self):
        multiLineString= """Ein Car
Marke: Mercedes
Farbe: Schwarz
Leistung: 560
Kilometerstand: 10
Vorheriger Besitzer: Eine Person
Nachname: Hamilton
Vorname: Lewis

HeckFlügel: mittel\n"""
        self.assertMultiLineEqual(str(self.f1), multiLineString)