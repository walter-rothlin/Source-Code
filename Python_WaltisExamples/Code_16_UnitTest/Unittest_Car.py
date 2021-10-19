# Unit Tests zu der Klasse Car
#
# Author: Mike Keller
#
# History:
# 19.10.2021 Initial Version
# ----------------------------------------------------------------------------------------------------------------------

import unittest

from Car import Car


class TestCar(unittest.TestCase):
      def setUp(self):
          self.car = Car()


class TestInit(TestCar):
    def test_InitMarke(self):
        self.assertEqual(self.car.marke, "Ford")

    def test_InitFarbe(self):
        self.assertEqual(self.car.farbe, "Blau")

    def test_InitLeistung(self):
        self.assertEqual(self.car.leistung, 560)

    def test_InitPreviousOwner(self):
        self.assertIsNone(self.car.previousOwner)

    def test_InitKmStand(self):
        self.assertEqual(self.car.kmStand, 10)

class TestKmStand(TestCar):
    def test_ValidKmUpdate(self):
        self.car.kmStand = 33
        self.assertEqual(self.car.kmStand, 33)

    def test_InvalidKmUpdate(self):
        with self.assertRaises(ValueError):
            self.car.kmStand = 10

class TestToString(TestCar):
    def test_ToStringNotNone(self):
        self.assertIsNotNone(str(self.car))

    def test_ToStringValueComparison(self):
        multiLineString = """Ein Car
Marke: Ford
Farbe: Blau
Leistung: 560
Kilometerstand: 10
Vorheriger Besitzer: None\n"""
        self.assertMultiLineEqual(str(self.car), multiLineString)


