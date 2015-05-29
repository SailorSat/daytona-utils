Attribute VB_Name = "ProcessMemory"
Option Explicit

Private mHandle As Long

Public pRAMBASE As Long
Public pRAM2BASE As Long
Public pBACKUPBASE As Long


Public Function OpenMemory() As Boolean
  ' check if we got handle
  If mHandle = -1 Then
    ' no handle, try to open process
    OpenMemory = OpenProcessMemory
  Else
    ' got handle, check if valid
    Dim Result As Long
    Dim Buffer As Byte
    Result = ReadProcessMemory(mHandle, pRAMBASE, Buffer, 1, 0)
    If Result = 0 Then
      CloseProcess
      OpenMemory = False
    Else
      OpenMemory = True
    End If
  End If
End Function


Public Sub CloseMemory()
  CloseProcess
End Sub


Private Function OpenProcessMemory() As Boolean
  Dim Process As Long
  Dim Handle As Long
  Dim Module As Long
  
  OpenProcessMemory = False
  
  Process = GetProcessByFilename("EMULATOR.EXE", 0)
  If Process = -1 Then
    Process = GetProcessByFilename("emulator_multicpu.exe", 0)
    If Process = -1 Then
      Exit Function
    End If
  End If
  
  Handle = OpenProcessID(Process)
  If Handle = -1 Then
    Exit Function
  End If
  
  Dim EmulatorEXE As Long
  EmulatorEXE = GetModuleByFilename("EMULATOR.EXE", Process)
  If EmulatorEXE = -1 Then
    EmulatorEXE = GetModuleByFilename("emulator_multicpu.exe", Process)
    If EmulatorEXE = -1 Then
      CloseProcess
      Exit Function
    End If
  End If
  
  Dim Offset1 As Long
  Offset1 = ReadLong(EmulatorEXE + &H1AA888)
  pRAMBASE = ReadLong(Offset1 + &H100&)
  If pRAMBASE = 0 Then
    CloseProcess
    Exit Function
  End If
  
  pRAM2BASE = ReadLong(Offset1 + &H108&)
  If pRAM2BASE = 0 Then
    CloseProcess
    Exit Function
  End If
  
  pBACKUPBASE = ReadLong(Offset1 + &H118&)
  If pBACKUPBASE = 0 Then
    CloseProcess
    Exit Function
  End If
  
  OpenProcessMemory = True
End Function


Private Function GetProcessByFilename(Filename As String, Index As Long) As Long
  Dim Result As Long
  Dim Snapshot As Long
  Dim Process As PROCESSENTRY32
  Dim Binary As String
  Dim Count As Integer
 
  Snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0&)
  If Snapshot = -1 Then
    GetProcessByFilename = -1
    Exit Function
  End If

  Process.dwSize = Len(Process)
  Result = Process32First(Snapshot, Process)
  While Result <> 0
    Binary = Left(Process.szExeFile, InStr(1, Process.szExeFile, Chr(0), vbBinaryCompare) - 1)
    If Binary = Filename Then
      If Count = Index Then
        GetProcessByFilename = Process.th32ProcessID
        CloseHandle Snapshot
        Exit Function
      Else
        Count = Count + 1
      End If
    End If
    Result = Process32Next(Snapshot, Process)
  Wend
  GetProcessByFilename = -1
  CloseHandle Snapshot
End Function


Private Function GetModuleByFilename(Filename As String, Process As Long) As Long
  Dim Result As Long
  Dim Snapshot As Long
  Dim Module As MODULEENTRY32
  Dim Binary As String
  
  Snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, Process)
  If Snapshot = -1 Then
    GetModuleByFilename = -1
    Exit Function
  End If

  Module.dwSize = Len(Module)
  Result = Module32First(Snapshot, Module)
  While Result <> 0
    Binary = Left(Module.szModule, InStr(1, Module.szModule, Chr(0), vbBinaryCompare) - 1)
    If Binary = Filename Then
      GetModuleByFilename = Module.modBaseAddr
      CloseHandle Snapshot
      Exit Function
    End If
    Result = Module32Next(Snapshot, Module)
  Wend
  GetModuleByFilename = -1
  CloseHandle Snapshot
End Function


Private Function OpenProcessID(Process As Long) As Long
  Dim Result As Long
  Result = OpenProcess(PROCESS_ALL_ACCESS, 0, Process)
  If Result = 0 Then
    OpenProcessID = -1
  Else
    OpenProcessID = Result
  End If
  mHandle = OpenProcessID
End Function


Private Function CloseProcess() As Long
  Dim Result As Long
  Result = CloseHandle(mHandle)
  CloseProcess = -1
  mHandle = CloseProcess
End Function


Public Function ReadSingle(Address As Long) As Single
  Dim Result As Long
  Dim Buffer As Single
  Result = ReadProcessMemory(mHandle, Address, Buffer, 4, 0)
  ReadSingle = Buffer
End Function


Public Function ReadLong(Address As Long) As Long
  Dim Result As Long
  Dim Buffer As Long
  Result = ReadProcessMemory(mHandle, Address, Buffer, 4, 0)
  ReadLong = Buffer
End Function


Public Function ReadInteger(Address As Long) As Integer
  Dim Result As Long
  Dim Buffer As Integer
  Result = ReadProcessMemory(mHandle, Address, Buffer, 2, 0)
  ReadInteger = Buffer
End Function


Public Function ReadByte(Address As Long) As Byte
  Dim Result As Long
  Dim Buffer As Byte
  Result = ReadProcessMemory(mHandle, Address, Buffer, 1, 0)
  ReadByte = Buffer
End Function


Public Function ReadString(Address As Long, Length As Byte) As String
  Dim Result As Long
  Dim Buffer() As Byte
  ReDim Buffer(Length)
  Result = ReadProcessMemory(mHandle, Address, Buffer(0), Length, 0)
  ReadString = Buffer
  If InStr(1, ReadString, Chr(0)) Then ReadString = Left(ReadString, InStr(1, ReadString, Chr(0), vbBinaryCompare) - 1)
End Function


Public Sub WriteSingle(Address As Long, Data As Single)
  Dim Result As Long
  Dim Buffer As Single
  Buffer = Data
  Result = WriteProcessMemory(mHandle, Address, Buffer, 4, 0)
End Sub


Public Sub WriteLong(Address As Long, Data As Long)
  Dim Result As Long
  Dim Buffer As Long
  Buffer = Data
  Result = WriteProcessMemory(mHandle, Address, Buffer, 4, 0)
End Sub


Public Sub WriteInteger(Address As Long, Data As Integer)
  Dim Result As Long
  Dim Buffer As Integer
  Buffer = Data
  Result = WriteProcessMemory(mHandle, Address, Buffer, 2, 0)
End Sub


Public Sub WriteByte(Address As Long, Data As Byte)
  Dim Result As Long
  Dim Buffer As Byte
  Buffer = Data
  Result = WriteProcessMemory(mHandle, Address, Buffer, 1, 0)
End Sub
