#!/usr/bin/python3

testFunctionExecuted=False

def testFunction():
    testFunctionExecuted=True
    return True;

if (True or testFunction()):
    if (testFunctionExecuted):
        print("Test Function executed: working like Java '|' and '&'")
    else:
        print("Test Function not executed: working like Java '||' and '&&'")