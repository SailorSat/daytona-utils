Attribute VB_Name = "DriveTranslation"
Option Explicit

' internal profile
Public Profile As String

' optional model3 and debug modes
Public Model3Mode As Boolean
Public DebugMode As Boolean

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
    Case "orunners"
      If OldData <> NewData Then
        OldData = NewData
        TranslateDrive_M2 = True
      End If
    Case "outrun"
      Select Case NewData
        Case &H1 To &H7
          TempData = &H68 - (NewData And &H7)
        Case &H9 To &HF
          TempData = &H50 + (NewData And &H7)
        Case &H0, &H8
          TempData = &H10
        Case Else
          Exit Function
      End Select
      Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M2 = True
      End If
      Exit Function
    Case "vr", "vformula"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce

      Select Case CmdGroup
        ' halve the force of any movements
        Case &H20, &H30, &H40, &H50, &H60
          TempData = CmdGroup + (CmdForce \ 2)
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
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
          Debug.Print Hex(NewData)
      End Select

      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M2 = True
      End If
      Exit Function

    Case "daytona"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce
      Select Case CmdGroup
        Case &H0, &H10, &H20, &H30, &H40, &H50, &H60, &H80
          TempData = NewData
        Case &H70, &HC0, &HD0, &HE0
          ' 0x7x = "DELUXE CABINET"
          ' 0xCx = CYLINDER
          ' 0xDx = QUICK BREATH
          ' 0xEx = TOWER SIGNAL
          Debug.Print Hex(NewData)
          Exit Function
        Case &H90, &HA0, &HB0
          Exit Function
        Case Else
          Debug.Print Hex(NewData)
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
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &HC0 To &HDF
          ' turn left
          CmdForce = (NewData - &HC0)
          TempData = &H50 + (CmdForce / 4)
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)

        Case Else
          TempData = NewData
          Debug.Print Hex(NewData)
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
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H40, &H50, &H60, &H70
          ' &H40 to &H7f - right
          CmdForce = (NewData - &H40)
          If CmdForce = 0 Then
            TempData = &H10
          Else
            TempData = &H60 + (CmdForce / 8)
          End If
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &HC0
          TempData = &H0 + CmdForce
          Window.lblDebug.Caption = Hex(NewData) & " > " & LeadZero(Hex(TempData), 2)
        
        Case Else
          Exit Function
        
      End Select
      
      If OldData <> TempData Then
        OldData = TempData
        TranslateDrive_M2 = True
      End If
      Exit Function
      
    Case "daytona2", "dayto2pe", "scud", "scuda", "lemans24"
      CmdForce = NewData Mod &H10
      CmdGroup = NewData - CmdForce

      Select Case CmdGroup
        Case &H0
          ' play sequences
          Exit Function
        Case &H10
          ' centering
          TempData = &H30 + CmdForce
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H20
          ' friction/clutch
          TempData = NewData
        Case &H30
          ' vibrate
          Exit Function
          TempData = &H40 + CmdForce
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H40
          ' uncentering
          TempData = CmdGroup + CmdForce
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H50
          ' roll right
          TempData = &H60 + CmdForce
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H60
          ' roll left
          TempData = &H50 + CmdForce
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H70
          ' set force strength
          Exit Function
        Case &H80
          '80 motor off
          '81 roll Left
          '82 roll Right
          '83 clutch on
          '84 clutch off
          '85 center
          '86 ?
          '87 ?
          Exit Function

        Case &H90
          ' ?
          Exit Function

        Case &HA0
          ' ?
          Exit Function

        Case &HB0
          ' ?
          Exit Function

        Case &HC0
          ' Game State
          TempData = &H0 + CmdForce
          Window.lblDebug.Caption = Hex(NewData) & " > " & LeadZero(Hex(TempData), 2)

        Case &HD0
          ' Page Select
          TempData = &H80 + CmdForce
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)

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

  Select Case Profile
    Case "outrun"
      Select Case NewData
        Case &H1 To &H7
          TempData = &H58 - (NewData And &H7)
        Case &H9 To &HF
          TempData = &H60 + (NewData And &H7)
        Case &H0, &H8
          TempData = &H10
        Case Else
          Exit Function
      End Select
      Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
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
        Case &H20, &H30, &H40, &H50, &H60
          TempData = CmdGroup + (CmdForce \ 2)
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
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
          Debug.Print Hex(NewData)
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
          TempData = NewData
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
          Debug.Print Hex(NewData)
      End Select
      Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
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
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        
        Case &HC0 To &HDF
          ' turn left
          CmdForce = (NewData - &HC0)
          TempData = &H60 + (CmdForce / 4)
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)

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
      Select Case CmdGroup
        Case &H0, &H10, &H20, &H30
          ' &H00 to &H3F - left
          CmdForce = NewData
          If CmdForce = 0 Then
            TempData = &H10
          Else
            TempData = &H60 + (CmdForce / 8)
          End If
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &H40, &H50, &H60, &H70
          ' &H40 to &H7f - right
          CmdForce = (NewData - &H40)
          If CmdForce = 0 Then
            TempData = &H10
          Else
            TempData = &H50 + (CmdForce / 8)
          End If
          Window.lblDebug.Caption = Hex(NewData) & " > " & Hex(TempData)
        Case &HC0
          TempData = &HC0 + CmdForce
          Window.lblDebug.Caption = Hex(NewData) & " > " & LeadZero(Hex(TempData), 2)
        
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
    Debug.Print Hex(NewData)
    TranslateDrive_M3 = True
  End If
End Function
