VERSION 5.00
Begin VB.Form Window 
   Caption         =   "Recorder"
   ClientHeight    =   840
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   3480
   LinkTopic       =   "Form1"
   ScaleHeight     =   840
   ScaleWidth      =   3480
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdRec 
      Caption         =   "REC"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   720
      TabIndex        =   0
      Top             =   120
      Width           =   615
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00000040&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00000000&
      FillColor       =   &H00FFFFFF&
      Height          =   375
      Left            =   120
      Shape           =   3  'Circle
      Top             =   120
      Width           =   375
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim STREAM_Socket As Long
Dim STREAM_Record As Boolean
Dim STREAM_File As Long

Private Sub cmdRec_Click()
  If STREAM_Record Then
    ' stop record
    STREAM_Record = False
    Close #STREAM_File
    Shape1.BackColor = &H40&
  Else
    ' start record
    STREAM_File = FreeFile
    Open App.Path & "\recording\" & Format(Now, "yyyy-mm-dd_HH-MM-SS") & ".rec" For Binary As #STREAM_File
    STREAM_Record = True
    Shape1.BackColor = &HFF&
  End If
End Sub

Private Sub Form_Load()
  Winsock.Load

  Dim Host As String, Port As Long, UDP_LocalAddress As String
  Host = ReadIni("recorder.ini", "recorder", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("recorder.ini", "recorder", "localport", "15612"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Error", vbOKOnly + vbCritical, "Recorder"
    End
  End If
  
  STREAM_Record = False
  STREAM_Socket = Winsock.ListenUDP(UDP_LocalAddress)
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Disconnect STREAM_Socket
  Winsock.Unload
  If STREAM_Record Then Close #STREAM_File
  End
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If STREAM_Record Then
    Put #STREAM_File, , sBuffer
  End If
End Sub

