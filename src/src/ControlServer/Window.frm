VERSION 5.00
Begin VB.Form Window 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "ControlServer"
   ClientHeight    =   7200
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   9600
   LinkTopic       =   "Form1"
   ScaleHeight     =   7200
   ScaleWidth      =   9600
   Begin VB.Timer Timer60 
      Enabled         =   0   'False
      Interval        =   60000
      Left            =   600
      Top             =   4200
   End
   Begin VB.Frame fmRemote 
      BackColor       =   &H00404040&
      Caption         =   "CONTROL"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   2175
      Left            =   120
      TabIndex        =   6
      Top             =   4920
      Width           =   1695
      Begin VB.OptionButton optRemote 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "PROFILE"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   375
         Index           =   2
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   39
         Top             =   1560
         Width           =   1215
      End
      Begin VB.OptionButton optRemote 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "CAMERA"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   375
         Index           =   1
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   8
         Top             =   960
         Width           =   1215
      End
      Begin VB.OptionButton optRemote 
         Appearance      =   0  'Flat
         BackColor       =   &H00000080&
         Caption         =   "SETTINGS"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   375
         Index           =   0
         Left            =   240
         MaskColor       =   &H00FFFFFF&
         Style           =   1  'Graphical
         TabIndex        =   7
         Top             =   360
         Value           =   -1  'True
         Width           =   1215
      End
   End
   Begin VB.Timer Timer2 
      Enabled         =   0   'False
      Interval        =   2000
      Left            =   120
      Top             =   4200
   End
   Begin VB.Frame fmReset 
      BackColor       =   &H00404040&
      Caption         =   "COMMAND"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   3975
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   1695
      Begin VB.CommandButton cmdReboot 
         BackColor       =   &H00C000C0&
         Caption         =   "REBOOT"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   38
         Top             =   3360
         Width           =   1215
      End
      Begin VB.CommandButton cmdShutdown 
         BackColor       =   &H00C0C000&
         Caption         =   "SHUTDOWN"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   5
         Top             =   2760
         Width           =   1215
      End
      Begin VB.CommandButton cmdLock 
         BackColor       =   &H000000C0&
         Caption         =   "LOCK"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   4
         Top             =   2160
         Width           =   1215
      End
      Begin VB.CommandButton cmdRefresh 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
         Caption         =   "PING"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   3
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdReset 
         BackColor       =   &H0000C0C0&
         Caption         =   "RESET"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   960
         Width           =   1215
      End
   End
   Begin VB.Frame fmStatus 
      BackColor       =   &H00404040&
      Caption         =   "STATUS"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   975
      Left            =   2040
      TabIndex        =   0
      Top             =   120
      Width           =   7455
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   375
         Index           =   8
         Left            =   6960
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   375
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   375
         Index           =   7
         Left            =   6120
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   375
         Index           =   6
         Left            =   5280
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   375
         Index           =   5
         Left            =   4440
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   375
         Index           =   4
         Left            =   3600
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   375
         Index           =   3
         Left            =   2760
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   375
         Index           =   2
         Left            =   1920
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   375
         Index           =   1
         Left            =   1080
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
      Begin VB.Shape shStatus 
         FillColor       =   &H00000080&
         FillStyle       =   0  'Solid
         Height          =   375
         Index           =   0
         Left            =   240
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   615
      End
   End
   Begin VB.Frame fmTabPage 
      BackColor       =   &H00404040&
      BorderStyle     =   0  'None
      Height          =   5775
      Index           =   2
      Left            =   2040
      TabIndex        =   40
      Top             =   1320
      Visible         =   0   'False
      Width           =   7455
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "Super Monaco GP"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   23
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   82
         Top             =   3480
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "Power Drift"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   22
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   81
         Top             =   3000
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H00C000C0&
         Caption         =   "Media Player"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   21
         Left            =   2280
         Style           =   1  'Graphical
         TabIndex        =   80
         Top             =   4920
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "S.F. Rush"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   20
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   61
         Top             =   2520
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "California Speed"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   19
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   60
         Top             =   2040
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C0C0&
         Caption         =   "SHOWCASE #2"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   18
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   59
         Top             =   4920
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C0C0&
         Caption         =   "SHOWCASE #1"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   17
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   58
         Top             =   4440
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "DIRT DEVILS"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   16
         Left            =   2280
         Style           =   1  'Graphical
         TabIndex        =   57
         Top             =   3000
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "LE MANS 24"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   15
         Left            =   2280
         Style           =   1  'Graphical
         TabIndex        =   56
         Top             =   2520
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "SEGA RALLY 2"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   14
         Left            =   2280
         Style           =   1  'Graphical
         TabIndex        =   55
         Top             =   2040
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C000&
         Caption         =   "Daytona2 PE"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   13
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   54
         Top             =   4920
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C000&
         Caption         =   "Daytona2 BotE"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   12
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   53
         Top             =   4440
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "SCUD Race"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   11
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   52
         Top             =   3000
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "Daytona2 PE"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   10
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   51
         Top             =   2520
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "Daytona2 BotE"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   9
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   50
         Top             =   2040
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "Stadium Cross"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   7
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   49
         Top             =   1080
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "OutRunners"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   8
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   48
         Top             =   1560
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "Rad Rally"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   6
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   47
         Top             =   600
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "F1 Super Lap"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   5
         Left            =   4440
         Style           =   1  'Graphical
         TabIndex        =   46
         Top             =   120
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "VIRTUA FORMULA"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   4
         Left            =   2280
         Style           =   1  'Graphical
         TabIndex        =   45
         Top             =   600
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "VIRTUA RACING"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   3
         Left            =   2280
         Style           =   1  'Graphical
         TabIndex        =   44
         Top             =   120
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "SEGA RALLY"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   2
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   43
         Top             =   1080
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "INDY500"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   1
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   42
         Top             =   600
         Width           =   2055
      End
      Begin VB.CommandButton cmdProfile 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         Caption         =   "DAYTONA USA"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   0
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   41
         Top             =   120
         Width           =   2055
      End
   End
   Begin VB.Frame fmTabPage 
      BackColor       =   &H00404040&
      BorderStyle     =   0  'None
      Height          =   5865
      Index           =   0
      Left            =   2040
      TabIndex        =   9
      Top             =   1320
      Width           =   7455
      Begin VB.Frame fmSTART 
         BackColor       =   &H00404040&
         Caption         =   "START"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   1095
         Left            =   0
         TabIndex        =   62
         Top             =   4680
         Width           =   7455
         Begin VB.CommandButton cmdStart 
            Appearance      =   0  'Flat
            BackColor       =   &H0000C000&
            Caption         =   "8"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   7
            Left            =   6120
            Style           =   1  'Graphical
            TabIndex        =   70
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdStart 
            Appearance      =   0  'Flat
            BackColor       =   &H0000C000&
            Caption         =   "7"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   6
            Left            =   5280
            Style           =   1  'Graphical
            TabIndex        =   69
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdStart 
            Appearance      =   0  'Flat
            BackColor       =   &H0000C000&
            Caption         =   "6"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   5
            Left            =   4440
            Style           =   1  'Graphical
            TabIndex        =   68
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdStart 
            Appearance      =   0  'Flat
            BackColor       =   &H0000C000&
            Caption         =   "5"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   4
            Left            =   3600
            Style           =   1  'Graphical
            TabIndex        =   67
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdStart 
            Appearance      =   0  'Flat
            BackColor       =   &H0000C000&
            Caption         =   "4"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   3
            Left            =   2760
            Style           =   1  'Graphical
            TabIndex        =   66
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdStart 
            Appearance      =   0  'Flat
            BackColor       =   &H0000C000&
            Caption         =   "3"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   2
            Left            =   1920
            Style           =   1  'Graphical
            TabIndex        =   65
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdStart 
            Appearance      =   0  'Flat
            BackColor       =   &H0000C000&
            Caption         =   "2"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   1
            Left            =   1080
            Style           =   1  'Graphical
            TabIndex        =   64
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdStart 
            Appearance      =   0  'Flat
            BackColor       =   &H0000C000&
            Caption         =   "1"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   0
            Left            =   240
            Style           =   1  'Graphical
            TabIndex        =   63
            Top             =   480
            Width           =   615
         End
         Begin VB.Shape shControl 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   7
            Left            =   6120
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shControl 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   6
            Left            =   5280
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shControl 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   5
            Left            =   4440
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shControl 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   4
            Left            =   3600
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shControl 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   3
            Left            =   2760
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shControl 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   2
            Left            =   1920
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shControl 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   1
            Left            =   1080
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shControl 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   0
            Left            =   240
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
      End
      Begin VB.Frame fmMusic 
         BackColor       =   &H00404040&
         Caption         =   "MUSIC"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   3375
         Left            =   5760
         TabIndex        =   32
         Top             =   0
         Width           =   1695
         Begin VB.OptionButton optMusic 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "4"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   4
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   37
            Top             =   2760
            Width           =   1215
         End
         Begin VB.OptionButton optMusic 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "3"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   3
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   36
            Top             =   2160
            Width           =   1215
         End
         Begin VB.OptionButton optMusic 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "2"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   2
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   35
            Top             =   1560
            Width           =   1215
         End
         Begin VB.OptionButton optMusic 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "1"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   1
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   34
            Top             =   960
            Width           =   1215
         End
         Begin VB.OptionButton optMusic 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "SELECT"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   0
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   33
            Top             =   360
            Value           =   -1  'True
            Width           =   1215
         End
      End
      Begin VB.Frame fmStartup 
         BackColor       =   &H00404040&
         Caption         =   "STARTUP"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   2175
         Left            =   1920
         TabIndex        =   27
         Top             =   0
         Width           =   1695
         Begin VB.OptionButton optStartup 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "NORMAL"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   0
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   30
            Top             =   360
            Width           =   1215
         End
         Begin VB.OptionButton optStartup 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "AUTOMATIC"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   1
            Left            =   240
            Style           =   1  'Graphical
            TabIndex        =   29
            Top             =   960
            Value           =   -1  'True
            Width           =   1215
         End
         Begin VB.OptionButton optStartup 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "EXTENDED"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   2
            Left            =   240
            Style           =   1  'Graphical
            TabIndex        =   28
            Top             =   1560
            Width           =   1215
         End
      End
      Begin VB.Frame fmTrack 
         BackColor       =   &H00404040&
         Caption         =   "TRACK"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   2775
         Left            =   0
         TabIndex        =   22
         Top             =   0
         Width           =   1695
         Begin VB.OptionButton optTrack 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "MAJOR"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   0
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   26
            Top             =   360
            Value           =   -1  'True
            Width           =   1215
         End
         Begin VB.OptionButton optTrack 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "BEGINNER"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   1
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   25
            Top             =   960
            Width           =   1215
         End
         Begin VB.OptionButton optTrack 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "ADVANCED"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   2
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   24
            Top             =   1560
            Width           =   1215
         End
         Begin VB.OptionButton optTrack 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "EXPERT"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   3
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   23
            Top             =   2160
            Width           =   1215
         End
      End
      Begin VB.Frame fmMode 
         BackColor       =   &H00404040&
         Caption         =   "MODE"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   2175
         Left            =   3840
         TabIndex        =   18
         Top             =   0
         Width           =   1695
         Begin VB.OptionButton optMode 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "MAJOR"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   0
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   21
            Top             =   360
            Value           =   -1  'True
            Width           =   1215
         End
         Begin VB.OptionButton optMode 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "NORMAL"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   1
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   20
            Top             =   960
            Width           =   1215
         End
         Begin VB.OptionButton optMode 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "TIMELAP"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   2
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   19
            Top             =   1560
            Width           =   1215
         End
      End
      Begin VB.Frame fmHandicap 
         BackColor       =   &H00404040&
         Caption         =   "HANDICAP"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   2175
         Left            =   3840
         TabIndex        =   14
         Top             =   2400
         Width           =   1695
         Begin VB.OptionButton optHandicap 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "SELECT"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   0
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   17
            Top             =   360
            Value           =   -1  'True
            Width           =   1215
         End
         Begin VB.OptionButton optHandicap 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "ARCADE"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   1
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   16
            Top             =   960
            Width           =   1215
         End
         Begin VB.OptionButton optHandicap 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "REAL"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   2
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   15
            Top             =   1560
            Width           =   1215
         End
      End
      Begin VB.Frame fmGears 
         BackColor       =   &H00404040&
         Caption         =   "GEARS"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   2175
         Left            =   1920
         TabIndex        =   10
         Top             =   2400
         Width           =   1695
         Begin VB.OptionButton optGears 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "SELECT"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   0
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   13
            Top             =   360
            Value           =   -1  'True
            Width           =   1215
         End
         Begin VB.OptionButton optGears 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "AUTOMATIC"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   1
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   12
            Top             =   960
            Width           =   1215
         End
         Begin VB.OptionButton optGears 
            Appearance      =   0  'Flat
            BackColor       =   &H00000080&
            Caption         =   "MANUAL"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   375
            Index           =   2
            Left            =   240
            MaskColor       =   &H00FFFFFF&
            Style           =   1  'Graphical
            TabIndex        =   11
            Top             =   1560
            Width           =   1215
         End
      End
   End
   Begin VB.Frame fmTabPage 
      BackColor       =   &H00404040&
      BorderStyle     =   0  'None
      Height          =   5775
      Index           =   1
      Left            =   2040
      TabIndex        =   31
      Top             =   1320
      Visible         =   0   'False
      Width           =   7455
      Begin VB.Frame Frame1 
         BackColor       =   &H00404040&
         Caption         =   "PRIORITY"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   1095
         Left            =   0
         TabIndex        =   71
         Top             =   4680
         Width           =   7455
         Begin VB.CommandButton cmdCamera 
            BackColor       =   &H0000C0C0&
            Caption         =   "8"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   7
            Left            =   6120
            Style           =   1  'Graphical
            TabIndex        =   79
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdCamera 
            BackColor       =   &H0000C0C0&
            Caption         =   "7"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   6
            Left            =   5280
            Style           =   1  'Graphical
            TabIndex        =   78
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdCamera 
            BackColor       =   &H0000C0C0&
            Caption         =   "6"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   5
            Left            =   4440
            Style           =   1  'Graphical
            TabIndex        =   77
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdCamera 
            BackColor       =   &H0000C0C0&
            Caption         =   "5"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   4
            Left            =   3600
            Style           =   1  'Graphical
            TabIndex        =   76
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdCamera 
            BackColor       =   &H0000C0C0&
            Caption         =   "4"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   3
            Left            =   2760
            Style           =   1  'Graphical
            TabIndex        =   75
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdCamera 
            BackColor       =   &H0000C0C0&
            Caption         =   "3"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   2
            Left            =   1920
            Style           =   1  'Graphical
            TabIndex        =   74
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdCamera 
            BackColor       =   &H0000C0C0&
            Caption         =   "2"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   1
            Left            =   1080
            Style           =   1  'Graphical
            TabIndex        =   73
            Top             =   480
            Width           =   615
         End
         Begin VB.CommandButton cmdCamera 
            BackColor       =   &H0000C0C0&
            Caption         =   "1"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   0
            Left            =   240
            Style           =   1  'Graphical
            TabIndex        =   72
            Top             =   480
            Width           =   615
         End
         Begin VB.Shape shPriority 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   7
            Left            =   6120
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shPriority 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   6
            Left            =   5280
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shPriority 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   5
            Left            =   4440
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shPriority 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   4
            Left            =   3600
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shPriority 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   3
            Left            =   2760
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shPriority 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   2
            Left            =   1920
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shPriority 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   1
            Left            =   1080
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
         Begin VB.Shape shPriority 
            FillColor       =   &H00404040&
            FillStyle       =   0  'Solid
            Height          =   135
            Index           =   0
            Left            =   240
            Shape           =   4  'Rounded Rectangle
            Top             =   360
            Width           =   615
         End
      End
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private UDP_LocalAddress_RX As String
Private UDP_Socket_RX As Long

Private UDP_RemoteAddress_RX(0 To 8) As String
Private UDP_RemoteStatus(0 To 8) As Byte

Private CurrentPriority As Byte

Private OPT_Startup As Byte
Private OPT_Track As Byte
Private OPT_Gears As Byte
Private OPT_GameMode As Byte
Private OPT_Handicap As Byte
Private OPT_Music As Byte

Private Sub cmdCamera_Click(Index As Integer)
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_CAMERA
  baBuffer(1) = Index

  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  ' only to camera
  SendToClient 8, sBuffer, CTRL_STATUS_OFFLINE
End Sub

Private Sub cmdLock_Click()
  WindowLock.Show vbModal, Window
End Sub

Private Sub cmdProfile_Click(Index As Integer)
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_LOADER_PROFILE
  
  Dim bsBuffer() As Byte
  Select Case Index
    Case 0
      bsBuffer = StrConv("daytona", vbFromUnicode)
    Case 1
      bsBuffer = StrConv("indy500", vbFromUnicode)
    Case 2
      bsBuffer = StrConv("srallyc", vbFromUnicode)
      
    Case 3
      bsBuffer = StrConv("vr", vbFromUnicode)
    Case 4
      bsBuffer = StrConv("vformula", vbFromUnicode)
    Case 5
      bsBuffer = StrConv("f1lap", vbFromUnicode)
    Case 6
      bsBuffer = StrConv("radr", vbFromUnicode)
    Case 7
      bsBuffer = StrConv("scross", vbFromUnicode)
    Case 8
      bsBuffer = StrConv("orunners", vbFromUnicode)
    Case 19
      bsBuffer = StrConv("calspeed", vbFromUnicode)
    Case 20
      bsBuffer = StrConv("sfrush", vbFromUnicode)
    Case 22
      bsBuffer = StrConv("pdrift", vbFromUnicode)
    Case 23
      bsBuffer = StrConv("smgp", vbFromUnicode)
      
    Case 9
      bsBuffer = StrConv("daytona2", vbFromUnicode)
    Case 10
      bsBuffer = StrConv("daytona2pe", vbFromUnicode)
    Case 11
      bsBuffer = StrConv("scud", vbFromUnicode)
      
    Case 12
      bsBuffer = StrConv("daytona2-16", vbFromUnicode)
    Case 13
      bsBuffer = StrConv("daytona2pe-16", vbFromUnicode)
    
    Case 14
      bsBuffer = StrConv("srally2", vbFromUnicode)
    Case 15
      bsBuffer = StrConv("lemans24", vbFromUnicode)
    Case 16
      bsBuffer = StrConv("dirtdvls", vbFromUnicode)
      
    Case 17
      bsBuffer = StrConv("showcase", vbFromUnicode)
    Case 18
      bsBuffer = StrConv("showcase2", vbFromUnicode)
    
    Case 21
      bsBuffer = StrConv("media", vbFromUnicode)
      
    Case Else
      Exit Sub
  End Select
  
  RtlMoveMemory baBuffer(1), bsBuffer(0), UBound(bsBuffer) + 1
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_OFFLINE
End Sub

Private Sub cmdReboot_Click()
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_REBOOT
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_OFFLINE
End Sub

Private Sub cmdRefresh_Click()
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_PING
  baBuffer(1) = CTRL_STATUS_OFFLINE
  baBuffer(2) = 0 ' <id>
  
  Dim sBuffer As String
  
  Dim Index As Integer
  For Index = 0 To 8
    UDP_RemoteStatus(Index) = 0&
    shStatus(Index).FillColor = &H80&
    baBuffer(2) = Index
    sBuffer = StrConv(baBuffer, vbUnicode)
    If UDP_RemoteAddress_RX(Index) <> "" Then
      Winsock.SendUDP UDP_Socket_RX, sBuffer, UDP_RemoteAddress_RX(Index)
    End If
  Next
End Sub

Private Sub cmdReset_Click()
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_RESET
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub cmdShutdown_Click()
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_SHUTDOWN
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_OFFLINE
End Sub

Private Sub cmdStart_Click(Index As Integer)
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_START
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClient Index, sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub fmTabPage_DblClick(Index As Integer)
  Form_DblClick
End Sub


Private Sub optGears_Click(Index As Integer)
  Select Case Index
    Case 0
      OPT_Gears = CTRL_GEARS_SELECT
    Case 1
      OPT_Gears = CTRL_GEARS_AUTO
    Case 2
      OPT_Gears = CTRL_GEARS_MANUAL
  End Select
  
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_GEARS
  baBuffer(1) = OPT_Gears
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optHandicap_Click(Index As Integer)
  Select Case Index
    Case 0
      OPT_Handicap = CTRL_HANDICAP_SELECT
    Case 1
      OPT_Handicap = CTRL_HANDICAP_ARCADE
    Case 2
      OPT_Handicap = CTRL_HANDICAP_REAL
  End Select
  
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_HANDICAP
  baBuffer(1) = OPT_Handicap
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optMode_Click(Index As Integer)
  Select Case Index
    Case 0
      OPT_GameMode = CTRL_GAMEMODE_MAJOR
    Case 1
      OPT_GameMode = CTRL_GAMEMODE_NORMAL
    Case 2
      OPT_GameMode = CTRL_GAMEMODE_TIMEATCK
  End Select
  
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_GAMEMODE
  baBuffer(1) = OPT_GameMode
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optMusic_Click(Index As Integer)
  Select Case Index
    Case 0
      OPT_Music = CTRL_MUSIC_SELECT
    Case 1
      OPT_Music = CTRL_MUSIC_1
    Case 2
      OPT_Music = CTRL_MUSIC_2
    Case 3
      OPT_Music = CTRL_MUSIC_3
    Case 4
      OPT_Music = CTRL_MUSIC_4
  End Select
  
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_MUSIC
  baBuffer(1) = OPT_Music
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optRemote_Click(Index As Integer)
  Dim SubIndex As Integer
  For SubIndex = 0 To 2
    fmTabPage(SubIndex).Visible = optRemote(SubIndex).Value
  Next
End Sub

Private Sub optStartup_Click(Index As Integer)
  Select Case Index
    Case 0
      OPT_Startup = CTRL_STARTUP_NORMAL
    Case 1
      OPT_Startup = CTRL_STARTUP_AUTO
    Case 2
      OPT_Startup = CTRL_STARTUP_EXTEND
  End Select
  
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_STARTUP
  baBuffer(1) = OPT_Startup
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub optTrack_Click(Index As Integer)
  Select Case Index
    Case 0
      OPT_Track = CTRL_TRACK_MAJOR
    Case 1
      OPT_Track = CTRL_TRACK_BEGINNER
    Case 2
      OPT_Track = CTRL_TRACK_ADVANCED
    Case 3
      OPT_Track = CTRL_TRACK_EXPERT
  End Select
  
  Dim baBuffer(0 To 31) As Byte
  baBuffer(0) = CTRL_CMD_TRACK
  baBuffer(1) = OPT_Track
  
  Dim sBuffer As String
  sBuffer = StrConv(baBuffer, vbUnicode)
  
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub

Private Sub Form_DblClick()
  Form_Unload 0
End Sub

Private Sub Form_Load()
  Dim Host As String
  Dim Port As Long
  Dim Index As Integer
  
  Me.Move 0, 0
  Winsock.Load
  
  ' Local-RX (control)
  Host = ReadIni("control.ini", "server", "localhost", "0.0.0.0")
  Port = CLng(ReadIni("control.ini", "server", "localport", "23456"))
  UDP_LocalAddress_RX = Winsock.WSABuildSocketAddress(Host, Port)
  If UDP_LocalAddress_RX = "" Then
    MsgBox "Something went wrong! #ADDR_RX", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If

  UDP_Socket_RX = Winsock.ListenUDP(UDP_LocalAddress_RX)
  If UDP_Socket_RX = -1 Then
    MsgBox "Something went wrong! #SOCK_RX", vbCritical Or vbOKOnly, Me.Caption
    Form_Unload 0
  End If
  
  ' Remote-RX (control - 9 units)
  For Index = 0 To 8
    Host = ReadIni("control.ini", "server", "remotehost" & Index, "")
    Port = CLng(ReadIni("control.ini", "server", "remoteport" & Index, "23456"))
    UDP_RemoteAddress_RX(Index) = Winsock.WSABuildSocketAddress(Host, Port)
  Next
  For Index = 0 To 7
    UDP_RemoteStatus(Index) = CTRL_STATUS_OFFLINE
  Next

  Timer2.Enabled = True
  Timer2_Timer
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Winsock.Unload
  End
End Sub

Public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
  If Len(sBuffer) < 32 Then Exit Sub
  Dim baBuffer() As Byte
  baBuffer = StrConv(sBuffer, vbFromUnicode)
  
  Dim Index As Integer
  
  Select Case baBuffer(0)
    Case CTRL_CMD_PING
      If baBuffer(2) < 9 Then
        Index = baBuffer(2)
        UDP_RemoteStatus(Index) = baBuffer(1)
        Select Case UDP_RemoteStatus(Index)
          Case CTRL_STATUS_ONLINE
            shStatus(Index).FillColor = &HC0C0&
          Case CTRL_STATUS_INGAME
            shStatus(Index).FillColor = &HC000&
          Case Else
            shStatus(Index).FillColor = &HC00000
        End Select
      End If
    Case CTRL_CMD_EX
      ' 1 = ex
      ' 2 = node
      Dim Node As Byte
      Dim Val As Byte
      Node = baBuffer(2) And &HF
      If Node > 7 Then Exit Sub
      Val = baBuffer(1) And &H1
      Select Case Val
        Case &H1
          ' not ready
          shControl(Node).FillColor = &HC0C0&
        Case &H0
          ' ready
          shControl(Node).FillColor = &HC000&
      End Select
      Val = baBuffer(1) And &H2
      Select Case Val
        Case &H2
          ' not priority
          shPriority(Node).FillColor = &HC0C0&
          OnPriority Node, False
        Case &H0
          ' priority
          shPriority(Node).FillColor = &HC000&
          OnPriority Node, True
      End Select

      'Debug.Print Node, Hex(baBuffer(2))
  End Select
End Sub

Public Sub OnPriority(Node As Byte, Active As Boolean)
  If Active And CurrentPriority = 255 Then
    CurrentPriority = Node
    cmdCamera_Click CInt(Node)
    Debug.Print "auto priority on car #" & Node + 1
  ElseIf (Not Active) And CurrentPriority = Node Then
    CurrentPriority = 255
  End If
End Sub

Public Sub SendToClient(Index As Integer, sBuffer As String, MinimumStatus As Byte)
  If UDP_RemoteStatus(Index) >= MinimumStatus Then
    Winsock.SendUDP UDP_Socket_RX, sBuffer, UDP_RemoteAddress_RX(Index)
  End If
End Sub

Public Sub SendToClients(sBuffer As String, MinimumStatus As Byte)
  Dim Index As Integer
  For Index = 8 To 0 Step -1
    SendToClient Index, sBuffer, MinimumStatus
  Next
End Sub

Private Sub Timer2_Timer()
  cmdRefresh_Click
End Sub

Private Sub Timer60_Timer()
  Dim baBuffer(0 To 31) As Byte
  Dim sBuffer As String
  
  baBuffer(0) = CTRL_CMD_STARTUP
  baBuffer(1) = OPT_Startup
  sBuffer = StrConv(baBuffer, vbUnicode)
  SendToClients sBuffer, CTRL_STATUS_ONLINE

  baBuffer(0) = CTRL_CMD_TRACK
  baBuffer(1) = OPT_Track
  sBuffer = StrConv(baBuffer, vbUnicode)
  SendToClients sBuffer, CTRL_STATUS_ONLINE

  baBuffer(0) = CTRL_CMD_GEARS
  baBuffer(1) = OPT_Gears
  sBuffer = StrConv(baBuffer, vbUnicode)
  SendToClients sBuffer, CTRL_STATUS_ONLINE

  baBuffer(0) = CTRL_CMD_GAMEMODE
  baBuffer(1) = OPT_GameMode
  sBuffer = StrConv(baBuffer, vbUnicode)
  SendToClients sBuffer, CTRL_STATUS_ONLINE

  baBuffer(0) = CTRL_CMD_HANDICAP
  baBuffer(1) = OPT_Handicap
  sBuffer = StrConv(baBuffer, vbUnicode)
  SendToClients sBuffer, CTRL_STATUS_ONLINE

  baBuffer(0) = CTRL_CMD_MUSIC
  baBuffer(1) = OPT_Music
  sBuffer = StrConv(baBuffer, vbUnicode)
  SendToClients sBuffer, CTRL_STATUS_ONLINE
End Sub
