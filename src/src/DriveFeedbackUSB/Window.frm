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
   Begin VB.TextBox txtPwm 
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
      Left            =   600
      TabIndex        =   3
      Text            =   "00"
      Top             =   120
      Width           =   375
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Interval        =   4
      Left            =   480
      Top             =   0
   End
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

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Window.Move 480, 0
  If ReadIni("drive.ini", "feedback", "hidden", "false") = "true" Then
    Window.Hide
  Else
    Window.Show
  End If
  
  Feedback.Load
  
  Feedback.FeedbackDebug = True
  DriveTranslation.TranslationDebug = True
  
  Timer.Enabled = True
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Feedback.Unload
  End
End Sub

Private Sub Timer_Timer()
  Feedback.Timer
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
      OverrideDrive DummyData
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
      OverrideLamps DummyData
    End If
  End If
End Sub

Private Sub txtPwm_KeyPress(KeyAscii As Integer)
  If KeyAscii = 13 Then
    KeyAscii = 0
    Dim DummyData As Byte
    On Error Resume Next
    DummyData = CByte("&H" & txtPwm)
    On Error GoTo 0
    If Err Then
      Err.Clear
      txtPwm.Text = "00"
    Else
      OverridePwm DummyData
    End If
  End If
End Sub
