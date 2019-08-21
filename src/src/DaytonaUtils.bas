Attribute VB_Name = "DaytonaUtils"
Option Explicit


Public Function DistanceToLap(CurrentTrack As Byte, Distance As Integer) As String
  If Distance > &HF000 Then
    DistanceToLap = "1"
  End If
  Select Case CurrentTrack
    Case 0
      DistanceToLap = CStr((Abs(Distance) \ &HC3) + 1)
    Case 1
      DistanceToLap = CStr((Abs(Distance) \ &H3DE) + 1)
    Case 2
      DistanceToLap = CStr((Abs(Distance) \ &H1E6) + 1)
    Case Else
      DistanceToLap = "1"
  End Select
End Function


Public Function CarToModel(Car As Byte) As Long
  Select Case Car
    Case 0
      CarToModel = &H2848890
    Case 1
      CarToModel = &H28488E0
    Case 2
      CarToModel = &H2848930
    Case 3
      CarToModel = &H2848980
    Case 4
      CarToModel = &H28489D0
    Case 5
      CarToModel = &H2848A20
    Case 6
      CarToModel = &H2848A70
    Case 7
      CarToModel = &H2848AC0
    Case Else
      CarToModel = &H2848B24
  End Select
End Function


Public Function CarToColor(Car As Byte) As Long
  Select Case Car
    Case 0
      CarToColor = RGB(255, 0, 0)
    Case 1
      CarToColor = RGB(0, 0, 255)
    Case 2
      CarToColor = RGB(255, 255, 0)
    Case 3
      CarToColor = RGB(0, 255, 0)
    Case 4
      CarToColor = RGB(64, 64, 64)
    Case 5
      CarToColor = RGB(255, 128, 255)
    Case 6
      CarToColor = RGB(0, 255, 255)
    Case 7
      CarToColor = RGB(255, 128, 0)
  End Select
End Function
