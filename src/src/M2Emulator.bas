Attribute VB_Name = "M2Emulator"
Option Explicit

Public M2EM_Online As Boolean
Public M2EM_Profile As String

Private DriveOffset As Long
Private LampOffset As Long

Public Sub Check_M2EM()
  If OpenMemory Then
    CheckProfile
  End If
End Sub

Public Function Get_M2EM_DriveData() As Byte
  Get_M2EM_DriveData = ReadByte(DriveOffset)
End Function

Public Function Get_M2EM_LampsData() As Byte
  Get_M2EM_LampsData = ReadByte(LampOffset)
End Function

Private Sub CheckProfile()
  ' check model 2
  Dim EmulatorWindow As Long
  M2EM_Profile = ""
  
  EmulatorWindow = FindWindowA(vbNullString, "Daytona USA (Saturn Ads)")
  If EmulatorWindow Then
    M2EM_Profile = "daytona"
    DriveOffset = pRAMBASE + CUSTOM_DRIVE
    LampOffset = pRAMBASE + CUSTOM_LAMP
  End If
    
  EmulatorWindow = FindWindowA(vbNullString, "Indianapolis 500 (Rev A, Twin, Newer rev)")
  If EmulatorWindow Then
    M2EM_Profile = "indy500"
    DriveOffset = pRAMBASE + &HEBF74
    LampOffset = pRAMBASE + &H3C390
  End If
    
  EmulatorWindow = FindWindowA(vbNullString, "Sega Touring Car Championship")
  If EmulatorWindow Then
    M2EM_Profile = "stcc"
    DriveOffset = pRAM2BASE + &HB2E0&
    LampOffset = pRAM2BASE + &HB2E4&
  End If
    
  EmulatorWindow = FindWindowA(vbNullString, "Sega Touring Car Championship (Rev A)")
  If EmulatorWindow Then
    M2EM_Profile = "stcc"
    DriveOffset = pRAM2BASE + &HB2E0&
    LampOffset = pRAM2BASE + &HB2E4&
  End If
    
  EmulatorWindow = FindWindowA(vbNullString, "Sega Rally Championship")
  If EmulatorWindow Then
    M2EM_Profile = "srallyc"
    DriveOffset = pRAM2BASE + &H2049&
    LampOffset = pRAM2BASE + &H204C&
  End If
  
  If M2EM_Profile <> "" Then
    M2EM_Online = True
  End If
End Sub
