Attribute VB_Name = "Lagfix"
Option Explicit

Private UDP_LocalAddress_RX As String
Private UDP_LocalAddress_TX As String
Private UDP_RemoteAddress_RX As String
Private UDP_RemoteAddress_TX As String
Private UDP_Socket_RX As Long
Private UDP_Socket_TX As Long

Private STATS_Enabled As Boolean
Private STATS_RemoteAddress As String

Private LAG_Enabled As Boolean
Private LAG_Packet As String
Private LAG_Tick As Long

Private LINK_Enabled As Boolean

Private STALL_Enabled As Boolean
Private STALL_Tick As Long

Private LOG_Enabled As Boolean
Private LOG_FileHandle As Integer


Public Sub Load()
  Dim Host As String
  Dim Port As Long
  
  If LOG_Enabled Then
    LOG_FileHandle = FreeFile
    
    ' Clear Log
    Open App.Path & "\lagfix.log" For Output As #LOG_FileHandle
    Print #LOG_FileHandle, "-- START @ " & Date & " " & Time
  End If
  
  ' Local-RX (lagfix)
  Host = ReadIni("lagfix.ini", "rx", "LocalHost", "127.0.0.1")
  Port = CLng(ReadIni("lagfix.ini", "rx", "LocalPort", "15611"))
  UDP_LocalAddress_RX = Winsock.WSABuildSocketAddress(Host, Port)
  
  ' Remote-RX (emulator)
  Host = ReadIni("lagfix.ini", "rx", "EmulatorHost", "127.0.0.1")
  Port = CLng(ReadIni("m2lagfix.ini", "rx", "EmulatorPort", "15612"))
  UDP_RemoteAddress_RX = Winsock.WSABuildSocketAddress(Host, Port)

  ' Local-TX (lagfix)
  Host = ReadIni("lagfix.ini", "tx", "LocalHost", "127.0.0.1")
  Port = CLng(ReadIni("m2lagfix.ini", "tx", "LocalPort", "15613"))
  UDP_LocalAddress_TX = Winsock.WSABuildSocketAddress(Host, Port)
  
  ' Remote-RX (Emulator)
  Host = ReadIni("lagfix.ini", "tx", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("m2lagfix.ini", "x", "RemotePort", "15611"))
  UDP_RemoteAddress_TX = Winsock.WSABuildSocketAddress(Host, Port)

  ' Stats (if enabled)
  Host = ReadIni("lagfix.ini", "stats", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("m2lagfix.ini", "stats", "RemotePort", "-1"))
  STATS_RemoteAddress = Winsock.WSABuildSocketAddress(Host, Port)
  STATS_Enabled = Not (STATS_RemoteAddress = "")
  
  ' DELAY fix (if enabled)
  STALL_Enabled = CBool(ReadIni("lagfix.ini", "rx", "StallDetection", "false"))
  
  If UDP_LocalAddress_RX = "" Or UDP_RemoteAddress_RX = "" Then
    MsgBox "Something went wrong! #ADDR_RX", vbCritical Or vbOKOnly, App.Title
    OnUnload
  End If
  
  If UDP_LocalAddress_TX = "" Or UDP_RemoteAddress_TX = "" Then
    MsgBox "Something went wrong! #ADDR_TX", vbCritical Or vbOKOnly, App.Title
    OnUnload
  End If
  
  UDP_Socket_RX = Winsock.ListenUDP(UDP_LocalAddress_RX)
  If UDP_Socket_RX = -1 Then
    MsgBox "Something went wrong! #SOCK_RX", vbCritical Or vbOKOnly, App.Title
    OnUnload
  End If
  
  UDP_Socket_TX = Winsock.ListenUDP(UDP_LocalAddress_TX)
  If UDP_Socket_TX = -1 Then
    MsgBox "Something went wrong! #SOCK_TX", vbCritical Or vbOKOnly, App.Title
    OnUnload
  End If
  
  LAG_Enabled = False
  LAG_Packet = ""
  LAG_Tick = 0
  
  LINK_Enabled = False
  
  STALL_Tick = 0
  
  If STATS_Enabled Then
    OnStatus "LagFix", vbCyan, "ready+"
  Else
    OnStatus "LagFix", vbYellow, "ready"
  End If
End Sub

Public Sub Unload()
  If LOG_Enabled Then
    Close #LOG_FileHandle
  End If
  Winsock.Disconnect UDP_Socket_RX
  Winsock.Disconnect UDP_Socket_TX
End Sub

Public Sub Timer()
  ' LAG if enabled
  If LAG_Enabled Then
    ' if waited long enough
    If GetTickCount - LAG_Tick >= 64 Then
      Winsock.SendUDP UDP_Socket_RX, LAG_Packet, UDP_RemoteAddress_RX
      LAG_Tick = GetTickCount
    
      If LOG_Enabled Then
        ' Log
        Print #LOG_FileHandle, "LAG-- @ " & Date & " " & Time
      End If
    End If
  ElseIf (STALL_Enabled And LINK_Enabled) Then
    ' if waited long enough
    If GetTickCount - STALL_Tick >= 128 Then
      Winsock.SendUDP UDP_Socket_RX, LAG_Packet, UDP_RemoteAddress_RX
      STALL_Tick = GetTickCount
      
      If LOG_Enabled Then
        ' Log
        Print #LOG_FileHandle, "STALL @ " & Date & " " & Time
      End If
    End If
  End If
End Sub

Public Sub ReadUDP(lSocket As Long, sBuffer As String, sAddress As String)
  Dim sDummy As String
  If lSocket = UDP_Socket_RX Then
    ' incoming, send to emulator
    While Len(sBuffer) >= 3589
      sDummy = Left$(sBuffer, 3589)
      sBuffer = Mid$(sBuffer, 3590)
      Winsock.SendUDP UDP_Socket_RX, sDummy, UDP_RemoteAddress_RX
      If STATS_Enabled Then
        Winsock.SendUDP UDP_Socket_RX, sDummy, STATS_RemoteAddress
      End If
    Wend
    
    LINK_Enabled = (Asc(Mid$(sDummy, 5, 1)) = 2)
    
    LAG_Tick = GetTickCount
    LAG_Packet = sDummy
    LAG_Enabled = LINK_Enabled
  ElseIf lSocket = UDP_Socket_TX Then
    ' outgoing, send to next unit
    While Len(sBuffer) >= 3589
      sDummy = Left$(sBuffer, 3589)
      sBuffer = Mid$(sBuffer, 3590)
      Winsock.SendUDP UDP_Socket_TX, sDummy, UDP_RemoteAddress_TX
    Wend

    STALL_Tick = GetTickCount
    LAG_Enabled = False
  End If
End Sub

