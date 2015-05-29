Attribute VB_Name = "Utilities"
Option Explicit

Public Function LeadZero(Data As String, Length As Integer) As String
  If Len(Data) < Length Then
    LeadZero = String(Length - Len(Data), "0") & Data
  Else
    LeadZero = Data
  End If
End Function

Public Function LeadSpace(Data As String, Length As Integer) As String
  If Len(Data) < Length Then
    LeadSpace = String(Length - Len(Data), " ") & Data
  Else
    LeadSpace = Data
  End If
End Function
