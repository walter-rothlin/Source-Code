#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_07_Classes_Objects.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_07_Classes_Objects.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

class Employee:
   empCount = 0

   def __init__(self, name, salary):
      self.name = name
      self.salary = salary
      Employee.empCount += 1
   
   def displayCount(self):
     print("Total Employee {c:4d}".format(c=Employee.empCount))

   def displayEmployee(self):
      print("Name : ", self.name,  ", Salary: ", self.salary)

if __name__ == '__main__':
   "This would create first object of Employee class"
   emp1 = Employee("Zara", 2000)
   "This would create second object of Employee class"
   emp2 = Employee("Manni", 5000)
   emp1.displayEmployee()
   emp2.displayEmployee()
   print("Total Employee {c:4d}".format(c=Employee.empCount))
