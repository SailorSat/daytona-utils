Attribute VB_Name = "Core"
Option Explicit

Private Const Row1 As Long = 20
Private Const Row2 As Long = 36

Private UseControlClient As Boolean
Private UseFeedback As Boolean
Private UseLagFix As Boolean
Private UseWheelCheck As Boolean
Private UseThrottle As Boolean
Private UseProfile As Boolean

Private CurrentProfile As String

Global RunOnIDE As Boolean

Private Function IsRunOnIDE() As Boolean
  RunOnIDE = True
  IsRunOnIDE = True
End Function

Public Sub Main()
  ' check for visual basic ide (debug mode)
  RunOnIDE = False
  Debug.Assert IsRunOnIDE
  
  ' load essential stuff
  GUI.Load
  Winsock.Load
  
  ' now, check for ip availability
  Dim Host As String, Port As Long, UDP_LocalAddress As String
  Host = ReadIni("loader.ini", "netcheck", "Host", "127.0.0.1")
  Port = CLng(ReadIni("loader.ini", "netcheck", "Port", "15160"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  
  UseControlClient = CBool(ReadIni("loader.ini", "control", "enabled", "false"))
  UseFeedback = CBool(ReadIni("loader.ini", "feedback", "enabled", "false"))
  UseLagFix = CBool(ReadIni("loader.ini", "lagfix", "enabled", "false"))
  UseWheelCheck = CBool(ReadIni("loader.ini", "wheelcheck", "enabled", "false"))
  UseThrottle = CBool(ReadIni("loader.ini", "throttle", "enabled", "false"))
  UseProfile = CBool(ReadIni("loader.ini", "profile", "enabled", "false"))

  ' draw primary gui
  GUI.EnableAlwaysOnTop
  DrawFont "LOCAL ADDRESS", Row1, 5, vbWhite
  DrawFont "REMOTE CONTROL", Row1, 7, vbWhite
  DrawFont "USB FEEDBACK", Row1, 9, vbWhite
  DrawFont "NETWORK FIX", Row1, 11, vbWhite
  DrawFont "WHEEL CHECK", Row1, 13, vbWhite
  
  DrawFont TailSpace(Host, 15), Row2, 5, vbYellow
  If UseControlClient Then
    DrawFont "...", Row2, 7, vbYellow
  Else
    DrawFont "OFF", Row2, 7, vbRed
  End If
  If UseFeedback Then
    DrawFont "...", Row2, 9, vbYellow
  Else
    DrawFont "OFF", Row2, 9, vbRed
  End If
  If UseLagFix Then
    DrawFont "...", Row2, 11, vbYellow
  Else
    DrawFont "OFF", Row2, 11, vbRed
  End If
  If UseWheelCheck Then
    DrawFont "...", Row2, 13, vbYellow
  Else
    DrawFont "OFF", Row2, 13, vbRed
  End If
  If UseProfile Then
    DrawFont "PROFILE", Row1, 17, vbWhite
    DrawFont "...", Row2, 17, vbYellow
  End If
  Sleep 500
  
  ' do the actual network check
  DrawFont TailSpace(Host, 15), Row2, 5, vbRed
  NetworkCheck UDP_LocalAddress
  DrawFont TailSpace(Host, 15), Row2, 5, vbGreen
  Sleep 500
  
  ' load (not yet) optional stuff
  If UseControlClient Then ControlClient.Load
  Sleep 500
  
  If UseFeedback Then
    Feedback.Load
    FeedbackDebug = CBool(ReadIni("loader.ini", "feedback", "debug", "false"))
  End If
  Sleep 500
  
  If UseLagFix Then Lagfix.Load
  Sleep 500
  
  ' do the actual wheel check
  If UseWheelCheck Then
    DrawFont "CHECK", Row2, 13, vbRed
    WheelCheck
    DrawFont "ONLINE", Row2, 13, vbGreen
  End If
  Sleep 500
  
  ' start throttle
  If UseThrottle Then
    ShellExecuteA Window.hWnd, "open", App.Path & "\DaytonaThrottle.exe", "", App.Path, SW_HIDE
  End If
  Sleep 500
  
  ' enable the timer
  Window.Timer.Enabled = True
  Sleep 500

  ' done
  GUI.DisableAlwaysOnTop
  
  ' start the emulation
  Dim Path As String, File As String, Parameters As String
  If UseProfile Then
    Parameters = ReadIni("loader.ini", "profile", "default", "daytona")
    OnProfile Parameters
  Else
    ' legacy emulator
    Path = ReadIni("loader.ini", "emulator", "Path", "D:\m2emulator")
    File = ReadIni("loader.ini", "emulator", "File", "emulator_multicpu.exe")
    Parameters = ReadIni("loader.ini", "emulator", "Parameters", "daytonas")
    ShellExecuteA Window.hWnd, "open", Path & "\" & File, Parameters, Path, SW_SHOWMAXIMIZED
  End If
  
  Debug.Print "done."
End Sub

Public Sub NetworkCheck(UDP_LocalAddress As String)
  Dim UDP_Socket As Long, FlipFlop As Boolean
  UDP_Socket = Winsock.ListenUDP(UDP_LocalAddress)
  While UDP_Socket = -1
    FlipFlop = Not FlipFlop
    If FlipFlop Then
      DrawFont "NETWORK CHECKING", 24, 40, vbWhite
    Else
      DrawFont "                ", 24, 40, vbWhite
    End If
    DoEvents
    Sleep 500
    UDP_Socket = Winsock.ListenUDP(UDP_LocalAddress)
  Wend
  DrawFont "                ", 24, 40, vbWhite
  Winsock.Disconnect UDP_Socket
End Sub

Public Sub WheelCheck()
  Dim DirectX As DirectX8, DirectInput As DirectInput8, DirectInputEnumeration As DirectInputEnumDevices8, FlipFlop As Boolean
  
  Set DirectX = New DirectX8
  Set DirectInput = DirectX.DirectInputCreate
  Set DirectInputEnumeration = DirectInput.GetDIDevices(DI8DEVCLASS_GAMECTRL, DIEDFL_ATTACHEDONLY)
  While DirectInputEnumeration.GetCount = 0
    FlipFlop = Not FlipFlop
    If FlipFlop Then
      DrawFont " WHEEL CHECKING ", 24, 40, vbWhite
    Else
      DrawFont "                ", 24, 40, vbWhite
    End If
    DoEvents
    Sleep 500
    Set DirectInputEnumeration = DirectInput.GetDIDevices(DI8DEVCLASS_GAMECTRL, DIEDFL_ATTACHEDONLY)
  Wend
  Set DirectInputEnumeration = Nothing
  Set DirectInput = Nothing
  Set DirectX = Nothing
End Sub

' generic events
Public Sub OnUnload()
  ' disable the timer
  Window.Timer.Enabled = False
  
  ' unload (not yet) optional stuff
  If UseLagFix Then Lagfix.Unload
  If UseFeedback Then Feedback.Unload
  If UseControlClient Then ControlClient.Unload
  
  ' unload essential stuff
  Winsock.Unload
  
  ' some other cleanup
  CloseProcess
  End
End Sub

Public Sub OnTimer()
  If UseControlClient Then ControlClient.Timer
  If UseFeedback Then Feedback.Timer
  If UseLagFix Then Lagfix.Timer
End Sub

Public Sub OnStatus(sModule As String, lStatus As Long, sStatus As String)
  Dim SrcX As Long, SrcY As Long
  SrcX = Row2
  Select Case sModule
    Case "ControlClient"
      SrcY = 7
    Case "Feedback"
      SrcY = 9
    Case "LagFix"
      SrcY = 11
    Case "Profile"
      SrcY = 17
  End Select
  DrawFont TailSpace(UCase(sStatus), 12), SrcX, SrcY, lStatus
  
  Debug.Print "OnStatus", sModule, lStatus, sStatus
End Sub

Public Sub OnText(sModule As String, sTopic As String, sText As String)
  Dim SrcX As Long, SrcY As Long, Color As Long, length As Integer
  Color = vbWhite
  Select Case sModule
    Case "Feedback", "DriveTranslation"
      SrcY = 9
      Select Case sTopic
        Case "Lamps"
          SrcX = Row2 + 8
          length = 2
          Color = vbCyan
        Case "Drive"
          SrcX = Row2 + 11
          length = 2
          Color = vbMagenta
        Case "Pwm"
          SrcX = Row2 + 14
          length = 2
          Color = vbRed
        Case "Debug"
          SrcX = Row2 + 17
          length = 8
      End Select
  End Select
  DrawFont TailSpace(UCase(sText), length), SrcX, SrcY, Color
  
  Debug.Print "OnText", sModule, sTopic, sText
End Sub

Public Sub OnProfile(sProfile As String)
  If Not UseProfile Then Exit Sub
  
  If CurrentProfile <> sProfile Then
    Dim Path As String, File As String, Parameters As String, Key As String, Host As String, Port As Long
    Key = "profile-" & CurrentProfile
    File = ReadIni("loader.ini", Key, "File", "")

    ' kill old emulator (based on filename)
    If File <> "" Then
      ShellExecuteA Window.hWnd, "open", SystemPath & "\taskkill.exe", "/IM " & File & " /T", SystemPath, SW_HIDE
      Sleep 500
      ShellExecuteA Window.hWnd, "open", SystemPath & "\taskkill.exe", "/IM " & File & " /T /F", SystemPath, SW_HIDE
      Sleep 500
    End If
    
    CurrentProfile = sProfile
    Key = "profile-" & CurrentProfile
    
    ' override lagfix config (if enabled)
    If UseLagFix Then
      Host = ReadIni("loader.ini", Key, "remotehost", "")
      Port = CLng(ReadIni("loader.ini", Key, "remoteport", "0"))
      Lagfix.OverrideTX Host, Port
    End If
    
    Path = ReadIni("loader.ini", Key, "Path", "D:\m2emulator")
    File = ReadIni("loader.ini", Key, "File", "emulator_multicpu.exe")
    Parameters = ReadIni("loader.ini", Key, "Parameters", "daytonas")
    ShellExecuteA Window.hWnd, "open", Path & "\" & File, Parameters, Path, SW_SHOWMAXIMIZED
   
    OnStatus "Profile", vbGreen, CurrentProfile
  End If

  Debug.Print "OnProfile", sProfile
  
  ' Move Mouse
  SetCursorPos Screen.Width / Screen.TwipsPerPixelX, Screen.Height / Screen.TwipsPerPixelY
End Sub

' feedback events
Public Sub OnDaytonaEx(Data As Byte)
  ControlClient.OnDriveEx Data
End Sub


' winsock events
Public Sub OnReadTCP(lHandle As Long, sBuffer As String)
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  ControlClient.ReadUDP lHandle, sBuffer, sAddress
  Lagfix.ReadUDP lHandle, sBuffer, sAddress
End Sub

Public Sub OnIncoming(lHandle As Long, sNewSocket As Long)
End Sub

Public Sub OnConnected(lHandle As Long)
End Sub

Public Sub OnConnectError(lHandle As Long, lError As Long)
End Sub

Public Sub OnClose(lHandle As Long)
End Sub
