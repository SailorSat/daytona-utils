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
  CLIENT_Hooked = OpenMemory
End Sub


Public Sub CLIENT_OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  Dim sReply As String
  sReply = LiveClient.ProcessFakeFrame(sBuffer)
  If Len(sReply) > 0 Then
    Winsock.SendUDP CLIENT_Socket, sReply, CLIENT_RemoteAddress
  End If
End Sub


Public Sub CLIENT_OnRaceEnd()
  WriteByte pRAMBASE + CAR_GEAR_MODE, 0
  WriteByte pRAMBASE + CAR_GEAR_MODE + 1, 0
  WriteInteger pRAMBASE + CAR_MODEL, &H2
End Sub


Public Sub ProcessFrame(LastFrame As DaytonaFrame)
  Dim iMasterCar As Integer
  Dim iSlaveCar As Integer
  Dim iServerCar As Integer
  iMasterCar = -1
  iSlaveCar = -1
  iServerCar = -1
  
  Dim iIndex As Integer
  For iIndex = 0 To 7
    If LastFrame.Packet(iIndex).x0D4_CarNumber = 0 Then
      iMasterCar = iIndex
      iIndex = 8
    End If
  Next
  For iIndex = 0 To 7
    If LastFrame.Packet(iIndex).x0D4_CarNumber = CLIENT_CarNo Then
      iSlaveCar = iIndex
      iIndex = 8
    End If
  Next
  
  Dim bGameState As Byte
  bGameState = ReadByte(pRAMBASE + GAMESTATE)
  
  Dim bMasterState As Byte
  Dim bMasterNode As Byte
  Dim bReplacementNode As Byte
  If iMasterCar >= 0 Then
    If bGameState < &H10 Then
      ' Enable tilemaps
      WriteByte pRAMBASE + TILEMAPS, &H0
    Else
      ' Disable tilemaps (thanks nuezz!)
      WriteByte pRAMBASE + TILEMAPS, &H1
    End If
    
    ' Disable hud elements (thanks nuezz!)
    WriteInteger pRAMBASE + HUD_OFFSET_X, &H600
    
    ' Disable setup map (thanks nuezz!)
    WriteByte pRAMBASE + SETUP_MAP, &H0
    
    ' Disable setup selectors (thanks nuezz!)
    WriteByte pRAMBASE + SETUP_SELECTORS, &H0
    
    ' Disable setup cars (thanks nuezz!)
    WriteByte pRAMBASE + SETUP_CARS, &H0
    
    ' Disable panorama attract (thanks nuezz!)
    WriteByte pRAMBASE + ATTRACT_MODE, &H1
    
    If bGameState > &H2 Then
      ' once network up...
      bMasterNode = LastFrame.Packet(iMasterCar).x018_MasterNode
      bMasterState = LastFrame.Packet(iMasterCar).x01B_RemoteGameState
      For iIndex = 0 To 7
        If LastFrame.Packet(iIndex).x00C_LocalNode = bMasterNode Then
          iServerCar = iIndex
          iIndex = 8
        End If
      Next
      Select Case bMasterState
        Case Is > &H12&
          If CoinLock Then
            CoinLock = False
            WriteByte pRAMBASE + CUSTOM_MASK, &HFF
          End If
        Case Is = &H12&
          ' car no. 1
          If Not bMasterNode = LastFrame.Packet(iMasterCar).x00C_LocalNode Then
            If Not bGameState = &H12& Then
              ' auto coin up
              If Not CoinLock Then
                CoinLock = True
                WriteByte pRAMBASE + CUSTOM_MASK, &HF5
              End If
            End If
          End If
      End Select
      
      If bGameState = &H16 Or bGameState = &H15 Or bGameState = &H14 Or bGameState = &H13 Then
        If bMasterState = &H16 Or bMasterState = &H15 Or bMasterState = &H14 Or bMasterState = &H13 Then
          If Not Ingame Then
            Ingame = True
            OnRaceStart LastFrame.Packet(iMasterCar).x017_CourseActive, bMasterNode, LastFrame.Packet(iServerCar).x00B_NodeCount
            CLIENT_CarNo = 0
            CLIENT_ViewNo = 3
          End If
        End If
        
        ' Enforce automatic gears
        WriteByte pRAMBASE + CAR_GEAR_MODE, 0
        WriteByte pRAMBASE + CAR_GEAR_MODE + 1, 0
        
        ' Set Laps to 255 to avoid live client finishing the race
        WriteByte pRAMBASE + LAPS_TOTAL, &HFF
        
        ' Y
        WriteSingle pRAMBASE + CAR_Y, LastFrame.Packet(iSlaveCar).x05C_CarY
        
        ' X
        WriteSingle pRAMBASE + CAR_X, LastFrame.Packet(iSlaveCar).x064_CarX
        
        ' Speed
        WriteSingle pRAMBASE + CAR_SPEED, LastFrame.Packet(iSlaveCar).x074_CarSpeed
        
        ' YAW
        WriteInteger pRAMBASE + CAR_YAW, LastFrame.Packet(iSlaveCar).x08E_CarYaw
        
        ' CarNo / Icon
        WriteByte pRAMBASE + CAR_ICON, LastFrame.Packet(iSlaveCar).x0D4_CarNumber
      
        ' Car Model (and Number)
        WriteLong pRAMBASE + CAR_MODEL_BODY, CarToModel(LastFrame.Packet(iSlaveCar).x0D4_CarNumber)
        WriteLong pRAMBASE + CAR_MODEL_NUMBER, 0
        
        ' Process Camera Stuff
        LiveCamera.ProcessPackets LastFrame.Packet(iServerCar), LastFrame.Packet(iSlaveCar)
        
        ' Update Overlay (if enabled)
        LiveOverlay.ProcessPackets LastFrame.Packet(iServerCar), LastFrame.Packet(iSlaveCar)

        ' Replace cars if needed
        If CLIENT_LastCarNo <> CLIENT_CarNo Then
          If CLIENT_TableHack Then
            ' restore table
            WriteByte pRAMBASE + CAR_NODE + (CLIENT_TableIndex * &H300&), CLIENT_LastNode
            WriteByte pRAMBASE + CAR_ICON + (CLIENT_TableIndex * &H300&), CLIENT_LastCarNo
            CLIENT_TableHack = False
          End If
          If Not CLIENT_TableHack Then
            CLIENT_LastCarNo = CLIENT_CarNo
            ' manipulate table
            For iIndex = 1 To 7
              If ReadByte(pRAMBASE + CAR_ICON + (iIndex * &H300&)) = CLIENT_CarNo Then
                CLIENT_TableIndex = iIndex
                CLIENT_LastNode = ReadByte(pRAMBASE + CAR_NODE + (iIndex * &H300&))
                CLIENT_TableHack = True
                WriteByte pRAMBASE + CAR_NODE + (iIndex * &H300&), ReadByte(pRAMBASE + CAR_NODE)
              End If
            Next
          End If
        End If
      Else
        If Ingame Then
          Ingame = False
          OnRaceEnd
        End If
      End If
    End If
  End If
End Sub


Private Function ProcessFakeFrame(sBuffer As String) As String
  Dim lIndex As Long
  
  ' convert from wide-string to byte array
  Dim baBuffer() As Byte
  baBuffer() = StrConv(sBuffer, vbFromUnicode)
  
  ' check header status
  Select Case baBuffer(4)
    Case 0
      ' type 0 packet
      ' add 7 cabs, set count to 8
      baBuffer(&H5) = 8   ' Player Count
      
      baBuffer(&HC) = 2   ' Cab #2
      baBuffer(&H12) = 3  ' Cab #3
      baBuffer(&H18) = 4  ' Cab #4
      baBuffer(&H1E) = 5  ' Cab #5
      baBuffer(&H24) = 6  ' Cab #6
      baBuffer(&H2A) = 7  ' Cab #7
      baBuffer(&H30) = 8  ' Cab #8
      
      OnLinkDown
      
    Case 1
      ' type 1 packet
      ' count up ids
      baBuffer(&H5) = 8   ' Player Count
      baBuffer(&H6) = 9   ' Next Node
      
      baBuffer(&HC) = 8   ' Cab #2
      baBuffer(&H12) = 7  ' Cab #3
      baBuffer(&H18) = 6  ' Cab #4
      baBuffer(&H1E) = 5  ' Cab #5
      baBuffer(&H24) = 4  ' Cab #6
      baBuffer(&H2A) = 3  ' Cab #7
      baBuffer(&H30) = 2  ' Cab #8
      baBuffer(&H36) = 1  ' Cab #1
      
    Case 2
      ' type 2 packet
      If baBuffer(&H1A) >= &H80 Then
        ' sync phase done!
        OnLinkUp
        ProcessFakeFrame = ""
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
