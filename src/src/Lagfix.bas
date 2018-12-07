Attribute VB_Name = "Lagfix"
Option Explicit

Private UDP_Address_NetworkRX As String
Private UDP_Address_NetworkTX As String
Private UDP_Address_EmulatorRX As String
Private UDP_Address_EmulatorTX As String
Private UDP_Socket_Network As Long
Private UDP_Socket_Emulator As Long

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
  
  ' Network-RX (where we listen)
  Host = ReadIni("lagfix.ini", "network", "localhost", "127.0.0.1")
  Port = CLng(ReadIni("lagfix.ini", "network", "localport", "15611"))
  UDP_Address_NetworkRX = Winsock.WSABuildSocketAddress(Host, Port)
  
  ' Network-TX (where we send to)
  Host = ReadIni("lagfix.ini", "network", "remotehost", "127.0.0.1")
  Port = CLng(ReadIni("lagfix.ini", "network", "remoteport", "15611"))
  UDP_Address_NetworkTX = Winsock.WSABuildSocketAddress(Host, Port)
  
  ' Emulator-RX (where m2em sends to)
  Host = ReadIni("lagfix.ini", "emulator", "host", "127.0.0.1")
  Port = CLng(ReadIni("lagfix.ini", "emulator", "localport", "15613"))
  UDP_Address_EmulatorRX = Winsock.WSABuildSocketAddress(Host, Port)
  
  ' Emulator-TX (where m2em listens)
  Port = CLng(ReadIni("lagfix.ini", "emulator", "remoteport", "15612"))
  UDP_Address_EmulatorTX = Winsock.WSABuildSocketAddress(Host, Port)

  ' Stats (if enabled)
  Host = ReadIni("lagfix.ini", "stats", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("lagfix.ini", "stats", "RemotePort", "-1"))
  STATS_RemoteAddress = Winsock.WSABuildSocketAddress(Host, Port)
  STATS_Enabled = Not (STATS_RemoteAddress = "")
  
  ' DELAY fix (if enabled)
  STALL_Enabled = CBool(ReadIni("lagfix.ini", "rx", "StallDetection", "false"))
  
  If UDP_Address_NetworkRX = "" Or UDP_Address_EmulatorRX = "" Then
    MsgBox "Something went wrong! #ADDR_RX", vbCritical Or vbOKOnly, App.Title
    OnUnload
  End If
  
  If UDP_Address_EmulatorTX = "" Or UDP_Address_NetworkTX = "" Then
    MsgBox "Something went wrong! #ADDR_TX", vbCritical Or vbOKOnly, App.Title
    OnUnload
  End If
  
  UDP_Socket_Network = Winsock.ListenUDP(UDP_Address_NetworkRX)
  If UDP_Socket_Network = -1 Then
    MsgBox "Something went wrong! #SOCK_NET", vbCritical Or vbOKOnly, App.Title
    OnUnload
  End If
  
  UDP_Socket_Emulator = Winsock.ListenUDP(UDP_Address_EmulatorRX)
  If UDP_Socket_Emulator = -1 Then
    MsgBox "Something went wrong! #SOCK_EMU", vbCritical Or vbOKOnly, App.Title
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
  Winsock.Disconnect UDP_Socket_Network
  Winsock.Disconnect UDP_Socket_Emulator
End Sub

Public Sub Timer()
  ' LAG if enabled
  If LAG_Enabled Then
    ' if waited long enough
    If GetTickCount - LAG_Tick >= 64 Then
      Winsock.SendUDP UDP_Socket_Emulator, LAG_Packet, UDP_Address_EmulatorTX
      LAG_Tick = GetTickCount
    
      If LOG_Enabled Then
        ' Log
        Print #LOG_FileHandle, "LAG-- @ " & Date & " " & Time
      End If
    End If
  ElseIf (STALL_Enabled And LINK_Enabled) Then
    ' if waited long enough
    If GetTickCount - STALL_Tick >= 128 Then
      Winsock.SendUDP UDP_Socket_Network, LAG_Packet, UDP_Address_NetworkTX
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
  If lSocket = UDP_Socket_Network Then
    ' incoming, send to emulator (and stats if enabled)
    While Len(sBuffer) >= 3589
      sDummy = Left$(sBuffer, 3589)
      sBuffer = Mid$(sBuffer, 3590)
      Winsock.SendUDP UDP_Socket_Emulator, sDummy, UDP_Address_EmulatorTX
      If STATS_Enabled Then
        Winsock.SendUDP UDP_Socket_Network, sDummy, STATS_RemoteAddress
      End If
    Wend
    
    LINK_Enabled = (Asc(Mid$(sDummy, 5, 1)) = 2)
    
    LAG_Tick = GetTickCount
    LAG_Packet = sDummy
    LAG_Enabled = LINK_Enabled
  ElseIf lSocket = UDP_Socket_Emulator Then
    ' outgoing, send to next unit
    While Len(sBuffer) >= 3589
      sDummy = Left$(sBuffer, 3589)
      sBuffer = Mid$(sBuffer, 3590)
      Winsock.SendUDP UDP_Socket_Network, sDummy, UDP_Address_NetworkTX
    Wend

    STALL_Tick = GetTickCount
    LAG_Enabled = False
  End If
End Sub

