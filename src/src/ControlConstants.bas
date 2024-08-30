Attribute VB_Name = "ControlConstants"
Option Explicit

' Commands (byte 0)
Public Const CTRL_CMD_PING As Byte = &H1
Public Const CTRL_CMD_RESET As Byte = &H2
Public Const CTRL_CMD_STARTUP As Byte = &H3
Public Const CTRL_CMD_START As Byte = &H4
Public Const CTRL_CMD_TRACK As Byte = &H5
Public Const CTRL_CMD_GEARS As Byte = &H6
Public Const CTRL_CMD_GAMEMODE As Byte = &H7
Public Const CTRL_CMD_HANDICAP As Byte = &H8
Public Const CTRL_CMD_MUSIC As Byte = &HA
Public Const CTRL_CMD_SHUTDOWN As Byte = &H9
Public Const CTRL_CMD_REBOOT As Byte = &H10
Public Const CTRL_CMD_EX As Byte = &H11
Public Const CTRL_CMD_CAMERA As Byte = &H12
Public Const CTRL_CMD_LOADER_PROFILE As Byte = &HF0
Public Const CTRL_CMD_LOADER_SOUND As Byte = &HF1

' Status (byte 1)
Public Const CTRL_STATUS_OFFLINE As Byte = &H10
Public Const CTRL_STATUS_ONLINE As Byte = &H11
Public Const CTRL_STATUS_INGAME As Byte = &H12

' Startup (byte 1)
Public Const CTRL_STARTUP_NORMAL As Byte = &H30
Public Const CTRL_STARTUP_AUTO As Byte = &H31
Public Const CTRL_STARTUP_EXTEND As Byte = &H32

' Track (byte 1)
Public Const CTRL_TRACK_MAJOR As Byte = &H50
Public Const CTRL_TRACK_BEGINNER As Byte = &H51
Public Const CTRL_TRACK_ADVANCED As Byte = &H52
Public Const CTRL_TRACK_EXPERT As Byte = &H53
Public Const CTRL_TRACK_CHALLENGE As Byte = &H54

' Gears (byte 1)
Public Const CTRL_GEARS_SELECT As Byte = &H60
Public Const CTRL_GEARS_AUTO As Byte = &H61
Public Const CTRL_GEARS_MANUAL As Byte = &H62

' GameMode (byte 1)
Public Const CTRL_GAMEMODE_MAJOR As Byte = &H70
Public Const CTRL_GAMEMODE_NORMAL As Byte = &H71
Public Const CTRL_GAMEMODE_TIMEATCK As Byte = &H72

' Handicap (byte 1)
Public Const CTRL_HANDICAP_SELECT As Byte = &H80
Public Const CTRL_HANDICAP_ARCADE As Byte = &H81
Public Const CTRL_HANDICAP_REAL As Byte = &H82

' Music (byte 1)
Public Const CTRL_MUSIC_SELECT As Byte = &HA0
Public Const CTRL_MUSIC_1 As Byte = &HA1
Public Const CTRL_MUSIC_2 As Byte = &HA2
Public Const CTRL_MUSIC_3 As Byte = &HA3
Public Const CTRL_MUSIC_4 As Byte = &HA4

