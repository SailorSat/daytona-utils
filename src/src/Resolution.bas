Attribute VB_Name = "Resolution"
Option Explicit

Public Sub SwitchResolution(DisplayName As String, Width As Long, Height As Long, Bits As Long, Frequency As Long)
  Dim lResult As Long
  Dim lModeNum As Long
  Dim lpDevMode As DEVMODE
  lResult = EnumDisplaySettingsA(DisplayName, -1, lpDevMode)
  If lpDevMode.dmPelsWidth = Width Then
    If lpDevMode.dmPelsHeight = Height Then
      If lpDevMode.dmBitsPerPel = Bits Then
        If lpDevMode.dmDisplayFrequency = Frequency Then
          ' already at resolution
          Exit Sub
        End If
      End If
    End If
  End If
  
  lResult = EnumDisplaySettingsA(DisplayName, lModeNum, lpDevMode)
  While Not lResult = 0
    'Debug.Print lModeNum, lpDevMode.dmPelsWidth, lpDevMode.dmPelsHeight, lpDevMode.dmBitsPerPel, lpDevMode.dmDisplayFrequency
    If lpDevMode.dmPelsWidth = Width Then
      If lpDevMode.dmPelsHeight = Height Then
        If lpDevMode.dmBitsPerPel = Bits Then
          If lpDevMode.dmDisplayFrequency = Frequency Then
            lResult = ChangeDisplaySettingsExA(DisplayName, lpDevMode, 0, 1, 0)
            Exit Sub
          End If
        End If
      End If
    End If
    lModeNum = lModeNum + 1
    lResult = EnumDisplaySettingsA(DisplayName, lModeNum, lpDevMode)
  Wend
End Sub

