Attribute VB_Name = "ControlClient"
Option Explicit

Private SystemPath As String

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long

Private MEM_Open As Boolean
Private MEM_Mask As Long
Private MEM_GameState As Byte
Private MEM_SetupState As Byte

Private OPT_Reset As Byte
Private OPT_Startup As Byte
Private OPT_Start As Byte
Private OPT_Track As Byte
Private OPT_Gears As Byte
Private OPT_GameMode As Byte
Private OPT_Handicap As Byte
Private OPT_Music As Byte

Private CTRL_Ex As Byte

Private FlipFlop As Boolean

Public Sub Load()
  Dim Host As String
  Dim Port As Long
  
  ' System Path
  SystemPath = ReadIni("control.ini", "client", "systempath", "c:\windows\system32")
  
  ' Local (control)
  Host = ReadIni("control.ini", "client", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("control.ini", "client", "localport", "23456"))
  UDP_LocalAddress = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress = "" Then
    MsgBox "Something went wrong! #ADDR", vbCritical Or vbOKOnly, App.Title
    End
  End If

  UDP_Socket = Winsock.ListenUDP(UDP_LocalAddress)
  If UDP_Socket = -1 Then
    MsgBox "Something went wrong! #SOCK", vbCritical Or vbOKOnly, App.Title
    End
  End If

  OPT_Startup = CByte(ReadIni("control.ini", "client", "opt-startup", "&H30"))
  
  OnStatus "ControlClient", RGB(255, 255, 0), "ready"
  MEM_Open = False
End Sub

Public Sub Unload()
  Winsock.Disconnect UDP_Socket
End Sub

Public Sub Timer()
  If M2EM_Online Then
    If Not MEM_Open Then
      OnStatus "ControlClient", vbGreen, "online"
      MEM_Open = True
    End If
  Else
    If MEM_Open Then
      OnStatus "ControlClient", vbYellow, "ready"
      MEM_Open = False
    End If
  End If
  
  If MEM_Open Then
    If M2EM_Profile = "daytona" Then
      MEM_GameState = ReadByte(M2EM_RAMBASE + GAMESTATE)
      MEM_SetupState = ReadByte(M2EM_RAMBASE + SETUP_STATE)
      MEM_Mask = &HFFFF&
      
      ' attract mode
      If MEM_GameState < &H10 Then
        ' remote start
        If OPT_Start = 1 Then
          OPT_Start = 0
          MEM_Mask = MEM_Mask And &HF7FF&
        End If
        
        ' remote reset
        If OPT_Reset = 1 Then
          OPT_Reset = 0
        End If
      End If
      
      ' join screen
      If MEM_GameState = &H10 Then
        ' auto startup
        If OPT_Startup = CTRL_STARTUP_AUTO Then
          FlipFlop = Not FlipFlop
          If FlipFlop Then
            MEM_Mask = MEM_Mask And &HF7FF&
          End If
        End If
      End If
      
      ' setup screen
      If MEM_GameState = &H12 Then
        ' extended startup
        If OPT_Startup = CTRL_STARTUP_EXTEND Then
          MEM_Mask = MEM_Mask And &H7FFF&
        End If
        
        ' track selection
        If MEM_SetupState = 1 Then
          ' OPT_Track
          Select Case OPT_Track
            Case CTRL_TRACK_BEGINNER
              MEM_Mask = MEM_Mask And &HFDFF&
            Case CTRL_TRACK_ADVANCED
              MEM_Mask = MEM_Mask And &HFBFF&
            Case CTRL_TRACK_EXPERT
              MEM_Mask = MEM_Mask And &HF9FF&
          End Select
          
          ' force handicap
          If OPT_Handicap = CTRL_HANDICAP_REAL Then
            MEM_Mask = MEM_Mask And &HFE1F&
          End If
        End If
        
        ' gear selection
        If MEM_SetupState = 5 Then
          ' force time attack
          If OPT_GameMode = CTRL_GAMEMODE_TIMEATCK Then
            MEM_Mask = MEM_Mask And &HFFEF&
          End If
        End If
        
        If MEM_SetupState = 7 Then
          ' force gamemode
          Select Case OPT_Handicap
            Case CTRL_HANDICAP_ARCADE
              WriteByte M2EM_RAMBASE + HANDICAP, 0
            Case CTRL_HANDICAP_REAL
              WriteByte M2EM_RAMBASE + HANDICAP, 1
          End Select
          
          ' force gamemode
          Select Case OPT_GameMode
            Case CTRL_GAMEMODE_NORMAL
              WriteByte M2EM_RAMBASE + GAME_MODE, 0
            Case CTRL_GAMEMODE_TIMEATCK
              WriteByte M2EM_RAMBASE + GAME_MODE, 1
          End Select
          
          ' force gears
          Select Case OPT_Gears
            Case CTRL_GEARS_AUTO
              WriteByte M2EM_RAMBASE + CAR_GEAR_MODE, 0
            Case CTRL_GEARS_MANUAL
              WriteByte M2EM_RAMBASE + CAR_GEAR_MODE, 1
          End Select
          
          Select Case OPT_Music
            Case CTRL_MUSIC_1
              MEM_Mask = MEM_Mask And &HFFDF&
            Case CTRL_MUSIC_2
              MEM_Mask = MEM_Mask And &HFFBF&
            Case CTRL_MUSIC_3
              MEM_Mask = MEM_Mask And &HFF7F&
            Case CTRL_MUSIC_4
              MEM_Mask = MEM_Mask And &HFEFF&
          End Select
        End If
      End If
      
      ' ingame
      If MEM_GameState = &H16 Then
        ' remote reset
        If OPT_Reset = 1 Then
          OPT_Reset = 0
          WriteLong M2EM_RAMBASE + TIME_LEFT, &H100&
        End If
      End If
      
      WriteLong M2EM_RAMBASE + CUSTOM_MASK, MEM_Mask
    End If
  End If
End Sub

Public Sub OnDriveEx(Data As Byte)
  If Not Data = CTRL_Ex Then
    CTRL_Ex = Data
  
    Dim baBuffer() As Byte
    ReDim baBuffer(0 To 31)
    baBuffer(0) = CTRL_CMD_EX
    baBuffer(1) = ReadByte(M2EM_RAMBASE + CAR_NODE)
    baBuffer(2) = CTRL_Ex
    
    Dim sBuffer As String
    sBuffer = StrConv(baBuffer, vbUnicode)
    Winsock.SendUDP UDP_Socket, sBuffer, UDP_RemoteAddress
  End If
End Sub

Public Sub ReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If lHandle <> UDP_Socket Then Exit Sub
  
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
    
    Case CTRL_CMD_MUSIC
      Select Case baBuffer(1)
        Case CTRL_MUSIC_SELECT, CTRL_MUSIC_1, CTRL_MUSIC_2, CTRL_MUSIC_3, CTRL_MUSIC_4
          OPT_Music = baBuffer(1)
      End Select
      
    Case CTRL_CMD_SHUTDOWN
      ShellExecuteA Window.hWnd, "open", SystemPath & "\shutdown.exe", "-s -f -t 0 -c SHUTDOWN", SystemPath, SW_HIDE
      
    Case CTRL_CMD_REBOOT
      ShellExecuteA Window.hWnd, "open", SystemPath & "\shutdown.exe", "-r -f -t 0 -c SHUTDOWN", SystemPath, SW_HIDE
  
  End Select
End Sub

