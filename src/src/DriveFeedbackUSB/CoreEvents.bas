Attribute VB_Name = "CoreEvents"
Option Explicit

Public Sub OnStatus(sModule As String, lStatus As Long, sStatus As String)
  Window.BackColor = lStatus
End Sub

Public Sub OnText(sModule As String, sTopic As String, sText As String)
  Select Case sTopic
    Case "Drive"
      Window.txtDrive.Text = sText
    Case "Lamps"
      Window.txtLamp.Text = sText
    Case "Pwm"
      Window.txtPwm.Text = sText
    Case "Debug"
      Window.lblDebug.Caption = sText
  End Select
End Sub

Public Sub OnDaytonaEx(Data As Byte)
  ' silently drop in feedback app
End Sub
