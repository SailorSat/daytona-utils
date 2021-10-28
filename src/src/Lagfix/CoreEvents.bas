Attribute VB_Name = "CoreEvents"
Option Explicit

Public Sub Main()
  Window.Show
  DoEvents

  ' load essential stuff
  Winsock.Load
  Lagfix.Load
  
  ' enable the timer
  Window.Timer.Enabled = True
End Sub

Public Sub OnUnload()
  ' disable the timer
  Window.Timer.Enabled = False
  
  ' unload essential stuff
  Lagfix.Unload
  Winsock.Unload
  
  ' some other cleanup
  End
End Sub

Public Sub OnTimer()
  Lagfix.Timer
End Sub

Public Sub OnStatus(sModule As String, lStatus As Long, sStatus As String)
  Debug.Print sModule, lStatus, sStatus
End Sub


' --- Socket Events ---
Public Sub OnReadTCP(lHandle As Long, sBuffer As String)
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  'Debug.Print "OnReadUDP", lHandle
  Lagfix.ReadUDP lHandle, sBuffer, sAddress
End Sub

Public Sub OnIncoming(lHandle As Long, sNewSocket As Long)
End Sub

Public Sub OnConnected(lHandle As Long)
End Sub

Public Sub OnConnectError(lHandle As Long, lError As Long)
End Sub

Public Sub OnClose(lHandle As Long)
End Sub
