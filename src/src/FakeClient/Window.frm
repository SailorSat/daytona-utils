VERSION 5.00
Begin VB.Form Window 
   BorderStyle     =   4  'Festes Werkzeugfenster
   Caption         =   "Form1"
   ClientHeight    =   1095
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   2295
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1095
   ScaleWidth      =   2295
   StartUpPosition =   3  'Windows-Standard
   Begin VB.Shape shStatus 
      BackColor       =   &H00000040&
      BackStyle       =   1  'Undurchsichtig
      Height          =   375
      Left            =   120
      Shape           =   4  'Gerundetes Rechteck
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

Private FAKE_Status As Byte
Private FAKE_Size As Byte

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long

Private UDP_Buffer As String

Private Sub Form_Load()
  ' Init Winsock
  Winsock.Load
    
  Dim Host As String
  Dim Port As Long
  
  Host = ReadIni("fakeclient.ini", "network", "LocalHost", "127.0.0.1")
  Port = CLng(ReadIni("fakeclient.ini", "network", "LocalPort", "8000"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #UDP_LocalAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If
  
  Host = ReadIni("fakeclient.ini", "network", "RemoteHost", "127.0.0.1")
  Port = CLng(ReadIni("fakeclient.ini", "network", "RemotePort", "8000"))
  UDP_RemoteAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_RemoteAddress = "" Then
    MsgBox "Something went wrong! #UDP_RemoteAddress", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If

  UDP_Socket = ListenUDP(UDP_LocalAddress)
  If UDP_Socket = -1 Then
    MsgBox "Something went wrong! #UDP_Socket", vbCritical Or vbOKOnly, Window.Caption
    Form_Unload 0
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Unload
  End
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If Left(sBuffer, 4) = "M2EM" And Len(sBuffer) = 3589 Then
    Winsock.SendUDP UDP_Socket, ParseFrame(sBuffer), UDP_RemoteAddress
    Debug.Print FAKE_Status, FAKE_Size
  End If
End Sub

Public Function ParseFrame(sBuffer As String) As String
  Dim lOffset As Long
  Dim lIndex As Long
  
  ' convert from wide-string to byte array
  Dim baBuffer() As Byte
  baBuffer() = StrConv(sBuffer, vbFromUnicode)

  ' check header status
  Select Case baBuffer(4)
    Case 0
      ' type 0 packet
      ' add up to 7 cabs, set count to 8
      baBuffer(&H5) = 8   ' Player Count
      
      FAKE_Status = 0
      FAKE_Size = 0
      
      If baBuffer(&HC) = 0 Then
        baBuffer(&HC) = 2   ' Cab #2
        FAKE_Size = FAKE_Size + 1
      End If
      If baBuffer(&H12) = 0 Then
        baBuffer(&H12) = 3  ' Cab #3
        FAKE_Size = FAKE_Size + 1
      End If
      If baBuffer(&H18) = 0 Then
        baBuffer(&H18) = 4  ' Cab #4
        FAKE_Size = FAKE_Size + 1
      End If
      If baBuffer(&H1E) = 0 Then
        baBuffer(&H1E) = 5  ' Cab #5
        FAKE_Size = FAKE_Size + 1
      End If
      If baBuffer(&H24) = 0 Then
        baBuffer(&H24) = 6  ' Cab #6
        FAKE_Size = FAKE_Size + 1
      End If
      If baBuffer(&H2A) = 0 Then
        baBuffer(&H2A) = 7  ' Cab #7
        FAKE_Size = FAKE_Size + 1
      End If
      If baBuffer(&H30) = 0 Then
        baBuffer(&H30) = 8  ' Cab #8
        FAKE_Size = FAKE_Size + 1
      End If
    Case 1
      ' type 1 packet
      ' count up ids
      baBuffer(&H5) = 8   ' Player Count
      baBuffer(&H6) = 9   ' Node
      
      FAKE_Status = 1
      
      If baBuffer(&HC) = 0 Then
        baBuffer(&HC) = 8   ' Cab #2
      End If
      If baBuffer(&H12) = 0 Then
        baBuffer(&H12) = 7  ' Cab #3
      End If
      If baBuffer(&H18) = 0 Then
        baBuffer(&H18) = 6  ' Cab #4
      End If
      If baBuffer(&H1E) = 0 Then
        baBuffer(&H1E) = 5  ' Cab #5
      End If
      If baBuffer(&H24) = 0 Then
        baBuffer(&H24) = 4  ' Cab #6
      End If
      If baBuffer(&H2A) = 0 Then
        baBuffer(&H2A) = 3  ' Cab #7
      End If
      If baBuffer(&H30) = 0 Then
        baBuffer(&H30) = 2  ' Cab #8
      End If
      If baBuffer(&H36) = 0 Then
        baBuffer(&H36) = 1  ' Cab #1
      End If
      
    Case 2
      ' type 2 packet
      If baBuffer(&H1A) >= &H80 And baBuffer(&H1B) >= 3 Then
        ' sync phase done!
        FAKE_Status = 3
        
        If FAKE_Size = 0 Then
          Dim bCarNo(0 To 7) As Byte
          Dim bCar As Byte
          lOffset = 5
          While lOffset < 3584
            bCar = baBuffer(lOffset + &HD4)
            If bCarNo(bCar) = 0 Then
              bCarNo(bCar) = 1
            Else
              FAKE_Size = FAKE_Size + 1
            End If
            lOffset = lOffset + 448
          Wend
        End If
        
        For lIndex = 1 To FAKE_Size
          RtlMoveMemory baBuffer(3141), baBuffer(2693), 448
          RtlMoveMemory baBuffer(2693), baBuffer(2245), 448
          RtlMoveMemory baBuffer(2245), baBuffer(1797), 448
          RtlMoveMemory baBuffer(1797), baBuffer(1349), 448
          RtlMoveMemory baBuffer(1349), baBuffer(901), 448
          RtlMoveMemory baBuffer(901), baBuffer(453), 448
          RtlMoveMemory baBuffer(453), baBuffer(5), 448
          lOffset = 5
          baBuffer(lOffset + &HB) = 0
          baBuffer(lOffset + &HC) = 0
          baBuffer(lOffset + &H16) = 3
          baBuffer(lOffset + &H18) = 0
          baBuffer(lOffset + &H1B) = 0
          baBuffer(lOffset + &HD4) = 8 - lIndex
        Next
      Else
        ' do nothing and wait...
        FAKE_Status = 2
        ParseFrame = sBuffer
        Exit Function
      End If
    Case Else
      Debug.Print "unknown frame type", baBuffer(4)
  End Select
  
  ParseFrame = StrConv(baBuffer, vbUnicode)
End Function
