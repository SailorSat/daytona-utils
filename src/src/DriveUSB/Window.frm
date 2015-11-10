VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'Kein
   Caption         =   "DriveControl"
   ClientHeight    =   240
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   240
   LinkTopic       =   "Form1"
   ScaleHeight     =   240
   ScaleWidth      =   240
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private UDP_LocalAddress As String
Private UDP_Socket As Long
Private UDP_Buffer As String

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Dim Host As String
  Dim Port As Long

  Me.BackColor = RGB(255, 0, 0)
  Me.Move Me.Width, 0
  Me.Show
  
  Winsock.Load
  
  ' init network (drive)
  UDP_Buffer = ""
  Host = ReadIni("drive.ini", "network", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("drive.ini", "network", "localport", "9000"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #ADDR", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If

  UDP_Socket = Winsock.ListenUDP(UDP_LocalAddress)
  If UDP_Socket = -1 Then
    MsgBox "Something went wrong! #SOCK", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If
  
  Me.BackColor = RGB(0, 255, 0)
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Unload
  CloseDriveChannel
  End
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  UDP_Buffer = UDP_Buffer & sBuffer
  While Len(UDP_Buffer) > 1
    Dim bData() As Byte
    bData = StrConv(Left(UDP_Buffer, 2), vbFromUnicode)
    Select Case bData(0)
      Case 1
        UDP_Buffer = Mid(UDP_Buffer, 3)
        If OpenDriveChannel Then
          WriteDriveData 1, bData(1)
        End If
      Case 2
        UDP_Buffer = Mid(UDP_Buffer, 3)
        If OpenDriveChannel Then
          WriteDriveData 2, bData(1)
        End If
      Case Else
        UDP_Buffer = Mid(UDP_Buffer, 2)
    End Select
  Wend
End Sub
