import unittest

from Shifter_A import shiftChr_simple, shiftChr, encrypt


class TestShifterFunctions(unittest.TestCase):

    def test_shiftChr_simple(self):
        self.assertEqual(shiftChr_simple('a', 1), 'b')
        self.assertEqual(shiftChr_simple('z', 1), 'a')
        self.assertEqual(shiftChr_simple('A', 2), 'C')
        self.assertEqual(shiftChr_simple(' ', 5), '%')

    def test_shiftChr(self):
        self.assertEqual(shiftChr('a', 1), 'b')
        self.assertEqual(shiftChr('z', 1), 'a')
        self.assertEqual(shiftChr('A', 2), 'C')
        self.assertEqual(shiftChr(' ', 5), '%')
        self.assertEqual(shiftChr('~', 1), ' ')

    def test_encrypt(self):
        self.assertEqual(encrypt('abc', 'a'), 'bcd')
        self.assertEqual(encrypt('abc', 'b'), 'cde')
        self.assertEqual(encrypt('xyz', 'a'), 'yza')
        self.assertEqual(encrypt('xyz', 'b'), 'zab')


if __name__ == '__main__':
    unittest.main()