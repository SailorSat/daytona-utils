Attribute VB_Name = "ProcessMemory64"
Option Explicit

Private mProcessHandle As Long

Public Function GetModuleByFilename64(Filename As String, hProcess As Long, ByRef BaseAddress As LARGE_INTEGER) As Long
  Dim tPBI        As PROCESS_BASIC_INFORMATION64
  Dim tPeb        As PEB64
  Dim lStatus     As Long
  Dim hPID        As Long
  Dim liRet       As LARGE_INTEGER
  
  If mProcessHandle <> hProcess Then
    GetModuleByFilename64 = -1
    Exit Function
  End If
  
  lStatus = NtWow64QueryInformationProcess64(hProcess, ProcessBasicInformation, tPBI, Len(tPBI), 0)
  If lStatus < 0 Then
    GetModuleByFilename64 = -1
    Exit Function
  End If
  
  lStatus = NtWow64ReadVirtualMemory64(hProcess, tPBI.PebBaseAddress.lowpart, tPBI.PebBaseAddress.highpart, tPeb, Len(tPeb), 0, liRet)
  If lStatus < 0 Then
    GetModuleByFilename64 = -1
    Exit Function
  End If

  'LoaderData
  Dim tPEB_LDR_DATA64 As PEB_LDR_DATA64
  lStatus = NtWow64ReadVirtualMemory64(hProcess, tPeb.LoaderData.lowpart, tPeb.LoaderData.highpart, tPEB_LDR_DATA64, Len(tPEB_LDR_DATA64), 0, liRet)
  If lStatus < 0 Then
    GetModuleByFilename64 = -1
    Exit Function
  End If

  Dim tLDR_DATA_TABLE_ENTRY64 As LDR_DATA_TABLE_ENTRY64
  Dim liAddress As LARGE_INTEGER, counter As Long
  Dim Buffer() As Byte, bLength As Long, BaseDllName As String
  Dim supermodel_offset As LARGE_INTEGER
  
  liAddress = tPEB_LDR_DATA64.InLoadOrderModuleList.Flink
  counter = 1
  Do
    lStatus = NtWow64ReadVirtualMemory64(hProcess, liAddress.lowpart, liAddress.highpart, tLDR_DATA_TABLE_ENTRY64, LenB(tLDR_DATA_TABLE_ENTRY64), 0, liRet)
    If lStatus < 0 Then
      GetModuleByFilename64 = -1
      Exit Function
    End If
    
    If tLDR_DATA_TABLE_ENTRY64.BaseAddress.highpart = 0 And tLDR_DATA_TABLE_ENTRY64.BaseAddress.lowpart = 0 Then Exit Do
    
    bLength = tLDR_DATA_TABLE_ENTRY64.BaseDllName.MaxLength
    ReDim Buffer(bLength)
    
    lStatus = NtWow64ReadVirtualMemory64(hProcess, tLDR_DATA_TABLE_ENTRY64.BaseDllName.lpBuffer.lowpart, tLDR_DATA_TABLE_ENTRY64.BaseDllName.lpBuffer.highpart, Buffer(0), bLength, 0, liRet)
    If lStatus < 0 Then
      GetModuleByFilename64 = -1
      Exit Function
    End If
    
    BaseDllName = Left(Buffer, tLDR_DATA_TABLE_ENTRY64.BaseDllName.length / 2)
    If BaseDllName = Filename Then
      BaseAddress = tLDR_DATA_TABLE_ENTRY64.BaseAddress
      GetModuleByFilename64 = counter
      Exit Function
    End If
    liAddress = tLDR_DATA_TABLE_ENTRY64.InLoadOrderModuleList.Flink
    counter = counter + 1
    DoEvents
  Loop

  ' not found
  GetModuleByFilename64 = -1
  Exit Function
End Function


Public Function OpenProcess64(Process As Long) As Long
  Dim Result As Long
  Result = OpenProcess(PROCESS_ALL_ACCESS, 0, Process)
  If Result = 0 Then
    OpenProcess64 = -1
  Else
    OpenProcess64 = Result
  End If
  mProcessHandle = OpenProcess64
End Function


Public Function CloseProcess64() As Long
  If mProcessHandle <> -1 Then
    CloseHandle mProcessHandle
    mProcessHandle = -1
    CloseProcess64 = mProcessHandle
  End If
End Function


Public Function ReadSingle64(Address As LARGE_INTEGER) As Single
  Dim liRet As LARGE_INTEGER
  Dim Result As Long
  Dim Buffer As Single
  Result = NtWow64ReadVirtualMemory64(mProcessHandle, Address.lowpart, Address.highpart, Buffer, 4, 0, liRet)
  ReadSingle64 = Buffer
End Function


Public Function ReadLong64(Address As LARGE_INTEGER) As Long
  Dim liRet As LARGE_INTEGER
  Dim Result As Long
  Dim Buffer As Long
  Result = NtWow64ReadVirtualMemory64(mProcessHandle, Address.lowpart, Address.highpart, Buffer, 4, 0, liRet)
  ReadLong64 = Buffer
End Function


Public Function ReadInteger64(Address As LARGE_INTEGER) As Integer
  Dim liRet As LARGE_INTEGER
  Dim Result As Long
  Dim Buffer As Integer
  Result = NtWow64ReadVirtualMemory64(mProcessHandle, Address.lowpart, Address.highpart, Buffer, 2, 0, liRet)
  ReadInteger64 = Buffer
End Function


Public Function ReadByte64(Address As LARGE_INTEGER) As Byte
  Dim liRet As LARGE_INTEGER
  Dim Result As Long
  Dim Buffer As Byte
  Result = NtWow64ReadVirtualMemory64(mProcessHandle, Address.lowpart, Address.highpart, Buffer, 1, 0, liRet)
  ReadByte64 = Buffer
End Function


Public Function ReadString64(Address As LARGE_INTEGER, length As Byte) As String
  Dim liRet As LARGE_INTEGER
  Dim Result As Long
  Dim Buffer() As Byte
  ReDim Buffer(length)
  Result = NtWow64ReadVirtualMemory64(mProcessHandle, Address.lowpart, Address.highpart, Buffer(0), length, 0, liRet)
  ReadString64 = Buffer
  If InStr(1, ReadString64, Chr(0)) Then ReadString64 = Left$(ReadString64, InStr(1, ReadString64, Chr(0), vbBinaryCompare) - 1)
End Function


Public Sub WriteSingle64(Address As LARGE_INTEGER, Data As Single)
  Dim liRet As LARGE_INTEGER
  Dim Result As Long
  Dim Buffer As Single
  Buffer = Data
  Result = NtWow64WriteVirtualMemory64(mProcessHandle, Address.lowpart, Address.highpart, Buffer, 4, 0, liRet)
End Sub


Public Sub WriteLong64(Address As LARGE_INTEGER, Data As Long)
  Dim liRet As LARGE_INTEGER
  Dim Result As Long
  Dim Buffer As Long
  Buffer = Data
  Result = NtWow64WriteVirtualMemory64(mProcessHandle, Address.lowpart, Address.highpart, Buffer, 4, 0, liRet)
End Sub


Public Sub WriteInteger64(Address As LARGE_INTEGER, Data As Integer)
  Dim liRet As LARGE_INTEGER
  Dim Result As Long
  Dim Buffer As Integer
  Buffer = Data
  Result = NtWow64WriteVirtualMemory64(mProcessHandle, Address.lowpart, Address.highpart, Buffer, 2, 0, liRet)
End Sub


Public Sub WriteByte64(Address As LARGE_INTEGER, Data As Byte)
  Dim liRet As LARGE_INTEGER
  Dim Result As Long
  Dim Buffer As Byte
  Buffer = Data
  Result = NtWow64WriteVirtualMemory64(mProcessHandle, Address.lowpart, Address.highpart, Buffer, 1, 0, liRet)
End Sub

