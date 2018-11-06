VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "ControlClient"
   ClientHeight    =   240
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   240
   LinkTopic       =   "Form1"
   ScaleHeight     =   240
   ScaleWidth      =   240
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   0
      Top             =   0
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private SystemPath As String

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long

Private MEM_Open As Boolean
Private MEM_Mask As Byte
Private MEM_GameState As Byte

Private OPT_Reset As Byte
Private OPT_Startup As Byte
Private OPT_Start As Byte
Private OPT_Track As Byte
Private OPT_Gears As Byte
Private OPT_GameMode As Byte
Private OPT_Handicap As Byte

Private CTRL_LastEx As Byte

Private FlipFlop As Boolean

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Dim Host As String
  Dim Port As Long
  
  Me.Move Screen.Width - Me.Width, 0
  Winsock.Load
  
  ' System Path
  SystemPath = ReadIni("control.ini", "client", "systempath", "c:\windows\system32")
  
  ' Local (control)
  Host = ReadIni("control.ini", "client", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("control.ini", "client", "localport", "23456"))
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

  OPT_Startup = CByte(ReadIni("control.ini", "client", "opt-startup", "&H30"))
  
  Timer.Enabled = True
  Timer_Timer
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Unload
  End
End Sub

Private Sub Timer_Timer()
  If OpenMemoryModel2 Then
    If Not MEM_Open Then
      Window.BackColor = RGB(0, 255, 0)
      MEM_Open = True
    End If
  Else
    Window.BackColor = RGB(255, 0, 0)
    MEM_Open = False
  End If
  
  If MEM_Open Then
    MEM_GameState = ReadByte(pRAMBASE + GAMESTATE)
    MEM_Mask = &HFF
    
    ' remote reset
    If OPT_Reset = 1 Then
      OPT_Reset = 0
      If MEM_GameState = &H16 Then
        WriteLong pRAMBASE + TIME_LEFT, &H100&
      End If
    End If
    
    ' track selection
    Select Case OPT_Track
      Case CTRL_TRACK_MAJOR
        MEM_Mask = MEM_Mask And &HFF
      Case CTRL_TRACK_BEGINNER
        MEM_Mask = MEM_Mask And &HFD
      Case CTRL_TRACK_ADVANCED
        MEM_Mask = MEM_Mask And &HFB
      Case CTRL_TRACK_EXPERT
        MEM_Mask = MEM_Mask And &HF9
    End Select
    
    ' auto start if gamestate 0x10
    FlipFlop = Not FlipFlop
    Select Case OPT_Startup
      Case CTRL_STARTUP_AUTO
        If MEM_GameState = &H10 And FlipFlop Then
          MEM_Mask = MEM_Mask And &HF7
        End If
      Case CTRL_STARTUP_EXTEND
        MEM_Mask = MEM_Mask And &H7F
    End Select
  
    ' remote start
    If OPT_Start = 1 Then
      OPT_Start = 0
      MEM_Mask = MEM_Mask And &HF7
    End If
    
    ' others
    If MEM_GameState = &H12 Then
      ' OPT_Gears
      Select Case OPT_Gears
        Case CTRL_GEARS_AUTO
          WriteInteger pRAMBASE + CAR_GEAR_MODE, 0
        Case CTRL_GEARS_MANUAL
          WriteInteger pRAMBASE + CAR_GEAR_MODE, 1
      End Select
    
      ' OPT_GameMode
      Select Case OPT_GameMode
        Case CTRL_GAMEMODE_NORMAL
          WriteByte pRAMBASE + GAME_MODE, 0
        Case CTRL_GAMEMODE_TIMEATCK
          WriteByte pRAMBASE + GAME_MODE, 1
      End Select
    
      ' OPT_Handicap
      Select Case OPT_Handicap
        Case CTRL_HANDICAP_ARCADE
          WriteByte pRAMBASE + HANDICAP, 0
        Case CTRL_HANDICAP_REAL
          WriteByte pRAMBASE + HANDICAP, 1
      End Select
    End If
    
    WriteByte pRAMBASE + CUSTOM_MASK, MEM_Mask
    
    Dim CTRL_CurrEx As Byte
    CTRL_CurrEx = ReadByte(pRAMBASE + CUSTOM_CTRL)
    If Not CTRL_CurrEx = 0 Then
      If Not CTRL_CurrEx = CTRL_LastEx Then
        CTRL_LastEx = CTRL_CurrEx
      
        Dim baBuffer() As Byte
        ReDim baBuffer(0 To 31)
        baBuffer(0) = CTRL_CMD_EX
        baBuffer(1) = ReadByte(pRAMBASE + CAR_NODE)
        baBuffer(2) = CTRL_LastEx
        Dim sBuffer As String
        sBuffer = StrConv(baBuffer, vbUnicode)
        Winsock.SendUDP UDP_Socket, sBuffer, UDP_RemoteAddress
      End If
    End If
  End If
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If Len(sBuffer) < 32 Then Exit Sub
  UDP_RemoteAddress = sAddress
  
  Dim baBuffer() As Byte
  baBuffer = StrConv(sBuffer, vbFromUnicode)
  Select Case baBuffer(0)
    Case CTRL_CMD_PING
      If MEM_Open Then
        If MEM_GameState > &H9 Then
          baBuffer(1) = CTRL_STATUS_INGAME
        Else
          baBuffer(1) = CTRL_STATUS_ONLINE
        End If
      Else
        baBuffer(1) = CTRL_STATUS_OFFLINE
      End If
      sBuffer = StrConv(baBuffer, vbUnicode)
      Winsock.SendUDP lHandle, sBuffer, UDP_RemoteAddress
    
    Case CTRL_CMD_RESET
      OPT_Reset = 1
    
    Case CTRL_CMD_STARTUP
      Select Case baBuffer(1)
        Case CTRL_STARTUP_NORMAL, CTRL_STARTUP_AUTO, CTRL_STARTUP_EXTEND
          OPT_Startup = baBuffer(1)
      End Select
      
    Case CTRL_CMD_START
      OPT_Start = 1
      
    Case CTRL_CMD_TRACK
      Select Case baBuffer(1)
        Case CTRL_TRACK_MAJOR, CTRL_TRACK_BEGINNER, CTRL_TRACK_ADVANCED, CTRL_TRACK_EXPERT
          OPT_Track = baBuffer(1)
      End Select
      
    Case CTRL_CMD_GEARS
      Select Case baBuffer(1)
        Case CTRL_GEARS_SELECT, CTRL_GEARS_AUTO, CTRL_GEARS_MANUAL
          OPT_Gears = baBuffer(1)
      End Select
      
    Case CTRL_CMD_GAMEMODE
      Select Case baBuffer(1)
        Case CTRL_GAMEMODE_MAJOR, CTRL_GAMEMODE_NORMAL, CTRL_GAMEMODE_TIMEATCK
          OPT_GameMode = baBuffer(1)
      End Select
      
    Case CTRL_CMD_HANDICAP
      Select Case baBuffer(1)
        Case CTRL_HANDICAP_SELECT, CTRL_HANDICAP_ARCADE, CTRL_HANDICAP_REAL
          OPT_Handicap = baBuffer(1)
      End Select
      
    Case CTRL_CMD_SHUTDOWN
      ShellExecuteA Me.hWnd, "open", SystemPath & "\shutdown.exe", "-s -f -t 0 -c SHUTDOWN", SystemPath, SW_HIDE
      
    Case CTRL_CMD_REBOOT
      ShellExecuteA Me.hWnd, "open", SystemPath & "\shutdown.exe", "-r -f -t 0 -c SHUTDOWN", SystemPath, SW_HIDE
  
  End Select
End Sub
