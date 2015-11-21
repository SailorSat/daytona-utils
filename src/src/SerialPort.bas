Attribute VB_Name = "SerialPort"
Option Explicit

Public SerialReadBuffer(0 To 255) As Byte
Private SerialReadOffset As Long

Private mHandle As Long

Public Function OpenSerial(Port As String, settings As String) As Boolean
  OpenSerial = False

  ' open file handle
  mHandle = CreateFileA(Port, GENERIC_READ Or GENERIC_WRITE, 0, 0&, &H3, 0, 0)
  If mHandle = -1 Then
      Exit Function
  End If
  
  Dim Result As Long
  Dim timeout As COMMTIMEOUTS
  
  ' define timeouts
  With timeout
    .ReadIntervalTimeout = 20
    .ReadTotalTimeoutConstant = 1
    .ReadTotalTimeoutMultiplier = 1
    .WriteTotalTimeoutConstant = 20
    .WriteTotalTimeoutMultiplier = 1
  End With
  
  ' set timeouts
  Result = SetCommTimeouts(mHandle, timeout)
  If Result = -1 Then
    CloseSerial
    Exit Function
  End If
  
  ' parse settings
  Dim config As DCB
  Result = BuildCommDCBA(settings, config)
  If Result = -1 Then
    CloseSerial
    Exit Function
  End If
  
  ' force DTR signal on (resets arduino)
  config.fDtrControl = &H1&

  ' apply settings
  Result = SetCommState(mHandle, config)
  If Result = -1 Then
    CloseSerial
    Exit Function
  End If
  
  OpenSerial = True
End Function

Public Function CloseSerial() As Long
  Dim Result As Long
  Result = CloseHandle(mHandle)
  CloseSerial = -1
  mHandle = CloseSerial
End Function

Public Sub FlushSerial()
  FlushFileBuffers mHandle
End Sub

Public Function ReadSerialByte() As Byte
  Dim bBuffer As Byte
  Dim lLength As Long
  Dim lResult As Long
  Dim lProcessed As Long
  lLength = 1&
  lResult = ReadFile(mHandle, bBuffer, lLength, lProcessed, 0)
  ReadSerialByte = bBuffer
  'Debug.Print "read", "byte", lResult, lProcessed, Err.LastDllError
End Function

Public Function ReadSerialBuffer() As Boolean
  Dim lLength As Long
  Dim lResult As Long
  Dim lProcessed As Long
  lLength = 11& - SerialReadOffset
  lResult = ReadFile(mHandle, SerialReadBuffer(SerialReadOffset), lLength, lProcessed, 0)
  SerialReadOffset = SerialReadOffset + lProcessed
  If SerialReadOffset = 11 Then
    SerialReadOffset = 0
    ReadSerialBuffer = True
  Else
    ReadSerialBuffer = False
  End If
  'Debug.Print "read", "buffer", lResult, lProcessed
End Function

Public Sub WriteSerialByte(bData As Byte)
  Dim bBuffer As Byte
  Dim lResult As Long
  Dim lLength As Long
  Dim lProcessed As Long
  bBuffer = bData
  lLength = 1&
  lResult = WriteFile(mHandle, bBuffer, lLength, lProcessed, 0)
  'Debug.Print "write", "byte", lResult, lProcessed, Err.LastDllError
End Sub

Public Sub WriteSerialInteger(iData As Long)
  Dim lBuffer As Long
  Dim lResult As Long
  Dim lLength As Long
  Dim lProcessed As Long
  lBuffer = iData
  lLength = 2&
  lResult = WriteFile(mHandle, lBuffer, lLength, lProcessed, 0)
  If lResult = 0 Then Stop
  'Debug.Print "write", "integer", lResult, lProcessed, Err.LastDllError, Hex(iData)
End Sub

Public Sub WriteSerialInteger1(iData As Long)
  Dim lBuffer As Long
  Dim lResult As Long
  Dim lLength As Long
  Dim lProcessed As Long
  lBuffer = iData
  lLength = 2&
  lResult = WriteFile(mHandle, lBuffer, lLength, lProcessed, 0)
  If lResult = 0 Then Stop
  'Debug.Print "write", "integer", lResult, lProcessed, Err.LastDllError, Hex(iData)
End Sub

Public Sub WriteSerialInteger2(iData As Long)
  Dim lBuffer As Long
  Dim lResult As Long
  Dim lLength As Long
  Dim lProcessed As Long
  lBuffer = iData
  lLength = 2&
  lResult = WriteFile(mHandle, lBuffer, lLength, lProcessed, 0)
  If lResult = 0 Then Stop
  'Debug.Print "write", "integer", lResult, lProcessed, Err.LastDllError, Hex(iData)
End Sub

