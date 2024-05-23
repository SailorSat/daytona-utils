VERSION 5.00
Begin VB.Form Window 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private DirectX As DirectX8, DirectInput As DirectInput8, DirectInputEnumeration As DirectInputEnumDevices8
Private DirectInputDevice As DirectInputDevice8, Joystate As DIJOYSTATE
Private Active As Boolean

Private Sub Form_Load()
  Me.Show

  Set DirectX = New DirectX8
  Set DirectInput = DirectX.DirectInputCreate
  Set DirectInputEnumeration = DirectInput.GetDIDevices(DI8DEVCLASS_GAMECTRL, DIEDFL_ATTACHEDONLY)
  While DirectInputEnumeration.GetCount = 0
    DoEvents
    Sleep 500
    Set DirectInputEnumeration = DirectInput.GetDIDevices(DI8DEVCLASS_GAMECTRL, DIEDFL_ATTACHEDONLY)
  Wend

  Set DirectInputDevice = DirectInput.CreateDevice(DirectInputEnumeration.GetItem(1).GetGuidInstance)
  DirectInputDevice.SetCommonDataFormat DIFORMAT_JOYSTICK
  DirectInputDevice.SetCooperativeLevel Window.hWnd, DISCL_BACKGROUND Or DISCL_NONEXCLUSIVE
  DirectInputDevice.Acquire

  Active = True
  
  While Active
    DoEvents
    Sleep 16
    
    DirectInputDevice.Poll
    DirectInputDevice.GetDeviceStateJoystick Joystate
    
    ConvertToMouse Joystate.X, Joystate.Z, Joystate.RZ
    Debug.Print Joystate.X, Joystate.Z, Joystate.RZ
  Wend
  
  DirectInputDevice.Unacquire
  Set DirectInputDevice = Nothing
  Set DirectInputEnumeration = Nothing
  Set DirectInput = Nothing
  Set DirectX = Nothing
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Active = False
  End
End Sub

Sub ConvertToMouse(X As Long, Z As Long, RZ As Long)
Dim mX As Long, mY As Long
mX = (X / 512&) - 64&
mY = (RZ / 1024&) - (Z / 1024&)

mouse_event MOUSEEVENTF_MOVE, mX, mY, 0, 0
End Sub
