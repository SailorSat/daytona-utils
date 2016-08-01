Attribute VB_Name = "LiveMap"
Option Explicit

Public STATS_LocalAddress As String
Public STATS_Socket As Long

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
  For Index = 0 To 7
    Window2.imgDistance(Index).Move 0, ScreenHeight
    Window2.imgCar(Index).Move 0, ScreenHeight
  Next
End Sub


Public Sub STATS_OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  Dim LastFrame As DaytonaFrame
  Dim Index As Integer
  Dim Packet As DaytonaPacket
  
  Set LastFrame = ParseFrame(sBuffer)
  If Not LastFrame Is Nothing Then
    If CurrentTrack < 3 Then
      For Index = 0 To 7
        Set Packet = LastFrame.Packet(Index)
        If Packet.x016_LocalGameState = &H14 Or Packet.x01B_RemoteGameState = &H14 Or Packet.x016_LocalGameState = &H16 Or Packet.x01B_RemoteGameState = &H16 Then
          If Packet.x00C_LocalNode = CurrentNode Or Packet.x018_MasterNode = CurrentNode Then
            DrawMap Packet
            DrawDistance Packet
          End If
        End If
      Next
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
  
  Window2.shpDistance.Move 8, 8, ScreenWidth - 16, 16
  Window2.shpDistance.Visible = True
  BitBlt Window2.hdc, (ScreenWidth / 2) - 320, (ScreenHeight / 2) - 192, 640, 384, Window2.pbTrack(CurrentTrack).hdc, 0, 0, vbSrcCopy
  Window2.Refresh
End Sub


Public Sub STATS_OnRaceEnd()
  CurrentTrack = 255
  CurrentNode = 255
  
  Window2.shpDistance.Visible = False
  BitBlt Window2.hdc, (ScreenWidth / 2) - 320, (ScreenHeight / 2) - 192, 640, 384, Window2.pbBackground.hdc, 0, 48, vbSrcCopy
  Window2.Refresh
  
  Dim Index As Integer
  For Index = 0 To 7
    Window2.imgDistance(Index).Move 0, ScreenHeight
    Window2.imgCar(Index).Move 0, ScreenHeight
  Next
End Sub


Private Sub DrawDistance(Packet As DaytonaPacket)
  Dim DstX As Long
  DstX = DistanceToPixel(Packet.x0A0_Distance)
  Window2.imgDistance(Packet.x0D4_CarNumber).Move 10 + DstX, 8
End Sub


Private Sub DrawMap(Packet As DaytonaPacket)
  Dim PosX As Single
  Dim PosY As Single
  Dim PosZ As Single
  Dim IntX As Integer
  Dim IntY As Integer
  Dim IntZ As Integer
  If CurrentTrack = 0 Then
    PosX = Packet.x05C_CarY
    PosY = Packet.x064_CarX
    PosZ = Packet.x060_CarZ
    IntX = ((ScreenWidth / 2) - (PosX * 0.9))
    IntY = ((ScreenHeight / 2) - 40 + (PosY * 0.9))
    IntZ = 64 + PosZ
    Window2.imgCar(Packet.x0D4_CarNumber).Move -8 + IntX, 40 + IntY
  ElseIf CurrentTrack = 1 Then
    PosX = Packet.x064_CarX
    PosY = Packet.x05C_CarY
    PosZ = Packet.x060_CarZ
    IntX = ((ScreenWidth / 2) + (PosX / 5.5))
    IntY = ((ScreenHeight / 2) - 50 + (PosY / 5.5))
    IntZ = 64 + PosZ
    Window2.imgCar(Packet.x0D4_CarNumber).Move -8 + IntX, 40 + IntY
  ElseIf CurrentTrack = 2 Then
    PosX = Packet.x064_CarX
    PosY = Packet.x05C_CarY
    PosZ = Packet.x060_CarZ
    IntX = ((ScreenWidth / 2) - (PosX / 2.25))
    IntY = ((ScreenHeight / 2) - 40 - (PosY / 2.25))
    IntZ = 64 + PosZ
    Window2.imgCar(Packet.x0D4_CarNumber).Move -8 + IntX, 40 + IntY
  End If
End Sub


Private Function DistanceToPixel(Distance As Integer) As Long
  If Distance > &HF000 Then
    DistanceToPixel = 0
  End If
  Select Case CurrentTrack
    Case 0
      DistanceToPixel = (Abs(Distance) / &HF3C) * (ScreenWidth - 16)
    Case 1
      DistanceToPixel = (Abs(Distance) / &H1356) * (ScreenWidth - 16)
    Case 2
      DistanceToPixel = (Abs(Distance) / &H12FC) * (ScreenWidth - 16)
    Case Else
      DistanceToPixel = 0
  End Select
End Function

