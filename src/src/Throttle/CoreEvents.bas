Attribute VB_Name = "CoreEvents"
Option Explicit

' --- Socket Events ---
Public Sub OnReadTCP(lHandle As Long, sBuffer As String)
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  Window.OnReadUDP lHandle, sBuffer, sAddress
End Sub

Public Sub OnIncoming(lHandle As Long, sNewSocket As Long)
End Sub

Public Sub OnConnected(lHandle As Long)
End Sub

Public Sub OnConnectError(lHandle As Long, lError As Long)
End Sub

Public Sub OnClose(lHandle As Long)
End Sub
