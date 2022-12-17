VERSION 5.00
Begin VB.Form Window 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   7500
   ClientLeft      =   645
   ClientTop       =   0
   ClientWidth     =   12315
   LinkTopic       =   "Form1"
   ScaleHeight     =   500
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   821
   Begin VB.PictureBox pbSheet 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   5760
      Left            =   1560
      Picture         =   "Window.frx":0000
      ScaleHeight     =   384
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   2
      Top             =   6720
      Visible         =   0   'False
      Width           =   9600
   End
   Begin VB.PictureBox pbBot 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   720
      Left            =   1560
      Picture         =   "Window.frx":308DF
      ScaleHeight     =   48
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   1
      Top             =   5280
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
      Left            =   1440
      Picture         =   "Window.frx":31226
      ScaleHeight     =   48
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   683
      TabIndex        =   0
      Top             =   6000
      Visible         =   0   'False
      Width           =   10245
   End
   Begin VB.Timer Timer 
      Interval        =   100
      Left            =   1440
      Top             =   1440
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private TopX As Long
Private BotX As Long
Private Counter As Long
Private Sheet As Long
Private Filename As String

Private Sub Form_DblClick()
  End
End Sub

Private Sub Form_Load()
  Me.Move 640 * 15, 0, 640 * 15, 480 * 15
  Filename = Dir(App.Path & "\sheet*.jpg")
  
  ' Always on top
  SetWindowPos Window.hwnd, HWND_TOPMOST, 640&, 0&, 0&, 0&, SWP_SHOWWINDOW Or SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOACTIVATE
  
  ' Move Mouse
  SetCursorPos 1280, 480
End Sub

Private Sub AnimateBorders()
  TopX = TopX - 1
  If TopX < -682 Then TopX = 0
  BotX = BotX + 1
  If BotX > -1 Then BotX = -640

  ' (Top)
  BitBlt Me.hdc, TopX, 0&, 683&, 48&, pbBanner.hdc, 0&, 0&, vbSrcCopy
  BitBlt Me.hdc, 683& + TopX, 0&, 640&, 48&, pbBanner.hdc, 0&, 0&, vbSrcCopy

  ' (Bottom)
  BitBlt Me.hdc, BotX, 432&, 683&, 48&, pbBot.hdc, 0&, 0&, vbSrcCopy
  BitBlt Me.hdc, 640& + BotX, 432&, 683&, 48&, pbBot.hdc, 0&, 0&, vbSrcCopy

  ' (Center)
  If Counter = 0 Then
    Counter = 150
    Filename = Dir()
    If Filename = "" Then Filename = Dir(App.Path & "\sheet*.jpg")
    pbSheet.Picture = LoadPicture(App.Path & "\" & Filename)
    BitBlt Me.hdc, 0&, 48&, 640&, 384&, pbSheet.hdc, 0, 0, vbSrcCopy
  Else
    Counter = Counter - 1
  End If
  
  Window.Refresh
End Sub

Private Sub Timer_Timer()
  AnimateBorders
End Sub
