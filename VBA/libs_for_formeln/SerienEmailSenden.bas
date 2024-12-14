Attribute VB_Name = "SerienEmailSenden"
Public Const FixedValueStr As String = "FixedValue"

Sub SendEmailsForList()
    Dim tmpVar As String
    Dim setUpShName As String
    setUpShName = "SerienEmail"
    
    Dim z_emailColName As String
    Dim z_MsgTemplate As String
    Dim z_subjectColName As String
    Dim z_sendConditionColName As String
    Dim z_valSendConditionColName As String
    Dim z_ccColName As String
    Dim z_bccColName As String
    Dim z_fromEmailColName As String
    Dim z_receiptColName As String
    Dim z_attachmentColName As String
    Dim z_importanceColName As String

    z_emailColName = Sheets(setUpShName).Range("C9").Value
    z_MsgTemplate = Sheets(setUpShName).Range("C10").Value
    z_subjectColName = Sheets(setUpShName).Range("C11").Value
    z_sendConditionColName = Sheets(setUpShName).Range("C12").Value
    z_valSendConditionColName = Sheets(setUpShName).Range("D12").Value
    z_ccColName = Sheets(setUpShName).Range("C13").Value
    z_bccColName = Sheets(setUpShName).Range("C14").Value
    z_fromEmailColName = Sheets(setUpShName).Range("C15").Value
    z_receiptColName = Sheets(setUpShName).Range("C16").Value
    z_attachmentColName = Sheets(setUpShName).Range("C17").Value
    z_importanceColName = Sheets(setUpShName).Range("C18").Value
    
    tmpVar = sendSerienMail(z_emailColName, z_MsgTemplate, z_subjectColName, z_sendConditionColName, z_valSendConditionColName, z_ccColName, z_bccColName, z_fromEmailColName, z_receiptColName, z_attachmentColName, z_importanceColName)
    If (tmpVar <> "") Then
        MsgBox tmpVar, vbOKOnly, "Send Email Error"
    End If
End Sub
