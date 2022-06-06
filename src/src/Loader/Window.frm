VERSION 5.00
Begin VB.Form Window 
   Appearance      =   0  'Flat
   AutoRedraw      =   -1  'True
   BackColor       =   &H00400040&
   BorderStyle     =   0  'None
   Caption         =   "Daytona Loader"
   ClientHeight    =   2880
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   20400
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Window"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   MousePointer    =   2  'Cross
   ScaleHeight     =   192
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1360
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Interval        =   2
      Left            =   0
      Top             =   120
   End
   Begin VB.PictureBox pbFont 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   135
      Left            =   0
      Picture         =   "Window.frx":0000
      ScaleHeight     =   135
      ScaleWidth      =   17265
      TabIndex        =   0
      Top             =   0
      Visible         =   0   'False
      Width           =   17265
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

Private Sub Form_Unload(Cancel As Integer)
  OnUnload
End Sub

Private Sub Timer_Timer()
  OnTimer
End Sub
