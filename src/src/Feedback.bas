Attribute VB_Name = "Feedback"
Option Explicit

Public FeedbackDebug As Boolean

' internal buffer
Private DriveData As Byte
Private DriveReal As Byte
Private LampsData As Byte

Public Sub Load()
  Dim SomeData As Byte
  Model3Mode = CBool(ReadIni("drive.ini", "feedback", "model3", "false"))
  
  CloseDriveChannel
  Call init_mame(ByVal 1, "Test", AddressOf mame_start, AddressOf mame_stop, AddressOf mame_copydata, AddressOf mame_updatestate)
  
  OnStatus "Feedback", vbYellow, "ready"
End Sub

Public Sub Unload()
  Call close_mame
  CloseDriveChannel
End Sub

Public Sub Timer()
  If MAME_Online Then
    Profile = MAME_Profile
    ProcessDrive Get_MAME_DriveData
    ProcessLamps Get_MAME_LampsData
  ElseIf M2EM_Online Then
    Profile = M2EM_Profile
    ProcessDrive Get_M2EM_DriveData
    ProcessLamps Get_M2EM_LampsData
  Else
    OverrideDrive 0
    OverrideLamps 0
  End If
End Sub

Public Sub ProcessDrive(Data As Byte)
  If Data <> DriveData Then
    DriveData = Data
    If TranslateDrive(DriveReal, Data) Then
      SendDrive DriveReal
    End If
  End If
End Sub

Public Sub OverrideDrive(Data As Byte)
  DriveData = Data
  SendDrive DriveData
End Sub

Public Sub SendDrive(Data As Byte)
  If OpenDriveChannel Then
    WriteDriveData 1, Data
  End If
  If FeedbackDebug Then OnText "Feedback", "Drive", LeadZero(Hex(Data), 2)
End Sub

Public Sub ProcessLamps(Data As Byte)
  If Data <> LampsData Then
    LampsData = Data
    SendLamps LampsData
  End If
End Sub

Public Sub OverrideLamps(Data As Byte)
  LampsData = Data
  SendLamps LampsData
End Sub

Public Sub SendLamps(Data As Byte)
  If OpenDriveChannel Then
    WriteDriveData 2, Data
  End If
  If FeedbackDebug Then OnText "Feedback", "Lamps", LeadZero(Hex(Data), 2)
End Sub

