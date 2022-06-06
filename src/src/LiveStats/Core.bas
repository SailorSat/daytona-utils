Attribute VB_Name = "Core"
Option Explicit

Global ScreenSizeX As Long
Global ScreenSizeY As Long
Global ScreenZoomX As Long
Global ScreenZoomY As Long

Private RunOnIDE As Boolean

Private Function IsRunOnIDE() As Boolean
  RunOnIDE = True
  IsRunOnIDE = True
End Function

Public Sub Main()
  ' check for visual basic ide (debug mode)
  RunOnIDE = False
  Debug.Assert IsRunOnIDE

  If Not RunOnIDE Then
    While Not M2EM_Online
      Sleep 500
    Wend
  End If
  
  ' Check Resolution and calculate zoom
  ScreenSizeX = Screen.Width / Screen.TwipsPerPixelX
  ScreenSizeY = Screen.Height / Screen.TwipsPerPixelY
  
  If RunOnIDE Then
    ScreenSizeX = 512
    ScreenSizeY = 384
  End If

  Dim ScreenZoomX As Double
  Dim ScreenZoomY As Double
  ScreenZoomX = ScreenSizeX / 496
  ScreenZoomY = ScreenSizeY / 360

  Dim WindowWidth As Long
  Dim WindowHeight As Long
  WindowWidth = ScreenSizeX * Screen.TwipsPerPixelX
  WindowHeight = ScreenSizeY * Screen.TwipsPerPixelY

  ' Screen #1 - Top Left
  Window.Hide
  Window.Move 0&, 0&, WindowWidth, WindowHeight
  Window.Show

  ' Screen #2 - Top Left
  Window2.Hide
  Window2.Move WindowWidth, 0&, WindowWidth, WindowHeight
  Window2.MoveBorder
  Window2.Show

  ' Move Mouse
  SetCursorPos ScreenSizeX * 2&, ScreenSizeY
  
  ' Prepare Overlay
  ManipulateEmulator
  EnableTransparency
  EnableAlwaysOnTop
  
  ' Raise OnLoad Event
  OnLoad
  
  SetFocus Window2.hwnd
End Sub

Private Sub ManipulateEmulator()
  Dim EmulatorWindow As Long
  EmulatorWindow = FindWindowA(vbNullString, "Daytona USA (Saturn Ads)")
  If EmulatorWindow Then
    Call SetWindowLongA(EmulatorWindow, GWL_STYLE, &H16000000)
    Call SetMenu(EmulatorWindow, 0&)
    Call SetWindowPos(EmulatorWindow, Window.hwnd, 0&, 0&, ScreenSizeX, ScreenSizeY, 0&)
  End If
End Sub

Private Sub EnableTransparency()
  Dim DisplayStyle As Long
  DisplayStyle = GetWindowLongA(Window.hwnd, GWL_EXSTYLE)
  If DisplayStyle <> (DisplayStyle Or WS_EX_LAYERED) Then
    DisplayStyle = (DisplayStyle Or WS_EX_LAYERED)
    Call SetWindowLongA(Window.hwnd, GWL_EXSTYLE, DisplayStyle)
  End If
  Call SetLayeredWindowAttributes(Window.hwnd, &HFF00FF, 0&, LWA_COLORKEY)
End Sub

Private Sub EnableAlwaysOnTop()
  Call SetWindowPos(Window.hwnd, HWND_TOPMOST, 0&, 0&, 0&, 0&, SWP_SHOWWINDOW Or SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOACTIVATE)
End Sub
