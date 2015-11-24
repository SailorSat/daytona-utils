VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'Kein
   Caption         =   "DriveFeedback"
   ClientHeight    =   3450
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6105
   LinkTopic       =   "Form1"
   ScaleHeight     =   3450
   ScaleWidth      =   6105
   Begin VB.TextBox txtLamp 
      Alignment       =   2  'Zentriert
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1320
      TabIndex        =   1
      Text            =   "00"
      Top             =   360
      Width           =   375
   End
   Begin VB.TextBox txtDrive 
      Alignment       =   2  'Zentriert
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   480
      TabIndex        =   0
      Text            =   "00"
      Top             =   360
      Width           =   375
   End
   Begin VB.Label lblDebug 
      Alignment       =   2  'Zentriert
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   480
      TabIndex        =   2
      Top             =   960
      Width           =   1215
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private CommandUsed(0 To 255) As Boolean

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long
Private UDP_Buffer As String

Private MODEL2_Online As Boolean
Private MODEL3_Online As Boolean

Private Profile As String

Private DriveData As Byte
Private DriveReal As Byte
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
  Me.Move 480, 0 ', 240, 240
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
      ProcessDrive SomeData
  
      RtlMoveMemory SomeData, MAME_LampData, 1
      ProcessLamp SomeData
    ElseIf MODEL2_Online Then
      While OpenMemory
        Sleep 1
        DataChanged = False
    
        SomeData = ReadByte(DriveOffset)
        ProcessDrive SomeData
        
        SomeData = ReadByte(LampOffset)
        ProcessLamp SomeData
    
        DoEvents
      Wend
      MODEL2_Online = False
      SendDrive 0
      SendLamp 0
    ElseIf MODEL3_Online Then
      While OpenMemoryModel3
        Sleep 1
    
        SomeData = ReadByte(DriveOffset)
        ProcessDrive SomeData
    
        SomeData = ReadByte(LampOffset)
        ProcessLamp SomeData
    
        DoEvents
      Wend
      MODEL3_Online = False
      SendDrive 0
      SendLamp 0
    Else
      If OpenMemory Then
        CheckProfile
      ElseIf OpenMemoryModel3 Then
        CheckProfileModel3
      End If
    End If
  Loop
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Call close_mame
  Winsock.Unload
  End
End Sub

Private Sub CheckProfile()
  ' check model 2
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
    
  EmulatorWindow = FindWindowA(vbNullString, "Sega Touring Car Championship")
  If EmulatorWindow Then
    Profile = "stcc"
    DriveOffset = pRAM2BASE + &HB2E0&
    LampOffset = pRAM2BASE + &HB2E4&
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
End Sub

Private Sub CheckProfileModel3()
  ' check model 3
  Dim EmulatorWindow As Long
  Profile = ""
  
  EmulatorWindow = FindWindowA(vbNullString, "Supermodel - Daytona USA 2 Battle on the Edge")
  If EmulatorWindow Then
    Profile = "daytona2"
    DriveOffset = pRAMBASE + &H1084B1
    LampOffset = pRAMBASE + &H1016EF
  End If

  EmulatorWindow = FindWindowA(vbNullString, "Supermodel - Daytona USA 2 Power Edition")
  If EmulatorWindow Then
    Profile = "daytona2"
    DriveOffset = pRAMBASE + &H737BBE
    LampOffset = pRAMBASE + &H73780E
  End If

  EmulatorWindow = FindWindowA(vbNullString, "Supermodel - Scud Race (Australia)")
  If EmulatorWindow Then
    Profile = "daytona2"
    DriveOffset = pRAMBASE + &H107191
    LampOffset = pRAMBASE + &H1000E7
  End If
  
  EmulatorWindow = FindWindowA(vbNullString, "Supermodel - Scud Race (Export)")
  If EmulatorWindow Then
    Profile = "daytona2"
    DriveOffset = pRAMBASE + &H107191
    LampOffset = pRAMBASE + &H1000E7
  End If
  
  EmulatorWindow = FindWindowA(vbNullString, "Supermodel - Scud Race (Japan)")
  If EmulatorWindow Then
    Profile = "daytona2"
    DriveOffset = pRAMBASE + &H105191
    LampOffset = pRAMBASE + &H1000E7
  End If
  
  EmulatorWindow = FindWindowA(vbNullString, "Supermodel - Scud Race Plus")
  If EmulatorWindow Then
    Profile = "daytona2"
    DriveOffset = pRAMBASE + &H107191
    LampOffset = pRAMBASE + &H1000E7
  End If
  
  If Profile <> "" Then
    If ReadByte(DriveOffset) = &H0 Then
      MODEL3_Online = False
      Profile = ""
      CloseProcess
      Sleep 250
    Else
      MODEL3_Online = True
    End If
  End If
End Sub

Private Function TranslateDrive(ByRef OldData As Byte, ByVal NewData As Byte) As Boolean
  Dim TempData As Byte
  TranslateDrive = False
  
  Dim CmdGroup As Byte
  Dim CmdForce As Byte
  
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
      lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive = True
      End If
      Exit Function
    Case "vr", "vformula"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      
      Select Case CmdGroup
        ' halve the force of any movements
        Case &H20, &H30, &H40, &H50, &H60
          TempData = CmdGroup + (CmdForce \ 2)
          lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H0, &H10, &H80
          ' direct
          TempData = NewData
        Case &H70, &H90
          '0x7x airbags(VR)
          '0x7x cylinder(VF)
          '0x9x  taco meter (VF)
          Exit Function
        Case Else
          TempData = NewData
          Debug.Print Hex(NewData)
      End Select
      
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive = True
      End If
      Exit Function

    Case "daytona"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      Select Case CmdGroup
        Case &H0, &H10, &H20, &H30, &H40, &H50, &H60, &H80
          TempData = NewData
        Case &H70, &HC0, &HD0, &HE0
          ' 0x7x = "DELUXE CABINET"
          ' 0xCx = CYLINDER
          ' 0xDx = QUICK BREATH
          ' 0xEx = TOWER SIGNAL
          Exit Function
        Case Else
          Debug.Print Hex(NewData)
      End Select
    
    Case "srallyc"
      Select Case NewData
        Case &H0
          TempData = &H10
          
        Case &H1 To &HF, &H7E
          Exit Function
        
        Case &H10
          TempData = &H7
          
        Case &H15
          TempData = &H30
          
        Case &H80 To &H9F
          ' turn right
          CmdForce = (NewData - &H80)
          TempData = &H60 + (CmdForce / 4)
          lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &HC0 To &HDF
          ' turn left
          CmdForce = (NewData - &HC0)
          TempData = &H50 + (CmdForce / 4)
          lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
          
        Case Else
          TempData = NewData
          Debug.Print Hex(NewData)
      End Select
      
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive = True
      End If
      Exit Function
      
    Case "daytona2"
'      If Not CommandUsed(NewData) Then
'        CommandUsed(NewData) = True
'        Debug.Print "new cmd", Hex(NewData)
'      End If
      
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      
      Select Case CmdGroup
        Case &H0
          ' ?
          Exit Function
        Case &H10
          ' centering
          TempData = &H30 + CmdForce
          lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H20
          ' friction/clutch
          TempData = NewData
        Case &H30
          ' uncentering
          TempData = &H40 + CmdForce
          lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H40
          ' ?
          Exit Function
        Case &H50, &H60
          ' roll left, roll right
          TempData = CmdGroup + CmdForce
          lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H70
          ' set force strength
          Exit Function
        Case &H80
          '80 motor off
          '81 roll Left
          '82 roll Right
          '83 clutch on
          '84 clutch off
          '85 center
          '86 ?
          '87 ?
          Exit Function
        
        Case &H90
          ' ?
          Exit Function

        Case &HA0
          ' ?
          Exit Function
        
        Case &HB0
          ' ?
          Exit Function
        
        Case &HC0
          ' Game State
          TempData = &H0 + CmdForce
          lblDebug.Caption = LeadZero(Hex(NewData)) & " > " & LeadZero(Hex(TempData))
          
        Case &HD0
          ' Page Select
          TempData = &H80 + CmdForce
          lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
          
        Case &HE0
          ' ?
          Exit Function
          
        Case &HF0
          ' ?
          Exit Function
        
        Case Else
          TempData = NewData
      End Select
      
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive = True
      End If
      Exit Function
          
          
  End Select
  If OldData <> NewData Then
    OldData = NewData
    Debug.Print Hex(NewData)
    TranslateDrive = True
  End If
End Function

Private Sub txtDrive_KeyPress(KeyAscii As Integer)
  If KeyAscii = 13 Then
    KeyAscii = 0
    Dim DummyData As Byte
    On Error Resume Next
    DummyData = CByte("&H" & txtDrive)
    On Error GoTo 0
    If Err Then
      Err.Clear
      txtDrive.Text = "00"
    Else
      DriveData = DummyData
      SendDrive (DriveData)
    End If
  End If
End Sub

Private Sub txtLamp_KeyPress(KeyAscii As Integer)
  If KeyAscii = 13 Then
    KeyAscii = 0
    Dim DummyData As Byte
    On Error Resume Next
    DummyData = CByte("&H" & txtLamp)
    On Error GoTo 0
    If Err Then
      Err.Clear
      txtLamp.Text = "00"
    Else
      LampData = DummyData
      SendLamp (LampData)
    End If
  End If
End Sub

Private Sub ProcessDrive(Data As Byte)
  If Data <> DriveData Then
    DriveData = Data
    If TranslateDrive(DriveReal, Data) Then
      SendDrive DriveReal
    End If
  End If
End Sub

Private Sub SendDrive(Data As Byte)
  UDP_Buffer = Chr(&H1) & Chr(Data)
  SendUDP UDP_Socket, UDP_Buffer, UDP_RemoteAddress
  txtDrive.Text = LeadZero(Hex(Data))
End Sub

Private Sub ProcessLamp(Data As Byte)
  If Data <> LampData Then
    LampData = Data
    SendLamp LampData
  End If
End Sub

Private Sub SendLamp(Data As Byte)
  UDP_Buffer = Chr(&H2) & Chr(Data)
  SendUDP UDP_Socket, UDP_Buffer, UDP_RemoteAddress
  txtLamp.Text = LeadZero(Hex(Data))
End Sub

Private Function LeadZero(Data As String) As String
  If Len(Data) = 1 Then
    LeadZero = "0" & Data
  Else
    LeadZero = Data
  End If
End Function
