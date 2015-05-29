Attribute VB_Name = "DaytonaMath"
Option Explicit


Private Const Pi As Double = 3.14159265358979


Private Function ArcSin(X As Double) As Double
  If (Sqr(1 - X * X) <= 0.000000000001) And (Sqr(1 - X * X) >= -0.000000000001) Then
    ArcSin = Pi / 2
  Else
    ArcSin = Atn(X / Sqr(-X * X + 1))
  End If
End Function


Public Function Distance(X1 As Single, Y1 As Single, X2 As Single, Y2 As Single) As Double
  Dim XD As Single
  Dim YD As Single
  
  XD = X2 - X1
  YD = Y2 - Y1
  
  Distance = Sqr(XD * XD + YD * YD)
End Function


Public Function Degrees(X1 As Single, Y1 As Single, X2 As Single, Y2 As Single) As Long
  Dim A As Single
  Dim B As Single
  Dim C As Double
  
  Dim SinA As Double
  
  Dim Alpha As Double
  Dim DegDiff As Long
  
  
  A = Y2 - Y1
  B = X2 - X1
  C = Distance(X1, Y1, X2, Y2)
  
  SinA = Abs(A) / C
  DegDiff = (ArcSin(SinA) * &H8000& / Pi)
  If A > 0 And B > 0 Then
    Degrees = &H10000 - DegDiff
  ElseIf A < 0 And B > 0 Then
    Degrees = DegDiff
  ElseIf A > 0 And B < 0 Then
    Degrees = &H8000& + DegDiff
  ElseIf A < 0 And B < 0 Then
    Degrees = &H8000& - DegDiff
  End If
End Function

