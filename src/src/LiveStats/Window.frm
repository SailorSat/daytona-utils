VERSION 5.00
Begin VB.Form Window 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   0  'None
   Caption         =   "LiveStats"
   ClientHeight    =   12000
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   19200
   LinkTopic       =   "Form1"
   Picture         =   "Window.frx":0000
   ScaleHeight     =   800
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1280
   Begin VB.PictureBox pbOverlay 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00FF00FF&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   5760
      Left            =   0
      Picture         =   "Window.frx":11D6
      ScaleHeight     =   384
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   4
      Top             =   720
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
      Left            =   9600
      Picture         =   "Window.frx":1857
      ScaleHeight     =   48
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   683
      TabIndex        =   6
      Top             =   0
      Width           =   10245
   End
   Begin VB.PictureBox pbBackground 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   7200
      Left            =   9600
      Picture         =   "Window.frx":3FB0
      ScaleHeight     =   480
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   5
      Top             =   0
      Width           =   9600
   End
   Begin VB.PictureBox pbVFormula 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   7200
      Left            =   0
      Picture         =   "Window.frx":5186
      ScaleHeight     =   480
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   3
      Top             =   7200
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
      Left            =   9600
      Picture         =   "Window.frx":9443
      ScaleHeight     =   384
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   0
      Top             =   7200
      Visible         =   0   'False
      Width           =   9600
   End
   Begin VB.Timer Timer 
      Interval        =   500
      Left            =   120
      Top             =   120
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
      Left            =   9600
      Picture         =   "Window.frx":A333
      ScaleHeight     =   384
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   1
      Top             =   7200
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
      Index           =   2
      Left            =   9600
      Picture         =   "Window.frx":B509
      ScaleHeight     =   384
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   2
      Top             =   7200
      Visible         =   0   'False
      Width           =   9600
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   7
      Left            =   0
      Picture         =   "Window.frx":C75B
      Top             =   1680
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   6
      Left            =   0
      Picture         =   "Window.frx":CAD9
      Top             =   1440
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   5
      Left            =   0
      Picture         =   "Window.frx":CE53
      Top             =   1200
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   4
      Left            =   0
      Picture         =   "Window.frx":D1CF
      Top             =   960
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   3
      Left            =   0
      Picture         =   "Window.frx":D54D
      Top             =   720
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   2
      Left            =   0
      Picture         =   "Window.frx":D8C9
      Top             =   480
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   1
      Left            =   0
      Picture         =   "Window.frx":DC45
      Top             =   240
      Width           =   240
   End
   Begin VB.Image imgCar 
      Appearance      =   0  'Flat
      Height          =   240
      Index           =   0
      Left            =   0
      Picture         =   "Window.frx":DFC3
      Top             =   0
      Width           =   240
   End
   Begin VB.Shape shpDistance 
      BackColor       =   &H00000000&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H000080FF&
      Height          =   240
      Left            =   1050
      Shape           =   4  'Rounded Rectangle
      Top             =   120
      Visible         =   0   'False
      Width           =   7500
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private WINDOW_Offset As Long
Private WINDOW_RunOnIDE As Boolean

Private Sub Form_DblClick()
  OnUnload
End Sub

Private Sub Form_Load()
  WINDOW_RunOnIDE = False
  Debug.Assert RunOnIDE
  
  If Not WINDOW_RunOnIDE Then
    While Not OpenMemory
      Sleep 500
    Wend
  End If
  
  OnLoad
  
  EnableTransparency
  ManipulateEmulator
  
  ' 640x480 * 15 Twips
  Me.Move 0, 0, 9600, 7200
  Me.Show

  ' 640x480 * 15 Twips
  Window2.Move 9600, 0, 9600, 7200
  Window2.Show
  
  ' Move Mouse
  SetCursorPos 1280, 480
End Sub

Private Sub Form_Unload(Cancel As Integer)
  OnUnload
End Sub

Private Function RunOnIDE() As Boolean
  WINDOW_RunOnIDE = True
  RunOnIDE = True
End Function

Private Sub Timer_Timer()
  OnTimer
  MoveBorder
End Sub

Private Sub CutHoleInWindow()
  Dim FormRegion As Long
  Dim HoleRegion As Long
  Dim RealRegion As Long
  FormRegion = CreateRectRgn(0, 0, 1280, 480)
  HoleRegion = CreateRectRgn(72, 48, 72 + 496, 48 + 384)
  RealRegion = CreateRectRgn(0, 0, 1280, 480)
  CombineRgn RealRegion, FormRegion, HoleRegion, RGN_DIFF
  SetWindowRgn Me.hWnd, RealRegion, True
  DeleteObject FormRegion
  DeleteObject HoleRegion
  DeleteObject RealRegion
End Sub

Private Sub ManipulateEmulator()
  Dim EmulatorWindow As Long
  EmulatorWindow = FindWindowA(vbNullString, "Daytona USA (Saturn Ads)")
  If EmulatorWindow Then
    SetWindowLongA EmulatorWindow, GWL_STYLE, &H16000000
    SetMenu EmulatorWindow, 0
    SetWindowPos EmulatorWindow, Me.hWnd, -10, 48, 660, 384, 0
  End If
End Sub

Private Sub EnableTransparency()
  Dim DisplayStyle As Long
  DisplayStyle = GetWindowLongA(Me.hWnd, GWL_EXSTYLE)
  If DisplayStyle <> (DisplayStyle Or WS_EX_LAYERED) Then
    DisplayStyle = (DisplayStyle Or WS_EX_LAYERED)
    Call SetWindowLongA(Me.hWnd, GWL_EXSTYLE, DisplayStyle)
  End If
  Call SetLayeredWindowAttributes(Me.hWnd, &HFF00FF, 0&, LWA_COLORKEY)
End Sub

Public Sub MoveBorder()
  WINDOW_Offset = WINDOW_Offset - 1
  If WINDOW_Offset <= -683 Then WINDOW_Offset = 0
  
  ' Banner
'  BitBlt Window.hDC, WINDOW_Offset, 0, 683, 48, pbBanner.hDC, 0, 0, vbSrcCopy
'  BitBlt Window.hDC, 683 + WINDOW_Offset, 0, 683, 48, pbBanner.hDC, 0, 0, vbSrcCopy
  BitBlt Window.hDC, WINDOW_Offset, 432, 683, 48, pbBanner.hDC, 0, 0, vbSrcCopy
  BitBlt Window.hDC, 683 + WINDOW_Offset, 432, 683, 48, pbBanner.hDC, 0, 0, vbSrcCopy
'  BitBlt Window2.hDC, WINDOW_Offset, 0, 683, 48, pbBanner.hDC, 0, 0, vbSrcCopy
'  BitBlt Window2.hDC, 683 + WINDOW_Offset, 0, 683, 48, pbBanner.hDC, 0, 0, vbSrcCopy
  BitBlt Window2.hDC, WINDOW_Offset, 432, 683, 48, pbBanner.hDC, 0, 0, vbSrcCopy
  BitBlt Window2.hDC, 683 + WINDOW_Offset, 432, 683, 48, pbBanner.hDC, 0, 0, vbSrcCopy
  
  ' Background (Checkerboard)
  BitBlt Window.hDC, WINDOW_Offset, 0, 640, 48, pbBackground.hDC, 0, 0, vbSrcCopy
  BitBlt Window.hDC, 640 + WINDOW_Offset, 0, 640, 48, pbBackground.hDC, 0, 0, vbSrcCopy
'  BitBlt Window.hDC, WINDOW_Offset, 432, 640, 48, pbBackground.hDC, 0, 432, vbSrcCopy
'  BitBlt Window.hDC, 640 + WINDOW_Offset, 432, 640, 48, pbBackground.hDC, 0, 432, vbSrcCopy
  BitBlt Window2.hDC, WINDOW_Offset, 0, 640, 48, pbBackground.hDC, 0, 0, vbSrcCopy
  BitBlt Window2.hDC, 640 + WINDOW_Offset, 0, 640, 48, pbBackground.hDC, 0, 0, vbSrcCopy
'  BitBlt Window2.hDC, WINDOW_Offset, 432, 640, 48, pbBackground.hDC, 0, 432, vbSrcCopy
'  BitBlt Window2.hDC, 640 + WINDOW_Offset, 432, 640, 48, pbBackground.hDC, 0, 432, vbSrcCopy

  Window.Refresh
  Window2.Refresh
End Sub
