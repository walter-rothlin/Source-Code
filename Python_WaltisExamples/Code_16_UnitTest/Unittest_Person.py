# Definiert Unit Tests zu der Klasse Person
#
# Author: Mike Keller
#
# History:
# 19.10.2021 Initial Version
# ----------------------------------------------------------------------------------------------------------------------

import unittest

from Person import Person


class TestPerson(unittest.TestCase):
    def setUp(self):
        self.person = Person("Keller", "Mike")

class TestInit(TestPerson):
    def test_InitName(self):
        self.assertEqual(self.person.name, "Keller")

    def test_InitFirstName(self):
        self.assertEqual(self.person.firstName, "Mike")

class TestSetter(TestPerson):
    def test_ChangeName(self):
        self.person.name = "Muster"
        self.assertEqual(self.person.name, "Muster")

    def test_ChangeFirstName(self):
        self.person.firstName = "Max"
        self.assertEqual(self.person.firstName, "Max")

class TestToString(TestPerson):
    def test_ToStringNotNone(self):
        self.assertIsNotNone(str(self.person))

    def test_ToStringValueComparison(self):
        multiLineString = """Eine Person
Nachname: Keller
Vorname: Mike\n"""
        self.assertMultiLineEqual(str(self.person), multiLineString)