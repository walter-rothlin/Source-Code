Attribute VB_Name = "OutlookCalender_VBA"
Option Explicit


Sub Excel_Control_Termin_nach_Outlook()
    Dim retVal As String
    
    Dim TblName As String
    Dim rowCount As Integer
    Dim Col_Start As String
    Dim Col_Title As String
    Dim Col_Place As String
    Dim Col_Text As String
    Dim Col_Busy As String
    Dim Col_Duration As String
    Dim Col_Reminder As String
    Dim Col_Category As String
    Dim appoCount As Integer
    
    TblName = Sheets("Set-Up").Range("D9").Value
    rowCount = Sheets("Set-Up").Range("D10").Value
    Col_Start = Sheets("Set-Up").Range("D15").Value
    Col_Title = Sheets("Set-Up").Range("D16").Value
    Col_Place = Sheets("Set-Up").Range("D17").Value
    Col_Text = Sheets("Set-Up").Range("D18").Value
    Col_Busy = Sheets("Set-Up").Range("D19").Value
    Col_Duration = Sheets("Set-Up").Range("D20").Value
    Col_Reminder = Sheets("Set-Up").Range("D21").Value
    Col_Category = Sheets("Set-Up").Range("D22").Value

    
    ' retVal = CreateCalendarEntry("24.12.2019 12:00", "Test from Excel", "Test-Raum", "Hallo dies ist ein Termin von Excel gesetzt!")
    ' retVal = CreateCalendarEntry("24.12.2019 07:00", "Test ohne Alarm", "Test-Raum", "Hallo dies ist ein Termin von Excel gesetzt!")
    ' retVal = CreateCalendarEntry("24.12.2019 07:00", "Test All Day Event", "Test-Raum", "Hallo dies ist ein Termin von Excel gesetzt!")
    ' retVal = CreateCalendarEntry("24.12.2019 07:00", "Test All Day Event", "Test-Raum", 0, 0, "Hallo dies ist ein Termin von Excel gesetzt!")
    '
    ' apptOutApp.Start = Format(ActiveCell.Value, "dd.mm.yyyy") & " " & Format(ActiveCell.Offset(0, 1).Value, "hh:mm") '*****offset für Zeit
    appoCount = 0
    Do Until Sheets(TblName).Range(Col_Title & rowCount).Value = ""
         retVal = CreateCalendarEntry(Sheets(TblName).Range(Col_Start & rowCount).Value, _
                                      Sheets(TblName).Range(Col_Title & rowCount).Value, _
                                      Sheets(TblName).Range(Col_Place & rowCount).Value, _
                                      Sheets(TblName).Range(Col_Text & rowCount).Value, _
                                      Sheets(TblName).Range(Col_Busy & rowCount).Value, _
                                      Sheets(TblName).Range(Col_Duration & rowCount).Value, _
                                      Sheets(TblName).Range(Col_Reminder & rowCount).Value, _
                                      "", _
                                      "", _
                                      "", _
                                      Sheets(TblName).Range(Col_Category & rowCount).Value)
         ' Debug.Print (Sheets(TblName).Range(Col_Title & rowCount).Value)
         rowCount = rowCount + 1
         appoCount = appoCount + 1
    Loop
     
    MsgBox appoCount & " appointment(s) inserted in outlook!"
End Sub

