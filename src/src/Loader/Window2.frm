VERSION 5.00
Begin VB.Form Window2 
   Appearance      =   0  'Flat
   BackColor       =   &H00400040&
   BorderStyle     =   0  'None
   Caption         =   "Daytona Loader"
   ClientHeight    =   3015
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4560
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Window"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   MousePointer    =   2  'Cross
   ScaleHeight     =   201
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   304
   ShowInTaskbar   =   0   'False
End
Attribute VB_Name = "Window2"
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

