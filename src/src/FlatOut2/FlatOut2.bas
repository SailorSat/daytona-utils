Attribute VB_Name = "FlatOut2"
Option Explicit

Private FO2_RACEINFOPTR As Long
Private Const FO2_LINKSESSIONPTR = &H73B018

Private Handle As Long

Public Function FO2_Online() As Boolean
  ' check if we got handle
  If Handle = -1 Then
    ' no handle, try to open process
    FO2_Online = OpenProcessFlatOut2
  Else
    ' got handle, check if valid
    Dim Result As Long
    Dim Buffer As Byte
    Result = ReadProcessMemory(Handle, FO2_RACEINFOPTR, Buffer, 1, 0)
    If Result = 0 Then
      CloseProcess
      Handle = -1
      FO2_Online = False
    Else
      FO2_Online = True
    End If
  End If
End Function

Private Function OpenProcessFlatOut2() As Boolean
  Dim Process As Long
  
  OpenProcessFlatOut2 = False
  
  Process = GetProcessByFilename("flatout2.exe", 0)
  If Process = -1 Then
    Exit Function
  End If
 
  Handle = OpenProcessID(Process)
  If Handle = -1 Then
    Exit Function
  End If
 
  FO2_RACEINFOPTR = ReadLong(&H8E8410)
  If FO2_RACEINFOPTR = 0 Then
    CloseProcess
    Exit Function
  End If
  
  OpenProcessFlatOut2 = True
End Function

Public Function FO2_GameState() As Long
  Dim GameState As Long
  GameState = ReadLong(FO2_RACEINFOPTR + &H458)

  FO2_GameState = GameState
  Select Case GameState
    Case 0 ' splash
      ' nothing to do
      
    Case 1 ' Menu
      If ReadString(FO2_RACEINFOPTR + &H1E14, 16) = "PLAYER" Then
        ' profile selection
        FO2_GameState = 3
      Else
        ' menu
        ' nothing to do
      End If
    
    Case 2 ' race
      ' nothing to do
    
    Case Else
      Debug.Print "unknown gamestate", GameState
  End Select
End Function

Public Sub FO2_SendKey_Return()
  Dim keyInput As INPUT_
  Dim VKey As Long, ScanCode As Long
  
  ScanCode = MapVirtualKeyA(VK_RETURN, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
End Sub

Public Sub FO2_SendKey_Escape()
  Dim keyInput As INPUT_
  Dim VKey As Long, ScanCode As Long
  
  ScanCode = MapVirtualKeyA(VK_ESCAPE, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
End Sub

Public Sub FO2_SendKey_CursorLeft()
  Dim keyInput As INPUT_
  Dim VKey As Long, ScanCode As Long
  
  ScanCode = MapVirtualKeyA(VK_LEFT, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
End Sub

Public Sub FO2_SendKey_CursorRight()
  Dim keyInput As INPUT_
  Dim VKey As Long, ScanCode As Long
  
  ScanCode = MapVirtualKeyA(VK_RIGHT, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
End Sub

Public Sub FO2_SendKey_CursorUp()
  Dim keyInput As INPUT_
  Dim VKey As Long, ScanCode As Long
  
  ScanCode = MapVirtualKeyA(VK_UP, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
End Sub

Public Sub FO2_SendKey_CursorDown()
  Dim keyInput As INPUT_
  Dim VKey As Long, ScanCode As Long
  
  ScanCode = MapVirtualKeyA(VK_DOWN, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
End Sub

