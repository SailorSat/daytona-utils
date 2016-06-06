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

Public Function HexDump(sData As String) As String
  Dim bData() As Byte
  bData = StrConv(sData, vbFromUnicode)
  Dim Index As Integer
  For Index = 0 To UBound(bData)
    HexDump = HexDump & LeadSpace(Hex(bData(Index)), 2) & " "
  Next
End Function
