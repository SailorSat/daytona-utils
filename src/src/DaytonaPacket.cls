VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DaytonaPacket"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private baBuffer() As Byte

Private Sub Class_Initialize()
  ReDim baBuffer(0 To 447)
End Sub

Public Property Get Buffer() As String
  Buffer = StrConv(baBuffer, vbUnicode)
End Property

Public Property Let Buffer(ByVal sBuffer As String)
  baBuffer = StrConv(sBuffer, vbFromUnicode)
End Property

Public Function HexDump() As String
  Dim iCount As Integer
  Dim iLine As Integer
  
  For iCount = 0 To 447
    If iCount Mod 1 = 0 Then HexDump = HexDump & " "
    If iCount Mod 8 = 0 Then HexDump = HexDump & "   "
    If iCount Mod 16 = 0 Then
      HexDump = HexDump & vbCrLf & LeadZero(Hex(iLine), 8) & vbTab
      iLine = iLine + 16
    End If
    HexDump = HexDump & LeadZero(Hex(baBuffer(iCount)), 2)
  Next
End Function

' ---------------------------------------------------------------------------- '

Public Property Get z000_Position(Index As Integer) As Byte
  z000_Position = baBuffer(&H0 + Index)
End Property
Public Property Let z000_Position(Index As Integer, ByVal newValue As Byte)
  baBuffer(&H0 + Index) = newValue
End Property


Public Property Get z00C_Node(Index As Integer) As Byte
  z00C_Node = baBuffer(&HC + Index)
End Property
Public Property Let z00C_Node(Index As Integer, ByVal newValue As Byte)
  baBuffer(&HC + Index) = newValue
End Property


Public Property Get x00A_FrameNumber() As Byte
  x00A_FrameNumber = baBuffer(&HA)
End Property
Public Property Let x00A_FrameNumber(ByVal newValue As Byte)
  baBuffer(&HA) = newValue
End Property


Public Property Get x00B_NodeCount() As Byte
  x00B_NodeCount = baBuffer(&HB)
End Property
Public Property Let x00B_NodeCount(ByVal newValue As Byte)
  baBuffer(&HB) = newValue
End Property


Public Property Get x00C_LocalNode() As Byte
  x00C_LocalNode = baBuffer(&HC)
End Property
Public Property Let x00C_LocalNode(ByVal newValue As Byte)
  baBuffer(&HC) = newValue
End Property


Public Property Get x00D_RemoteNode0() As Byte
  x00D_RemoteNode0 = baBuffer(&HD)
End Property
Public Property Let x00D_RemoteNode0(ByVal newValue As Byte)
  baBuffer(&HD) = newValue
End Property


Public Property Get x014_CourseSelect() As Byte
  x014_CourseSelect = baBuffer(&H14)
End Property
Public Property Let x014_CourseSelect(ByVal newValue As Byte)
  baBuffer(&H14) = newValue
End Property


Public Property Get x015_Difficulty() As Byte
  x015_Difficulty = baBuffer(&H15)
End Property
Public Property Let x015_Difficulty(ByVal newValue As Byte)
  baBuffer(&H15) = newValue
End Property


Public Property Get x016_LocalGameState() As Byte
  x016_LocalGameState = baBuffer(&H16)
End Property
Public Property Let x016_LocalGameState(ByVal newValue As Byte)
  baBuffer(&H16) = newValue
End Property


Public Property Get x017_CourseActive() As Byte
  x017_CourseActive = baBuffer(&H17)
End Property
Public Property Let x017_CourseActive(ByVal newValue As Byte)
  baBuffer(&H17) = newValue
End Property


Public Property Get x018_MasterNode() As Byte
  x018_MasterNode = baBuffer(&H18)
End Property
Public Property Let x018_MasterNode(ByVal newValue As Byte)
  baBuffer(&H18) = newValue
End Property


Public Property Get x01B_RemoteGameState() As Byte
  x01B_RemoteGameState = baBuffer(&H1B)
End Property
Public Property Let x01B_RemoteGameState(ByVal newValue As Byte)
  baBuffer(&H1B) = newValue
End Property


Public Property Get x01C_RemoteSubState() As Byte
  x01C_RemoteSubState = baBuffer(&H1C)
End Property
Public Property Let x01C_RemoteSubState(ByVal newValue As Byte)
  baBuffer(&H1C) = newValue
End Property


Public Property Get x028_TimeLeft() As Long
  RtlMoveMemory x028_TimeLeft, baBuffer(&H28), 4
End Property
Public Property Let x028_TimeLeft(ByVal newValue As Long)
  RtlMoveMemory baBuffer(&H28), newValue, 4
End Property


Public Property Get x058_CarKMH() As Integer
  RtlMoveMemory x058_CarKMH, baBuffer(&H58), 2
End Property
Public Property Let x058_CarKMH(ByVal newValue As Integer)
  RtlMoveMemory baBuffer(&H58), newValue, 2
End Property


Public Property Get x05C_CarY() As Single
  RtlMoveMemory x05C_CarY, baBuffer(&H5C), 4
End Property
Public Property Let x05C_CarY(ByVal newValue As Single)
  RtlMoveMemory baBuffer(&H5C), newValue, 4
End Property


Public Property Get x060_CarZ() As Single
  RtlMoveMemory x060_CarZ, baBuffer(&H60), 4
End Property
Public Property Let x060_CarZ(ByVal newValue As Single)
  RtlMoveMemory baBuffer(&H60), newValue, 4
End Property


Public Property Get x064_CarX() As Single
  RtlMoveMemory x064_CarX, baBuffer(&H64), 4
End Property
Public Property Let x064_CarX(ByVal newValue As Single)
  RtlMoveMemory baBuffer(&H64), newValue, 4
End Property


Public Property Get x074_CarSpeed() As Single
  RtlMoveMemory x074_CarSpeed, baBuffer(&H74), 4
End Property
Public Property Let x074_CarSpeed(ByVal newValue As Single)
  RtlMoveMemory baBuffer(&H74), newValue, 4
End Property


Public Property Get x08E_CarYaw() As Integer
  RtlMoveMemory x08E_CarYaw, baBuffer(&H8E), 2
End Property
Public Property Let x08E_CarYaw(ByVal newValue As Integer)
  RtlMoveMemory baBuffer(&H8E), newValue, 2
End Property


Public Property Get x0A0_Distance() As Integer
  RtlMoveMemory x0A0_Distance, baBuffer(&HA0), 2
End Property
Public Property Let x0A0_Distance(ByVal newValue As Integer)
  RtlMoveMemory baBuffer(&HA0), newValue, 2
End Property


Public Property Get x0D4_CarNumber() As Byte
  x0D4_CarNumber = baBuffer(&HD4)
End Property
Public Property Let x0D4_CarNumber(ByVal newValue As Byte)
  baBuffer(&HD4) = newValue
End Property

