Attribute VB_Name = "DosBox"
Option Explicit

Private Handle As Long

Private DOSBOX_EXE As Long

Public Function DosBox_Online() As Boolean
  ' check if we got handle
  If Handle = -1 Then
    ' no handle, try to open process
    DosBox_Online = OpenProcessDosBox
  Else
    ' got handle, check if valid
    Dim Result As Long
    Dim Buffer As Byte
    Result = ReadProcessMemory(Handle, DOSBOX_EXE, Buffer, 1, 0)
    If Result = 0 Then
      CloseProcess
      Handle = -1
      DosBox_Online = False
    Else
      DosBox_Online = True
    End If
  End If
End Function

Private Function OpenProcessDosBox() As Boolean
  Dim Process As Long
  
  OpenProcessDosBox = False
  
  Process = GetProcessByFilename("dosbox.exe", 0)
  If Process = -1 Then
    Exit Function
  End If
 
  Handle = OpenProcessID(Process)
  If Handle = -1 Then
    Exit Function
  End If
 
  DOSBOX_EXE = GetModuleByFilename("DOSBox.EXE", Process)
  If DOSBOX_EXE = -1 Then
    CloseProcess
    Exit Function
  End If
  
  OpenProcessDosBox = True
End Function
