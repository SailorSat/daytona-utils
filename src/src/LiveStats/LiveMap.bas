Attribute VB_Name = "LiveMap"
Option Explicit

Private MapOffset(0 To 15) As Long

Public STATS_LocalAddress As String
Public STATS_Socket As Long

Public STATS_Online As Boolean
Public STATS_Players As Long

Public STATS_CarToNode(0 To 7) As Long
Public STATS_NodeToCar(1 To 8) As Long

Private STATS_FlipFlop As Byte

Private CurrentTrack As Byte
Private CurrentNode As Byte
Private CurrentOffset As Integer


Public Sub STATS_OnLoad()
  Dim Host As String
  Dim Port As Long
  
  ' Local (client)
  Host = ReadIni("stats.ini", "client", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("stats.ini", "client", "localport", "8000"))
  STATS_LocalAddress = WSABuildSocketAddress(Host, Port)
  If STATS_LocalAddress = "" Then
    MsgBox "Something went wrong! #STATS_LocalAddress", vbCritical Or vbOKOnly, Window.Caption
    OnUnload
  End If

  STATS_Socket = ListenUDP(STATS_LocalAddress)
  If STATS_Socket = -1 Then
    MsgBox "Something went wrong! #STATS_Socket", vbCritical Or vbOKOnly, Window.Caption
    OnUnload
  End If
  
  CurrentTrack = 255
  CurrentNode = 255

  Dim Index As Integer
  For Index = 0 To 8
    Window2.imgDistance(Index).Move 0, ScreenSizeY
    Window2.imgCar(Index).Move 0, ScreenSizeY
  Next
  
  MapOffset(0) = ScreenSizeX - 16
  MapOffset(1) = ScreenSizeX / 2 - 320
  MapOffset(2) = ScreenSizeY / 2 - 192
  MapOffset(3) = ScreenSizeX / 2 - 8
  MapOffset(4) = ScreenSizeY / 2
  MapOffset(5) = ScreenSizeY / 2 - 10
  
  STATS_FlipFlop = 0
  
  STATS_Online = False
  STATS_Players = 0
End Sub


Public Sub STATS_OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  Dim LastFrame As DaytonaFrame
  Dim Index As Long
  Dim Packet As DaytonaPacket
  
  Set LastFrame = ParseFrame(sBuffer)
  If Not LastFrame Is Nothing Then
    If Not STATS_Online Then
      If LastFrame.Status = 2 And LastFrame.Packet(0).x016_LocalGameState > 0 Then
        Dim FoundCar(0 To 7) As Boolean, LocalCar As Byte
        STATS_Players = 0
        For Index = 0 To 7
          Set Packet = LastFrame.Packet(Index)
          LocalCar = Packet.x0D4_CarNumber
          If FoundCar(LocalCar) Then
            Index = 8
          Else
            FoundCar(LocalCar) = True
            STATS_Players = STATS_Players + 1
          End If
        Next
        
        For Index = 0 To STATS_Players - 1
          LocalCar = STATS_Players - Index + 1
          If LocalCar > STATS_Players Then LocalCar = 1
          STATS_CarToNode(Index) = LocalCar
          STATS_NodeToCar(LocalCar) = Index
        Next
      
        STATS_Online = True
      End If
    End If
    If CurrentTrack < 3 Then
      If STATS_FlipFlop > 0 Then
        STATS_FlipFlop = STATS_FlipFlop - 1
      Else
        For Index = 0 To STATS_Players - 1
          Set Packet = LastFrame.Packet(Index)
          If Packet.x00C_LocalNode = CurrentNode Or Packet.x018_MasterNode = CurrentNode Then
            If Packet.x016_LocalGameState = &H14 Or Packet.x01B_RemoteGameState = &H14 Or Packet.x016_LocalGameState = &H16 Or Packet.x01B_RemoteGameState = &H16 Then
              DrawMap Packet
              DrawDistance Packet
            End If
          End If
        Next
        STATS_FlipFlop = 1
      End If
    End If
    If CLIENT_Online Then
      If CLIENT_Hooked Then
        LiveClient.ProcessFrame LastFrame
      End If
      Winsock.SendUDP CLIENT_Socket, LastFrame.Buffer, CLIENT_RemoteAddress
    End If
  End If
End Sub


Public Sub STATS_OnRaceStart(Track As Byte, Node As Byte, Players As Byte)
  CurrentTrack = Track
  CurrentNode = Node
  
  Window2.shpDistance.Move 8, 56, MapOffset(0), 16
  Window2.shpDistance.Visible = True
  BitBlt Window2.hdc, MapOffset(1), MapOffset(2), 640, 384, Window2.pbTrack(CurrentTrack).hdc, 0, 0, vbSrcCopy
  Window2.Refresh
End Sub


Public Sub STATS_OnRaceEnd()
  CurrentTrack = 255
  CurrentNode = 255
  
  Window2.shpDistance.Visible = False
  BitBlt Window2.hdc, MapOffset(1), MapOffset(2), 640, 384, Window2.pbBackground.hdc, 0, 48, vbSrcCopy
  Window2.Refresh
  
  Dim Index As Integer
  For Index = 0 To 8
    Window2.imgDistance(Index).Move 0, ScreenSizeY
    Window2.imgCar(Index).Move 0, ScreenSizeY
  Next
End Sub


Private Sub DrawDistance(Packet As DaytonaPacket)
  Dim DstX As Long
  DstX = DistanceToPixel(Packet.x0A0_Distance)
  Window2.imgDistance(Packet.x0D4_CarNumber).Move 8 + DstX, 56
End Sub


Private Sub DrawMap(Packet As DaytonaPacket)
  Dim PosX As Single
  Dim PosY As Single
  Dim PosZ As Single
  Dim IntX As Long
  Dim IntY As Long
  Dim IntZ As Long
  
  PosX = Packet.x05C_CarY
  PosY = Packet.x064_CarX
  'PosZ = Packet.x060_CarZ
  
  If CurrentTrack = 0 Then
    IntX = (MapOffset(3) - (PosX * 0.9))
    IntY = (MapOffset(4) + (PosY * 0.9))
    'IntZ = 64 + PosZ
    Window2.imgCar(Packet.x0D4_CarNumber).Move IntX, IntY
  ElseIf CurrentTrack = 1 Then
    IntX = (MapOffset(3) + (PosY / 5.5))
    IntY = (MapOffset(5) + (PosX / 5.5))
    'IntZ = 64 + PosZ
    Window2.imgCar(Packet.x0D4_CarNumber).Move IntX, IntY
  ElseIf CurrentTrack = 2 Then
    IntX = (MapOffset(3) - (PosY / 2.25))
    IntY = (MapOffset(4) - (PosX / 2.25))
    'IntZ = 64 + PosZ
    Window2.imgCar(Packet.x0D4_CarNumber).Move IntX, IntY
  End If
End Sub


Private Function DistanceToPixel(Distance As Integer) As Long
  If Distance > &HF000 Then
    DistanceToPixel = 0
  End If
  Select Case CurrentTrack
    Case 0
      DistanceToPixel = (Abs(Distance) / &HF3C) * MapOffset(0)
    Case 1
      DistanceToPixel = (Abs(Distance) / &H1356) * MapOffset(0)
    Case 2
      DistanceToPixel = (Abs(Distance) / &H12FC) * MapOffset(0)
    Case Else
      DistanceToPixel = 0
  End Select
End Function
