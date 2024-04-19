VERSION 5.00
Begin VB.Form Window 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private isRunning As Boolean

Private UDP_Address_EmulatorRX As String
Private UDP_Address_EmulatorTX As String
Private UDP_Socket_Emulator As Long

Private FrameCounter As Long
Private NetCounter As Long

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  Winsock.SendUDP lHandle, sBuffer, UDP_Address_EmulatorTX
  NetCounter = NetCounter + 1
End Sub

Private Sub Form_Load()
  Winsock.Load
  Me.Show
  DoEvents
  
  Dim Host As String
  Dim Port As Long
  
  ' Emulator-RX (where m2em sends to)
  Host = ReadIni("monitor.ini", "emulator", "host", "192.168.10.199")
  Port = CLng(ReadIni("monitor.ini", "emulator", "localport", "15613"))
  UDP_Address_EmulatorRX = Winsock.WSABuildSocketAddress(Host, Port)
  
  ' Emulator-TX (where m2em listens)
  Port = CLng(ReadIni("monitor.ini", "emulator", "remoteport", "15612"))
  UDP_Address_EmulatorTX = Winsock.WSABuildSocketAddress(Host, Port)
  
  UDP_Socket_Emulator = Winsock.ListenUDP(UDP_Address_EmulatorRX)
  If UDP_Socket_Emulator = -1 Then
    MsgBox "Something went wrong! #SOCK_EMU", vbCritical Or vbOKOnly, App.Title
    Form_Unload 0
  End If

  Dim TempCounter As Long
  isRunning = True
  While isRunning
    DoEvents
    
    If M2EM_Online Then
      
      TempCounter = ReadLong(M2EM_RAMBASE + &H10&)
      If TempCounter <> FrameCounter Then
        Debug.Print FrameCounter, NetCounter, Abs(FrameCounter - NetCounter)
        FrameCounter = TempCounter
      End If
    End If
  Wend
  
  Winsock.Unload
  End
End Sub

Private Sub Form_Unload(Cancel As Integer)
  isRunning = False
End Sub
