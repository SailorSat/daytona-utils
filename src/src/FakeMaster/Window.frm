VERSION 5.00
Begin VB.Form Window 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Form1"
   ClientHeight    =   1095
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   2295
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1095
   ScaleWidth      =   2295
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command2 
      Caption         =   "+"
      Height          =   255
      Left            =   1680
      TabIndex        =   3
      Top             =   600
      Width           =   255
   End
   Begin VB.CommandButton Command1 
      Caption         =   "-"
      Height          =   255
      Left            =   1320
      TabIndex        =   2
      Top             =   600
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Left            =   1800
      TabIndex        =   1
      Top             =   120
      Width           =   255
   End
   Begin VB.Timer Timer16 
      Interval        =   16
      Left            =   600
      Top             =   600
   End
   Begin VB.Timer Timer 
      Interval        =   1000
      Left            =   120
      Top             =   600
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

Private FAKE_Status As Byte
Private FAKE_Size As Byte
Private FAKE_READY As Boolean

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long

Private UDP_Buffer As String

Private NET_Framerate As Long
Private NET_Delay As Long
Private NET_FlipFlop As Long

Private NET_Resolution As Currency

Private LastFrame As String

Private Sub cmdGo_Click()
  Winsock.SendUDP UDP_Socket, SendFrame0, UDP_RemoteAddress
End Sub

Private Sub Command1_Click()
  NET_Delay = NET_Delay - 1
  If NET_Delay = 0 Then NET_Delay = 1
End Sub

Private Sub Command2_Click()
  NET_Delay = NET_Delay + 1
End Sub

Private Sub Form_Load()
  Me.Show
  DoEvents
  
  NET_Delay = 3
  
  QueryPerformanceFrequency NET_Resolution
  Debug.Print "1000ms ~= " & NET_Resolution

  ' Init Winsock
  Winsock.Load
    
  Dim Host As String
  Dim Port As Long
  
  Host = ReadIni("fakemaster.ini", "network", "LocalHost", "127.0.0.1")
  Port = CLng(ReadIni("fakemaster.ini", "network", "LocalPort", "7000"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #UDP_LocalAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If
  
  Host = ReadIni("fakemaster.ini", "network", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("fakemaster.ini", "network", "RemotePort", "7002"))
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
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Unload
  End
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If FAKE_READY Then
    'Sleep NET_Delay
    'SleepHigh 0.017 '0.01667
    If Mid(sBuffer, 5, 1) = Chr(2) Then
      If LastFrame = Mid(sBuffer, 16, 1) Then
        If LastFrame > Chr(0) Then
          Debug.Print Hex(Asc(LastFrame))
          Exit Sub
        End If
      End If
      LastFrame = Mid(sBuffer, 16, 1)
    End If
    Winsock.SendUDP UDP_Socket, sBuffer, UDP_RemoteAddress
    NET_Framerate = NET_Framerate + 1
    DoEvents
    Debug.Print HexDump(Left(sBuffer, 16))
  Else
    Winsock.SendUDP UDP_Socket, ParseFrame(sBuffer), UDP_RemoteAddress
  End If
End Sub

Public Sub SleepHigh(Delay As Currency)
  'Sleep Delay
  Dim Counter1 As Currency
  Dim Counter2 As Currency
  QueryPerformanceCounter Counter1
  Counter2 = Counter1 + NET_Resolution * Delay
  While Counter1 < Counter2
    QueryPerformanceCounter Counter1
  Wend
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
      Open App.Path & "\00.bin" For Binary As #1
      Put #1, , baBuffer
      Close #1
      ParseFrame = SendFrame1(baBuffer(5))
    
    Case 1
      Open App.Path & "\01.bin" For Binary As #1
      Put #1, , baBuffer
      Close #1
      ParseFrame = SendFrame2
       
    Case 2
      Open App.Path & "\02.bin" For Binary As #1
      Put #1, , baBuffer
      Close #1
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
  Me.Caption = NET_Framerate & " - " & NET_Delay
  If Check1.Value Then
    If NET_Framerate > 60 Then
      NET_Delay = NET_Delay + 1
      If NET_Delay > 20 Then NET_Delay = 20
    End If
    If NET_Framerate < 56 Then
      NET_Delay = NET_Delay - 1
      If NET_Delay < 10 Then NET_Delay = 10
    End If
  End If
  NET_Framerate = 0
End Sub
