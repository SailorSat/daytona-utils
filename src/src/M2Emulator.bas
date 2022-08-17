Attribute VB_Name = "M2Emulator"
Option Explicit

Public M2EM_Profile As String

Public M2EM_RAMBASE As Long
Public M2EM_RAM2BASE As Long
Public M2EM_BACKUPBASE As Long

Private Handle As Long
Private DriveOffset As Long
Private LampOffset As Long
Private ProfileOffset As Long

Public Function M2EM_Online() As Boolean
  ' check if we got handle
  If Handle = -1 Then
    ' no handle, try to open process
    M2EM_Online = OpenProcessMemoryModel2
  Else
    ' got handle, check if valid
    Dim Result As Long
    Dim Buffer As Byte
    Result = ReadProcessMemory(Handle, M2EM_RAMBASE, Buffer, 1, 0)
    If Result = 0 Then
      CloseProcess
      Handle = -1
      M2EM_Profile = ""
      M2EM_Online = False
    Else
      M2EM_Online = True
    End If
  End If
End Function

Public Function Get_M2EM_DriveData() As Byte
  Get_M2EM_DriveData = ReadByte(DriveOffset)
End Function

Public Function Get_M2EM_LampsData() As Byte
  Get_M2EM_LampsData = ReadByte(LampOffset)
End Function


Private Function OpenProcessMemoryModel2() As Boolean
  Dim Process As Long
  Dim Module As Long
  
  OpenProcessMemoryModel2 = False
  
  Process = GetProcessByFilename("EMULATOR.EXE", 0)
  If Process = -1 Then
    Process = GetProcessByFilename("emulator_multicpu.exe", 0)
    If Process = -1 Then
      Exit Function
    End If
  End If
  
  Handle = OpenProcessID(Process)
  If Handle = -1 Then
    Exit Function
  End If
  
  Dim EmulatorEXE As Long
  EmulatorEXE = GetModuleByFilename("EMULATOR.EXE", Process)
  If EmulatorEXE = -1 Then
    EmulatorEXE = GetModuleByFilename("emulator_multicpu.exe", Process)
    If EmulatorEXE = -1 Then
      CloseProcess
      Exit Function
    End If
  End If
  
  Dim Offset1 As Long
  Offset1 = ReadLong(EmulatorEXE + &H1AA888)
  M2EM_RAMBASE = ReadLong(Offset1 + &H100&)
  If M2EM_RAMBASE = 0 Then
    CloseProcess
    Exit Function
  End If
  
  M2EM_RAM2BASE = ReadLong(Offset1 + &H108&)
  If M2EM_RAM2BASE = 0 Then
    CloseProcess
    Exit Function
  End If
  
  M2EM_BACKUPBASE = ReadLong(Offset1 + &H118&)
  If M2EM_BACKUPBASE = 0 Then
    CloseProcess
    Exit Function
  End If
  
  DriveOffset = EmulatorEXE + &H17285B
  LampOffset = EmulatorEXE + &H174CF0
  ProfileOffset = EmulatorEXE + &HC44100
  
  If Not CheckProfile Then
    CloseProcess
    Exit Function
  End If
  
  OpenProcessMemoryModel2 = True
End Function


Private Function CheckProfile() As Boolean
  Dim Profile As String
  Profile = StrConv(ReadString(ProfileOffset, 8), vbUnicode)
  If InStr(1, Profile, Chr(0), vbBinaryCompare) > 0 Then
    Profile = Left$(Profile, InStr(1, Profile, Chr(0), vbBinaryCompare) - 1)
  End If

  Select Case Profile
    Case "daytona", "daytonase", "daytonas"
      ' 2o Daytona USA
      M2EM_Profile = "daytona"
      LampOffset = M2EM_RAMBASE + CUSTOM_LAMP

    Case "manxtt", "manxttc"
      ' 2A ManxTT Superbike
      M2EM_Profile = "manxtt"
      
    Case "motoraid"
      ' 2A Motor Raid
      M2EM_Profile = "motoraid"
      
    Case "srallyc"
      ' 2A Sega Rally Championship
      M2EM_Profile = "srallyc"
    
    Case "indy500", "indy500d", "indy500to"
      ' Indianapolis 500
      M2EM_Profile = "indy500"

    Case "stcc", "stcca", "stccb"
      ' Sega Touring Car Championship
      M2EM_Profile = "stcc"

    Case Else
      M2EM_Profile = Profile
      Debug.Print "unknown game", Profile
  End Select
  
  If M2EM_Profile = "" Then
    CheckProfile = False
  Else
    CheckProfile = True
  End If
End Function
