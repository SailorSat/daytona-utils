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
Public MAME_NagScreen As Byte

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
    Case "orunners", "outrun", "calspeed", "offroadc", "crusnusa", "crusnwld", "crusnwld24", "crusnexo", "sfrush", "sfrushrk", "sf2049", "gticlub", "midnrun", "windheat", "harddriv", "racedriv", "ridgera", "ridgera2", "raverace", "acedrive", "victlap"
      DriveData = &H7
      LampsData = &H0
      PwmData = &H0
    Case Else
      DriveData = &H0
      LampsData = &H0
      PwmData = &H0
  End Select
  MAME_Online = True
  MAME_NagScreen = 10
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
  MAME_Profile = ""
End Function

Public Function mame_copydata(ByVal id As Long, ByVal Name As String) As Long
  Call get_name_from_id(id, Name)
End Function

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

Public Function mame_updatestate(ByVal id As Long, ByVal State As Long) As Long
  Dim Name As String
  Name = get_name_from_id(id, "")
  
  If MAME_NagScreen > 0 Then
    If id <> 0 Then MAME_NagScreen = 0
  End If
  
  Debug.Print "mame_updatestate", id, Hex(State), Name
  
  If Left(Name, 6) = "cpuled" Then Exit Function
  If Left(Name, 10) = "system_led" Then Exit Function
  
  If Left(Name, 11) = "Orientation" Then
    Sleep 500
    MAME_SendLeftRight
    Sleep 500
    MAME_SendLeftRight
  End If
  
  
  Select Case MAME_Profile
    Case "harddriv", "racedriv"
      HardDrivin Name, State
    Case "outrun"
      OutRun Name, State
    Case "orunners"
      OutRunners Name, State
    
    Case "offroadc"
      OffroadC Name, State
      
    Case "calspeed"
      CalSpeed Name, State
      
    Case "crusnusa", "crusnwld", "crusnwld24", "crusnexo"
      Crusn Name, State
    
    Case "sfrush", "sfrushrk"
      SFRush Name, State
      
    Case "sf2049"
      SFRush2049 Name, State
    
    Case "gticlub", "midnrun", "windheat"
      GtiClub Name, State

    Case "ridgera", "ridgera2", "raverace"
      RaveRacer Name, State

    Case "acedrive", "victlap"
      AceDriver Name, State
    
    Case "cybrcomm"
      ' 0x10 = "view lamp"

    Case "cybrcycc"
    
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
  ' lamp1 = seat lock?
  ' lamp2 = abort light
  ' wheel = wheel (duh!)
  ' sel3 = shifter magnet pwm

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
      Debug.Print "HardDrivin_SEL1", Hex(State)

    Case "SEL2"
      HardDrivin_SEL2 = State
      Debug.Print "HardDrivin_SEL2", Hex(State)

    Case "SEL3"
      ' Shifter PWM?
      HardDrivin_SEL3 = State
      'Debug.Print "HardDrivin_SEL3", Hex(State)

    Case "SEL4"
      HardDrivin_SEL4 = State
      Debug.Print "HardDrivin_SEL4", Hex(State)
 
    Case Else
      Dim Mask As Byte
      Select Case Name
        Case "lamp1"
          ' seat lock / &H04 - start lamp
          Mask = &H4
          Debug.Print Name, Hex(State)
        Case "lamp2"
          ' abort led / &H08 - red lamp
          Mask = &H8
          Debug.Print Name, Hex(State)
        Case Else
          Debug.Print Name, Hex(State)
      End Select
      
      If State = 0 Then
        LampsData = LampsData And (&HFF - Mask)
      Else
        LampsData = LampsData Or Mask
      End If
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
    DriveData = &H10
  Else
    If OutRun_Motor_Direction = 1 Then
      DriveData = &H50 + OutRun_Motor_Speed
    Else
      DriveData = &H60 + OutRun_Motor_Speed
    End If
  End If
End Sub

Public Sub OffroadC(Name As String, State As Long)
'  wheel ? ff-80 = left; 00-7f = right
'  lamp0 start 0/1
'  lamp1 view1 0/1
'  lamp2 view2 0/1
'  lamp3 view3 0/1
'  lamp6/lamp7 leader 0/1
  
  If Name = "wheel" Then
    Dim Cmd As Byte
    Dim Force As Byte
    If State > &H7F Then
      ' ff-80 = left / ccw
      Cmd = &H50
      Force = (&HFF - State) \ &H10&
    Else
      ' 00-7f = right / cw
      Cmd = &H60
      Force = State \ &H10&
    End If
    If Force = 0 Then
      DriveData = &H10
    Else
      DriveData = Cmd Or (Force - 1)
    End If
  End If
End Sub

Public Sub CalSpeed(Name As String, State As Long)
'  wheel ? ff-80 = left; 00-7f = right
'  lamp0 start 0/1
'  lamp1 view1 0/1
'  lamp2 view2 0/1
'  lamp3 view3 0/1
  
  If Name = "wheel" Or Name = "wheel_motor" Then
    Dim Cmd As Byte
    Dim Force As Byte
    If State > &H7F Then
      ' ff-80 = left / ccw
      Cmd = &H60
      Force = (&HFF - State) \ &H10&
    Else
      ' 00-7f = right / cw
      Cmd = &H50
      Force = State \ &H10&
    End If
    If Force = 0 Then
      DriveData = &H10
    Else
      DriveData = Cmd Or (Force - 1)
    End If
  End If
End Sub

Public Sub Crusn(Name As String, State As Long)
'  wheel ? ff-80 = left; 00-7f = right
'  lamp0 start 0/1
'  lamp1 view1 0/1
'  lamp2 view2 0/1
'  lamp3 view3 0/1
'  lamp4 ltail 0/1 (not mapped)
'  lamp5 rtail 0/1 (not mapped)
'  lamp6 lfrnt 0/1 (not mapped) / mrq1
'  lamp7 rfrnt 0/1 (not mapped) / mrq2
  
  If Name = "wheel" Then
    Dim Cmd As Byte
    Dim Force As Byte
    If State > &H7F Then
      ' 80-ff = left / ccw
      Cmd = &H50
      Force = (&HFF - State) \ &H10&
    Else
      ' 00-7f = right / cw
      Cmd = &H60
      Force = State \ &H10&
    End If
    If Force = 0 Then
      DriveData = &H10
    Else
      DriveData = Cmd Or (Force - 1)
    End If
  Else
    Dim Mask As Byte
    Select Case Name
      Case "lamp0"
        '&H04 - start lamp
        Mask = &H4
      Case "lamp1"
        '&H08 - red lamp
        Mask = &H8
      Case "lamp2"
        '&H10 - blue lamp
        Mask = &H10
      Case "lamp3"
        '&H20 - yellow lamp
        Mask = &H20
      Case "lamp7"
        '&H80 - leader lamp
        Mask = &H80
    End Select
    If State = 0 Then
      LampsData = LampsData And (&HFF - Mask)
    Else
      LampsData = LampsData Or Mask
    End If
  End If
End Sub

Public Sub SFRush(Name As String, State As Long)
'  lamp9 winner (not mapped)
'  lamp8 leader
'  lamp7 view1
'  lamp6 view2
'  lamp5 view3
'  lamp4 music
'  lamp3 abort / start
'  wheel - 80-ff = left; 00-7f = right
  If Name = "wheel" Then
    Dim Cmd As Byte
    Dim Force As Byte
    If State > &H7F Then
      ' 80-ff = left / ccw
      Cmd = &H50
      Force = (&HFF - State) \ &H10&
    Else
      ' 00-7f = right / cw
      Cmd = &H60
      Force = State \ &H10&
    End If
    If Force = 0 Then
      DriveData = &H10
    Else
      DriveData = Cmd Or Force - 1
    End If
  Else
    Dim Mask As Byte
    Select Case Name
      Case "lamp8"
        '&H80 - leader lamp
        Mask = &H80
      Case "lamp7"
        '&H08 - red lamp
        Mask = &H8
      Case "lamp6"
        '&H10 - blue lamp
        Mask = &H10
      Case "lamp5"
        '&H20 - yellow lamp
        Mask = &H20
      Case "lamp4"
        '&H40 - green lamp
        Mask = &H40
      Case "lamp3"
        '&H04 - start lamp
        Mask = &H4
    End Select
    If State = 0 Then
      LampsData = LampsData And (&HFF - Mask)
    Else
      LampsData = LampsData Or Mask
    End If
  End If
End Sub

Public Sub SFRush2049(Name As String, State As Long)
'  lamp8 leader
'  lamp0 start
'  lamp1 view1
'  lamp2 view2
'  lamp3 view3
'  lamp5 music
'  wheel ? 90-ff = left? 10-7f = right 0x/8x = center
'      90-ff might be reversed

  If Name = "wheel" Then
    Dim Cmd As Byte
    Dim Force As Byte
    If State > &H7F Then
      ' 80-ff = left / ccw
      Cmd = &H60
      Force = (&HFF& - State) \ &H10&
    Else
      ' 00-7f = right / cw
      Cmd = &H50
      Force = State \ &H10&
    End If
    If Force = 0 Then
      DriveData = &H10
    Else
      DriveData = Cmd Or Force - 1
    End If
  Else
    Dim Mask As Byte
    Select Case Name
      Case "lamp8"
        '&H80 - leader lamp
        Mask = &H80
      Case "lamp1"
        '&H08 - red lamp
        Mask = &H8
      Case "lamp2"
        '&H10 - blue lamp
        Mask = &H10
      Case "lamp3"
        '&H20 - yellow lamp
        Mask = &H20
      Case "lamp5"
        '&H40 - green lamp
        Mask = &H40
      Case "lamp0"
        '&H04 - start lamp
        Mask = &H4
    End Select
    If State = 0 Then
      LampsData = LampsData And (&HFF - Mask)
    Else
      LampsData = LampsData Or Mask
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

Public Sub GtiClub(Name As String, State As Long)
  If Name = "pcbdigit2" Or Name = "pcboutput0" Then
    Dim Cmd As Byte
    Dim Force As Byte
    Cmd = State And &HF0&
    Force = State And &HF&
    Select Case Cmd
      Case &H80&
        ' right?
        Cmd = &H50&
        Force = Force \ 2
      Case &H90&
        ' left?
        Cmd = &H60&
        Force = Force \ 2
      Case Else
        ' 00 = center / motor off
        Cmd = &H10&
        Force = 0
    End Select
    DriveData = Cmd Or Force
  End If
End Sub

Public Sub RaveRacer(Name As String, State As Long)
  Select Case Name
    Case "mcuoutput0"
      ' lamps
      ' 0x02 = coin counter #1
      ' 0x08 = ? ingame ?
      ' 0x10 = leader lamp
      Dim Lmp As Byte
      If State And &H8 Then Lmp = Lmp Or &H4
      If State And &H10 Then Lmp = Lmp Or &H80
      LampsData = Lmp
    
    Case "mcuoutput1"
      ' driveboard
      ' 80-9f = left!
      ' c0-df = right!
      If LampsData And &H4 Then
        Dim Cmd As Byte
        Dim Force As Byte
        Force = Not bitReverse(CByte(State))
        If Force >= &H80 And Force <= &H9F Then
          ' left!
          Cmd = &H60
          Force = (Force - &H80) / 8
          If Force = 0 Then
            Cmd = &H10
          Else
            Force = Force - 1
          End If
        ElseIf Force >= &HC0 And Force <= &HDF Then
          ' right!
          Cmd = &H50
          Force = (Force - &HC0) / 8
          If Force = 0 Then
            Cmd = &H10
          Else
            Force = Force - 1
          End If
        End If
        If Cmd <> 0 Then DriveData = Cmd Or Force
      Else
        DriveData = &H10
      End If

    Case Else
    
  End Select
End Sub

Public Sub AceDriver(Name As String, State As Long)
  Select Case Name
    Case "mcuoutput0"
      ' lamps
      ' 0x01 = green lamp
      ' 0x02 = coin counter #1
      ' 0x04 = motor on?
      ' 0x08 = ? ingame ?
      ' 0x10 = leader lamp
      ' 0x20 = red lamp
      Debug.Print "AceDriver", "Lamp", Hex(State)
      Dim Lmp As Byte
      If State And &H1 Then Lmp = Lmp Or &H8
      If State And &H8 Then Lmp = Lmp Or &H4
      If State And &H10 Then Lmp = Lmp Or &H80
      If State And &H20 Then Lmp = Lmp Or &H10
      LampsData = Lmp
      
      Debug.Print "AceDriver", "Lamp", Hex(State)
    Case "mcuoutput1"
      ' driveboard
      ' 3f-00 = left!
      ' 40-7f = right!
      If LampsData And &H4 Then
        Dim Cmd As Byte
        Dim Force As Byte
        Force = Not bitReverse(CByte(State))
        Debug.Print "AceDriver", "Drive", Hex(Cmd)
        If Force >= &H40 And Force <= &H7F Then
          ' right!
          Cmd = &H50
          Force = (Force - &H40) / 8
          If Force = 0 Then
            Cmd = &H10
          Else
            Force = Force - 1
          End If
        ElseIf Force >= &H0 And Force <= &H3F Then
          ' left!
          Cmd = &H60
          Force = (Force) / 8
          If Force = 0 Then
            Cmd = &H10
          Else
            Force = Force - 1
          End If
        End If
        If Cmd <> 0 Then DriveData = Cmd Or Force
      Else
        DriveData = &H10
      End If


    Case Else
    
  End Select
End Sub

Public Function decode_force_feedback_command(Cmd As Long)
  Static page As Long
  Dim major As Long
  Dim minor As Long
  major = Cmd And &HF0
  minor = Cmd And &HF
  
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
      Debug.Print Hex(page), Hex(Cmd)
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


Public Sub MAME_SendLeftRight()
  Dim keyInput As INPUT_
  Dim VKey As Long, ScanCode As Long
  
  ' left
  ScanCode = MapVirtualKeyA(VK_LEFT, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)

  Sleep 25
  
  ' right
  ScanCode = MapVirtualKeyA(VK_RIGHT, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_EXTENDEDKEY + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)

  Sleep 25
End Sub

Public Sub MAME_SendF3()
  Dim keyInput As INPUT_
  Dim VKey As Long, ScanCode As Long
  
  ' left
  ScanCode = MapVirtualKeyA(VK_F3, MAPVK_VK_TO_VSC)
  
  keyInput.dwType = INPUT_KEYBOARD
  keyInput.dwFlags = KEYEVENTF_SCANCODE
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)
  
  Sleep 25
  
  keyInput.dwFlags = KEYEVENTF_SCANCODE + KEYEVENTF_KEYUP
  keyInput.wScan = ScanCode
  SendInput 1, keyInput, LenB(keyInput)

  Sleep 25
End Sub
