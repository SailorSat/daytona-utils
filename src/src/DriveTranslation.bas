Attribute VB_Name = "DriveTranslation"
Option Explicit

' internal profile
Public Profile As String

' optional model3 and debug modes
Public Model3Mode As Boolean
Public TranslationDebug As Boolean

Public Function TranslateDrive(ByRef OldData As Byte, ByVal NewData As Byte) As Boolean
  If Model3Mode Then
    TranslateDrive = TranslateDrive_M3(OldData, NewData)
  Else
    TranslateDrive = TranslateDrive_M2(OldData, NewData)
  End If
End Function

Private Function TranslateDrive_M2(ByRef OldData As Byte, ByVal NewData As Byte) As Boolean
  Dim TempData As Byte
  TranslateDrive_M2 = False

  Dim CmdGroup As Byte
  Dim CmdForce As Byte

  Select Case Profile
    Case "orunners", "outrun"
      If OldData <> NewData Then
        OldData = NewData
        TranslateDrive_M2 = True
      End If
    Case "vr", "vformula"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce

      Select Case CmdGroup
        ' halve the force of any movements
        Case &H20, &H40, &H50, &H60
          TempData = CmdGroup + (CmdForce \ 2)
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        ' halve the force of any movements
        Case &H30
          TempData = CmdGroup + 8 + (CmdForce \ 2)
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &H0, &H10, &H80
          ' direct
          TempData = NewData
        Case &H70, &H90
          '0x7x airbags(VR)
          '0x7x cylinder(VF)
          '0x9x  taco meter (VF)
          Exit Function
        Case Else
          TempData = NewData
          Debug.Print "vr", Hex(NewData)
      End Select

      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M2 = True
      End If
      Exit Function

    Case "daytona", "indy500"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      Select Case CmdGroup
        Case &H0, &H10, &H20, &H30, &H40, &H50, &H60, &H70, &H80
          ' 0x0x = GAME STATE
          ' 0x1x = SPRING (motor off)
          ' 0x2x = HOLD (20-27)
          ' 0x3x = CENTERING (38-3F)
          ' 0x4x = UNCENTERING (40-47)
          ' 0x5x = ROLL LEFT (50-57)
          ' 0x6x = ROLL RIGHT (60-67)
          ' 0x7x = 71 on race start
          ' 0x8x = PAGE SELECT (82 = Dips, 83 = Wheel)
          Debug.Print "daytona 0", Hex(NewData)
          TempData = NewData
        Case &HC0, &HD0
          ' 0xCx = CYLINDER
          ' 0xDx = QUICK BREATH
          Debug.Print "daytona 1", Hex(NewData)
          Exit Function
        Case &HE0
          ' 0xEx = TOWER SIGNAL
          OnDaytonaEx NewData
          Debug.Print "daytona ex", Hex(NewData)
          Exit Function
        Case &H90, &HA0, &HB0
          Debug.Print "daytona 2", Hex(NewData)
          Exit Function
        Case Else
          Debug.Print "daytona u", Hex(NewData)
      End Select
      
    Case "stcc"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      Select Case CmdGroup
        Case &H0, &H10, &H20, &H30, &H40, &H50, &H60, &H80
          ' 0x0x = GAME STATE
          ' 0x3x = CENTERING (30-38)
          ' 0x5x = ROLL LEFT (51-57)
          ' 0x6x = ROLL RIGHT (61-67)
          Debug.Print "stcc 0", Hex(NewData)
          TempData = NewData
        Case &H90
          ' 0x9x = ? (98 on start)
          Debug.Print "stcc 1", Hex(NewData)
          Exit Function
        Case Else
          Debug.Print "stcc u", Hex(NewData)
      End Select

    Case "srallyc"
      Select Case NewData
        Case &H0
          TempData = &H10

        Case &H1 To &HF, &H7E
          Exit Function

        Case &H10
          TempData = &H7

        Case &H15
          TempData = &H30

        Case &H80 To &H9F
          ' turn right
          CmdForce = (NewData - &H80)
          TempData = &H60 + (CmdForce / 4)
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &HC0 To &HDF
          ' turn left
          CmdForce = (NewData - &HC0)
          TempData = &H50 + (CmdForce / 4)
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)

        Case Else
          TempData = NewData
          Debug.Print "srallyc", Hex(NewData)
      End Select

      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M2 = True
      End If
      Exit Function

    Case "srally2"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      Select Case CmdGroup
        Case &H0, &H10, &H20, &H30
          ' &H00 to &H3F - left
          CmdForce = NewData
          If CmdForce = 0 Then
            TempData = &H10
          Else
            TempData = &H50 + (CmdForce / 8)
          End If
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &H40, &H50, &H60, &H70
          ' &H40 to &H7f - right
          CmdForce = (NewData - &H40)
          If CmdForce = 0 Then
            TempData = &H10
          Else
            TempData = &H60 + (CmdForce / 8)
          End If
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &HC0
          TempData = &H0 + CmdForce
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & LeadZero(Hex(TempData), 2)
        
        Case Else
          Exit Function
        
      End Select
      
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M2 = True
      End If
      Exit Function
      
    Case "daytona2", "dayto2pe", "scud", "scuda", "scudau", "lemans24"
      CmdForce = NewData And &HF
      CmdGroup = NewData And &HF0
      Debug.Print Hex(NewData) 'CmdGroup, CmdForce

      Select Case CmdGroup
        Case &H0
          ' play sequences
          Exit Function
        Case &H10
          ' centering (10-17)
          TempData = &H30 + CmdForce
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &H20
          ' friction/clutch
          TempData = NewData
        Case &H30
          ' vibrate
          Exit Function
          TempData = &H40 + CmdForce
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &H40
          ' uncentering
          TempData = CmdGroup + CmdForce
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &H50
          ' roll right (50-57)
          TempData = &H60 + CmdForce
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &H60
          ' roll left (60-67)
          TempData = &H50 + CmdForce
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &H70
          ' set force strength (70-75)
          Exit Function
        Case &H80
          '80 test motor off
          '81 test roll Left
          '82 test roll Right
          '83 test clutch on
          '84 test clutch off
          '85 set center steer
          '86 set center cabinet
          '87 test lamps
          Exit Function

        Case &H90
          ' ?
          Exit Function

        Case &HA0
          ' ?
          Exit Function

        Case &HB0
          ' Cabinet Type? (80 = dlx, 81 = twin)
          Exit Function

        Case &HC0
          ' Game State
          TempData = &H0 + CmdForce
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & LeadZero(Hex(TempData), 2)

        Case &HD0
          ' Page Select
          TempData = &H80 + CmdForce
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)

        Case &HE0
          ' ?
          Exit Function

        Case &HF0
          ' ?
          Exit Function

        Case Else
          TempData = NewData
      End Select

      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M2 = True
      End If
      Exit Function
  Case Else
    Debug.Print Profile, Hex(NewData)

  End Select

  If OldData <> NewData Then
    OldData = NewData
    TranslateDrive_M2 = True
  End If
End Function

Private Function TranslateDrive_M3(ByRef OldData As Byte, ByVal NewData As Byte) As Boolean
  Dim TempData As Byte
  TranslateDrive_M3 = False

  Dim CmdGroup As Byte
  Dim CmdForce As Byte
  Dim TmpForce As Byte

  Select Case Profile
    Case "orunners", "outrun"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      
      Select Case CmdGroup
        Case &H0
          ' game mode
          TempData = &HC0 + CmdForce
        Case &H30
          ' center
          TempData = &H10
        Case &H50
          ' left
          TempData = &H60 + CmdForce
        Case &H60
          ' right
          TempData = &H50 + CmdForce
      End Select
      
      If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M3 = True
      End If
      Exit Function
    Case "vr", "vformula"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce

      Select Case CmdGroup
        ' halve the force of any movements
        Case &H30
          TempData = &H10 + (CmdForce \ 2)
        Case &H50
          TempData = &H60 + (CmdForce \ 2)
        Case &H60
          TempData = &H50 + (CmdForce \ 2)
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &H0
          TempData = &HC0 + CmdForce
        Case &H10
          TempData = &H10 + CmdForce
        Case &H20, &H40, &H70, &H90
          '0x7x airbags(VR)
          '0x7x cylinder(VF)
          '0x9x  taco meter (VF)
          Exit Function
        Case Else
          Debug.Print "vr", Hex(NewData)
          Exit Function
      End Select

      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M3 = True
      End If
      Exit Function

    Case "daytona", "indy500", "stcc"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      Select Case CmdGroup
        Case &H0
          ' game mode
          TempData = &HC0 + CmdForce
          If CmdForce = &HA Then TempData = &HC7
        Case &H10
          ' spring
          TempData = &H14
        Case &H20, &H40
          ' clutch
          ' uncenter
          ' seems to be force power on daytona2
          Exit Function
        Case &H30
          ' center
          CmdForce = CmdForce Mod 8
          TempData = &H14 + (CmdForce \ 2)
        Case &H50
          ' left
          TempData = &H60 + CmdForce
        Case &H60
          ' right
          TempData = &H50 + CmdForce
        Case &H70, &H80, &H90, &HA0, &HB0, &HC0, &HD0, &HE0, &HF0
          ' 0x7x = "DELUXE CABINET"
          ' 0xCx = CYLINDER
          ' 0xDx = QUICK BREATH
          ' 0xEx = TOWER SIGNAL
          If Profile = "stcc" And NewData = &H98 Then
            TempData = &HC7
          Else
            Exit Function
          End If
        Case Else
          Debug.Print "daytona", Hex(NewData)
      End Select
      If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M3 = True
      End If
      Exit Function
    
    Case "srallyc"
      Select Case NewData
        Case &H0
          ' (auto) center
          TempData = &H10

        Case &H1 To &HF, &H7E
          Exit Function

        Case &H10
          ' game mode
          TempData = &HC7

        Case &H15
          ' center
          TempData = &H17

        Case &H80 To &H9F
          ' turn right
          CmdForce = (NewData - &H80)
          TempData = &H50 + (CmdForce / 4)
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        
        Case &HC0 To &HDF
          ' turn left
          CmdForce = (NewData - &HC0)
          TempData = &H60 + (CmdForce / 4)
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)

        Case Else
          Exit Function
      End Select

      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M3 = True
      End If
      Exit Function

    Case "srally2"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      CmdForce = NewData Mod &H40
      Select Case CmdGroup
        Case &H0, &H10, &H20, &H30
          ' &H00 to &H3F - left
          ' sr2 to d2/scud
          TmpForce = CmdForce / 8
          If TmpForce = 0 Then
            TempData = &H10
          Else
            TempData = &H60 + TmpForce
          End If
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &H40, &H50, &H60, &H70
          ' &H40 to &H7f - right
          ' sr2 to d2/scud
          TmpForce = CmdForce / 8
          If TmpForce = 0 Then
            TempData = &H10
          Else
            TempData = &H50 + TmpForce
          End If
          If TranslationDebug Then OnText "DriveTranslation", "Debug", Hex(NewData) & " > " & Hex(TempData)
        Case &HC0
          TempData = NewData
        
        Case Else
          Exit Function
        
      End Select
            
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M3 = True
      End If
      Exit Function
  End Select

  If OldData <> NewData Then
    OldData = NewData
    TranslateDrive_M3 = True
  End If
End Function
