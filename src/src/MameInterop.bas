Attribute VB_Name = "MameInterop"
Option Explicit

' cache for output names
Private output_array() As String

Private HardDrivin_MotorNew As Integer
Private HardDrivin_MotorOld As Integer
Private HardDrivin_MotorOffset As Byte

Private HardDrivin_SEL1 As Byte
Private HardDrivin_SEL2 As Byte
Private HardDrivin_SEL3 As Byte
Private HardDrivin_SEL4 As Byte

Private OutRun_Motor_Direction As Byte
Private OutRun_Motor_Speed As Byte

' status flags
Public MAME_Online As Boolean
Public MAME_Profile As String

Private DriveData As Byte
Private LampsData As Byte
Private PwmData As Byte

' api declares
Public Declare Function init_mame Lib "mame" (ByVal id As Long, ByVal Name As String, ByVal MameStart As Long, ByVal MameStop As Long, ByVal MameCopyData As Long, ByVal UpdateState As Long) As Long
Public Declare Function close_mame Lib "mame" () As Long
Public Declare Function map_id_to_outname Lib "mame" (ByVal id As Long) As String


Public Function Get_MAME_DriveData() As Byte
  Get_MAME_DriveData = DriveData
End Function


Public Function Get_MAME_LampsData() As Byte
  Get_MAME_LampsData = LampsData
End Function


Public Function Get_MAME_PwmData() As Byte
  Get_MAME_PwmData = PwmData
End Function


' internal handling for various games
Public Sub mame_start_internal(Profile As String)
  Debug.Print "mame_start_internal", Profile
  MAME_Profile = Profile
  Select Case MAME_Profile
    Case "orunners", "outrun"
      DriveData = &H7
      LampsData = &H0
    Case Else
      DriveData = &H0
      LampsData = &H0
      PwmData = &H0
  End Select
  MAME_Online = True
End Sub


' public hooks
Public Function mame_start() As Long
  Debug.Print "mame_start"
  ReDim output_array(1, 0) As String
  MAME_Online = False
End Function

Public Function mame_stop() As Long
  Debug.Print "mame_stop"
  ReDim output_array(1, 0) As String
  MAME_Online = False
End Function

Public Function mame_copydata(ByVal id As Long, ByVal Name As String) As Long
  Call get_name_from_id(id, Name)
End Function

Public Function mame_updatestate(ByVal id As Long, ByVal State As Long) As Long
  Dim Name As String
  Name = get_name_from_id(id, "")
  
  'Debug.Print "mame_updatestate", id, Hex(State), Name
  
  Select Case MAME_Profile
    Case "harddriv", "racedriv"
      HardDrivin Name, State
    Case "outrun"
      OutRun Name, State
    Case "orunners"
      OutRunners Name, State
    Case Else
      Select Case Name
        Case "digit0", "RawDrive"
          ' raw drive data
          DriveData = State
          
        Case "digit1", "RawLamps"
          ' raw lamp data
          LampsData = State
          
      End Select
  End Select
End Function

Public Sub HardDrivin(Name As String, State As Long)
  Select Case Name
    Case "wheel"
      ' wheel latch
      If (State And &HE0) = 0 Then
        HardDrivin_MotorOffset = 0
      Else
        If HardDrivin_MotorOffset = 0 Then
          HardDrivin_MotorNew = State And &H1F
          If HardDrivin_MotorNew = 0 Then
            If HardDrivin_MotorNew <> HardDrivin_MotorOld Then
              HardDrivin_MotorOld = HardDrivin_MotorNew
              DriveData = &H10
              PwmData = &H0
            End If
          End If
        ElseIf HardDrivin_MotorOffset = 1 Then
          HardDrivin_MotorNew = HardDrivin_MotorNew + (State And &HF) * &H20
          If State And &H10 Then
            HardDrivin_MotorNew = HardDrivin_MotorNew * -1
          End If
          If HardDrivin_MotorNew <> HardDrivin_MotorOld Then
            HardDrivin_MotorOld = HardDrivin_MotorNew
            If HardDrivin_MotorNew < 0 Then
              ' negative (turn left?)
              DriveData = &H50 + ((HardDrivin_MotorNew * -1) / 12)
              PwmData = Abs(HardDrivin_MotorNew)
            ElseIf HardDrivin_MotorNew > 0 Then
              ' positive (turn right?)
              DriveData = &H60 + ((HardDrivin_MotorNew) / 12)
              PwmData = &H80 Or Abs(HardDrivin_MotorNew)
            Else
              DriveData = &H10
              PwmData = &H0
            End If
          End If
        End If
        HardDrivin_MotorOffset = HardDrivin_MotorOffset + 1
        If HardDrivin_MotorOffset > 2 Then HardDrivin_MotorOffset = 2
      End If
      
    Case "SEL1"
      HardDrivin_SEL1 = State

    Case "SEL2"
      HardDrivin_SEL2 = State

    Case "SEL3"
      HardDrivin_SEL3 = State

    Case "SEL4"
      HardDrivin_SEL4 = State

    Case Else
      Debug.Print Name, Hex(State)
  End Select
End Sub

Public Sub OutRun(Name As String, State As Long)
  If Name = "Bank_Motor_Speed" Then
    OutRun_Motor_Speed = State
  ElseIf Name = "Bank_Motor_Direction" Then
    OutRun_Motor_Direction = State
  Else
    Dim Mask As Byte
    Select Case Name
      Case "Start_lamp"
        '&H04 - start lamp
        Mask = &H4
      Case "Brake_lamp"
        '&H08 - red lamp
        Mask = &H8
    End Select
    If State = 0 Then
      LampsData = LampsData And (&HFF - Mask)
    Else
      LampsData = LampsData Or Mask
    End If
  End If
  If OutRun_Motor_Direction = 0 Then
    DriveData = &H30
  Else
    If OutRun_Motor_Direction = 1 Then
      DriveData = &H50 + OutRun_Motor_Speed
    Else
      DriveData = &H60 + OutRun_Motor_Speed
    End If
  End If
End Sub

Public Sub OutRunners(Name As String, State As Long)
  If Name = "MA_Steering_Wheel_motor" Then
    If State = 0 Then
      DriveData = &H10
    Else
      DriveData = &H40
    End If
  Else
    Dim Mask As Byte
    Select Case Name
      Case "MA_Check_Point_lamp"
        '&H04 - start lamp
        Mask = &H4
      Case "MA_Race_Leader_lamp"
        '&H80 - leader lamp
        Mask = &H80
      Case "MA_DJ_Music_lamp"
        '&H08 - red lamp
        Mask = &H8
      Case "MA_<<_>>_lamp"
        '&H30 - blue & yellow lamp
        Mask = &H30
    End Select
    If State = 0 Then
      LampsData = LampsData And (&HFF - Mask)
    Else
      LampsData = LampsData Or Mask
    End If

  End If
End Sub

Public Function get_name_from_id(id As Long, Name As String) As String
  Dim i As Integer
  Dim idStr As String
  
  idStr = ""
  
  For i = 1 To UBound(output_array, 2)
    If output_array(0, i) = id Then
      idStr = output_array(1, i)
    End If
  Next i
  
  If idStr = "" Then
    If Name = "" Then
      idStr = map_id_to_outname(id)
    Else
      idStr = Name
    End If
    ReDim Preserve output_array(1, UBound(output_array, 2) + 1) As String
    output_array(0, UBound(output_array, 2)) = id
    output_array(1, UBound(output_array, 2)) = idStr
    
    If id = 0 And MAME_Online = False Then
      mame_start_internal idStr
    End If
  End If
  
  get_name_from_id = idStr
End Function

Public Function decode_force_feedback_command(cmd As Long)
  Static page As Long
  Dim major As Long
  Dim minor As Long
  major = cmd And &HF0
  minor = cmd And &HF
  
  Select Case major
    Case &H0
      'enable / disable
      '1 = reset
    
    Case &H10
      ' [TWIN] spring
      Debug.Print major, minor
      
    Case &H20
      ' [TWIN] clutch
      ' 0 = lowest
      ' f = highest
      
      ' [SPECIAL] handle
      ' 0 = center
      ' 1 = center
      ' 2 = roll left
      ' 3 = roll right
      ' 4 = free
      'If FFenable Then FE_CLUTCH minor * 666
      
    Case &H30
      ' [TWIN] centering
      ' 0 = lowest
      ' f = highest
      'If FFenable Then FE_CENTERING minor * 666

    Case &H40
      ' [TWIN] uncentering
      ' 0 = lowest
      ' f = highest
      
      ' [SPECIAL] airbag shoulder
      
      'If FFenable Then FE_UNCENTERING minor * 666
      
    Case &H50
      ' [TWIN] roll left
      ' 0 = lowest
      ' f = highest
      'If FFenable Then FE_LEFT minor * 666
      
    Case &H60
      ' [TWIN] roll right
      ' 0 = lowest
      ' f = highest
      
      ' [SPECIAL] airbag back
      'If FFenable Then FE_RIGHT minor * 666
    
    Case &H70
      ' [SPECIAL] airbag thigh
      
      ' cylinder
      ' 0 = centering
      ' 1 = slide r
      ' 2 = slide l
      ' 5 = sus up r
      ' 6 = sus down r
      ' 7 = sus up l
      ' 8 = sus down l
      ' 9 = sus up d
      ' A = sus down d
      ' E = slide center
      ' F = keep move
      
    Case &H80
      ' page select
      ' 0 = input/output
      ' 1 = dip sw 1
      ' 2 = dip sw 2
      ' 3 = handle
      ' 4 = handle pos
      ' 5 = valve?
      ' 5 = highest
      ' 6 = air bag 1?
      ' 7 = air bag 2? / slide
      page = minor
    
    Case &H90
      ' taco meter
      ' 0 = lowest
      ' F = highest
    Case Else
      Debug.Print Hex(page), Hex(cmd)
  End Select
  
  'If major <> &H80 Then Debug.Print Hex(page), Hex(cmd)

End Function

' page 0 (input/output)
' 0x01 - press sw low
' 0x02 - press sw high
' 0x04 - forward sw
' 0x08 - read sw
' 0x10 - comp pwr (ssr)
' 0x20 - forward lamp
' 0x40 - read lamp
' 0x80 - unused?

' page 1 (dip sw 1)
' page 2 (dip sw 2)

' page 3 (handle)

' page 4 (handle pos)
' 0x00-0x07

' page 5 (valve)
' 0x01 - steering 0
' 0x02 - steering 1
' 0x04 - steering 2
' 0x08 - steering 3

' page 6 (valve)
' 0x01 - right low int
' 0x02 - right low ext
' 0x04 - left low int
' 0x08 - left low ext
' 0x10 - right up int
' 0x20 - right up ext
' 0x40 - left up int
' 0x80 - left up ext

' page 7 (valve)
' 0x01 - back int
' 0x02 - back ext

' 0x20 - fwd/rvs
' 0x40 - brake
' 0x80 - seat lock
