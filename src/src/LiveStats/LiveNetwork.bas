Attribute VB_Name = "LiveNetwork"
Option Explicit

Public Function FakeNetworkIfNeeded(Frame As DaytonaFrame) As Byte
  Dim Car(0 To 7) As Byte
  Dim Index As Integer
  Dim Id As Byte
  Dim Count As Byte
  
  For Index = 0 To 7
    With Frame.Packet(Index)
      Id = .x0D4_CarNumber
      If Car(Id) > 0 Then
        .x00B_NodeCount = 1
        .x00C_LocalNode = Index
        .x00D_RemoteNode0 = 0
        .x016_LocalGameState = &H16
        .x018_MasterNode = Index
        .x01B_RemoteGameState = &H16
        .x0D4_CarNumber = 0
      Else
        Car(Id) = 1
        Count = Count + 1
      End If
    End With
  Next
  FakeNetworkIfNeeded = Count
End Function
