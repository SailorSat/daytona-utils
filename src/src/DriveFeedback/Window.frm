VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "DriveFeedback"
   ClientHeight    =   240
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   240
   LinkTopic       =   "Form1"
   ScaleHeight     =   240
   ScaleWidth      =   240
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long
Private UDP_Buffer As String

Private MODEL2_Online As Boolean

Private Profile As String

Private DriveData As Byte
Private LampData As Byte

Private DriveOffset As Long
Private LampOffset As Long

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Dim SomeData As Byte
  Dim DataChanged As Boolean

  Dim Host As String
  Dim Port As Long

  Me.BackColor = RGB(255, 0, 0)
  Me.Move Me.Width * 2, 0
  Me.Show
  
  Winsock.Load
  
  ' init network (drive)
  Host = ReadIni("drive.ini", "feedback", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("drive.ini", "feedback", "localport", "9001"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #ADDR", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If

  Host = ReadIni("drive.ini", "feedback", "remotehost", "127.0.0.1")
  Port = CLng(ReadIni("drive.ini", "feedback", "remoteport", "9000"))
  UDP_RemoteAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_RemoteAddress = "" Then
    MsgBox "Something went wrong! #ADDR", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If

  UDP_Socket = Winsock.ListenUDP(UDP_LocalAddress)
  If UDP_Socket = -1 Then
    MsgBox "Something went wrong! #SOCK", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If
  
  Me.BackColor = RGB(255, 255, 0)
  MAME_Online = False
  MODEL2_Online = False
  
  ' init mame hook
  Call init_mame(ByVal 1, "Test", AddressOf mame_start, AddressOf mame_stop, AddressOf mame_copydata, AddressOf mame_updatestate)
  
  Do
    DoEvents
    Sleep 1
    If MAME_Online And MAME_Profile <> "" Then
      Profile = MAME_Profile
      MODEL2_Online = False
      
      DataChanged = False
    
      SomeData = Get_MAME_DriveData
      If SomeData <> DriveData Then
        DataChanged = TranslateDrive(DriveData, SomeData)
      End If
  
      RtlMoveMemory SomeData, MAME_LampData, 1
      If SomeData <> LampData Then
        LampData = SomeData
        DataChanged = True
      End If
  
      If DataChanged Then
        UDP_Buffer = Chr(&HA5) & Chr(DriveData) & Chr(LampData)
        SendUDP UDP_Socket, UDP_Buffer, UDP_RemoteAddress
        'Debug.Print Hex(DriveData), Hex(LampData)
      End If
    ElseIf MODEL2_Online Then
      While OpenMemory
        Sleep 1
        DataChanged = False
    
        SomeData = ReadByte(DriveOffset)
        If SomeData <> DriveData Then
          DataChanged = TranslateDrive(DriveData, SomeData)
        End If
    
        SomeData = ReadByte(LampOffset)
        If SomeData <> LampData Then
          LampData = SomeData
          DataChanged = True
        End If
    
        If DataChanged Then
          UDP_Buffer = Chr(&HA5) & Chr(DriveData) & Chr(LampData)
          SendUDP UDP_Socket, UDP_Buffer, UDP_RemoteAddress
          'Debug.Print Hex(DriveData), Hex(LampData)
        Else
          DoEvents
        End If
      Wend
      MODEL2_Online = False
    Else
      ' check model 2
      If OpenMemory Then
        Dim EmulatorWindow As Long
        Profile = ""
        
        EmulatorWindow = FindWindowA(vbNullString, "Daytona USA (Saturn Ads)")
        If EmulatorWindow Then
          Profile = "daytona"
          DriveOffset = pRAMBASE + CUSTOM_DRIVE
          LampOffset = pRAMBASE + CUSTOM_LAMP
        End If
          
        EmulatorWindow = FindWindowA(vbNullString, "Indianapolis 500 (Rev A, Twin, Newer rev)")
        If EmulatorWindow Then
          Profile = "indy500"
          DriveOffset = pRAMBASE + &HEBF74
          LampOffset = pRAMBASE + &H3C390
        End If
          
        EmulatorWindow = FindWindowA(vbNullString, "Sega Touring Car Championship (Rev A)")
        If EmulatorWindow Then
          Profile = "stcc"
          DriveOffset = pRAM2BASE + &HB2E0&
          LampOffset = pRAM2BASE + &HB2E4&
        End If
          
        EmulatorWindow = FindWindowA(vbNullString, "Sega Rally Championship")
        If EmulatorWindow Then
          Profile = "srallyc"
          DriveOffset = pRAM2BASE + &H2049&
          LampOffset = pRAM2BASE + &H204C&
        End If
        
        If Profile <> "" Then
          MODEL2_Online = True
        End If
      Else
        Dim drivByte As Byte
        Dim lampByte As Byte
        drivByte = &HFF
        lampByte = &HFF   'Rnd * 255
        'SendUDP UDP_Socket, Chr(&HA5) & Chr(drivByte) & Chr(lampByte), UDP_RemoteAddress
        drivByte = &H10
        'SendUDP UDP_Socket, Chr(&HA5) & Chr(drivByte) & Chr(lampByte), UDP_RemoteAddress
      End If
    End If
  Loop
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Call close_mame
  Winsock.Unload
  End
End Sub

Private Function TranslateDrive(ByRef OldData As Byte, ByVal NewData As Byte) As Boolean
  Dim TempData As Byte
  TranslateDrive = False
  Select Case Profile
    Case "outrun"
      Select Case NewData
        Case &H1 To &H7
          TempData = &H68 - (NewData And &H7)
        Case &H9 To &HF
          TempData = &H50 + (NewData And &H7)
        Case &H0, &H8
          TempData = &H10
        Case Else
          Exit Function
      End Select
      'Debug.Print Profile, Hex(NewData), "->", Hex(TempData)
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive = True
      End If
      Exit Function
    Case "vr"
      Dim CmdGroup As Byte
      Dim CmdForce As Byte
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      
      Select Case CmdGroup
        ' halve the force of any movements
        Case &H20, &H30, &H40, &H50, &H60
          TempData = CmdGroup + (CmdForce \ 2)
          Debug.Print Hex(NewData), Hex(TempData)
        Case Else
          TempData = NewData
      End Select
      
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive = True
      End If
      Exit Function

    Case "daytona"
      Select Case NewData
        Case &H90 To &H9F
          Exit Function
        Case Else
      End Select
    
    Case "srallyc"
      Dim Force As Byte
      Select Case NewData
        Case &H0
          TempData = &H10
          
        Case &H1 To &HF
          Exit Function
        
        Case &H10
          TempData = &H10
          
        Case &H15
          TempData = &H30
          
        Case &H80 To &H9F
          ' turn right
          Force = (NewData - &H80)
          TempData = &H60 + (Force / 2)
        Case &HC0 To &HDF
          ' turn left
          Force = (NewData - &HC0)
          TempData = &H50 + (Force / 2)
          
        Case Else
          TempData = NewData
          Debug.Print Hex(NewData)
      End Select
      
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive = True
      End If
      Exit Function
          
  End Select
  If OldData <> NewData Then
    OldData = NewData
    TranslateDrive = True
  End If
End Function

