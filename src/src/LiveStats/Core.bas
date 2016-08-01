Attribute VB_Name = "Core"
Option Explicit

Global ScreenWidth As Long
Global ScreenHeight As Long
Global ScreenZoom As Double

Private IsRunOnIDE As Boolean

Private Function RunOnIDE() As Boolean
  IsRunOnIDE = True
  RunOnIDE = True
End Function

Public Sub Main()
  ' check for visual basic ide (debug mode)
  IsRunOnIDE = False
  Debug.Assert RunOnIDE
  
  'If Not IsRunOnIDE Then
    While Not OpenMemory
      Sleep 500
    Wend
  'End If
  
  ' Check Resolution and calculate zoom
  ScreenWidth = Screen.Width / Screen.TwipsPerPixelX
  ScreenHeight = Screen.Height / Screen.TwipsPerPixelY
  
  If RunOnIDE Then
    ScreenWidth = 848
    ScreenHeight = 480
  End If
  
  Dim ScreenZoomX As Double
  Dim ScreenZoomY As Double
  ScreenZoomX = ScreenWidth / 640
  ScreenZoomY = ScreenHeight / 480
  
  If ScreenZoomX > ScreenZoomY Then
    ScreenZoom = ScreenZoomY
  Else
    ScreenZoom = ScreenZoomX
  End If
  
  Dim WindowWidth As Long
  Dim WindowHeight As Long
  WindowWidth = ScreenWidth * Screen.TwipsPerPixelX
  WindowHeight = ScreenHeight * Screen.TwipsPerPixelY
  
  ' Screen #1 - Top Left
  Window.Hide
  Window.Move 0, 0, WindowWidth, WindowHeight
  Window.Show

  ' Screen #2 - Top Left
  Window2.Hide
  Window2.Move WindowWidth, 0, WindowWidth, WindowHeight
  Window2.MoveBorder
  Window2.Show
  
  ' Move Mouse
  SetCursorPos ScreenWidth * 2, ScreenHeight
  
  ' Prepare Overlay
  ManipulateEmulator
  EnableTransparency
  
  ' Raise OnLoad Event
  OnLoad
End Sub

Private Sub ManipulateEmulator()
  Dim EmulatorWindow As Long
  EmulatorWindow = FindWindowA(vbNullString, "Daytona USA (Saturn Ads)")
  If EmulatorWindow Then
    SetWindowLongA EmulatorWindow, GWL_STYLE, &H16000000
    SetMenu EmulatorWindow, 0
    SetWindowPos EmulatorWindow, Window.hWnd, 0, 0, ScreenWidth, ScreenHeight, 0
  End If
End Sub

Private Sub EnableTransparency()
  Dim DisplayStyle As Long
  DisplayStyle = GetWindowLongA(Window.hWnd, GWL_EXSTYLE)
  If DisplayStyle <> (DisplayStyle Or WS_EX_LAYERED) Then
    DisplayStyle = (DisplayStyle Or WS_EX_LAYERED)
    Call SetWindowLongA(Window.hWnd, GWL_EXSTYLE, DisplayStyle)
  End If
  Call SetLayeredWindowAttributes(Window.hWnd, &HFF00FF, 0&, LWA_COLORKEY)
End Sub


