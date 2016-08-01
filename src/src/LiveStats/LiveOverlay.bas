Attribute VB_Name = "LiveOverlay"
Option Explicit

Public OVERLAY_FlipFlop As Boolean
Public OVERLAY_Enabled As Boolean
Public OVERLAY_Players As Byte
Public OVERLAY_FrameCounter As Long


Public Sub OVERLAY_OnLoad()
  OVERLAY_Enabled = False
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
    BitBlt Window.hdc, ScreenWidth - 80, 120, 64, 16, Window.pbVFormula.hdc, 0, 400 + (CInt(Track) * 16), vbSrcCopy
    
    ' TIME
    BitBlt Window.hdc, ScreenWidth / 2 - 16, 12, 31, 9, Window.pbVFormula.hdc, 0, 64, vbSrcCopy
    
    ' RANK NUMBERS
    OVERLAY_Players = Players
    Offset = ScreenHeight - 32
    For Index = Players - 1 To 0 Step -1
      BitBlt Window.hdc, 8, Offset, 16, 24, Window.pbVFormula.hdc, Index * 16, 112, vbSrcCopy
      Offset = Offset - 24
    Next
    ' POSITION
    BitBlt Window.hdc, 32, Offset + 8, 61, 9, Window.pbVFormula.hdc, 64, 48, vbSrcCopy
    
    ' CAR NO.
    BitBlt Window.hdc, ScreenWidth - 144, ScreenHeight - 104, 54, 16, Window.pbVFormula.hdc, 0, 80, vbSrcCopy
    ' RANK
    BitBlt Window.hdc, ScreenWidth - 144, ScreenHeight - 80, 32, 16, Window.pbVFormula.hdc, 64, 80, vbSrcCopy
    ' LAP
    BitBlt Window.hdc, ScreenWidth - 144, ScreenHeight - 56, 24, 16, Window.pbVFormula.hdc, 0, 96, vbSrcCopy
    ' SPEED
    BitBlt Window.hdc, ScreenWidth - 144, ScreenHeight - 32, 40, 16, Window.pbVFormula.hdc, 64, 96, vbSrcCopy
    
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
    SrcY = ScreenHeight - 32
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
    BitBlt Window.hdc, ScreenWidth - 144, ScreenHeight - 136, 96, 24, Window.pbVFormula.hdc, SrcX, SrcY, vbSrcCopy
    DrawFont 4, 3, ScreenWidth - 48, ScreenHeight - 112, CStr(ClientPacket.x0D4_CarNumber + 1)
  
    '<current time>
    DrawFont 4, 2, ScreenWidth / 2, 24, " " & CStr(ServerPacket.x028_TimeLeft \ 64) & " "
    
    '<current rank>
    DrawFont 4, 3, ScreenWidth - 48, ScreenHeight - 88, LeadSpace(CStr(NodeRank(CarToNode(ClientPacket.x0D4_CarNumber)) + 1), 3)
    Select Case NodeRank(CarToNode(ClientPacket.x0D4_CarNumber))
      Case 0
        'ST
        BitBlt Window.hdc, ScreenWidth - 48, ScreenHeight - 80, 16, 16, Window.pbVFormula.hdc, 64, 64, vbSrcCopy
      Case 1
        'ND
        BitBlt Window.hdc, ScreenWidth - 48, ScreenHeight - 80, 16, 16, Window.pbVFormula.hdc, 80, 64, vbSrcCopy
      Case 2
        'RD
        BitBlt Window.hdc, ScreenWidth - 48, ScreenHeight - 80, 16, 16, Window.pbVFormula.hdc, 96, 64, vbSrcCopy
      Case Else
        'TH
        BitBlt Window.hdc, ScreenWidth - 48, ScreenHeight - 80, 16, 16, Window.pbVFormula.hdc, 112, 64, vbSrcCopy
    End Select
    
    '<current lap>
    DrawFont 4, 3, ScreenWidth - 48, ScreenHeight - 64, LeadSpace(DistanceToLap(ClientPacket.x017_CourseActive, ClientPacket.x0A0_Distance), 3)
    
    '<current speed>
    DrawFont 4, 3, ScreenWidth - 48, ScreenHeight - 40, LeadSpace(CStr(ClientPacket.x058_CarKMH), 3)
    BitBlt Window.hdc, ScreenWidth - 48, ScreenHeight - 35, 32, 19, Window.pbVFormula.hdc, 176, 149, vbSrcCopy
    
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


Private Sub DrawFont(Font As Byte, Align As Byte, ToX As Integer, ToY As Integer, Text As String)
  Dim SizeX As Integer  ' Charwidth
  Dim SizeY As Integer  ' Charheight
  Dim SizeL As Integer  ' Chars per Line
  
  Dim SrcX As Integer
  Dim SrcY As Integer
  
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

  
  Dim OffX As Integer
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
      Dim Col As Integer
      Dim Row As Integer
    
      Col = Char Mod SizeL
      Row = Char \ SizeL
    
      BitBlt Window.hdc, ToX - OffX + (Index * SizeX), ToY, SizeX, SizeY, Window.pbVFormula.hdc, SrcX + (Col * SizeX), SrcY + (Row * SizeY), vbSrcCopy
    End If
  Next
End Sub
