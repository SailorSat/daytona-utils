VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "ControlClient"
   ClientHeight    =   2700
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   5685
   LinkTopic       =   "Form1"
   ScaleHeight     =   2700
   ScaleWidth      =   5685
   Begin VB.TextBox txtDebug 
      Height          =   2415
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   120
      Width           =   5415
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private SystemPath As String

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long

Private FlipFlop As Boolean

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Dim Host As String
  Dim Port As Long
  
  Me.Move Screen.Width - Me.Width, 0
  Winsock.Load
  
  ' System Path
  SystemPath = ReadIni("control.ini", "client", "systempath", "c:\windows\system32")
  
  ' Local (control)
  Host = ReadIni("control.ini", "client", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("control.ini", "client", "localport", "23456"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #ADDR", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If

  UDP_Socket = Winsock.ListenUDP(UDP_LocalAddress)
  If UDP_Socket = -1 Then
    MsgBox "Something went wrong! #SOCK", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Unload
  End
End Sub

Public Sub DebugPrint(Text As String)
  txtDebug.Text = txtDebug.Text & vbCrLf & Text
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If Len(sBuffer) < 32 Then
    DebugPrint "*** invalid packet received - packet length != 32"
    Exit Sub
  End If
  UDP_RemoteAddress = sAddress
  
  Dim baBuffer() As Byte
  baBuffer = StrConv(sBuffer, vbFromUnicode)
  Select Case baBuffer(0)
    Case CTRL_CMD_PING
      DebugPrint "CTRL_CMD_PING - returning CTRL_STATUS_ONLINE"
      baBuffer(1) = CTRL_STATUS_ONLINE
      sBuffer = StrConv(baBuffer, vbUnicode)
      Winsock.SendUDP lHandle, sBuffer, UDP_RemoteAddress
    
    Case CTRL_CMD_RESET
      DebugPrint "CTRL_CMD_RESET - reseting daytona"
    
    Case CTRL_CMD_STARTUP
      Select Case baBuffer(1)
        Case CTRL_STARTUP_NORMAL
          DebugPrint "CTRL_CMD_STARTUP - set CTRL_STARTUP_NORMAL"
        Case CTRL_STARTUP_AUTO
          DebugPrint "CTRL_CMD_STARTUP - set CTRL_STARTUP_AUTO"
        Case CTRL_STARTUP_EXTEND
          DebugPrint "CTRL_CMD_STARTUP - set CTRL_STARTUP_EXTEND"
        Case Else
          DebugPrint "CTRL_CMD_STARTUP - invalid packet received"
      End Select
      
    Case CTRL_CMD_START
      DebugPrint "CTRL_CMD_START - starting a game"
      
    Case CTRL_CMD_TRACK
      Select Case baBuffer(1)
        Case CTRL_TRACK_MAJOR
          DebugPrint "CTRL_CMD_TRACK - set CTRL_TRACK_MAJOR"
        Case CTRL_TRACK_BEGINNER
          DebugPrint "CTRL_CMD_TRACK - forcing CTRL_TRACK_BEGINNER"
        Case CTRL_TRACK_ADVANCED
          DebugPrint "CTRL_CMD_TRACK - forcing CTRL_TRACK_ADVANCED"
        Case CTRL_TRACK_EXPERT
          DebugPrint "CTRL_CMD_TRACK - forcing CTRL_TRACK_EXPERT"
        Case Else
          DebugPrint "CTRL_CMD_TRACK - invalid packet received"
      End Select
      
    Case CTRL_CMD_GEARS
      Select Case baBuffer(1)
        Case CTRL_GEARS_SELECT
          DebugPrint "CTRL_CMD_GEARS - set CTRL_GEARS_SELECT"
        Case CTRL_GEARS_AUTO
          DebugPrint "CTRL_CMD_GEARS - forcing CTRL_GEARS_AUTO"
        Case CTRL_GEARS_MANUAL
          DebugPrint "CTRL_CMD_GEARS - forcing CTRL_GEARS_MANUAL"
        Case Else
          DebugPrint "CTRL_CMD_GEARS - invalid packet received"
      End Select
      
    Case CTRL_CMD_GAMEMODE
      Select Case baBuffer(1)
        Case CTRL_GAMEMODE_MAJOR
          DebugPrint "CTRL_CMD_GAMEMODE - set CTRL_GAMEMODE_MAJOR"
        Case CTRL_GAMEMODE_NORMAL
          DebugPrint "CTRL_CMD_GAMEMODE - forcing CTRL_GAMEMODE_NORMAL"
        Case CTRL_GAMEMODE_TIMEATCK
          DebugPrint "CTRL_CMD_GAMEMODE - forcing CTRL_GAMEMODE_TIMEATCK"
        Case Else
          DebugPrint "CTRL_CMD_GAMEMODE - invalid packet received"
      End Select
      
    Case CTRL_CMD_HANDICAP
      Select Case baBuffer(1)
        Case CTRL_HANDICAP_SELECT
          DebugPrint "CTRL_CMD_HANDICAP - set CTRL_HANDICAP_SELECT"
        Case CTRL_HANDICAP_ARCADE
          DebugPrint "CTRL_CMD_HANDICAP - forcing CTRL_HANDICAP_ARCADE"
        Case CTRL_HANDICAP_REAL
          DebugPrint "CTRL_CMD_HANDICAP - forcing CTRL_HANDICAP_REAL"
        Case Else
          DebugPrint "CTRL_CMD_HANDICAP - invalid packet received"
      End Select
      
    Case CTRL_CMD_SHUTDOWN
      DebugPrint "CTRL_CMD_SHUTDOWN - windows shutdown"
      
    Case CTRL_CMD_REBOOT
      DebugPrint "CTRL_CMD_REBOOT - windows reboot"
  
  End Select
End Sub
