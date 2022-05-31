import unittest
from passwordValidierer import *

class HowManyDigitsAreInString(unittest.TestCase):
    def test_howManyDigitsAreInString_Classic(self):
        self.assertEqual(howManyDigitsAreInString_Classic("01Walti9"), 3)
        self.assertEqual(howManyDigitsAreInString_Classic("123456"), 6)
        self.assertEqual(howManyDigitsAreInString_Classic("Walti"), 0)

    def test_howManyDigitsAreInString_WithComprehension(self):
        self.assertEqual(howManyDigitsAreInString_WithComprehension("01Walti9"), 3)
        self.assertEqual(howManyDigitsAreInString_WithComprehension("123456"), 6)
        self.assertEqual(howManyDigitsAreInString_WithComprehension("Walti"), 0)

    def test_howManyDigitsAreInString_WithRegEx(self):
        self.assertEqual(howManyDigitsAreInString_WithRegEx("01Walti9"), 3)
        self.assertEqual(howManyDigitsAreInString_WithRegEx("123456"), 6)
        self.assertEqual(howManyDigitsAreInString_WithRegEx("Walti"), 0)

if __name__ == '__main__':
    unittest.main()
