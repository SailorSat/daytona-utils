Attribute VB_Name = "LiveOverlay"
Option Explicit

Private OverlayOffset(0 To 15) As Long

Public OVERLAY_FlipFlop As Boolean
Public OVERLAY_Enabled As Boolean
Public OVERLAY_Players As Byte
Public OVERLAY_FrameCounter As Long


Public Sub OVERLAY_OnLoad()
  OVERLAY_Enabled = False

  OverlayOffset(0) = ScreenSizeX - 80
  OverlayOffset(1) = ScreenSizeX / 2 - 16
  OverlayOffset(2) = ScreenSizeX - 144
  OverlayOffset(3) = ScreenSizeY - 104
  OverlayOffset(4) = ScreenSizeY - 80
  OverlayOffset(5) = ScreenSizeY - 56
  OverlayOffset(6) = ScreenSizeY - 32
  OverlayOffset(7) = ScreenSizeX - 48
  OverlayOffset(8) = ScreenSizeY - 112
  OverlayOffset(9) = ScreenSizeY - 136
  OverlayOffset(10) = ScreenSizeX / 2
  OverlayOffset(11) = ScreenSizeY - 88
  OverlayOffset(12) = ScreenSizeY - 64
  OverlayOffset(13) = ScreenSizeY - 40
  OverlayOffset(14) = ScreenSizeY - 35
  
End Sub


Public Sub OVERLAY_OnTimer()
  If OVERLAY_Enabled Then
    OVERLAY_FlipFlop = Not OVERLAY_FlipFlop
    ' LIVE
    If OVERLAY_FlipFlop Then
      BitBlt Window.hdc, 16, 16, 112, 48, Window.pbVFormula.hdc, 0, 0, vbSrcCopy
    Else
      BitBlt Window.hdc, 16, 16, 112, 48, Window.pbVFormula.hdc, 320, 240, vbSrcCopy
    End If
  End If
End Sub


Public Sub OVERLAY_OnRaceEnd()
  If OVERLAY_Enabled Then
    OVERLAY_Enabled = False
    Window.Cls
    Window.Refresh
  End If
End Sub


Public Sub OVERLAY_OnRaceStart(Track As Byte, Node As Byte, Players As Byte)
  Dim Offset As Integer
  Dim Index As Integer
  
  If Not OVERLAY_Enabled Then
    OVERLAY_Enabled = True
    
    ' FROM
    BitBlt Window.hdc, 56, 72, 32, 8, Window.pbVFormula.hdc, 0, 48, vbSrcCopy
    ' <TRACK>
    BitBlt Window.hdc, OverlayOffset(0), 120, 64, 16, Window.pbVFormula.hdc, 0, 400 + (CInt(Track) * 16), vbSrcCopy
    
    ' TIME
    BitBlt Window.hdc, OverlayOffset(1), 12, 31, 9, Window.pbVFormula.hdc, 0, 64, vbSrcCopy
    
    ' RANK NUMBERS
    OVERLAY_Players = Players
    Offset = OverlayOffset(6)
    For Index = Players - 1 To 0 Step -1
      BitBlt Window.hdc, 8, Offset, 16, 24, Window.pbVFormula.hdc, Index * 16, 112, vbSrcCopy
      Offset = Offset - 24
    Next
    ' POSITION
    BitBlt Window.hdc, 32, Offset + 8, 61, 9, Window.pbVFormula.hdc, 64, 48, vbSrcCopy
    
    ' CAR NO.
    BitBlt Window.hdc, OverlayOffset(2), OverlayOffset(3), 54, 16, Window.pbVFormula.hdc, 0, 80, vbSrcCopy
    ' RANK
    BitBlt Window.hdc, OverlayOffset(2), OverlayOffset(4), 32, 16, Window.pbVFormula.hdc, 64, 80, vbSrcCopy
    ' LAP
    BitBlt Window.hdc, OverlayOffset(2), OverlayOffset(5), 24, 16, Window.pbVFormula.hdc, 0, 96, vbSrcCopy
    ' SPEED
    BitBlt Window.hdc, OverlayOffset(2), OverlayOffset(6), 40, 16, Window.pbVFormula.hdc, 64, 96, vbSrcCopy
    
    ' SWITCH TO PLAYER 1
    OVERLAY_FrameCounter = 1920
    CLIENT_CarNo = 0
    
    Window.Refresh
  End If
End Sub


Public Sub ProcessPackets(ServerPacket As DaytonaPacket, ClientPacket As DaytonaPacket)
  If OVERLAY_Enabled Then
    Dim SrcX As Integer
    Dim SrcY As Integer
    
    ' RANKING
    Dim NodeRank(1 To 8) As Byte
    Dim Ranking(0 To 7) As Byte
    Dim Index As Integer
    Dim Node As Byte
    Dim Rank As Byte
    For Index = 0 To ServerPacket.x00B_NodeCount - 1
      Node = ServerPacket.z00C_Node(Index)
      Rank = ServerPacket.z000_Position(Index)
      NodeRank(Node) = Rank
      Ranking(Rank) = Node
    Next

    ' RANK PLAYERS
    Rank = OVERLAY_Players
    SrcY = ScreenSizeY - 32
    While Rank > 0
      Rank = Rank - 1
      SrcX = NodeToCar(Ranking(Rank))
      BitBlt Window.hdc, 32, SrcY, 96, 24, Window.pbVFormula.hdc, 0, 144 + (SrcX * 32), vbSrcCopy
      SrcY = SrcY - 24
    Wend
    
    '<LOCATION NAME>
    DrawFont 3, 2, 72, 88, CAMERA_Name(ReadByte(pRAMBASE + View))
    
    '<current car>
    SrcX = 0
    SrcY = 144 + CInt(ClientPacket.x0D4_CarNumber) * 32
    BitBlt Window.hdc, OverlayOffset(2), OverlayOffset(9), 96, 24, Window.pbVFormula.hdc, SrcX, SrcY, vbSrcCopy
    DrawFont 4, 3, OverlayOffset(7), OverlayOffset(8), CStr(ClientPacket.x0D4_CarNumber + 1)
  
    '<current time>
    DrawFont 4, 2, OverlayOffset(10), 24, " " & CStr(ServerPacket.x028_TimeLeft \ 64) & " "
    
    '<current rank>
    DrawFont 4, 3, OverlayOffset(7), OverlayOffset(11), LeadSpace(CStr(NodeRank(CarToNode(ClientPacket.x0D4_CarNumber)) + 1), 3)
    Select Case NodeRank(CarToNode(ClientPacket.x0D4_CarNumber))
      Case 0
        'ST
        BitBlt Window.hdc, OverlayOffset(7), OverlayOffset(4), 16, 16, Window.pbVFormula.hdc, 64, 64, vbSrcCopy
      Case 1
        'ND
        BitBlt Window.hdc, OverlayOffset(7), OverlayOffset(4), 16, 16, Window.pbVFormula.hdc, 80, 64, vbSrcCopy
      Case 2
        'RD
        BitBlt Window.hdc, OverlayOffset(7), OverlayOffset(4), 16, 16, Window.pbVFormula.hdc, 96, 64, vbSrcCopy
      Case Else
        'TH
        BitBlt Window.hdc, OverlayOffset(7), OverlayOffset(4), 16, 16, Window.pbVFormula.hdc, 112, 64, vbSrcCopy
    End Select
    
    '<current lap>
    DrawFont 4, 3, OverlayOffset(7), OverlayOffset(12), LeadSpace(DistanceToLap(ClientPacket.x017_CourseActive, ClientPacket.x0A0_Distance), 3)
    
    '<current speed>
    DrawFont 4, 3, OverlayOffset(7), OverlayOffset(13), LeadSpace(CStr(ClientPacket.x058_CarKMH), 3)
    BitBlt Window.hdc, OverlayOffset(7), OverlayOffset(14), 32, 19, Window.pbVFormula.hdc, 176, 149, vbSrcCopy
    
    Window.Refresh

    ' AUTO SWITCH CAR
    If OVERLAY_FrameCounter = 0 Then
      OVERLAY_FrameCounter = 960
      If OVERLAY_Players = 8 Then
        SrcX = NodeToCar(Ranking(1))
        If CLIENT_CarNo = SrcX Then
          SrcX = NodeToCar(Ranking(2))
        End If
        CLIENT_CarNo = SrcX
      End If
    Else
      OVERLAY_FrameCounter = OVERLAY_FrameCounter - 1
    End If
    
  End If
End Sub


Private Sub DrawFont(Font As Byte, Align As Byte, ToX As Long, ToY As Long, Text As String)
  Dim SizeX As Long  ' Charwidth
  Dim SizeY As Long  ' Charheight
  Dim SizeL As Long  ' Chars per Line
  
  Dim SrcX As Long
  Dim SrcY As Long
  
  Select Case Font
    Case 1
      SizeX = 8
      SizeY = 8
      SizeL = 96
      SrcX = 128
      SrcY = 0
    Case 2
      SizeX = 8
      SizeY = 16
      SizeL = 96
      SrcX = 128
      SrcY = 16
    Case 3
      SizeX = 8
      SizeY = 16
      SizeL = 96
      SrcX = 128
      SrcY = 32
    Case 4
      SizeX = 16
      SizeY = 32
      SizeL = 32
      SrcX = 128
      SrcY = 48
    Case Else
      Exit Sub
  End Select

  
  Dim OffX As Long
  Select Case Align
    Case 1
      ' Left
      OffX = SizeX
    Case 2
      ' Center
      OffX = SizeX + (Len(Text) * SizeX) / 2
    Case 3
      ' Right
      OffX = SizeX + (Len(Text) * SizeX)
    Case Else
      Exit Sub
  End Select
  
  Dim Index As Integer
  For Index = 1 To Len(Text)
    Dim Char As Integer
    Char = Asc(Mid(Text, Index, 1)) - 32
    If Char < 96 Then
      Dim Col As Long
      Dim Row As Long
    
      Col = Char Mod SizeL
      Row = Char \ SizeL
    
      BitBlt Window.hdc, ToX - OffX + (Index * SizeX), ToY, SizeX, SizeY, Window.pbVFormula.hdc, SrcX + (Col * SizeX), SrcY + (Row * SizeY), vbSrcCopy
    End If
  Next
End Sub
