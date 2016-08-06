VERSION 5.00
Begin VB.Form Window 
   Appearance      =   0  'Flat
   AutoRedraw      =   -1  'True
   BackColor       =   &H00FF00FF&
   BorderStyle     =   0  'None
   ClientHeight    =   16005
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   19200
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Window"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1067
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1280
   ShowInTaskbar   =   0   'False
   Begin VB.PictureBox pbVFormula 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   7200
      Left            =   0
      Picture         =   "Window.frx":0000
      ScaleHeight     =   480
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   0
      Top             =   0
      Visible         =   0   'False
      Width           =   9600
   End
   Begin VB.Timer Timer 
      Interval        =   500
      Left            =   1320
      Top             =   1320
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_DblClick()
  OnUnload
End Sub

Private Sub Timer_Timer()
  OnTimer
End Sub
