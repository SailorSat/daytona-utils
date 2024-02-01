VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00000040&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   5760
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7680
   LinkTopic       =   "Form1"
   ScaleHeight     =   384
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   512
   ShowInTaskbar   =   0   'False
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Terminate()
  Terminate
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Form_Terminate
End Sub
