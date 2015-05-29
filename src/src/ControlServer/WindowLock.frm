VERSION 5.00
Begin VB.Form WindowLock 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   7200
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   9600
   LinkTopic       =   "Form1"
   ScaleHeight     =   7200
   ScaleWidth      =   9600
   ShowInTaskbar   =   0   'False
   Begin VB.Frame fmKeys 
      BackColor       =   &H00404040&
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
      Height          =   2895
      Left            =   3713
      TabIndex        =   1
      Top             =   2693
      Width           =   2175
      Begin VB.CommandButton cmdEnter 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
         Caption         =   "ENTER"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Left            =   840
         Style           =   1  'Graphical
         TabIndex        =   13
         Top             =   2160
         Width           =   1095
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
         Caption         =   "9"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Index           =   9
         Left            =   1440
         Style           =   1  'Graphical
         TabIndex        =   12
         Top             =   360
         Width           =   495
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
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
         Height          =   495
         Index           =   8
         Left            =   840
         Style           =   1  'Graphical
         TabIndex        =   11
         Top             =   360
         Width           =   495
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
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
         Height          =   495
         Index           =   7
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   10
         Top             =   360
         Width           =   495
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
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
         Height          =   495
         Index           =   6
         Left            =   1440
         Style           =   1  'Graphical
         TabIndex        =   9
         Top             =   960
         Width           =   495
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
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
         Height          =   495
         Index           =   5
         Left            =   840
         Style           =   1  'Graphical
         TabIndex        =   8
         Top             =   960
         Width           =   495
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
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
         Height          =   495
         Index           =   4
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   7
         Top             =   960
         Width           =   495
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
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
         Height          =   495
         Index           =   3
         Left            =   1440
         Style           =   1  'Graphical
         TabIndex        =   6
         Top             =   1560
         Width           =   495
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
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
         Height          =   495
         Index           =   2
         Left            =   840
         Style           =   1  'Graphical
         TabIndex        =   5
         Top             =   1560
         Width           =   495
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
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
         Height          =   495
         Index           =   1
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   4
         Top             =   1560
         Width           =   495
      End
      Begin VB.CommandButton cmdKey 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
         Caption         =   "0"
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Index           =   0
         Left            =   240
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   2160
         Width           =   495
      End
   End
   Begin VB.Frame fmReset 
      BackColor       =   &H00404040&
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
      Left            =   3713
      TabIndex        =   0
      Top             =   1613
      Width           =   2175
      Begin VB.Label lblCode 
         Alignment       =   2  'Center
         BackColor       =   &H00404040&
         BeginProperty Font 
            Name            =   "Terminal"
            Size            =   13.5
            Charset         =   255
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   375
         Left            =   240
         TabIndex        =   3
         Top             =   360
         Width           =   1695
      End
   End
End
Attribute VB_Name = "WindowLock"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const CodeNumber As String = "3008776"

Private CodeEntered As String

Private Sub cmdEnter_Click()
  If CodeEntered = CodeNumber Then
    Me.Hide
  End If
  CodeEntered = ""
  lblCode.Caption = ""
End Sub

Private Sub cmdKey_Click(Index As Integer)
  CodeEntered = CodeEntered & Index
  lblCode.Caption = String(Len(CodeEntered), "*")
  If Len(CodeEntered) = 8 Then cmdEnter_Click
End Sub

Private Sub Form_Load()
  CodeEntered = ""
End Sub
