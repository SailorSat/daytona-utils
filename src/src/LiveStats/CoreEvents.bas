Attribute VB_Name = "CoreEvents"
Option Explicit

' --- Core Events ---
Public Sub OnLoad()
  WINSOCK_OnLoad
  STATS_OnLoad
  CLIENT_OnLoad
  CAMERA_OnLoad
End Sub

Public Sub OnUnload()
  WINSOCK_OnUnload
  End
End Sub

Public Sub OnTimer()
  OVERLAY_OnTimer
  CLIENT_OnTimer
End Sub


' --- Socket Events ---
Public Sub OnReadTCP(lHandle As Long, sBuffer As String)
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If lHandle = STATS_Socket Then
    STATS_OnReadUDP lHandle, sBuffer, sAddress
  ElseIf lHandle = CLIENT_Socket Then
    CLIENT_OnReadUDP lHandle, sBuffer, sAddress
  End If
End Sub

Public Sub OnIncoming(lHandle As Long, sNewSocket As Long)
End Sub

Public Sub OnConnected(lHandle As Long)
End Sub

Public Sub OnConnectError(lHandle As Long, lError As Long)
End Sub

Public Sub OnClose(lHandle As Long)
End Sub


' --- Client Events ---
Public Sub OnLinkDown()
  If CLIENT_Online Then
    CLIENT_Online = False
  End If
End Sub

Public Sub OnLinkUp()
  If Not CLIENT_Online Then
    CLIENT_Online = True
  End If
End Sub

Public Sub OnRaceStart(Track As Byte, Node As Byte, Players As Byte)
  OVERLAY_OnRaceStart Track, Node, Players
  STATS_OnRaceStart Track, Node, Players
  CAMERA_OnRaceStart Track, Node, Players
End Sub

Public Sub OnRaceEnd()
  CLIENT_OnRaceEnd
  OVERLAY_OnRaceEnd
  STATS_OnRaceEnd
End Sub


