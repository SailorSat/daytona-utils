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
  Dim iCount As Integer
  For iCount = 0 To 7
    Set paPacket(iCount) = New DaytonaPacket
  Next
End Sub

Public Property Get Buffer() As String
  Dim iCount As Integer
  Buffer = StrConv(baBuffer, vbUnicode)
  For iCount = 0 To 7
    Buffer = Buffer & paPacket(iCount).Buffer
  Next
End Property

Public Property Let Buffer(ByVal sBuffer As String)
  Dim iCount As Integer
  Dim iOffset As Integer
  baBuffer = StrConv(Mid(sBuffer, 1, 5), vbFromUnicode)
  For iCount = 0 To 7
    iOffset = 6 + (iCount * 448)
    paPacket(iCount).Buffer = Mid(sBuffer, iOffset, 448)
  Next
End Property

' ---------------------------------------------------------------------------- '

Public Function Packet(iIndex As Integer) As DaytonaPacket
  Set Packet = paPacket(iIndex)
End Function

Public Property Get Status() As Byte
  Status = baBuffer(4)
End Property

Public Property Let Status(ByVal newValue As Byte)
  baBuffer(4) = newValue
End Property

