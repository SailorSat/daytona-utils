Attribute VB_Name = "ControlClient"
Option Explicit

Public SystemPath As String

Private UDP_LocalAddress As String
Private UDP_RemoteAddress As String
Private UDP_Socket As Long

Private MEM_Open As Boolean
Private MEM_Mask As Long
Private MEM_GameState As Byte
Private MEM_SetupState As Byte
Private MEM_ControlStatus As Byte

Private OPT_Reset As Byte
Private OPT_Startup As Byte
Private OPT_Start As Byte
Private OPT_Track As Byte
Private OPT_Gears As Byte
Private OPT_GameMode As Byte
Private OPT_Handicap As Byte
Private OPT_Music As Byte

Private CTRL_Node As Byte
Private CTRL_Ex As Byte

Private FlipFlop As Boolean
Private AllowTracksD2 As Boolean

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
    If M3EM_Online Then
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
  End If

  If MEM_Open Then
    If M2EM_Profile = "daytona" Then
      OnTimer_Daytona
    ElseIf M3EM_Profile = "daytona2" Then
      OnTimer_Daytona2
    ElseIf M3EM_Profile = "scud" Then
      OnTimer_Scud
    End If
  End If
End Sub

Private Sub OnTimer_Daytona()
  MEM_GameState = ReadByte(M2EM_RAMBASE + GAMESTATE)
  MEM_SetupState = ReadByte(M2EM_RAMBASE + SETUP_STATE)
  MEM_Mask = &HFFFF&
  
  If MEM_GameState >= &H10 Then
    MEM_ControlStatus = CTRL_STATUS_INGAME
  Else
    MEM_ControlStatus = CTRL_STATUS_ONLINE
  End If

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
End Sub

Private Sub OnTimer_Daytona2()
  Dim Offset As LARGE_INTEGER
  Offset.highpart = M3EM_RAMBASE.highpart
  
  Offset.lowpart = M3EM_RAMBASE.lowpart + &H105007
  MEM_GameState = ReadByte64(Offset)
  
  Offset.lowpart = M3EM_RAMBASE.lowpart + &H105005
  MEM_SetupState = ReadByte64(Offset)
  
  If MEM_GameState >= &HB Then
    MEM_ControlStatus = CTRL_STATUS_INGAME
  Else
    MEM_ControlStatus = CTRL_STATUS_ONLINE
  End If

  ' attract mode
  If MEM_GameState < &HB Then
    ' remote start
    If OPT_Start = 1 Then
      OPT_Start = 0
      M3EM_SendServiceB
    End If
    
    ' remote reset
    If OPT_Reset = 1 Then
      OPT_Reset = 0
    End If
    
    AllowTracksD2 = True
  End If
  
  ' join screen
  If MEM_GameState = &HB Then
    ' auto startup
    If OPT_Startup = CTRL_STARTUP_AUTO Then
      FlipFlop = Not FlipFlop
      If FlipFlop Then
        M3EM_SendServiceB
      End If
    End If
    
    AllowTracksD2 = True
  End If
  
  ' setup screen
  If MEM_GameState = &HD Then
    If MEM_SetupState = &H7 Or MEM_SetupState = &H8 Or MEM_SetupState = &HA Or MEM_SetupState = &HB Then
      ' track select (active)
      ' 07 BotE / 0A PE
      
      ' track select (inactive)
      ' 08 BotE / 0B PE
      
      If AllowTracksD2 Then
        ' 105FC6 - Track (RO) - 0 Challenge, 1 Beginner, 2 Advanced, 3 Expert
        Offset.lowpart = M3EM_RAMBASE.lowpart + &H105FC6
        Select Case OPT_Track
          Case CTRL_TRACK_BEGINNER
            WriteByte64 Offset, 1
          Case CTRL_TRACK_ADVANCED
            WriteByte64 Offset, 2
          Case CTRL_TRACK_EXPERT
            WriteByte64 Offset, 3
          Case CTRL_TRACK_CHALLENGE
            WriteByte64 Offset, 0
        End Select
        
        ' 500343 - Selection
        Offset.lowpart = M3EM_RAMBASE.lowpart + &H500343
        Select Case OPT_Track
          Case CTRL_TRACK_BEGINNER
            WriteByte64 Offset, 1
          Case CTRL_TRACK_ADVANCED
            WriteByte64 Offset, 2
          Case CTRL_TRACK_EXPERT
            WriteByte64 Offset, 3
          Case CTRL_TRACK_CHALLENGE
            WriteByte64 Offset, 4
        End Select
      End If
    ElseIf MEM_SetupState = &H9 Or MEM_SetupState = &HC Then
      ' car select / transmission select
      ' 09 BotE / 0C PE

      ' 105FC4 - CAR Type
      Offset.lowpart = M3EM_RAMBASE.lowpart + &H105FC4
      Select Case OPT_Music
        Case CTRL_MUSIC_1
          WriteByte64 Offset, 0
        Case CTRL_MUSIC_2
          WriteByte64 Offset, 1
        Case CTRL_MUSIC_3
          WriteByte64 Offset, 2
        Case CTRL_MUSIC_4
          WriteByte64 Offset, 3
      End Select

      ' 105FC5 - AT/MT
      Offset.lowpart = M3EM_RAMBASE.lowpart + &H105FC5
      Select Case OPT_Gears
        Case CTRL_GEARS_AUTO
          WriteByte64 Offset, 0
        Case CTRL_GEARS_MANUAL
          WriteByte64 Offset, 1
      End Select

      ' 106200 - Timelap
      Offset.lowpart = M3EM_RAMBASE.lowpart + &H106200
      Select Case OPT_GameMode
        Case CTRL_GAMEMODE_NORMAL
          WriteByte64 Offset, 0
        Case CTRL_GAMEMODE_TIMEATCK
          WriteByte64 Offset, 1
      End Select
      
      AllowTracksD2 = False
    End If
  End If

  ' ingame
  If MEM_GameState = &H11 Then
    ' remote reset
    If OPT_Reset = 1 Then
      OPT_Reset = 0
      Offset.lowpart = M3EM_RAMBASE.lowpart + &H105010
      WriteLong64 Offset, &H100&
    End If
    
    AllowTracksD2 = True
  End If
End Sub

Private Sub OnTimer_Scud()
  Dim Offset As LARGE_INTEGER
  Offset.highpart = M3EM_RAMBASE.highpart
  
  Offset.lowpart = M3EM_RAMBASE.lowpart + &H104007
  MEM_GameState = ReadByte64(Offset)
  
  Offset.lowpart = M3EM_RAMBASE.lowpart + &H104005
  MEM_SetupState = ReadByte64(Offset)
  
  If MEM_GameState >= &H11 Then
    MEM_ControlStatus = CTRL_STATUS_INGAME
  Else
    MEM_ControlStatus = CTRL_STATUS_ONLINE
  End If

  ' attract mode
  If MEM_GameState < &HF Then
    ' remote start
    If OPT_Start = 1 Then
      OPT_Start = 0
      M3EM_SendServiceB
    End If
    
    ' remote reset
    If OPT_Reset = 1 Then
      OPT_Reset = 0
    End If
  End If
  
  ' join screen
  If MEM_GameState = &HF Then
    ' auto startup
    If OPT_Startup = CTRL_STARTUP_AUTO Then
      FlipFlop = Not FlipFlop
      If FlipFlop Then
        M3EM_SendServiceB
      End If
    End If
  End If

  ' setup screen
  If MEM_GameState = &H11 Then
    ' 11 / 01 - Track select
    ' 11 / 02 - Track select (inactive)
    
    ' 11 / 05 - Car select / MT select
    ' 11 / 06 - Car select / MT select (inactive)
  
    ' 11 / 07 - all ready?
    
    ' 104F46 - Track
    Offset.lowpart = M3EM_RAMBASE.lowpart + &H104F46
    Select Case OPT_Track
      Case CTRL_TRACK_BEGINNER
        WriteByte64 Offset, 0
      Case CTRL_TRACK_ADVANCED
        WriteByte64 Offset, 1
      Case CTRL_TRACK_EXPERT
        WriteByte64 Offset, 2
      Case CTRL_TRACK_CHALLENGE
        WriteByte64 Offset, 3
    End Select
    
    ' 104F45 - AT/MT
    Offset.lowpart = M3EM_RAMBASE.lowpart + &H104F45
    Select Case OPT_Gears
      Case CTRL_GEARS_AUTO
        WriteByte64 Offset, 0
      Case CTRL_GEARS_MANUAL
        WriteByte64 Offset, 1
    End Select
    
    ' 104F44 - Car
    Offset.lowpart = M3EM_RAMBASE.lowpart + &H104F44
    Select Case OPT_Music
      Case CTRL_MUSIC_1
        WriteByte64 Offset, 4
      Case CTRL_MUSIC_2
        WriteByte64 Offset, 5
      Case CTRL_MUSIC_3
        WriteByte64 Offset, 6
      Case CTRL_MUSIC_4
        WriteByte64 Offset, 7
    End Select
    
    ' 1051A0 - Timelap
    Offset.lowpart = M3EM_RAMBASE.lowpart + &H1051A0
    Select Case OPT_GameMode
      Case CTRL_GAMEMODE_NORMAL
        WriteByte64 Offset, 0
      Case CTRL_GAMEMODE_TIMEATCK
        WriteByte64 Offset, 1
    End Select
  End If

  ' ingame
  If MEM_GameState = &H15 Then
    ' remote reset
    If OPT_Reset = 1 Then
      OPT_Reset = 0
      Offset.lowpart = M3EM_RAMBASE.lowpart + &H104010
      WriteLong64 Offset, &H100&
    End If
  End If
End Sub

Public Sub OnDriveEx(Data As Byte)
  If Not Data = CTRL_Ex Then
    CTRL_Ex = Data
  
    Dim baBuffer() As Byte
    ReDim baBuffer(0 To 31)
    baBuffer(0) = CTRL_CMD_EX
    baBuffer(1) = CTRL_Ex
    baBuffer(2) = CTRL_Node
    
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
      CTRL_Node = baBuffer(2)
      If MEM_Open Then
        baBuffer(1) = MEM_ControlStatus
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
  
    Case CTRL_CMD_LOADER_PROFILE
      OnProfile Replace(Mid(StrConv(baBuffer, vbUnicode), 2), Chr(0), "")
      
    Case CTRL_CMD_LOADER_SOUND
      PlaySoundA "test.wav", 0, SND_FILENAME Or SND_ASYNC
  End Select
End Sub

