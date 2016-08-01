VERSION 5.00
Begin VB.Form Window2 
   Appearance      =   0  'Flat
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   ClientHeight    =   15360
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   18405
   LinkTopic       =   "Form1"
   ScaleHeight     =   1024
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1227
   ShowInTaskbar   =   0   'False
   Begin VB.PictureBox pbTrack 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      DrawWidth       =   15
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      ForeColor       =   &H80000008&
      Height          =   5760
      Index           =   2
      Left            =   11640
      Picture         =   "Window2.frx":0000
      ScaleHeight     =   384
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   8
      Top             =   1080
      Visible         =   0   'False
      Width           =   9600
   End
   Begin VB.PictureBox pbTrack 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      DrawWidth       =   15
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      ForeColor       =   &H80000008&
      Height          =   5760
      Index           =   1
      Left            =   480
      Picture         =   "Window2.frx":1252
      ScaleHeight     =   384
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   7
      Top             =   7560
      Visible         =   0   'False
      Width           =   9600
   End
   Begin VB.PictureBox pbTrack 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      DrawWidth       =   15
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      ForeColor       =   &H80000008&
      Height          =   5760
      Index           =   0
      Left            =   11640
      Picture         =   "Window2.frx":2428
      ScaleHeight     =   384
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   6
      Top             =   7680
      Visible         =   0   'False
      Width           =   9600
   End
   Begin VB.PictureBox pbBackground 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   7200
      Left            =   9960
      Picture         =   "Window2.frx":3318
      ScaleHeight     =   480
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   5
      Top             =   2760
      Visible         =   0   'False
      Width           =   9600
   End
   Begin VB.PictureBox pbBanner 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   720
      Left            =   1680
      Picture         =   "Window2.frx":44EE
      ScaleHeight     =   48
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   683
      TabIndex        =   4
      Top             =   1800
      Visible         =   0   'False
      Width           =   10245
   End
   Begin VB.CommandButton cmdViewPlus 
      Caption         =   "+"
      Height          =   255
      Left            =   1320
      TabIndex        =   3
      Top             =   2040
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.CommandButton cmdViewMinus 
      Caption         =   "-"
      Height          =   255
      Left            =   960
      TabIndex        =   2
      Top             =   2040
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.CommandButton cmdActionPlus 
      Caption         =   "+"
      Height          =   255
      Left            =   360
      TabIndex        =   1
      Top             =   2040
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.CommandButton cmdActionMinus 
      Caption         =   "-"
      Height          =   255
      Left            =   0
      TabIndex        =   0
      Top             =   2040
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   0
      Left            =   240
      Picture         =   "Window2.frx":6C47
      Top             =   0
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   1
      Left            =   240
      Picture         =   "Window2.frx":6FC2
      Top             =   240
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   2
      Left            =   240
      Picture         =   "Window2.frx":7340
      Top             =   480
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   3
      Left            =   240
      Picture         =   "Window2.frx":76BC
      Top             =   720
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   4
      Left            =   240
      Picture         =   "Window2.frx":7A38
      Top             =   960
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   5
      Left            =   240
      Picture         =   "Window2.frx":7DB6
      Top             =   1200
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   6
      Left            =   240
      Picture         =   "Window2.frx":8132
      Top             =   1440
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   7
      Left            =   240
      Picture         =   "Window2.frx":84AC
      Top             =   1680
      Width           =   240
   End
   Begin VB.Shape shpDistance 
      BackColor       =   &H00000000&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H000080FF&
      Height          =   240
      Left            =   1050
      Shape           =   4  'Rounded Rectangle
      Top             =   150
      Visible         =   0   'False
      Width           =   7500
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   0
      Left            =   0
      Picture         =   "Window2.frx":882A
      Top             =   0
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   1
      Left            =   0
      Picture         =   "Window2.frx":8BA5
      Top             =   240
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   2
      Left            =   0
      Picture         =   "Window2.frx":8F23
      Top             =   480
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   3
      Left            =   0
      Picture         =   "Window2.frx":929F
      Top             =   720
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   4
      Left            =   0
      Picture         =   "Window2.frx":961B
      Top             =   960
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   5
      Left            =   0
      Picture         =   "Window2.frx":9999
      Top             =   1200
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   6
      Left            =   0
      Picture         =   "Window2.frx":9D15
      Top             =   1440
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   7
      Left            =   0
      Picture         =   "Window2.frx":A08F
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

Private BorderOffset As Long

Public Sub MoveBorder()
  BorderOffset = BorderOffset - 1
  If BorderOffset <= -683 Then BorderOffset = 0
  
  ' Checkerboard (Top)
  BitBlt Me.hdc, BorderOffset, 0, 640, 48, pbBackground.hdc, 0, 0, vbSrcCopy
  BitBlt Me.hdc, 640 + BorderOffset, 0, 640, 48, pbBackground.hdc, 0, 0, vbSrcCopy

  ' Banner (Bottom)
  BitBlt Me.hdc, BorderOffset, ScreenHeight - 48, 683, 48, pbBanner.hdc, 0, 0, vbSrcCopy
  BitBlt Me.hdc, 683 + BorderOffset, ScreenHeight - 48, 683, 48, pbBanner.hdc, 0, 0, vbSrcCopy

  Window2.Refresh
End Sub

Private Sub Form_DblClick()
  OnUnload
End Sub

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
