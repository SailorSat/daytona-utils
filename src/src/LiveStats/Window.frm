VERSION 5.00
Begin VB.Form Window 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00FF00FF&
   BorderStyle     =   0  'None
   Caption         =   "LiveStats"
   ClientHeight    =   16005
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   19200
   LinkTopic       =   "Form1"
   ScaleHeight     =   1067
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1280
   Begin VB.PictureBox pbVFormula 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   7200
      Left            =   5760
      Picture         =   "Window.frx":0000
      ScaleHeight     =   480
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   0
      Top             =   1440
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
