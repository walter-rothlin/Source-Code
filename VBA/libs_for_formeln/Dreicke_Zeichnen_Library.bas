Attribute VB_Name = "Dreicke_Zeichnen_Library"
Sub Deieck_Zeichnen_3S()
Attribute Deieck_Zeichnen_3S.VB_Description = "Macro recorded 16.11.2009 by Rothlin Walter (KSTC 3)"
Attribute Deieck_Zeichnen_3S.VB_ProcData.VB_Invoke_Func = " \n14"
    Range("S7").Select
    ActiveCell.FormulaR1C1 = "=R[14]C[-12]"
    Range("S8").Select
    ActiveCell.FormulaR1C1 = "=R[14]C[-12]"
    Range("S9").Select
    ActiveCell.FormulaR1C1 = "=R[14]C[-7]"
    Range("S10").Select
End Sub

Sub Deieck_Zeichnen_2S_1W_a()
    Range("S7").Select
    ActiveCell.FormulaR1C1 = "=R[25]C[-12]"
    Range("S8").Select
    ActiveCell.FormulaR1C1 = "=R[25]C[-12]"
    Range("S9").Select
    ActiveCell.FormulaR1C1 = "=R[25]C[-7]"
    Range("S10").Select
End Sub

Sub Deieck_Zeichnen_2S_1W_b()
    Range("S7").Select
    ActiveCell.FormulaR1C1 = "=R[39]C[-12]"
    Range("S8").Select
    ActiveCell.FormulaR1C1 = "=R[39]C[-12]"
    Range("S9").Select
    ActiveCell.FormulaR1C1 = "=R[39]C[-7]"
    Range("S10").Select
End Sub

Sub Deieck_Zeichnen_1S_2W_a()
    Range("S7").Select
    ActiveCell.FormulaR1C1 = "=R[52]C[-12]"
    Range("S8").Select
    ActiveCell.FormulaR1C1 = "=R[52]C[-12]"
    Range("S9").Select
    ActiveCell.FormulaR1C1 = "=R[52]C[-7]"
    Range("S10").Select
End Sub

Sub Deieck_Zeichnen_1S_2W_b()
    Range("S7").Select
    ActiveCell.FormulaR1C1 = "=R[65]C[-12]"
    Range("S8").Select
    ActiveCell.FormulaR1C1 = "=R[65]C[-12]"
    Range("S9").Select
    ActiveCell.FormulaR1C1 = "=R[65]C[-7]"
    Range("S10").Select
End Sub

Sub RechtwinkligesDreieckDoInteration()
    Range("M19").GoalSeek Goal:=0, ChangingCell:=Range("G19")
    Range("M20").GoalSeek Goal:=0, ChangingCell:=Range("F20")
End Sub

