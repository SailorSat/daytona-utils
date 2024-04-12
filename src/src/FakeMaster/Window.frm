VERSION 5.00
Begin VB.Form Window 
   BorderStyle     =   4  'Festes Werkzeugfenster
   Caption         =   "Form1"
   ClientHeight    =   585
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   1785
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   585
   ScaleWidth      =   1785
   StartUpPosition =   3  'Windows-Standard
   Begin VB.Timer Timer 
      Interval        =   1000
      Left            =   1800
      Top             =   120
   End
   Begin VB.CommandButton cmdGo 
      Caption         =   "Go!"
      Height          =   375
      Left            =   600
      TabIndex        =   0
      Top             =   120
      Width           =   1095
   End
   Begin VB.Shape shStatus 
      BackColor       =   &H00000040&
      BackStyle       =   1  'Undurchsichtig
      Height          =   375
      Left            =   120
      Shape           =   4  'Gerundetes Rechteck
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

Private FAKE_Status As Byte
Private FAKE_Size As Byte
Private FAKE_READY As Boolean

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long

Private UDP_Buffer As String

Private NET_Framerate As Long
Private NET_FlipFlop As Long

Private NET_Resolution As Currency

Private LastFrame As String

Private isRunning As Boolean

Private hEventTimer As Long

Private Sub cmdGo_Click()
  Winsock.SendUDP UDP_Socket, SendFrame0, UDP_RemoteAddress
End Sub


Private Sub Form_Load()
  Me.Show
  DoEvents
  
  ' Init Winsock
  Winsock.Load
    
  Dim Host As String
  Dim Port As Long
  
  Host = ReadIni("fakemaster.ini", "network", "LocalHost", "127.0.0.1")
  Port = CLng(ReadIni("fakemaster.ini", "network", "LocalPort", "7001"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #UDP_LocalAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If
  
  Host = ReadIni("fakemaster.ini", "network", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("fakemaster.ini", "network", "RemotePort", "7000"))
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

  FAKE_READY = True
  
  UDP_Buffer = ""
  
  MainLoop
End Sub

Private Sub MainLoop()
  isRunning = True
  
  ' prepare fps limiter
  SetupTimer 57
  
  ' main loop
  Dim delta As Single
  While isRunning
    ' throttle speed
    delta = WaitTimer
    
    ' VB shenanigans
    DoEvents
    
    ' send data if available
    If UDP_Buffer <> "" Then
      Winsock.SendUDP UDP_Socket, UDP_Buffer, UDP_RemoteAddress
      UDP_Buffer = ""
    
      ' update fps counter
      NET_Framerate = NET_Framerate + 1
    End If
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
  If FAKE_READY Then
    Dim baBuffer() As Byte
    baBuffer() = StrConv(sBuffer, vbFromUnicode)
    If baBuffer(4) = 2 Then
      UDP_Buffer = sBuffer
    Else
      Winsock.SendUDP UDP_Socket, sBuffer, UDP_RemoteAddress
    End If
  Else
    Winsock.SendUDP UDP_Socket, ParseFrame(sBuffer), UDP_RemoteAddress
  End If
End Sub


Public Function ParseFrame(sBuffer As String) As String
  Dim lOffset As Long
  Dim lIndex As Long
  
  ' convert from wide-string to byte array
  Dim baBuffer() As Byte
  baBuffer() = StrConv(sBuffer, vbFromUnicode)

  ' check header status
  Select Case baBuffer(4)
    Case 0
'      Open App.Path & "\00.bin" For Binary As #1
'      Put #1, , baBuffer
'      Close #1
      ParseFrame = SendFrame1(baBuffer(5))
    
    Case 1
'      Open App.Path & "\01.bin" For Binary As #1
'      Put #1, , baBuffer
'      Close #1
      ParseFrame = SendFrame2
       
    Case 2
'      Open App.Path & "\02.bin" For Binary As #1
'      Put #1, , baBuffer
'      Close #1
      ParseFrame = SendFrame2
  
  End Select
End Function


Public Function SendFrame0() As String
  FAKE_READY = False
  
  Dim baBuffer() As Byte
  baBuffer() = StrConv(String(3589, Chr(0)), vbFromUnicode)

  baBuffer(0) = &H4D
  baBuffer(1) = &H32
  baBuffer(2) = &H45
  baBuffer(3) = &H4D
  baBuffer(4) = &H0
  
  baBuffer(5) = &H1
  SendFrame0 = StrConv(baBuffer, vbUnicode)
End Function


Public Function SendFrame1(Size As Byte) As String
  Dim baBuffer() As Byte
  baBuffer() = StrConv(String(3589, Chr(0)), vbFromUnicode)

  baBuffer(0) = &H4D
  baBuffer(1) = &H32
  baBuffer(2) = &H45
  baBuffer(3) = &H4D
  baBuffer(4) = &H1
  
  baBuffer(5) = Size - 1
  baBuffer(6) = 2
  SendFrame1 = StrConv(baBuffer, vbUnicode)
End Function


Public Function SendFrame2() As String
  FAKE_READY = True
  
  Dim baBuffer() As Byte
  baBuffer() = StrConv(String(3589, Chr(0)), vbFromUnicode)

  baBuffer(0) = &H4D
  baBuffer(1) = &H32
  baBuffer(2) = &H45
  baBuffer(3) = &H4D
  baBuffer(4) = &H2
  
  SendFrame2 = StrConv(baBuffer, vbUnicode)
End Function


Private Sub Timer_Timer()
  Me.Caption = NET_Framerate
  NET_Framerate = 0
End Sub
