VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "DriveFeedbackUSB"
   ClientHeight    =   855
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1455
   LinkTopic       =   "Form1"
   ScaleHeight     =   855
   ScaleWidth      =   1455
   Begin VB.TextBox txtLamp 
      Alignment       =   2  'Center
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
      Left            =   960
      TabIndex        =   1
      Text            =   "00"
      Top             =   120
      Width           =   375
   End
   Begin VB.TextBox txtDrive 
      Alignment       =   2  'Center
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
      Left            =   120
      TabIndex        =   0
      Text            =   "00"
      Top             =   120
      Width           =   375
   End
   Begin VB.Label lblDebug 
      Alignment       =   2  'Center
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
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   1215
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' internal buffer
Private DriveData As Byte
Private DriveReal As Byte
Private LampsData As Byte

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Dim SomeData As Byte

  If ReadIni("drive.ini", "feedback", "hidden", "false") = "true" Then
    Me.BackColor = RGB(255, 0, 0)
    Me.Move 480, 0, 0, 0
    Me.Hide
  Else
    Me.BackColor = RGB(255, 0, 0)
    Me.Move 480, 0 ', 240, 240
    Me.Show
  End If
  
  Model3Mode = CBool(ReadIni("drive.ini", "feedback", "model3", "false"))
  DebugMode = CBool(ReadIni("drive.ini", "feedback", "debug", "false"))
  
  If DebugMode Then
    Open App.Path & "\debug.txt" For Output As #1
  End If
  
  Me.BackColor = RGB(255, 255, 0)
  
  MAME_Online = False
  M2EM_Online = False
  
  ' init mame hook
  Call init_mame(ByVal 1, "Test", AddressOf mame_start, AddressOf mame_stop, AddressOf mame_copydata, AddressOf mame_updatestate)
  
  Do
    DoEvents
    Sleep 10
    If MAME_Online Then
      Profile = MAME_Profile
      While MAME_Online
        SomeData = Get_MAME_DriveData
        ProcessDrive SomeData
    
        SomeData = Get_MAME_LampsData
        ProcessLamps SomeData
        
        Sleep 2
        DoEvents
      Wend
      SendDrive 0
      SendLamps 0
    ElseIf M2EM_Online Then
      While M2EM_Online
        SomeData = Get_M2EM_DriveData
        ProcessDrive SomeData
        
        SomeData = Get_M2EM_LampsData
        ProcessLamps SomeData
    
        Sleep 2
        DoEvents
      Wend
      SendDrive 0
      SendLamps 0
    Else
      Check_M2EM
    End If
  Loop
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Call close_mame
  If DebugMode Then
    Close #1
  End If
  End
End Sub

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
      LampsData = DummyData
      SendLamps LampsData
    End If
  End If
End Sub

Private Sub ProcessDrive(Data As Byte)
  If Data <> DriveData Then
    DriveData = Data
    If DebugMode Then
      Print #1, Hex(Data)
    End If
    If TranslateDrive(DriveReal, Data) Then
      SendDrive DriveReal
    End If
  End If
End Sub

Private Sub SendDrive(Data As Byte)
  If OpenDriveChannel Then
    WriteDriveData 1, Data
  End If
  txtDrive.Text = LeadZero(Hex(Data), 2)
End Sub

Private Sub ProcessLamps(Data As Byte)
  If Data <> LampsData Then
    LampsData = Data
    SendLamps LampsData
  End If
End Sub

Private Sub SendLamps(Data As Byte)
  If OpenDriveChannel Then
    WriteDriveData 2, Data
  End If
  txtLamp.Text = LeadZero(Hex(Data), 2)
End Sub
