Attribute VB_Name = "LiveClient"
Option Explicit

Public CLIENT_Online As Boolean
Public CLIENT_Hooked As Boolean
Public CLIENT_LocalAddress As String
Public CLIENT_RemoteAddress As String
Public CLIENT_Socket As Long
Public CLIENT_CarNo As Byte
Public CLIENT_ViewNo As Byte

Private CoinLock As Boolean
Private Ingame As Boolean

Private CLIENT_TableHack As Boolean
Private CLIENT_TableIndex As Long
Private CLIENT_LastCarNo As Byte
Private CLIENT_LastNode As Byte


Public Sub CLIENT_OnLoad()
  Dim Host As String
  Dim Port As Long

  ' Local (live)
  Host = ReadIni("stats.ini", "live", "LocalHost", "127.0.0.1")
  Port = CLng(ReadIni("stats.ini", "live", "LocalPort", "7001"))
  CLIENT_LocalAddress = WSABuildSocketAddress(Host, Port)
  If CLIENT_LocalAddress = "" Then
    MsgBox "Something went wrong! #CLIENT_LocalAddress", vbCritical Or vbOKOnly, Window.Caption
    OnUnload
  End If
    
  Host = ReadIni("stats.ini", "live", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("stats.ini", "live", "RemotePort", "7002"))
  CLIENT_RemoteAddress = WSABuildSocketAddress(Host, Port)
  If CLIENT_LocalAddress = "" Then
    MsgBox "Something went wrong! #CLIENT_RemoteAddress", vbCritical Or vbOKOnly, Window.Caption
    OnUnload
  End If
  
  CLIENT_Socket = ListenUDP(CLIENT_LocalAddress)
  If CLIENT_Socket = -1 Then
    MsgBox "Something went wrong! #CLIENT_Socket", vbCritical Or vbOKOnly, Window.Caption
    OnUnload
  End If
  
  CLIENT_ViewNo = 3
  CLIENT_TableHack = False
End Sub


Public Sub CLIENT_OnTimer()
  CLIENT_Hooked = M2EM_Online
End Sub


Public Sub CLIENT_OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  Dim sReply As String
  sReply = LiveClient.ProcessFakeFrame(sBuffer)
  If Len(sReply) > 0 Then
    Winsock.SendUDP CLIENT_Socket, sReply, CLIENT_RemoteAddress
  End If
End Sub


Public Sub CLIENT_OnLinkDown()
  If CLIENT_Online Then
    CLIENT_Online = False
    Debug.Print "CLIENT_OnLinkDown"
  End If
End Sub

Public Sub CLIENT_OnLinkUp()
  If Not CLIENT_Online Then
    CLIENT_Online = True
    Debug.Print "OnLinkUp", STATS_Players
  End If
End Sub


Public Sub CLIENT_OnRaceEnd()
  Debug.Print "OnRaceEnd"
End Sub


Public Sub ProcessFrame(LastFrame As DaytonaFrame)
  Dim lCount As Long
  Dim lMasterCar As Long
  Dim lSlaveCar As Long
  Dim lServerCar As Long
  lCount = STATS_Players - 1
  lMasterCar = -1
  lSlaveCar = -1
  lServerCar = -1
  
  Dim lIndex As Long
  For lIndex = 0 To lCount
    If LastFrame.Packet(lIndex).x0D4_CarNumber = 0 Then
      lMasterCar = lIndex
      lIndex = 8
    End If
  Next
  For lIndex = 0 To lCount
    If LastFrame.Packet(lIndex).x0D4_CarNumber = CLIENT_CarNo Then
      lSlaveCar = lIndex
      lIndex = 8
    End If
  Next
  
  Dim bGameState As Byte, bSetupState As Byte
  bGameState = ReadByte(M2EM_RAMBASE + GAMESTATE)
  bSetupState = ReadByte(M2EM_RAMBASE + SETUP_STATE)

  Dim bMasterState As Byte
  Dim bMasterNode As Byte
  Dim bReplacementNode As Byte
  If lMasterCar >= 0 Then
    If bGameState < &H10 Then
      ' Enable tilemaps
      WriteByte M2EM_RAMBASE + TILEMAPS, &H0
    Else
      ' Disable tilemaps (thanks nuezz!)
      WriteByte M2EM_RAMBASE + TILEMAPS, &H1
    End If
    
    ' Disable hud elements (thanks nuezz!)
    WriteInteger M2EM_RAMBASE + HUD_OFFSET_X, &H600
    
    ' Disable setup map (thanks nuezz!)
    WriteByte M2EM_RAMBASE + SETUP_MAP, &H0
    
    ' Disable setup selectors (thanks nuezz!)
    WriteByte M2EM_RAMBASE + SETUP_SELECTORS, &H0
    
    ' Disable setup cars (thanks nuezz!)
    WriteByte M2EM_RAMBASE + SETUP_CARS, &H0
    
    ' Disable panorama attract (thanks nuezz!)
    WriteByte M2EM_RAMBASE + ATTRACT_MODE, &H1
    
    If bGameState > &H2 Then
      ' once network up...
      bMasterNode = LastFrame.Packet(lMasterCar).x018_MasterNode
      bMasterState = LastFrame.Packet(lMasterCar).x01B_RemoteGameState
      For lIndex = 0 To lCount
        If LastFrame.Packet(lIndex).x00C_LocalNode = bMasterNode Then
          lServerCar = lIndex
          lIndex = 8
        End If
      Next
      Select Case bMasterState
        Case Is > &H12&
          If CoinLock Then
            CoinLock = False
            WriteLong M2EM_RAMBASE + CUSTOM_MASK, &HFFFF&
            Debug.Print Time, "disable coin lock"
          End If
        Case Is = &H12&
          ' car no. 1
          If Not bMasterNode = LastFrame.Packet(lMasterCar).x00C_LocalNode Then
            If Not bGameState = &H12& Then
              ' auto coin up
              If Not CoinLock Then
                CoinLock = True
                WriteLong M2EM_RAMBASE + CUSTOM_MASK, &HF7FF& '&HF5FF&
                Debug.Print Time, "enable coin lock"
              End If
            End If
          End If
      End Select
      
      If bGameState = &H16 Or bGameState = &H15 Or bGameState = &H14 Or bGameState = &H13 Then
        If bMasterState = &H16 Or bMasterState = &H15 Or bMasterState = &H14 Or bMasterState = &H13 Then
          If Not Ingame Then
            Ingame = True
            OnRaceStart LastFrame.Packet(lMasterCar).x017_CourseActive, bMasterNode, LastFrame.Packet(lServerCar).x00B_NodeCount
            CLIENT_CarNo = 0
            CLIENT_ViewNo = 3
            Debug.Print "ingame..."
          End If
        End If
        
        ' Set Laps to 255 to avoid live client finishing the race
        WriteByte M2EM_RAMBASE + LAPS_TOTAL, &HFF
        
        ' Y
        WriteSingle M2EM_RAMBASE + CAR_Y, LastFrame.Packet(lSlaveCar).x05C_CarY
        
        ' X
        WriteSingle M2EM_RAMBASE + CAR_X, LastFrame.Packet(lSlaveCar).x064_CarX
        
        ' Speed
        WriteSingle M2EM_RAMBASE + CAR_SPEED, LastFrame.Packet(lSlaveCar).x074_CarSpeed
        
        ' YAW
        WriteInteger M2EM_RAMBASE + CAR_YAW, LastFrame.Packet(lSlaveCar).x08E_CarYaw
        
        ' CarNo / Icon
        WriteByte M2EM_RAMBASE + CAR_ICON, LastFrame.Packet(lSlaveCar).x0D4_CarNumber
      
        ' Car Model (and Number)
        WriteLong M2EM_RAMBASE + CAR_MODEL_BODY, CarToModel(LastFrame.Packet(lSlaveCar).x0D4_CarNumber)
        WriteLong M2EM_RAMBASE + CAR_MODEL_NUMBER, 0
        
        ' Process Camera Stuff
        LiveCamera.ProcessPackets LastFrame.Packet(lServerCar), LastFrame.Packet(lSlaveCar)
        
        ' Update Overlay (if enabled)
        LiveOverlay.ProcessPackets LastFrame.Packet(lServerCar), LastFrame.Packet(lSlaveCar)

        ' Replace cars if needed
        If CLIENT_LastCarNo <> CLIENT_CarNo Then
          If CLIENT_TableHack Then
            ' restore table
            WriteByte M2EM_RAMBASE + CAR_NODE + (CLIENT_TableIndex * &H300&), CLIENT_LastNode
            WriteByte M2EM_RAMBASE + CAR_ICON + (CLIENT_TableIndex * &H300&), CLIENT_LastCarNo
            CLIENT_TableHack = False
          End If
          If Not CLIENT_TableHack Then
            CLIENT_LastCarNo = CLIENT_CarNo
            ' manipulate table
            For lIndex = 1 To lCount
              If ReadByte(M2EM_RAMBASE + CAR_ICON + (lIndex * &H300&)) = CLIENT_CarNo Then
                CLIENT_TableIndex = lIndex
                CLIENT_LastNode = ReadByte(M2EM_RAMBASE + CAR_NODE + (lIndex * &H300&))
                CLIENT_TableHack = True
                WriteByte M2EM_RAMBASE + CAR_NODE + (lIndex * &H300&), ReadByte(M2EM_RAMBASE + CAR_NODE)
              End If
            Next
          End If
        End If
      Else
        If Ingame Then
          Ingame = False
          OnRaceEnd
          Debug.Print "no longer ingame..."
        End If
      End If
    End If
  End If
End Sub


Private Function ProcessFakeFrame(sBuffer As String) As String
  ' check if stats online
  If Not STATS_Online Then Exit Function
  
  Dim lIndex As Long
  
  ' convert from wide-string to byte array
  Dim baBuffer() As Byte
  baBuffer() = StrConv(sBuffer, vbFromUnicode)
  
  ' check header status
  Select Case baBuffer(4)
    Case 0
      ' type 0 packet
      ' add missing cabs, set count to STATS_Players
      baBuffer(&H5) = STATS_Players             ' total
      For lIndex = 1 To STATS_Players - 1
        baBuffer(&H5 + lIndex * 6 + 0) = 0
        baBuffer(&H5 + lIndex * 6 + 1) = lIndex ' cab ##
      Next
      CLIENT_OnLinkDown
      
    Case 1
      ' type 1 packet
      ' count up ids
      baBuffer(&H5) = STATS_Players                                 ' total
      baBuffer(&H6) = STATS_Players + 1                             ' next node (total + 1)
      For lIndex = 1 To STATS_Players + 1
        baBuffer(&H5 + lIndex * 6 + 0) = 0
        baBuffer(&H5 + lIndex * 6 + 1) = STATS_Players + 1 - lIndex ' cab ##
      Next
     
    Case 2
      ' type 2 packet
      If baBuffer(&H1A) >= &H80 Then
        ' sync phase done!
        CLIENT_OnLinkUp
        Exit Function
      Else
        ' do nothing and wait...
        ProcessFakeFrame = sBuffer
        Exit Function
      End If
    Case Else
      Debug.Print "unknown frame type", baBuffer(4)
  End Select
  
  ProcessFakeFrame = StrConv(baBuffer, vbUnicode)
End Function
