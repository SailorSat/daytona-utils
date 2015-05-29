Attribute VB_Name = "SerialPort"
Option Explicit

Public SerialReadBuffer(0 To 9) As Byte
Private SerialOffset As Byte

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
    .WriteTotalTimeoutConstant = 10
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

Public Function ReadSerialString() As String
  Dim bBuffer(0 To 31) As Byte
  Dim sBuffer As String
  Dim Result As Long
  Dim Length As Long
  Result = ReadFile(mHandle, bBuffer(0), UBound(bBuffer) + 1, Length, 0)
  sBuffer = StrConv(bBuffer, vbUnicode)
  ReadSerialString = Left$(sBuffer, Length)
End Function

Public Function ReadSerialByte() As Byte
  Dim bBuffer As Byte
  Dim bLength As Long
  Dim Result As Long
  bLength = 1
  Result = ReadFile(mHandle, bBuffer, bLength, 0, 0)
  ReadSerialByte = bBuffer
End Function

Public Function ReadSerialBuffer() As Boolean
  Dim Result As Long
  Dim bLength As Long
  Dim bRead As Long
  bLength = 9 - SerialOffset
  bRead = 0
  Result = ReadFile(mHandle, SerialReadBuffer(SerialOffset), bLength, bRead, 0)
  SerialOffset = SerialOffset + bRead
  If SerialOffset = 9 Then
    If SerialReadBuffer(8) = &HA5 Then
      SerialOffset = 0
      ReadSerialBuffer = True
    Else
      SerialOffset = 8
      Debug.Print "desync...", Hex(SerialReadBuffer(8))
    End If
  Else
    ReadSerialBuffer = False
  End If
End Function

Public Sub WriteSerialString(sBuffer As String)
  Dim bBuffer() As Byte
  Dim Result As Long
  bBuffer = StrConv(sBuffer, vbFromUnicode)
  Result = WriteFile(mHandle, bBuffer(0), UBound(bBuffer) + 1, 0, 0)
End Sub

Public Sub WriteSerialByte(bData As Byte)
  Dim Result As Long
  Dim bBuffer As Byte
  Dim bLength As Long
  bBuffer = bData
  bLength = 1
  Result = WriteFile(mHandle, bData, bLength, 0, 0)
End Sub

