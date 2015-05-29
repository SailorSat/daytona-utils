Attribute VB_Name = "vJoy"
Option Explicit

Public Const VJD_STAT_OWN  As Long = 0
Public Const VJD_STAT_FREE As Long = 0
Public Const VJD_STAT_BUSY As Long = 0
Public Const VJD_STAT_MISS As Long = 0

Public Const HID_USAGE_X   As Long = &H30
Public Const HID_USAGE_Y   As Long = &H31
Public Const HID_USAGE_Z   As Long = &H32
Public Const HID_USAGE_RX  As Long = &H33
Public Const HID_USAGE_RY  As Long = &H34
Public Const HID_USAGE_RZ  As Long = &H35
Public Const HID_USAGE_SL0 As Long = &H36
Public Const HID_USAGE_SL1 As Long = &H37
Public Const HID_USAGE_WHL As Long = &H38
Public Const HID_USAGE_POV As Long = &H39

Public Type JOYSTICK_POSITION_V2
  bDevice As Byte
  wThrottle As Long
  wRudder As Long
  wAileron As Long
  wAxisX As Long
  wAxisY As Long
  wAxisZ As Long
  wAxisXRot As Long
  wAxisYRot As Long
  wAxisZRot As Long
  wSlider As Long
  wDial As Long
  wWheel As Long
  wAxisVX As Long
  wAxisVY As Long
  wAxisVZ As Long
  wAxisVBRX As Long
  wAxisVBRY As Long
  wAxisVBRZ As Long
  lButtons As Long
  bHats As Long
  bHatsEx1 As Long
  bHatsEx2 As Long
  bHatsEx3 As Long
  lButtonsEx1 As Long
  lButtonsEx2 As Long
  lButtonsEx3 As Long
End Type

' General driver data
Public Declare Function vJoyEnabled Lib "vJoyVB.dll" () As Long
Public Declare Function GetvJoyVersion Lib "vJoyVB.dll" () As Integer
Public Declare Function GetvJoyProductString Lib "vJoyVB.dll" () As Long
Public Declare Function GetvJoyManufacturerString Lib "vJoyVB.dll" () As Long
Public Declare Function GetvJoySerialNumberString Lib "vJoyVB.dll" () As Long

' Write access to vJoy Device
Public Declare Function GetVJDStatus Lib "vJoyVB.dll" (ByVal rID As Long) As Long
Public Declare Function AcquireVJD Lib "vJoyVB.dll" (ByVal rID As Long) As Long
Public Declare Sub RelinquishVJD Lib "vJoyVB.dll" (ByVal rID As Long)
Public Declare Function UpdateVJD Lib "vJoyVB.dll" (ByVal rID As Long, ByRef pData As JOYSTICK_POSITION_V2) As Long

'vJoy Device properties
Public Declare Function GetVJDButtonNumber Lib "vJoyVB.dll" (ByVal rID As Long) As Long
Public Declare Function GetVJDDiscPovNumber Lib "vJoyVB.dll" (ByVal rID As Long) As Long
Public Declare Function GetVJDContPovNumber Lib "vJoyVB.dll" (ByVal rID As Long) As Long
Public Declare Function GetVJDAxisExist Lib "vJoyVB.dll" (ByVal rID As Long, ByVal Axis As Long) As Boolean
Public Declare Function GetVJDAxisMax Lib "vJoyVB.dll" (ByVal rID As Long, ByVal Axis As Long, ByRef Max As Long) As Boolean
Public Declare Function GetVJDAxisMin Lib "vJoyVB.dll" (ByVal rID As Long, ByVal Axis As Long, ByRef Min As Long) As Boolean

'Robust write access to vJoy Devices
Public Declare Function ResetVJD Lib "vJoyVB.dll" (ByVal rID As Long) As Long
Public Declare Sub ResetAll Lib "vJoyVB.dll" ()
Public Declare Function ResetButtons Lib "vJoyVB.dll" (ByVal rID As Long) As Boolean
Public Declare Function ResetPovs Lib "vJoyVB.dll" (ByVal rID As Long) As Boolean
Public Declare Function SetAxis Lib "vJoyVB.dll" (ByVal Value As Long, ByVal rID As Long, ByVal Axis As Long) As Boolean
Public Declare Function SetBtn Lib "vJoyVB.dll" (ByVal Value As Long, ByVal rID As Long, ByVal nBtn As Long) As Boolean
Public Declare Function SetDiscPov Lib "vJoyVB.dll" (ByVal Value As Long, ByVal rID As Long, ByVal nPov As Long) As Boolean
Public Declare Function SetContPov Lib "vJoyVB.dll" (ByVal Value As Long, ByVal rID As Long, ByVal nPov As Long) As Boolean


