Attribute VB_Name = "GUI"
Option Explicit

Public ScreenSizeX As Long
Public ScreenSizeY As Long
Public ScreenZoomX As Long
Public ScreenZoomY As Long

Sub Load()
  ' Try to switch resolution
  Dim UseSwitchResolution As Boolean
  Dim Display As String
  Dim Width As Long
  Dim Height As Long
  Dim Bits As Long
  Dim Refresh As Long
  
  UseSwitchResolution = CBool(ReadIni("loader.ini", "gui", "enabled", "false"))
  If UseSwitchResolution Then
    Display = ReadIni("loader.ini", "gui", "Display", "\\.\DISPLAY1")
    Width = CLng(ReadIni("loader.ini", "gui", "Width", "496"))
    Height = CLng(ReadIni("loader.ini", "gui", "Height", "384"))
    Bits = CLng(ReadIni("loader.ini", "gui", "Bits", "32"))
    Refresh = CLng(ReadIni("loader.ini", "gui", "Refresh", "60"))
    SwitchResolution Display, Width, Height, Bits, Refresh
  End If

  ' Check Resolution and calculate zoom
  If RunOnIDE Then
    ScreenSizeX = 496
    ScreenSizeY = 384
  Else
    ScreenSizeX = Screen.Width / Screen.TwipsPerPixelX
    ScreenSizeY = Screen.Height / Screen.TwipsPerPixelY
  End If
  ScreenZoomX = ScreenSizeX / 496
  ScreenZoomY = ScreenSizeY / 384

  Dim WindowWidth As Long
  Dim WindowHeight As Long
  WindowWidth = ScreenSizeX * Screen.TwipsPerPixelX
  WindowHeight = ScreenSizeY * Screen.TwipsPerPixelY

  ' Screen #1 - Top Left
  Window.Hide
  Window.Move 0&, 0&, WindowWidth, WindowHeight
  Window.Show
  
  ' Move Mouse
  SetCursorPos ScreenSizeX, ScreenSizeY
  DoEvents
End Sub

Sub Unload()
  Window.Hide
End Sub

Sub EnableAlwaysOnTop()
  ' Set always on top
  SetWindowPos Window.hWnd, HWND_TOPMOST, 0&, 0&, 0&, 0&, SWP_SHOWWINDOW Or SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOACTIVATE
End Sub

Sub DisableAlwaysOnTop()
  ' Unset always on top
  SetWindowPos Window.hWnd, HWND_NOTOPMOST, 0&, 0&, 0&, 0&, SWP_SHOWWINDOW Or SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOACTIVATE
End Sub

Sub DrawFont(Text As String, X As Long, Y As Long, Color As Long)
  Dim SrcX As Long, SrcY As Long
  Dim DstX As Long, DstY As Long
  Dim Idx As Long, Char As Byte
  
  ' set background color if picturebox (to change the actual color)
  Window.pbFont.BackColor = Color
  
  DstX = X * 8
  DstY = Y * 8
  ' loop text
  For Idx = 1 To Len(Text)
    Char = Asc(Mid$(Text, Idx, 1))
    SrcX = Char * 9
    SrcY = 0
    BitBlt Window.hdc, DstX, DstY, 8, 8, Window.pbFont.hdc, SrcX, SrcY, vbSrcCopy
    DstX = DstX + 8
  Next
  Window.Refresh
End Sub
