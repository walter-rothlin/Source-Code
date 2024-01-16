#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_01_global_vars.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01_global_vars.py
#
# Description: Examples of GLOBAL variables
#
# Autor: Walter Rothlin
#
# History:
# 16-Jan-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

# Global variable
global_variable = 10
local_var = -70

def modify_global_variable():
    # Use the global keyword to access the global variable
    global global_variable
    global_variable = 20

    local_var = 3.14      # neue Variable
    print('local_var:', local_var)

    print(globals())
    if 'persistent_variable' not in globals():
        # If not, initialize it
        global persistent_variable
        persistent_variable = 0

    # Use the variable in your function
    persistent_variable += 1
    print("Persistent Variable:", persistent_variable)


def main():
    # global variables
    print("Global variable:", global_variable)
    modify_global_variable()
    print("Modified global variable:", global_variable)

    modify_global_variable()
    print('local_var:', local_var)

if __name__ == "__main__":
    main()
