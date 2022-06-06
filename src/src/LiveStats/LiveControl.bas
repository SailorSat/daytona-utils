Attribute VB_Name = "LiveControl"
Option Explicit

Public SystemPath As String

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long

Sub CONTROL_OnLoad()
  Dim Host As String
  Dim Port As Long
  
  ' System Path
  SystemPath = ReadIni("control.ini", "client", "systempath", "c:\windows\system32")
  
  ' Local (control)
  Host = ReadIni("control.ini", "client", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("control.ini", "client", "localport", "23456"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #ADDR", vbCritical Or vbOKOnly, App.Title
    End
  End If

  UDP_Socket = Winsock.ListenUDP(UDP_LocalAddress)
  If UDP_Socket = -1 Then
    MsgBox "Something went wrong! #SOCK", vbCritical Or vbOKOnly, App.Title
    End
  End If
End Sub

Public Sub CONTROL_OnUnload()
  Winsock.Disconnect UDP_Socket
End Sub

Public Sub CONTROL_OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If lHandle <> UDP_Socket Then Exit Sub
  
  If Len(sBuffer) < 32 Then Exit Sub

  UDP_RemoteAddress = sAddress
  
  Dim baBuffer() As Byte
  baBuffer = StrConv(sBuffer, vbFromUnicode)
  Select Case baBuffer(0)
    Case CTRL_CMD_PING
      baBuffer(1) = CTRL_STATUS_OFFLINE
      sBuffer = StrConv(baBuffer, vbUnicode)
      Winsock.SendUDP lHandle, sBuffer, UDP_RemoteAddress
      
    Case CTRL_CMD_SHUTDOWN
      ShellExecuteA Window.hWnd, "open", SystemPath & "\shutdown.exe", "-s -f -t 0 -c SHUTDOWN", SystemPath, SW_HIDE
      
    Case CTRL_CMD_REBOOT
      ShellExecuteA Window.hWnd, "open", SystemPath & "\shutdown.exe", "-r -f -t 0 -c SHUTDOWN", SystemPath, SW_HIDE
      
    Case CTRL_CMD_CAMERA
      CLIENT_CarNo = baBuffer(1) And &H7&
      OVERLAY_FrameCounter = 1920 ' focus for ~32 seconds
  End Select
End Sub

