VERSION 5.00
Begin VB.Form Window 
   BorderStyle     =   4  'Fixed ToolWindow
   ClientHeight    =   615
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   660
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   615
   ScaleWidth      =   660
   StartUpPosition =   3  'Windows Default
   Begin VB.Shape shStatus 
      BackColor       =   &H00000040&
      BackStyle       =   1  'Opaque
      Height          =   375
      Left            =   120
      Shape           =   4  'Rounded Rectangle
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

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long

Private TargetSpeed As Single
Private Ticks As Long

Private isRunning As Boolean

Private Sub Form_Load()
  Me.Hide
  DoEvents
  
  ' Init Winsock
  Winsock.Load
    
  Dim Host As String
  Dim Port As Long
  
  Host = ReadIni("throttle.ini", "network", "LocalHost", "127.0.0.1")
  Port = CLng(ReadIni("throttle.ini", "network", "LocalPort", "7001"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #UDP_LocalAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If
  
  Host = ReadIni("throttle.ini", "network", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("throttle.ini", "network", "RemotePort", "7000"))
  UDP_RemoteAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_RemoteAddress = "" Then
    MsgBox "Something went wrong! #UDP_RemoteAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If

  UDP_Socket = ListenUDP(UDP_LocalAddress)
  If UDP_Socket = -1 Then
    MsgBox "Something went wrong! #UDP_Socket", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If

  ' target framerate
  Host = ReadIni("throttle.ini", "speed", "fps", "58.0")
  If CSng("50,0") = 50 Then
    ' comma
    TargetSpeed = CSng(Replace(Host, ".", ","))
  Else
    ' dot
    TargetSpeed = CSng(Replace(Host, ",", "."))
  End If
  
  ' set 1st core high priority
  Port = GetCurrentProcess
  SetProcessAffinityMask Port, &H1&
  SetPriorityClass Port, HIGH_PRIORITY_CLASS
  
  MainLoop
End Sub


Private Sub MainLoop()
  isRunning = True
  
  ' prepare fps limiter
  SetupTimer TargetSpeed

  ' main loop
  Dim delta As Single
  While isRunning
    ' throttle speed
    delta = WaitTimer
    Ticks = 0
    
    ' VB shenanigans
    DoEvents
  Wend

  Winsock.Unload
  End
End Sub


Private Sub Form_Unload(Cancel As Integer)
  isRunning = False

  Winsock.Unload
  End
End Sub


Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If Ticks = 0 Then
    Winsock.SendUDP UDP_Socket, sBuffer, UDP_RemoteAddress
    Ticks = 1
  End If
End Sub
