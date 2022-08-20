Attribute VB_Name = "M3Emulator"
Option Explicit

Public M3EM_Profile As String

Public M3EM_RAMBASE As LARGE_INTEGER

Private M3EM_SupermodelEXE As LARGE_INTEGER
Private M3EM_Handle As Long

Public Function M3EM_Online() As Boolean
  ' check if we got handle
  If M3EM_Handle = -1 Then
    ' no handle, try to open process
    M3EM_Online = OpenProcessMemoryModel3
  Else
    ' got handle, check if valid
    Dim liRet As LARGE_INTEGER
    Dim Result As Long
    Result = NtWow64ReadVirtualMemory64(M3EM_Handle, M3EM_SupermodelEXE.lowpart + &H432058, M3EM_SupermodelEXE.highpart, M3EM_RAMBASE, 8, 0, liRet)
    If Result < 0 Then
      CloseProcess64
      M3EM_Handle = -1
      M3EM_Profile = ""
      M3EM_Online = False
    Else
      M3EM_Online = True
    End If
  End If
End Function


Private Function OpenProcessMemoryModel3() As Boolean
  Dim Process As Long
  Dim Module As Long
  
  OpenProcessMemoryModel3 = False

  Process = GetProcessByFilename("supermodel.exe", 0)
  If Process = -1 Then
    Exit Function
  End If

  M3EM_Handle = OpenProcess64(Process)
  If M3EM_Handle = -1 Then
    Exit Function
  End If

  Dim Result As Long
  Result = GetModuleByFilename64("supermodel.exe", M3EM_Handle, M3EM_SupermodelEXE)
  If Result = -1 Then
    CloseProcess64
    Exit Function
  End If

  Dim liRet As LARGE_INTEGER

  'Supermodel.exe+432058
  Result = NtWow64ReadVirtualMemory64(M3EM_Handle, M3EM_SupermodelEXE.lowpart + &H432058, M3EM_SupermodelEXE.highpart, M3EM_RAMBASE, 8, 0, liRet)
  If Result < 0 Then
    CloseProcess64
    Exit Function
  End If
  
  If Not CheckProfile Then
    CloseProcess64
    Exit Function
  End If
  
  OpenProcessMemoryModel3 = True
End Function


Private Function CheckProfile() As Boolean
  Dim Result As Long, liRet As LARGE_INTEGER
  Dim Buffer(0 To 7) As Byte, Profile As String

  '"Supermodel.exe"+005720D0
  Dim Offset0 As LARGE_INTEGER, Offset1 As LARGE_INTEGER, Offset2 As LARGE_INTEGER, Offset3 As LARGE_INTEGER
  Result = NtWow64ReadVirtualMemory64(M3EM_Handle, M3EM_SupermodelEXE.lowpart + &H5720D0, M3EM_SupermodelEXE.highpart, Offset0, 8, 0, liRet)
  Result = NtWow64ReadVirtualMemory64(M3EM_Handle, Offset0.lowpart + &H268&, Offset0.highpart, Offset1, 8, 0, liRet)
  Result = NtWow64ReadVirtualMemory64(M3EM_Handle, Offset1.lowpart + &H28&, Offset1.highpart, Offset2, 8, 0, liRet)
  Result = NtWow64ReadVirtualMemory64(M3EM_Handle, Offset2.lowpart + &HC0&, Offset2.highpart, Offset3, 8, 0, liRet)
  Result = NtWow64ReadVirtualMemory64(M3EM_Handle, Offset3.lowpart + &H9E0&, Offset3.highpart, Buffer(0), 8, 0, liRet)
  Profile = StrConv(Buffer, vbUnicode)
  If InStr(1, Profile, Chr(0)) Then Profile = Left$(Profile, InStr(1, Profile, Chr(0), vbBinaryCompare) - 1)
  
  'Profile = MAME_Profile
  
  Select Case Profile
    Case "daytona2", "dayto2pe"
      ' 2.1 Daytona USA2
      M3EM_Profile = "daytona2"
    
    Case "scud", "scudau"
      ' 1.5 Scud Race
      M3EM_Profile = "scud"

    Case Else
      M3EM_Profile = ""
      Debug.Print "unknown game", Profile
  End Select
    
  If M3EM_Profile = "" Then
    CheckProfile = False
  Else
    CheckProfile = True
  End If
End Function


Public Sub M3EM_SendServiceB()
  Dim keyInput As INPUT_
  Dim VKey As Long, ScanCode As Long
  
  ScanCode = MapVirtualKeyA(VK_7, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
End Sub
