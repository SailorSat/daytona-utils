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
   Begin VB.Timer Timer 
      Interval        =   1000
      Left            =   120
      Top             =   600
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

Private TCP_LocalAddress As String
Private TCP_RemoteAddress As String
Private TCP_Socket1 As Long
Private TCP_Socket2 As Long
Private TCP_Socket3 As Long
Private TCP_Buffer As String

Private NET_Framerate As Long

Private Sub Form_Load()
  Me.Show
  DoEvents
  
  FAKE_READY = False
  
  ' Init Winsock
  Winsock.Load
    
  Dim Host As String
  Dim Port As Long
  
  Host = ReadIni("mamebridge.ini", "m2em", "LocalHost", "127.0.0.1")
  Port = CLng(ReadIni("mamebridge.ini", "m2em", "LocalPort", "7001"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #UDP_LocalAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If
  
  Host = ReadIni("mamebridge.ini", "m2em", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("mamebridge.ini", "m2em", "RemotePort", "7002"))
  UDP_RemoteAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_RemoteAddress = "" Then
    MsgBox "Something went wrong! #UDP_RemoteAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If

  Host = ReadIni("mamebridge.ini", "mame", "LocalHost", "127.0.0.1")
  Port = CLng(ReadIni("mamebridge.ini", "mame", "LocalPort", "15113"))
  TCP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If TCP_LocalAddress = "" Then
    MsgBox "Something went wrong! #TCP_LocalAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If
  
  Host = ReadIni("fakemaster.ini", "mame", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("fakemaster.ini", "mame", "RemotePort", "15112"))
  TCP_RemoteAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If TCP_RemoteAddress = "" Then
    MsgBox "Something went wrong! #TCP_RemoteAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If

  UDP_Socket = ListenUDP(UDP_LocalAddress)
  If UDP_Socket = -1 Then
    MsgBox "Something went wrong! #UDP_Socket", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If

  TCP_Socket3 = -1
  TCP_Socket2 = -1
  TCP_Socket1 = ListenTCP(TCP_LocalAddress)
  If TCP_Socket1 = -1 Then
    MsgBox "Something went wrong! #TCP_Socket1", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Unload
  End
End Sub

' --- Socket Events ---
Public Sub OnReadTCP(lHandle As Long, sBuffer As String)
  TCP_Buffer = TCP_Buffer & sBuffer
  If Len(TCP_Buffer) >= 3585 Then
    Dim Packet0 As String, Packet1 As String
    Packet0 = Left(TCP_Buffer, 3585)
    TCP_Buffer = Mid(TCP_Buffer, 3586)
    Packet1 = Translate_MAME_to_M2EM(Packet0)
    If Len(Packet1) > 0 Then
      Winsock.SendUDP UDP_Socket, Packet1, UDP_RemoteAddress
    End If
  End If
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  UDP_Buffer = UDP_Buffer & sBuffer
  If Len(UDP_Buffer) >= 3589 Then
    Dim Packet0 As String, Packet1 As String
    Packet0 = Left(UDP_Buffer, 3589)
    UDP_Buffer = Mid(UDP_Buffer, 3590)
    Packet1 = Translate_M2EM_to_MAME(Packet0)
    If Len(Packet1) > 0 And FAKE_READY Then
      Winsock.SendTCP TCP_Socket3, Packet1
    End If
  End If
End Sub

Public Sub OnIncoming(lHandle As Long, sNewSocket As Long)
  Debug.Print "OnIncoming", lHandle, sNewSocket
  If TCP_Socket2 <> -1 Then
    Winsock.Disconnect TCP_Socket2
  End If
  TCP_Socket2 = sNewSocket
End Sub

Public Sub OnConnected(lHandle As Long)
  Debug.Print "OnConnected", lHandle
  TCP_Buffer = ""
  UDP_Buffer = ""
  FAKE_READY = True
End Sub

Public Sub OnConnectError(lHandle As Long, lError As Long)
  Debug.Print "OnConnectError", lHandle, lError
  TCP_Socket3 = -1
End Sub

Public Sub OnClose(lHandle As Long)
  Debug.Print "OnClose", lHandle
  If TCP_Socket2 = lHandle Then
    TCP_Socket2 = -1
  ElseIf TCP_Socket3 = lHandle Then
    FAKE_READY = False
    TCP_Socket3 = -1
  End If
End Sub

Public Function Translate_MAME_to_M2EM(sBuffer As String) As String
  Dim baBuffer() As Byte
  baBuffer() = StrConv("M2EM" & sBuffer, vbFromUnicode)

  Select Case baBuffer(4)
    Case &HFF
      ' 0xFF - link id
      baBuffer(4) = 0
      Translate_MAME_to_M2EM = StrConv(baBuffer, vbUnicode)
    Case &HFE
      ' 0xFE - link size
      baBuffer(4) = 1
      Translate_MAME_to_M2EM = StrConv(baBuffer, vbUnicode)
    Case &HFC
      ' 0xFC - vsync
      ' silently droped
      Translate_MAME_to_M2EM = ""
    Case &H1
      ' 0x01 - master data
      baBuffer(4) = 2
      Translate_MAME_to_M2EM = StrConv(baBuffer, vbUnicode)
    Case Else
      Debug.Print "MAME: detected type " & Hex(baBuffer(4))
  End Select
End Function

Public Function Translate_M2EM_to_MAME(sBuffer As String) As String
  Dim baBuffer() As Byte
  baBuffer() = StrConv(Mid(sBuffer, 5), vbFromUnicode)

  Select Case baBuffer(0)
    Case &H0
      ' 0x00 - link id
      baBuffer(0) = &HFF
      FAKE_Size = baBuffer(1)
      Debug.Print "received link size: " & FAKE_Size
      Translate_M2EM_to_MAME = StrConv(baBuffer, vbUnicode)
    Case &H1
      ' 0x01 - link size
      baBuffer(0) = &HFE
      Translate_M2EM_to_MAME = StrConv(baBuffer, vbUnicode)
    Case &H2
      ' 0x02  - data
      Translate_M2EM_to_MAME = StrConv(baBuffer, vbUnicode)
      baBuffer(0) = &HFC
      NET_Framerate = NET_Framerate + 1
      Translate_M2EM_to_MAME = Translate_M2EM_to_MAME & StrConv(baBuffer, vbUnicode)
    Case Else
      Debug.Print "M2EM: detected type " & Hex(baBuffer(0))
  End Select
End Function

Private Sub Timer_Timer()
  Me.Caption = NET_Framerate
  NET_Framerate = 0
  
  If TCP_Socket3 = -1 Then
    TCP_Socket3 = Winsock.ConnectTCP(TCP_RemoteAddress)
  End If
End Sub
