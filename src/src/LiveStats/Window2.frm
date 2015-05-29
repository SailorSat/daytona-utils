VERSION 5.00
Begin VB.Form Window2 
   Appearance      =   0  '2D
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000005&
   BorderStyle     =   0  'Kein
   ClientHeight    =   7200
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   9600
   LinkTopic       =   "Form1"
   Picture         =   "Window2.frx":0000
   ScaleHeight     =   480
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   640
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdViewPlus 
      Caption         =   "+"
      Height          =   255
      Left            =   1440
      TabIndex        =   3
      Top             =   120
      Width           =   255
   End
   Begin VB.CommandButton cmdViewMinus 
      Caption         =   "-"
      Height          =   255
      Left            =   1080
      TabIndex        =   2
      Top             =   120
      Width           =   255
   End
   Begin VB.CommandButton cmdActionPlus 
      Caption         =   "+"
      Height          =   255
      Left            =   480
      TabIndex        =   1
      Top             =   120
      Width           =   255
   End
   Begin VB.CommandButton cmdActionMinus 
      Caption         =   "-"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   255
   End
   Begin VB.Image imgCar 
      Appearance      =   0  '2D
      Height          =   240
      Index           =   0
      Left            =   0
      Picture         =   "Window2.frx":11D6
      Top             =   0
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  '2D
      Height          =   240
      Index           =   1
      Left            =   0
      Picture         =   "Window2.frx":1551
      Top             =   240
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  '2D
      Height          =   240
      Index           =   2
      Left            =   0
      Picture         =   "Window2.frx":18CF
      Top             =   480
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  '2D
      Height          =   240
      Index           =   3
      Left            =   0
      Picture         =   "Window2.frx":1C4B
      Top             =   720
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  '2D
      Height          =   240
      Index           =   4
      Left            =   0
      Picture         =   "Window2.frx":1FC7
      Top             =   960
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  '2D
      Height          =   240
      Index           =   5
      Left            =   0
      Picture         =   "Window2.frx":2345
      Top             =   1200
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  '2D
      Height          =   240
      Index           =   6
      Left            =   0
      Picture         =   "Window2.frx":26C1
      Top             =   1440
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  '2D
      Height          =   240
      Index           =   7
      Left            =   0
      Picture         =   "Window2.frx":2A3B
      Top             =   1680
      Width           =   240
   End
End
Attribute VB_Name = "Window2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdActionMinus_Click()
  If CLIENT_CarNo > 0 Then
    CLIENT_CarNo = CLIENT_CarNo - 1
  End If
End Sub

Private Sub cmdActionPlus_Click()
  If CLIENT_CarNo < 7 Then
    CLIENT_CarNo = CLIENT_CarNo + 1
  End If
End Sub

Private Sub cmdViewMinus_Click()
  If CLIENT_ViewNo > 0 Then
    CLIENT_ViewNo = CLIENT_ViewNo - 1
  End If
End Sub

Private Sub cmdViewPlus_Click()
  If CLIENT_ViewNo < 15 Then
    CLIENT_ViewNo = CLIENT_ViewNo + 1
  End If
End Sub

Private Sub Form_DblClick()
  OnUnload
End Sub
