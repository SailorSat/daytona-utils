VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DaytonaFrame"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private baBuffer() As Byte

Private paPacket(0 To 7) As DaytonaPacket

Private Sub Class_Initialize()
  ReDim baBuffer(0 To 4)
  Dim lCount As Long
  For lCount = 0 To 7
    Set paPacket(lCount) = New DaytonaPacket
  Next
End Sub

Public Property Get Buffer() As String
  Dim lCount As Long
  Buffer = StrConv(baBuffer, vbUnicode)
  For lCount = 0 To 7
    Buffer = Buffer & paPacket(lCount).Buffer
  Next
End Property

Public Property Let Buffer(ByVal sBuffer As String)
  Dim lCount As Long
  Dim lOffset As Long
  baBuffer = StrConv(Mid(sBuffer, 1, 5), vbFromUnicode)
  For lCount = 0 To 7
    lOffset = 6 + (lCount * 448)
    paPacket(lCount).Buffer = Mid(sBuffer, lOffset, 448)
  Next
End Property

' ---------------------------------------------------------------------------- '

Public Function Packet(lIndex As Long) As DaytonaPacket
  Set Packet = paPacket(lIndex)
End Function

Public Property Get Status() As Byte
  Status = baBuffer(4)
End Property

Public Property Let Status(ByVal newValue As Byte)
  baBuffer(4) = newValue
End Property

