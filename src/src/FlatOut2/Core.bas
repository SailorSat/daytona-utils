Attribute VB_Name = "Core"
Option Explicit

Private DirectX As DirectX8
Private DirectInput As DirectInput8

Global RunOnIDE As Boolean
Private IsRunning As Boolean
Private SystemPath As String

Private Declare Function GetSystemDirectoryA Lib "kernel32" (ByVal lpBuffer As String, ByVal nSize As Long) As Long

Private LastReturnTick As Long

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
  If DirectInputEnumeration.GetCount = 0 Then
    Debug.Print "no direct input devices?"
    Stop
  End If
    

  ' dummy call
  FO2_Online
  
  ' start flatout2 (if not running)
  Dim Path As String, File As String, Parameters As String, Key As String
  Key = "flatout2"
  Path = ReadIni("flatout2launcher.ini", Key, "Path", "C:\Transfer\flatout2")
  File = ReadIni("flatout2launcher.ini", Key, "File", "flatout2cracked.exe")
  Parameters = ReadIni("loader.ini", Key, "Parameters", "-lan -host")
  
  If Not FO2_Online Then
    ShellExecuteA Window.hWnd, "open", Path & "\" & File, Parameters, Path, SW_SHOWNORMAL
    While Not FO2_Online
      Sleep 100
      DoEvents
    Wend
  End If

  IsRunning = FO2_Online
  While IsRunning
    Sleep 100
    DoEvents
    If FO2_Online Then
      RetVal = FO2_GameState
      Window.Caption = RetVal
      Select Case RetVal
        Case 0
          ' 0 splash
          ' do nothing
            LastReturnTick = GetTickCount
        
        Case 1
          ' 1 menu
          'TODO map controls to keys
        
        Case 2, 3
          ' 2 race
          ' 3 profile
          ' tick return key once a second
          If GetTickCount - LastReturnTick >= 1000 Then
            LastReturnTick = GetTickCount
            FO2_SendKey_Return
            Debug.Print "Return"
          End If
      End Select
    Else
      IsRunning = False
    End If
  Wend
  
  ShellExecuteA Window.hWnd, "open", SystemPath & "\taskkill.exe", "/IM " & File & " /T", SystemPath, SW_HIDE
  End
End Sub

Public Sub Terminate()
  IsRunning = False
End Sub

