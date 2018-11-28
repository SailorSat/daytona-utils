Attribute VB_Name = "ProcessMemory"
Option Explicit

Private mProcessHandle As Long

Public Function GetProcessByFilename(Filename As String, Index As Long) As Long
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
    Binary = Left$(Process.szExeFile, InStr(1, Process.szExeFile, Chr(0), vbBinaryCompare) - 1)
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


Public Function GetModuleByFilename(Filename As String, Process As Long) As Long
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
    Binary = Left$(Module.szModule, InStr(1, Module.szModule, Chr(0), vbBinaryCompare) - 1)
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


Public Function OpenProcessID(Process As Long) As Long
  Dim Result As Long
  Result = OpenProcess(PROCESS_ALL_ACCESS, 0, Process)
  If Result = 0 Then
    OpenProcessID = -1
  Else
    OpenProcessID = Result
  End If
  mProcessHandle = OpenProcessID
End Function


Public Function CloseProcess() As Long
  If mProcessHandle <> -1 Then
    CloseHandle mProcessHandle
    mProcessHandle = -1
    CloseProcess = mProcessHandle
  End If
End Function


Public Function ReadSingle(Address As Long) As Single
  Dim Result As Long
  Dim Buffer As Single
  Result = ReadProcessMemory(mProcessHandle, Address, Buffer, 4, 0)
  ReadSingle = Buffer
End Function


Public Function ReadLong(Address As Long) As Long
  Dim Result As Long
  Dim Buffer As Long
  Result = ReadProcessMemory(mProcessHandle, Address, Buffer, 4, 0)
  ReadLong = Buffer
End Function


Public Function ReadInteger(Address As Long) As Integer
  Dim Result As Long
  Dim Buffer As Integer
  Result = ReadProcessMemory(mProcessHandle, Address, Buffer, 2, 0)
  ReadInteger = Buffer
End Function


Public Function ReadByte(Address As Long) As Byte
  Dim Result As Long
  Dim Buffer As Byte
  Result = ReadProcessMemory(mProcessHandle, Address, Buffer, 1, 0)
  ReadByte = Buffer
End Function


Public Function ReadString(Address As Long, Length As Byte) As String
  Dim Result As Long
  Dim Buffer() As Byte
  ReDim Buffer(Length)
  Result = ReadProcessMemory(mProcessHandle, Address, Buffer(0), Length, 0)
  ReadString = Buffer
  If InStr(1, ReadString, Chr(0)) Then ReadString = Left$(ReadString, InStr(1, ReadString, Chr(0), vbBinaryCompare) - 1)
End Function


Public Sub WriteSingle(Address As Long, Data As Single)
  Dim Result As Long
  Dim Buffer As Single
  Buffer = Data
  Result = WriteProcessMemory(mProcessHandle, Address, Buffer, 4, 0)
End Sub


Public Sub WriteLong(Address As Long, Data As Long)
  Dim Result As Long
  Dim Buffer As Long
  Buffer = Data
  Result = WriteProcessMemory(mProcessHandle, Address, Buffer, 4, 0)
End Sub


Public Sub WriteInteger(Address As Long, Data As Integer)
  Dim Result As Long
  Dim Buffer As Integer
  Buffer = Data
  Result = WriteProcessMemory(mProcessHandle, Address, Buffer, 2, 0)
End Sub


Public Sub WriteByte(Address As Long, Data As Byte)
  Dim Result As Long
  Dim Buffer As Byte
  Buffer = Data
  Result = WriteProcessMemory(mProcessHandle, Address, Buffer, 1, 0)
End Sub
