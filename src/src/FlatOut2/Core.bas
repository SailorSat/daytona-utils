Attribute VB_Name = "Core"
Option Explicit

Private DirectX As DirectX8
Private DirectInput As DirectInput8
Private DirectInputDevice As DirectInputDevice8
Private DirectInputJoyState As DIJOYSTATE

Global RunOnIDE As Boolean
Private IsRunning As Boolean
Private SystemPath As String

Private Declare Function GetSystemDirectoryA Lib "kernel32" (ByVal lpBuffer As String, ByVal nSize As Long) As Long

Private LastReturnTick As Long
Private LastWheelStatus As Long

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
  FO2_Online
  
  ' start flatout2 (if not running)
  Dim Path As String, File As String, Parameters As String
  Path = ReadIni("fo2launch.ini", "FlatOut2", "Path", App.Path)
  File = ReadIni("fo2launch.ini", "FlatOut2", "File", "flatout2.exe")
  Parameters = ReadIni("fo2launch.ini", "FlatOut2", "Parameters", "-lan -host")
  
  If Not FO2_Online Then
    ShellExecuteA Window.hWnd, "open", Path & "\" & File, Parameters, Path, SW_SHOWNORMAL
    While Not FO2_Online
      Sleep 100
      DoEvents
    Wend
  End If

  Dim WheelStatus As Long, WheelDifference As Long, WheelActive As Long
  IsRunning = FO2_Online
  While IsRunning
    Sleep 50
    DoEvents
    If FO2_Online Then
      RetVal = FO2_GameState
      Window.Caption = RetVal
      Select Case RetVal
        Case 0, 3
          ' 0 splash
          ' 3 profile
          ' nothing to do
        
        Case 1
          ' 1 menu
          If GetTickCount - LastReturnTick >= 1000 Then
            LastReturnTick = GetTickCount
            LastWheelStatus = LastWheelStatus And &HF
          End If
          
          WheelStatus = CombinedWheelStatus
          WheelDifference = LastWheelStatus Xor WheelStatus
          WheelActive = WheelStatus And WheelDifference
          LastWheelStatus = WheelStatus
            
          If WheelActive Then
            LastReturnTick = GetTickCount
            If WheelActive And &H80 Then FO2_SendKey_CursorLeft
            If WheelActive And &H40 Then FO2_SendKey_CursorRight
            If WheelActive And &H20 Then FO2_SendKey_CursorUp
            If WheelActive And &H10 Then FO2_SendKey_CursorDown
            If WheelActive And &H8 Then FO2_SendKey_Return
            If WheelActive And &H4 Then FO2_SendKey_Escape
            If WheelActive And &H2 Then FO2_SendKey_CursorUp
            If WheelActive And &H1 Then FO2_SendKey_CursorDown
          End If
        
        Case 2
          ' 2 race
          ' tick return key once a second
          If GetTickCount - LastReturnTick >= 1000 Then
            LastReturnTick = GetTickCount
            FO2_SendKey_Return
          End If

      End Select
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

Private Function CombinedWheelStatus() As Long
  Dim Result As Long
  
  If DirectInputDevice Is Nothing Then Exit Function
  
  DirectInputDevice.GetDeviceStateJoystick DirectInputJoyState
  With DirectInputJoyState
    ' X - wheel ; left / right
    If .X < 24576 Then
      Result = Result Or &H80
    ElseIf .X > 40960 Then
      Result = Result Or &H40
    End If
    
    ' Y - not on daytona; up / down
    If .Y < 16384 Then
      Result = Result Or &H20
    ElseIf .Y > 49152 Then
      Result = Result Or &H10
    End If
  
    ' Z - accel ; enter
    If .z > 16384 Then
      Result = Result Or &H8
    End If
    If .slider(0) > 16384 Then
      Result = Result Or &H4
    End If
    
    ' rZ - brake ; escape
    If .rz > 16384 Then
      Result = Result Or &H4
    End If
  
    ' button 1 - enter
    If .Buttons(1) Then
      Result = Result Or &H8
    End If
    
    ' button 2 - escape
    If .Buttons(2) Then
      Result = Result Or &H4
    End If
  
    ' button 3 - up
    If .Buttons(5) Then
      Result = Result Or &H2
    End If
    
    ' button 4 - down
    If .Buttons(6) Then
      Result = Result Or &H1
    End If

  End With
  
  CombinedWheelStatus = Result
End Function
