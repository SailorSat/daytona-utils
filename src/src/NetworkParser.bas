Attribute VB_Name = "NetworkParser"
Option Explicit

Public Function ParseFrame(sBuffer As String) As DaytonaFrame
  Set ParseFrame = Nothing
  If Len(sBuffer) = 3589 Then
    Set ParseFrame = New DaytonaFrame
    ParseFrame.Buffer = sBuffer
  End If
End Function
