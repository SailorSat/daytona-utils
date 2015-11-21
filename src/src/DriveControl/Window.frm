VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "DriveControl"
   ClientHeight    =   240
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   240
   LinkTopic       =   "Form1"
   ScaleHeight     =   240
   ScaleWidth      =   240
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private UDP_LocalAddress As String
Private UDP_Socket As Long
Private UDP_Buffer As String

Private PortName As String
Private PortConfig As String

Private Ready As Boolean

Private Joystick As JOYSTICK_POSITION_V2

Private LastTick As Long

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Dim Host As String
  Dim Port As Long

  Me.BackColor = RGB(255, 0, 0)
  Me.Move Me.Width, 0
  Me.Show
  
  Winsock.Load
  
  ' Serial (drive)
  PortName = ReadIni("drive.ini", "serial", "port", "")
  PortConfig = ReadIni("drive.ini", "serial", "config", "")
  
  ' init network (drive)
  UDP_Buffer = ""
  Host = ReadIni("drive.ini", "network", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("drive.ini", "network", "localport", "9000"))
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
  
  ' init serial port (resets arduino)
  Me.BackColor = RGB(255, 255, 0)
  Ready = False
  
  If Not OpenSerial(PortName, PortConfig) Then
    DoEvents
  End If
  Me.BackColor = RGB(0, 255, 255)
  
  ' wait for serial sync signal
  Dim SomeData As Byte
  While SomeData <> &HA5
    SomeData = ReadSerialByte
    DoEvents
  Wend
  Ready = True
  
  ' init vJoy
  If vJoyEnabled Then
    AcquireVJD 1
    UpdateVJD 1, Joystick
  End If
    
  Me.BackColor = RGB(0, 255, 0)
  
  WriteSerialInteger &H0&
  WriteSerialInteger &H100&
  WriteSerialInteger &H200&
  WriteSerialInteger &H300&
  WriteSerialInteger &H400&
  WriteSerialInteger &H500&
  WriteSerialInteger &H600&
  WriteSerialInteger &H700&
  WriteSerialInteger &H800&
  WriteSerialInteger &H900&
  WriteSerialInteger &HA00&
  WriteSerialInteger1 &H1&
  WriteSerialInteger2 &H2&
  Do
    If ReadSerialBuffer Then
      LastTick = GetTickCount
      Joystick.wAxisX = CLng(SerialReadBuffer(1)) * 256 + SerialReadBuffer(0)
      Joystick.wAxisY = CLng(SerialReadBuffer(3)) * 256 + SerialReadBuffer(2)
      Joystick.wAxisZRot = CLng(SerialReadBuffer(5)) * 256 + SerialReadBuffer(4)
      Joystick.wAxisZ = CLng(SerialReadBuffer(7)) * 256 + SerialReadBuffer(6)
      Joystick.lButtons = CLng(SerialReadBuffer(10)) * 65536 + CLng(SerialReadBuffer(9)) * 256 + SerialReadBuffer(8)
      UpdateVJD 1, Joystick
      WriteSerialInteger &H0&
      WriteSerialInteger &H100&
      WriteSerialInteger &H200&
      WriteSerialInteger &H300&
      WriteSerialInteger &H400&
      WriteSerialInteger &H500&
      WriteSerialInteger &H600&
      WriteSerialInteger &H700&
      WriteSerialInteger &H800&
      WriteSerialInteger &H900&
      WriteSerialInteger &HA00&
    Else
      If GetTickCount - LastTick > 100 Then
        LastTick = GetTickCount
      Debug.Print "lost sync?"
      WriteSerialInteger &H0&
      WriteSerialInteger &H100&
      WriteSerialInteger &H200&
      WriteSerialInteger &H300&
      WriteSerialInteger &H400&
      WriteSerialInteger &H500&
      WriteSerialInteger &H600&
      WriteSerialInteger &H700&
      WriteSerialInteger &H800&
      WriteSerialInteger &H900&
      WriteSerialInteger &HA00&
      End If
    End If
    DoEvents
    Sleep 1
  Loop
End Sub

Private Sub Form_Unload(Cancel As Integer)
  ResetVJD 1
  RelinquishVJD 1
  Winsock.Unload
  CloseSerial
  End
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  UDP_Buffer = UDP_Buffer & sBuffer
  While Len(UDP_Buffer) > 1
    Dim bData() As Byte
    bData = StrConv(Left(UDP_Buffer, 2), vbFromUnicode)
    Select Case bData(0)
      Case 1
        UDP_Buffer = Mid(UDP_Buffer, 3)
        If Ready Then
          WriteSerialInteger1 1 + CLng(bData(1)) * 256
          Debug.Print "drive", Hex(bData(1))
        End If
      Case 2
        UDP_Buffer = Mid(UDP_Buffer, 3)
        If Ready Then
          WriteSerialInteger2 2 + CLng(bData(1)) * 256
          Debug.Print "lamp", Hex(bData(1))
        End If
      Case Else
        UDP_Buffer = Mid(UDP_Buffer, 2)
    End Select
  Wend
End Sub
