VERSION 5.00
Begin VB.Form Window2 
   Appearance      =   0  'Flat
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   Caption         =   "LiveStats #2"
   ClientHeight    =   15360
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   18405
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1024
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1227
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
      Left            =   6240
      Picture         =   "Window2.frx":3318
      ScaleHeight     =   480
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   5
      Top             =   3840
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
      Left            =   1320
      TabIndex        =   1
      Top             =   2400
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.CommandButton cmdActionMinus 
      Caption         =   "-"
      Height          =   255
      Left            =   960
      TabIndex        =   0
      Top             =   2400
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   8
      Left            =   240
      Picture         =   "Window2.frx":6C47
      Top             =   1920
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   8
      Left            =   0
      Picture         =   "Window2.frx":6FCF
      Top             =   1920
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   0
      Left            =   240
      Picture         =   "Window2.frx":7357
      Top             =   0
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   1
      Left            =   240
      Picture         =   "Window2.frx":76D2
      Top             =   240
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   2
      Left            =   240
      Picture         =   "Window2.frx":7A50
      Top             =   480
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   3
      Left            =   240
      Picture         =   "Window2.frx":7DCC
      Top             =   720
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   4
      Left            =   240
      Picture         =   "Window2.frx":8148
      Top             =   960
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   5
      Left            =   240
      Picture         =   "Window2.frx":84C6
      Top             =   1200
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   6
      Left            =   240
      Picture         =   "Window2.frx":8842
      Top             =   1440
      Width           =   240
   End
   Begin VB.Image imgDistance 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   7
      Left            =   240
      Picture         =   "Window2.frx":8BBC
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
      Picture         =   "Window2.frx":8F3A
      Top             =   0
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   1
      Left            =   0
      Picture         =   "Window2.frx":92B5
      Top             =   240
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   2
      Left            =   0
      Picture         =   "Window2.frx":9633
      Top             =   480
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   3
      Left            =   0
      Picture         =   "Window2.frx":99AF
      Top             =   720
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   4
      Left            =   0
      Picture         =   "Window2.frx":9D2B
      Top             =   960
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   5
      Left            =   0
      Picture         =   "Window2.frx":A0A9
      Top             =   1200
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   6
      Left            =   0
      Picture         =   "Window2.frx":A425
      Top             =   1440
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   7
      Left            =   0
      Picture         =   "Window2.frx":A79F
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
Private BannerOffset As Long

Public Sub MoveBorder()
  ' Checkerboard (Top)
  BorderOffset = BorderOffset - 1&
  If BorderOffset <= -640& Then BorderOffset = 0
  BitBlt Me.hdc, BorderOffset, 0&, 640&, 48&, pbBackground.hdc, 0&, 0&, vbSrcCopy
  BitBlt Me.hdc, 640& + BorderOffset, 0&, 640&, 48&, pbBackground.hdc, 0&, 0&, vbSrcCopy
  BitBlt Me.hdc, 1280& + BorderOffset, 0&, 640&, 48&, pbBackground.hdc, 0&, 0&, vbSrcCopy

  ' Banner (Bottom)
  BannerOffset = BannerOffset - 1&
  If BannerOffset <= -683& Then BannerOffset = 0&
  BitBlt Me.hdc, BorderOffset, ScreenSizeY - 48&, 683&, 48&, pbBanner.hdc, 0&, 0&, vbSrcCopy
  BitBlt Me.hdc, 683& + BorderOffset, ScreenSizeY - 48&, 683&, 48&, pbBanner.hdc, 0&, 0&, vbSrcCopy
  BitBlt Me.hdc, 1366& + BorderOffset, ScreenSizeY - 48&, 683&, 48&, pbBanner.hdc, 0&, 0&, vbSrcCopy

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
