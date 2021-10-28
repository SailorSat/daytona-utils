VERSION 5.00
Begin VB.Form Window 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Lagfix"
   ClientHeight    =   600
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   630
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   600
   ScaleWidth      =   630
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   600
      Top             =   120
   End
   Begin VB.Shape shStatus 
      BackColor       =   &H00000040&
      BackStyle       =   1  'Opaque
      Height          =   375
      Left            =   120
      Shape           =   4  'Rounded Rectangle
      Top             =   120
      Width           =   375
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

