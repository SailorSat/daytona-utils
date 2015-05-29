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

Private DriveData As Byte
Private LampData As Byte
Private DataChanged As Boolean

Private Joystick As JOYSTICK_POSITION_V2

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
  DataChanged = False
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
  WriteSerialByte &HA5
  WriteSerialByte &H0
  WriteSerialByte &H0
  Ready = True
  
  ' init vJoy
  If vJoyEnabled Then
    AcquireVJD 1
    UpdateVJD 1, Joystick
  End If
    
  Me.BackColor = RGB(0, 255, 0)
  Do
    If ReadSerialBuffer Then
      Joystick.wAxisX = CLng(SerialReadBuffer(1)) * 256 + SerialReadBuffer(0)
      Joystick.wAxisY = &H4000&
      Joystick.wAxisZRot = CLng(SerialReadBuffer(3)) * 256 + SerialReadBuffer(2)
      Joystick.wAxisZ = CLng(SerialReadBuffer(5)) * 256 + SerialReadBuffer(4)
      Joystick.lButtons = CLng(SerialReadBuffer(7)) * 256 + SerialReadBuffer(6)
      UpdateVJD 1, Joystick
    End If
    If DataChanged Then
      DataChanged = False
      WriteSerialByte &HA5
      WriteSerialByte DriveData
      WriteSerialByte LampData
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
  While Len(UDP_Buffer) > 2
    Dim bData() As Byte
    bData = StrConv(Left(UDP_Buffer, 3), vbFromUnicode)
    If bData(0) = &HA5 Then
      UDP_Buffer = Mid(UDP_Buffer, 4)
      DriveData = bData(1)
      LampData = bData(2)
'      DataChanged = Ready
      If Ready Then
        WriteSerialByte &HA5
        WriteSerialByte DriveData
        WriteSerialByte LampData
        Debug.Print "data", Hex(DriveData), Hex(LampData)
      End If
    Else
      UDP_Buffer = Mid(UDP_Buffer, 2)
    End If
  Wend
End Sub

