VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "ControlClient"
   ClientHeight    =   240
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   240
   LinkTopic       =   "Form1"
   ScaleHeight     =   240
   ScaleWidth      =   240
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Interval        =   4
      Left            =   0
      Top             =   0
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Me.Move Screen.Width - Me.Width, 0
  Winsock.Load

  Call init_mame(ByVal 1, "Test", AddressOf mame_start, AddressOf mame_stop, AddressOf mame_copydata, AddressOf mame_updatestate)
  ControlClient.Load
  
  Timer.Enabled = True
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Timer.Enabled = False
  
  ControlClient.Unload
  
  Winsock.Unload
  End
End Sub

Private Sub Timer_Timer()
  ControlClient.Timer
End Sub
