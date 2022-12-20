Attribute VB_Name = "Utilities"
Option Explicit

Public Function LeadZero(Data As String, Length As Integer) As String
  If Len(Data) < Length Then
    LeadZero = String$(Length - Len(Data), "0") & Data
  Else
    LeadZero = Data
  End If
End Function

Public Function LeadSpace(Data As String, Length As Integer) As String
  If Len(Data) < Length Then
    LeadSpace = String$(Length - Len(Data), " ") & Data
  Else
    LeadSpace = Data
  End If
End Function

Public Function TailSpace(Data As String, Length As Integer) As String
  If Len(Data) < Length Then
    TailSpace = Data & String$(Length - Len(Data), " ")
  Else
    TailSpace = Data
  End If
End Function

Public Function HexDump(sData As String) As String
  Dim bData() As Byte
  bData = StrConv(sData, vbFromUnicode)
  Dim Index As Integer
  For Index = 0 To UBound(bData)
    HexDump = HexDump & LeadZero(Hex(bData(Index)), 2) & " "
  Next
End Function

Public Function bitReverse(byteIn As Byte) As Byte
    bitReverse = 0

    If (byteIn And 128) = 128 Then bitReverse = bitReverse + 1
    If (byteIn And 64) = 64 Then bitReverse = bitReverse + 2
    If (byteIn And 32) = 32 Then bitReverse = bitReverse + 4
    If (byteIn And 16) = 16 Then bitReverse = bitReverse + 8
    If (byteIn And 8) = 8 Then bitReverse = bitReverse + 16
    If (byteIn And 4) = 4 Then bitReverse = bitReverse + 32
    If (byteIn And 2) = 2 Then bitReverse = bitReverse + 64
    If (byteIn And 1) = 1 Then bitReverse = bitReverse + 128
End Function
