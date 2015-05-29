Attribute VB_Name = "LiveCamera"
Option Explicit

Private Type CAMERA_Setup
  Y_POS As Long
  Z_POS As Long
  Y_SCR As Long
  ZOOM As Long
  X_ROT As Integer
  UNKNOWN As Integer
End Type

Private Type CAMERA_Location
  Mode As Byte
  Name As String
  X As Single
  Y As Single
  Distance As Single
  Rotation As Long
  View As Byte
End Type

Public CAMERA_Name(0 To 15) As String

Private CAMERA_Custom(0 To 2, 5 To 15) As CAMERA_Setup
Private CAMERA_Preset(0 To 7) As CAMERA_Location


Public Sub CAMERA_OnLoad()
  CAMERA_Name(0) = "   BUMPER   "
  CAMERA_Name(1) = "   DRIVER   "
  CAMERA_Name(2) = "   BEHIND   "
  CAMERA_Name(3) = " FAR BEHIND "
  CAMERA_Name(4) = " HELICOPTER "
  ResetCustomPresets
End Sub


Private Sub ResetCustomPresets()
  Dim Index As Integer
  Dim Track As Integer
  For Track = 0 To 2
    ' Reset Views
    For Index = 5 To 15
      CAMERA_Name(Index) = "  SOMEWHERE  "
      With CAMERA_Custom(Track, Index)
        .Y_POS = &H3FF33333 '3FF33333
        .Z_POS = &HC07851EC 'C07851EC
        .Y_SCR = &HC2480000 'C2480000
        .ZOOM = &H43480000  '43480000
        .X_ROT = &HCCC      '0CCC
        .UNKNOWN = &HFF     '00FF
      End With
    Next
  Next
End Sub

Public Sub CAMERA_OnRaceStart(Track As Byte, Node As Byte, Players As Byte)
  Dim Index As Integer
  ' Reset Presets
  For Index = 0 To 7
    With CAMERA_Preset(Index)
      .Mode = 0
      .Name = ""
      .X = 0
      .Y = 0
      .Distance = 0
      .Rotation = 0
    End With
  Next
  
  ' Define presets based on Track
  Select Case Track
    Case 0
      ' BEGINNER
      With CAMERA_Preset(0)
        .Mode = 1
        .Name = " FINISH LINE "
        .X = -89
        .Y = -98
        .Distance = 80
        .View = 15
      End With
  
      With CAMERA_Preset(1)
        .Mode = 1
        .Name = " PIN CORNER "
        .X = 130
        .Y = -264
        .Distance = 100
        .View = 15
      End With
  
    Case 2
      ' ADVANCED
      With CAMERA_Preset(0)
        .Mode = 3
        .Name = "  LONG TURN  "
        .X = 370
        .Y = -87
        .Distance = 250
        .Rotation = &H10000
        .View = 14
      End With
  
      With CAMERA_Preset(1)
        .Mode = 2
        .Name = " S-CURVE #1 "
        .X = -475
        .Y = 278
        .Distance = 80
        .View = 14
      End With
  
      With CAMERA_Preset(2)
        .Mode = 2
        .Name = " S-CURVE #2 "
        .X = -532
        .Y = 59
        .Distance = 80
        .View = 14
      End With
  
      With CAMERA_Preset(3)
        .Mode = 2
        .Name = " S-CURVE #3 "
        .X = -211
        .Y = 128
        .Distance = 80
        .View = 14
      End With
  
      With CAMERA_Preset(4)
        .Mode = 1
        .Name = "   CANYON   "
        .X = -586
        .Y = -233
        .Distance = 100
        .View = 15
      End With
  End Select
End Sub


Public Sub ProcessPackets(ServerPacket As DaytonaPacket, ClientPacket As DaytonaPacket)
  ' check if overlay is visible
  If OVERLAY_Enabled Then
    Dim ViewNo As Byte
    ViewNo = CLIENT_ViewNo
    
    Dim Preset As Byte
    Dim FoundOne As Boolean
    
    Dim X1 As Single
    Dim Y1 As Single
    
    Dim X2 As Single
    Dim Y2 As Single
    
    Dim Dist As Single
    
    Dim Deg As Long
    Dim Yaw As Long
    Dim Rot As Long
    Dim RotI As Integer
    Dim ZPos As Long
    
    X1 = ClientPacket.x064_CarX
    Y1 = ClientPacket.x05C_CarY
    
    FoundOne = False
    For Preset = 0 To 7
      If Not FoundOne Then
        With CAMERA_Preset(Preset)
          If .Mode > 0 Then
            ' any other mode - check distance
            X2 = .X
            Y2 = .Y
            Dist = Distance(X1, Y1, X2, Y2)
            
            If Dist < .Distance Then
              FoundOne = True
              Select Case .Mode
                Case 1
                  ' -= Point-to-Car =-
                  ' Turn to Point
                  Deg = Degrees(X2, Y2, X1, Y1) ' from POINT to CAR
                  Yaw = ReadInteger(pRAMBASE + CAR_YAW)
                  Rot = (Deg - Yaw)
                  
                  ' Zoom out
                  ZPos = (CLng(Sqr(Distance(X1, Y1, X2, Y2)) * &H400000) + &HC0000000)
                  
                  ' Use correct name and view
                  CAMERA_Name(.View) = .Name
                  ViewNo = .View
                  
                Case 2
                  ' -= Car-to-Point =-
                  ' Turn to Point
                  Deg = Degrees(X1, Y1, X2, Y2) ' from CAR to POINT
                  Yaw = ReadInteger(pRAMBASE + CAR_YAW)
                  Rot = (Deg - Yaw)
                  
                  ' Don't zoom
                  ZPos = &H43480000
                  
                  ' Use correct name and view
                  CAMERA_Name(.View) = .Name
                  ViewNo = .View
                  
                Case 3
                  ' -= Car-Rotation =-
                  ' Turn to Point
                  Deg = .Rotation
                  Yaw = ReadInteger(pRAMBASE + CAR_YAW)
                  Rot = (Deg - Yaw)
                  
                  ' Use correct name and view
                  CAMERA_Name(.View) = .Name
                  ViewNo = .View
              End Select
            End If
          End If
        End With
      End If
    Next
    
    If FoundOne Then
      RtlMoveMemory RotI, Rot, 2
      WriteInteger pRAMBASE + CAMERA_ROTATION, RotI
      WriteLong pBACKUPBASE + &H350, ZPos
      WriteByte pRAMBASE + View, ViewNo
    Else
      ' Change View
      WriteInteger pRAMBASE + CAMERA_ROTATION, 0
      WriteByte pRAMBASE + View, ViewNo
    End If
  End If
End Sub

