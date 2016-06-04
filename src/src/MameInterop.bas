Attribute VB_Name = "MameInterop"
Option Explicit

Private output_array() As String

Public MAME_Online As Boolean
Public MAME_DriveData As Byte
Public MAME_LampData As Byte
Public MAME_Profile As String

Public GAMESTATE As Byte

Public Declare Function init_mame Lib "mame" (ByVal id As Long, ByVal Name As String, ByVal MameStart As Long, ByVal MameStop As Long, ByVal MameCopyData As Long, ByVal UpdateState As Long) As Long
Public Declare Function close_mame Lib "mame" () As Long
Public Declare Function map_id_to_outname Lib "mame" (ByVal id As Long) As String

Public Function mame_start() As Long
  Debug.Print "mame_start"
  ReDim output_array(1, 0) As String
  MAME_Online = True
  MAME_DriveData = &H0
  MAME_LampData = &H0
  MAME_Profile = ""
End Function

Public Function mame_stop() As Long
  Debug.Print "mame_stop"
  MAME_Online = False
End Function

Public Function mame_copydata(ByVal id As Long, ByVal Name As String) As Long
  Call get_name_from_id(id, Name)
  If id = 0 Then
    Debug.Print "Profile", MAME_Profile
    Select Case MAME_Profile
      Case "orunners", "outrun"
        MAME_DriveData = &H7
    End Select
  End If
End Function

Public Function mame_updatestate(ByVal id As Long, ByVal State As Long) As Long
  Dim Name As String
  Name = get_name_from_id(id, "")
  
  Select Case Name
    Case "digit0"
      ' raw drive data
      If State < &H10 Then
        GAMESTATE = State
      End If
      If GAMESTATE = 1 And State = &H46 Then
        Exit Function
      End If
      MAME_DriveData = State
      'decode_force_feedback_command State
      
    Case "digit1"
      ' raw lamp data
      MAME_LampData = State
    
    Case "MA_Check_Point_lamp", "MA_Race_Leader_lamp", "MA_Steering_Wheel_motor", "MA_DJ_Music_lamp", "MA_<<_>>_lamp"
      OutRunners State, Name
      
    Case Else
      Debug.Print "mame_updatestate", id, Hex(State), Name
  
  End Select
End Function

Public Sub OutRunners(State As Long, Name As String)
  If Name = "MA_Steering_Wheel_motor" Then
    If State = 0 Then
      MAME_DriveData = &H10
    Else
      MAME_DriveData = &H40
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
      MAME_LampData = MAME_LampData And (&HFF - Mask)
    Else
      MAME_LampData = MAME_LampData Or Mask
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
    
    If id = 0 Then
      MAME_Profile = idStr
      'Debug.Print MAME_Profile
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

Public Function Get_MAME_DriveData() As Byte
  Get_MAME_DriveData = MAME_DriveData
End Function
