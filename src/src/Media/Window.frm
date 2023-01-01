VERSION 5.00
Begin VB.Form Window 
   Caption         =   "Form1"
   ClientHeight    =   3120
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8145
   LinkTopic       =   "Form1"
   ScaleHeight     =   3120
   ScaleWidth      =   8145
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command13 
      Caption         =   "MagFest"
      Height          =   435
      Left            =   5880
      TabIndex        =   12
      Top             =   1080
      Width           =   1815
   End
   Begin VB.CommandButton Command12 
      Caption         =   "BillieJean"
      Height          =   435
      Left            =   5880
      TabIndex        =   11
      Top             =   600
      Width           =   1815
   End
   Begin VB.CommandButton Command11 
      Caption         =   "Blinding Lights"
      Height          =   435
      Left            =   3960
      TabIndex        =   10
      Top             =   2040
      Width           =   1815
   End
   Begin VB.CommandButton Command10 
      Caption         =   "Seligenstadt"
      Height          =   435
      Left            =   3960
      TabIndex        =   9
      Top             =   1560
      Width           =   1815
   End
   Begin VB.CommandButton Command9 
      Caption         =   "Thriller"
      Height          =   435
      Left            =   3960
      TabIndex        =   8
      Top             =   1080
      Width           =   1815
   End
   Begin VB.CommandButton Command8 
      Caption         =   "BillieJean"
      Height          =   435
      Left            =   3960
      TabIndex        =   7
      Top             =   600
      Width           =   1815
   End
   Begin VB.CommandButton Command7 
      Caption         =   "BlackKnight"
      Height          =   435
      Left            =   2040
      TabIndex        =   6
      Top             =   2040
      Width           =   1815
   End
   Begin VB.CommandButton Command6 
      Caption         =   "Armitage"
      Height          =   435
      Left            =   2040
      TabIndex        =   5
      Top             =   1560
      Width           =   1815
   End
   Begin VB.CommandButton Command5 
      Caption         =   "FULLSCREEN"
      Height          =   375
      Left            =   480
      TabIndex        =   4
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Spritgeld"
      Height          =   435
      Left            =   2040
      TabIndex        =   3
      Top             =   1080
      Width           =   1815
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Hurricane"
      Height          =   435
      Left            =   2040
      TabIndex        =   2
      Top             =   600
      Width           =   1815
   End
   Begin VB.CommandButton Command2 
      Caption         =   "PLAY"
      Height          =   375
      Left            =   480
      TabIndex        =   1
      Top             =   1080
      Width           =   1335
   End
   Begin VB.CommandButton Command1 
      Caption         =   "STOP"
      Height          =   375
      Left            =   480
      TabIndex        =   0
      Top             =   600
      Width           =   1335
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private SocketReady(0 To 8) As Boolean
Private SocketAddr(0 To 8) As String
Private Socket(0 To 8) As Long

Private Sub SendToAll(Data As String)
  Dim Index As Integer
  For Index = 0 To 8
    Winsock.SendTCP Socket(Index), Data
  Next
End Sub

Private Sub Command1_Click()
  Dim Data As String
  Data = "GET /command.html?wm_command=890 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command10_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cSeligenstadt.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command11_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cBlindingLights.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command12_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cdinner4one.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command13_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cmagfest.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command2_Click()
  Dim Data As String
  Data = "GET /command.html?wm_command=887 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command3_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cHurricane.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command4_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cSpritgeld.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command5_Click()
  Dim Data As String
  Data = "GET /command.html?wm_command=830 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command6_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cArmitage3rd.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command7_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cBlackKnight2000.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

Private Sub Command8_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cBillieJean.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data

End Sub

Private Sub Command9_Click()
  Dim Data As String
  Data = "GET /browser.html?path=%5c%5cDAYTONA09%5cSoftware%5cThriller.mp4 HTTP/1.1" & vbCrLf & vbCrLf
  SendToAll Data
End Sub

'/browser.html?path=%5c%5cDAYTONA09%5cSoftware%5c02.%20Head%20Radio%20(Chart).mp3
Private Sub Form_Load()
  Winsock.Load
  
  Dim Index As Integer
  For Index = 0 To 8
    SocketReady(Index) = False
    SocketAddr(Index) = WSABuildSocketAddress("192.168.10.21" & Index + 1, 80)
    Socket(Index) = Winsock.ConnectTCP(SocketAddr(Index))
  Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Unload
End Sub

Public Sub OnReadTCP(lHandle As Long, sBuffer As String)
  Dim Index As Integer
  For Index = 0 To 8
    If Socket(Index) = lHandle Then
      Debug.Print "socket #" & Index & " read data."
      SocketReady(Index) = False
      Winsock.Disconnect lHandle
      Socket(Index) = Winsock.ConnectTCP(SocketAddr(Index))
    End If
  Next
End Sub

Public Sub OnConnected(lHandle As Long)
  Dim Index As Integer
  For Index = 0 To 8
    If Socket(Index) = lHandle Then
      Debug.Print "socket #" & Index & " connected."
      SocketReady(Index) = True
      Exit Sub
    End If
  Next
End Sub

Public Sub OnConnectError(lHandle As Long, lError As Long)
  Dim Index As Integer
  For Index = 0 To 8
    If Socket(Index) = lHandle Then
      Debug.Print "socket #" & Index & " failed."
      SocketReady(Index) = False
      Winsock.Disconnect lHandle
      Socket(Index) = Winsock.ConnectTCP(SocketAddr(Index))
      Exit Sub
    End If
  Next
End Sub

Public Sub OnClose(lHandle As Long)
  Dim Index As Integer
  For Index = 0 To 8
    If Socket(Index) = lHandle Then
      Debug.Print "socket #" & Index & " closed."
      SocketReady(Index) = False
      Winsock.Disconnect lHandle
      Socket(Index) = Winsock.ConnectTCP(SocketAddr(Index))
      Exit Sub
    End If
  Next
End Sub

