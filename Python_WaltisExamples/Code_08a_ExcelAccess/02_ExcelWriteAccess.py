
import xlwt

book = xlwt.Workbook(encoding="utf-8")

# Add a sheet to the workbook
sheet1 = book.add_sheet("Python Sheet 1")

# Write to the sheet of the workbook
sheet1.write(r=0, c=0, label="This is the First Cell of the First Sheet with äöü")

# Save the workbook
book.save("TestPythonWriteAccess.xls")