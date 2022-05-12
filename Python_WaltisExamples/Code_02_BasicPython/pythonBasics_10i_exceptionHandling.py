#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_10i_exceptionHandling.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_10i_exceptionHandling.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import sys

# Erros an exception-Handling: https://docs.python.org/3/tutorial/errors.html
# try : https://docs.python.org/3/reference/compound_stmts.html#finally


# Raising an exception
# --------------------
x = "hello"
# via assert: if condition returns True, then nothing happens:
assert x == "hello"
assert x == "hello", "You have entred not 'hello'"   # this will be passed to the Ctr of the exception


# via raise: calls Ctr from an exception and string
x = 5555
if not type(x) is int:
    ## pass # NOP
    raise TypeError("Only integers are allowed")
else:
    print(x, "is an int!!!")



# Except an exception
# -------------------

x = "hello"
# assert: if returns False, AssertionError is raised with text:
try:
    assert x == "hello", "all fine! Not really an error!"
    assert x != "goodbye", "You have entred not 'hello'"
    assert x != "BZU Uster", "You have entred not 'hello'"
except AssertionError as error:
    print("Error happend! ", error)
    print("Error details: ", sys.exc_info())
else:
    print('else: executed if no error happens')
finally:
    print('finally: executed in any cases')

# Chaining an exception
# ---------------------
# def func():
#     raise IOError

# try:
#     func()
# except IOError as exc:
#     raise RuntimeError('Failed to open database') from exc



# User defined exceptions
class Error(Exception):
    """Base class for exceptions in this module."""
    pass

class InputError(Error):
    """Exception raised for errors in the input.

    Attributes:
        expression -- input expression in which the error occurred
        message -- explanation of the error
    """

    def __init__(self, expression, message):
        self.expression = expression
        self.message = message

class TransitionError(Error):
    """Raised when an operation attempts a state transition that's not
    allowed.

    Attributes:
        previous -- state at beginning of transition
        next -- attempted new state
        message -- explanation of why the specific transition is not allowed
    """

    def __init__(self, previous, next, message):
        self.previous = previous
        self.next = next
        self.message = message

    def __str__(self):
        return "TransitionError: " + self.previous + " " + str(self.next) + " '" + self.message + "'"


def func():
    raise TransitionError("Old value", 55, "Next value")

if __name__ == '__main__':
    try:
        func()
    except TransitionError as transError:
        print(transError)
