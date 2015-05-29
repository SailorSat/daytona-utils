VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "ControlServer"
   ClientHeight    =   7200
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   9600
   LinkTopic       =   "Form1"
   ScaleHeight     =   7200
   ScaleWidth      =   9600
   Begin VB.CommandButton cmdReboot 
      BackColor       =   &H00800080&
      Caption         =   "REBOOT"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   480
      Style           =   1  'Graphical
      TabIndex        =   28
      Top             =   4080
      Width           =   1455
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   2400
      Top             =   1440
   End
   Begin VB.Frame fmGears 
      BackColor       =   &H00404040&
      Caption         =   "GEARS"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   2535
      Left            =   5280
      TabIndex        =   18
      Top             =   4080
      Width           =   1935
      Begin VB.OptionButton optGears 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "MANUAL"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   2
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   21
         Top             =   1800
         Width           =   1455
      End
      Begin VB.OptionButton optGears 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "AUTOMATIC"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   1
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   20
         Top             =   1080
         Width           =   1455
      End
      Begin VB.OptionButton optGears 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "SELECT"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   0
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   19
         Top             =   360
         Value           =   -1  'True
         Width           =   1455
      End
   End
   Begin VB.Frame fmHandicap 
      BackColor       =   &H00404040&
      Caption         =   "HANDICAP"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   2535
      Left            =   7440
      TabIndex        =   15
      Top             =   4080
      Width           =   1935
      Begin VB.OptionButton optHandicap 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "REALISTIC"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   2
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   23
         Top             =   1800
         Width           =   1455
      End
      Begin VB.OptionButton optHandicap 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "ARCADE"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   1
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   17
         Top             =   1080
         Width           =   1455
      End
      Begin VB.OptionButton optHandicap 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "SELECT"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   0
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   16
         Top             =   360
         Value           =   -1  'True
         Width           =   1455
      End
   End
   Begin VB.Frame fmMode 
      BackColor       =   &H00404040&
      Caption         =   "MODE"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   2535
      Left            =   7440
      TabIndex        =   12
      Top             =   1320
      Width           =   1935
      Begin VB.OptionButton optMode 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "TIME ATCK"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   2
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   22
         Top             =   1800
         Width           =   1455
      End
      Begin VB.OptionButton optMode 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "NORMAL"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   1
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   14
         Top             =   1080
         Width           =   1455
      End
      Begin VB.OptionButton optMode 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "MAJOR"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   0
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   13
         Top             =   360
         Value           =   -1  'True
         Width           =   1455
      End
   End
   Begin VB.Frame fmReset 
      BackColor       =   &H00404040&
      Caption         =   "CONTROL"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   4695
      Left            =   240
      TabIndex        =   10
      Top             =   120
      Width           =   1935
      Begin VB.CommandButton cmdShutdown 
         BackColor       =   &H00C00000&
         Caption         =   "SHUTDOWN"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   27
         Top             =   3240
         Width           =   1455
      End
      Begin VB.CommandButton cmdLock 
         BackColor       =   &H000000C0&
         Caption         =   "LOCK"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   26
         Top             =   2520
         Width           =   1455
      End
      Begin VB.CommandButton cmdRefresh 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
         Caption         =   "PING"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   25
         Top             =   360
         Width           =   1455
      End
      Begin VB.CommandButton cmdStart 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "START"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   24
         Top             =   1080
         Width           =   1455
      End
      Begin VB.CommandButton cmdReset 
         BackColor       =   &H0000C0C0&
         Caption         =   "RESET"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   11
         Top             =   1800
         Width           =   1455
      End
   End
   Begin VB.Frame fmTrack 
      BackColor       =   &H00404040&
      Caption         =   "TRACK"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   3255
      Left            =   3120
      TabIndex        =   5
      Top             =   1320
      Width           =   1935
      Begin VB.OptionButton optTrack 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "EXPERT"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   3
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   9
         Top             =   2520
         Width           =   1455
      End
      Begin VB.OptionButton optTrack 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "ADVANCED"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   2
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   8
         Top             =   1800
         Width           =   1455
      End
      Begin VB.OptionButton optTrack 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "BEGINNER"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   1
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   7
         Top             =   1080
         Width           =   1455
      End
      Begin VB.OptionButton optTrack 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "MAJOR"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   0
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   6
         Top             =   360
         Value           =   -1  'True
         Width           =   1455
      End
   End
   Begin VB.Frame fmStartup 
      BackColor       =   &H00404040&
      Caption         =   "STARTUP"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   2535
      Left            =   5280
      TabIndex        =   1
      Top             =   1320
      Width           =   1935
      Begin VB.OptionButton optStartup 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "EXTENDED"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   2
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   4
         Top             =   1800
         Width           =   1455
      End
      Begin VB.OptionButton optStartup 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "AUTOMATIC"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   1
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   3
         Top             =   1080
         Width           =   1455
      End
      Begin VB.OptionButton optStartup 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "NORMAL"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   495
         Index           =   0
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   360
         Value           =   -1  'True
         Width           =   1455
      End
   End
   Begin VB.Frame fmStatus 
      BackColor       =   &H00404040&
      Caption         =   "STATUS"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   1095
      Left            =   2400
      TabIndex        =   0
      Top             =   120
      Width           =   6975
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   495
         Index           =   7
         Left            =   6120
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   495
         Index           =   6
         Left            =   5280
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   495
         Index           =   5
         Left            =   4440
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   495
         Index           =   4
         Left            =   3600
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   495
         Index           =   3
         Left            =   2760
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   495
         Index           =   2
         Left            =   1920
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   495
         Index           =   1
         Left            =   1080
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   495
         Index           =   0
         Left            =   240
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private UDP_LocalAddress_RX As String
Private UDP_Socket_RX As Long

Private UDP_RemoteAddress_RX(0 To 7) As String
Private UDP_RemoteStatus(0 To 7) As Byte

Private Sub cmdLock_Click()
  WindowLock.Show vbModal, Window
End Sub

Private Sub cmdReboot_Click()
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_REBOOT
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub cmdRefresh_Click()
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_PING
  baBuffer(1) = CTRL_STATUS_OFFLINE
  baBuffer(2) = 0 ' <id>
  
  Dim sBuffer As String
  
  Dim Index As Integer
  For Index = 0 To 7
    baBuffer(2) = Index
    sBuffer = StrConv(baBuffer, vbUnicode)
    If UDP_RemoteAddress_RX(Index) <> "" Then
      Winsock.SendUDP UDP_Socket_RX, sBuffer, UDP_RemoteAddress_RX(Index)
    End If
  Next
End Sub

Private Sub cmdReset_Click()
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_RESET
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub cmdShutdown_Click()
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_SHUTDOWN
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub cmdStart_Click()
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_START
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optGears_Click(Index As Integer)
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_GEARS
  Select Case Index
    Case 0
      baBuffer(1) = CTRL_GEARS_SELECT
    Case 1
      baBuffer(1) = CTRL_GEARS_AUTO
    Case 2
      baBuffer(1) = CTRL_GEARS_MANUAL
  End Select
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optHandicap_Click(Index As Integer)
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_HANDICAP
  Select Case Index
    Case 0
      baBuffer(1) = CTRL_HANDICAP_SELECT
    Case 1
      baBuffer(1) = CTRL_HANDICAP_ARCADE
    Case 2
      baBuffer(1) = CTRL_HANDICAP_REAL
  End Select
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optMode_Click(Index As Integer)
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_GAMEMODE
  Select Case Index
    Case 0
      baBuffer(1) = CTRL_GAMEMODE_MAJOR
    Case 1
      baBuffer(1) = CTRL_GAMEMODE_NORMAL
    Case 2
      baBuffer(1) = CTRL_GAMEMODE_TIMEATCK
  End Select
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optStartup_Click(Index As Integer)
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_STARTUP
  Select Case Index
    Case 0
      baBuffer(1) = CTRL_STARTUP_NORMAL
    Case 1
      baBuffer(1) = CTRL_STARTUP_AUTO
    Case 2
      baBuffer(1) = CTRL_STARTUP_EXTEND
  End Select
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optTrack_Click(Index As Integer)
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_TRACK
  Select Case Index
    Case 0
      baBuffer(1) = CTRL_TRACK_MAJOR
    Case 1
      baBuffer(1) = CTRL_TRACK_BEGINNER
    Case 2
      baBuffer(1) = CTRL_TRACK_ADVANCED
    Case 3
      baBuffer(1) = CTRL_TRACK_EXPERT
  End Select
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Dim Host As String
  Dim Port As Long
  Dim Index As Integer
  
  Me.Move 0, 0
  Winsock.Load
  
  ' Local-RX (control)
  Host = ReadIni("control.ini", "server", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("control.ini", "server", "localport", "23456"))
  UDP_LocalAddress_RX = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress_RX = "" Then
    MsgBox "Something went wrong! #ADDR_RX", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If

  UDP_Socket_RX = Winsock.ListenUDP(UDP_LocalAddress_RX)
  If UDP_Socket_RX = -1 Then
    MsgBox "Something went wrong! #SOCK_RX", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If
  
  ' Remote-RX (control)
  For Index = 0 To 7
    Host = ReadIni("control.ini", "server", "remotehost" & Index, "")
    Port = CLng(ReadIni("control.ini", "server", "remoteport" & Index, "23456"))
    UDP_RemoteAddress_RX(Index) = Winsock.WSABuildSocketAddress(Host, Port)
    UDP_RemoteStatus(Index) = CTRL_STATUS_OFFLINE
  Next
  
  Timer.Enabled = True
  Timer_Timer
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Unload
  End
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If Len(sBuffer) < 32 Then Exit Sub
  Dim baBuffer() As Byte
  baBuffer = StrConv(sBuffer, vbFromUnicode)
  
  Dim Index As Integer
  
  Select Case baBuffer(0)
    Case CTRL_CMD_PING
      If baBuffer(2) < 8 Then
        Index = baBuffer(2)
        UDP_RemoteStatus(Index) = baBuffer(1)
        Select Case UDP_RemoteStatus(Index)
          Case CTRL_STATUS_ONLINE
            shStatus(Index).FillColor = &HC0C0&
          Case CTRL_STATUS_INGAME
            shStatus(Index).FillColor = &HC000&
          Case Else
            shStatus(Index).FillColor = &HC00000
        End Select
      End If
  End Select
End Sub

Public Sub SendToClients(sBuffer As String, MinimumStatus As Byte)
  Dim Index As Integer
  For Index = 0 To 7
    If UDP_RemoteStatus(Index) >= MinimumStatus Then
      Winsock.SendUDP UDP_Socket_RX, sBuffer, UDP_RemoteAddress_RX(Index)
    End If
  Next
End Sub

Private Sub Timer_Timer()
  cmdRefresh_Click
End Sub
