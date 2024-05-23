Attribute VB_Name = "Core"
Option Explicit

Private DirectX As DirectX8
Private DirectInput As DirectInput8
Private DirectInputDevice As DirectInputDevice8
Private DirectInputJoyState As DIJOYSTATE

Global RunOnIDE As Boolean
Private IsRunning As Boolean
Private SystemPath As String

Private Function IsRunOnIDE() As Boolean
  RunOnIDE = True
  IsRunOnIDE = True
End Function

Public Sub Main()
  ' check for visual basic ide (debug mode)
  RunOnIDE = False
  Debug.Assert IsRunOnIDE
  
  Window.Show
  
  ' fetch system directory
  Dim Temp As String, RetVal As Long
  Temp = Space(256)
  RetVal = GetSystemDirectoryA(Temp, Len(Temp))
  SystemPath = Left(Temp, RetVal)
  
  ' get wheel
  Dim DirectInputEnumeration As DirectInputEnumDevices8
  Set DirectX = New DirectX8
  Set DirectInput = DirectX.DirectInputCreate
  Set DirectInputEnumeration = DirectInput.GetDIDevices(DI8DEVCLASS_GAMECTRL, DIEDFL_ATTACHEDONLY)
  If DirectInputEnumeration.GetCount > 0 Then
    Set DirectInputDevice = DirectInput.CreateDevice(DirectInputEnumeration.GetItem(1).GetGuidInstance)
    DirectInputDevice.SetCooperativeLevel Window.hWnd, DISCL_BACKGROUND Or DISCL_NONEXCLUSIVE
    DirectInputDevice.SetCommonDataFormat DIFORMAT_JOYSTICK
    DirectInputDevice.Acquire
    DirectInputDevice.GetDeviceStateJoystick DirectInputJoyState
  Else
    Debug.Print "no direct input devices?"
  End If

  ' dummy call
  DosBox_Online
  
  ' start dosbox (if not running)
  Dim Path As String, File As String, Parameters As String
  Path = ReadIni("dosboxlaunch.ini", "DosBox", "Path", App.Path)
  File = ReadIni("dosboxlaunch.ini", "DosBox", "File", "dosbox.exe")
  Parameters = ReadIni("dosboxlaunch.ini", "DosBox", "Parameters", Command)
  
  If Not DosBox_Online Then
    ShellExecuteA Window.hWnd, "open", Path & "\" & File, Parameters, Path, SW_SHOWNORMAL
    While Not DosBox_Online
      Sleep 100
      DoEvents
    Wend
  End If

  Dim WheelStatus As Long, WheelDifference As Long, WheelActive As Long
  IsRunning = DosBox_Online
  While IsRunning
    DoEvents
    Sleep 16
    
    If DosBox_Online Then
      ProcessWheelStatus
    Else
      IsRunning = False
    End If
  Wend
  
  ShellExecuteA Window.hWnd, "open", SystemPath & "\taskkill.exe", "/IM " & File & " /T", SystemPath, SW_HIDE
  
  If Not DirectInputDevice Is Nothing Then
    DirectInputDevice.Unacquire
    Set DirectInputDevice = Nothing
  End If
  
  End
End Sub

Public Sub Terminate()
  IsRunning = False
End Sub

Private Function ProcessWheelStatus() As Long
  If DirectInputDevice Is Nothing Then Exit Function

  DirectInputDevice.Poll
  DirectInputDevice.GetDeviceStateJoystick DirectInputJoyState

  With DirectInputJoyState
    Dim mX As Long, mY As Long
    mX = (.X / 512&) - 64&
    mY = (.rz / 1024&) - (.z / 1024&)
    mouse_event MOUSEEVENTF_MOVE, mX, mY, 0, 0
  End With
End Function

