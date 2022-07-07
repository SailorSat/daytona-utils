Attribute VB_Name = "Core"
Option Explicit

Public Sub Main()
  SwitchResolution "\\.\DISPLAY1", 640, 480, 32, 60
  SwitchResolution "\\.\DISPLAY2", 640, 480, 32, 60
End Sub
