Attribute VB_Name = "Testform_1_Library"
Sub showTestForm_1()
   TestForm_1.TextBox1.Text = Sheets("Eigene Formulare").Range("B12").Value
   TestForm_1.Show
End Sub


Sub showWebPage()
   Sheets("Web-Browser").WebBrowser1.Navigate Sheets("Web-Browser").Range("C4").Value
   ' Sheets("Web-Browser").WebBrowser1.Height = 235
   ' Sheets("Web-Browser").WebBrowser1.Width = 395
End Sub
