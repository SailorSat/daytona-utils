Attribute VB_Name = "API"
Option Explicit

Private Const ProcessBasicInformation As Long = 0

Private Type LARGE_INTEGER
    lowpart                         As Long
    highpart                        As Long
End Type

Public Type LIST_ENTRY64
    Flink                           As LARGE_INTEGER
    Blink                           As LARGE_INTEGER
End Type

Private Type UNICODE_STRING64
    length                          As Integer
    MaxLength                       As Integer
    lPad                            As Long
    lpBuffer                        As LARGE_INTEGER
End Type

Private Type PROCESS_BASIC_INFORMATION64
    ExitStatus                      As Long
    Reserved0                       As Long
    PebBaseAddress                  As LARGE_INTEGER
    AffinityMask                    As LARGE_INTEGER
    BasePriority                    As Long
    Reserved1                       As Long
    uUniqueProcessId                As LARGE_INTEGER
    uInheritedFromUniqueProcessId   As LARGE_INTEGER
End Type

Public Type PEB64
    InheritedAddressSpace           As Byte
    ReadImageFileExecOptions        As Byte
    BeingDebugged                   As Byte
    Spare                           As Byte
    lPad01                          As Long
    Mutant                          As LARGE_INTEGER
    ImageBaseAddress                As LARGE_INTEGER
    LoaderData                      As LARGE_INTEGER
    ProcessParameters               As LARGE_INTEGER
    SubSystemData                   As LARGE_INTEGER
    ProcessHeap                     As LARGE_INTEGER
    FastPebLock                     As LARGE_INTEGER
    AtlThunkSListPtr                As LARGE_INTEGER
    IFEOKey                         As LARGE_INTEGER
    CrossProcessFlags               As Long
    ProcessBits                     As Long
    KernelCallBackTable             As LARGE_INTEGER
    EventLogSection                 As Long
    EventLog                        As Long
    FreeList                        As LARGE_INTEGER
    TlsBitMapSize                   As Long
    lPad02                          As Long
    TlsBitMap                       As LARGE_INTEGER
    TlsBitMapData(1)                As Long
    ReadOnlySharedMemoryBase        As LARGE_INTEGER
    ReadOnlySharedMemoryHeap        As LARGE_INTEGER
    ReadOnlyStaticServerData        As LARGE_INTEGER
    InitAnsiCodePageData            As LARGE_INTEGER
    InitOemCodePageData             As LARGE_INTEGER
    InitUnicodeCaseTableData        As LARGE_INTEGER
    NumberOfProcessors              As Long
    NtGlobalFlag                    As Long
    CriticalSectionTimeout          As LARGE_INTEGER
    HeapSegmentReserve              As LARGE_INTEGER
    HeapSegmentCommit               As LARGE_INTEGER
    HeapDeCommitTotalFreeThreshold  As LARGE_INTEGER
    HeapDeCommitFreeBlockThreshold  As LARGE_INTEGER
    NumberOfHeaps                   As Long
    MaxNumberOfHeaps                As Long
    ProcessHeapsList                As LARGE_INTEGER
    GdiSharedHandleTable            As LARGE_INTEGER
    ProcessStarterHelper            As LARGE_INTEGER
    GdiDCAttributeList              As Long
    lPad03                          As Long
    LoaderLock                      As LARGE_INTEGER
    NtMajorVersion                  As Long
    NtMinorVersion                  As Long
    NtBuildNumber                   As Integer
    NtPlatformId                    As Integer
    PlatformId                      As Long
    ImageSubsystem                  As Long
    ImageMajorSubsystemVersion      As Long
    ImageMinorSubsystemVersion      As Long
    lPad09                          As Long
    AffinityMask                    As LARGE_INTEGER
    GdiHandleBuffer(29)             As LARGE_INTEGER
    PostProcessInitRoutine          As LARGE_INTEGER
    TlsExpansionBitmap              As LARGE_INTEGER
    TlsExpansionBitmapBits(31)      As Long
    SessionId                       As LARGE_INTEGER
    AppCompatFlags                  As LARGE_INTEGER
    AppCompatFlagsUser              As LARGE_INTEGER
    ShimData                        As LARGE_INTEGER
    AppCompatInfo                   As LARGE_INTEGER
    CSDVersion                      As UNICODE_STRING64
    ActivationContextData           As LARGE_INTEGER
    ProcessAssemblyStorageMap       As LARGE_INTEGER
    SystemDefaultActivationData     As LARGE_INTEGER
    SystemAssemblyStorageMap        As LARGE_INTEGER
    MinimumStackCommit              As Long
    lPad05                          As Long
    FlsCallBack                     As LARGE_INTEGER
    FlsListHead                     As LIST_ENTRY64
    FlsBitmap                       As LARGE_INTEGER
    FlsBitmapBits(3)                As Long
    FlsHighIndex                    As Long
    lPad06                          As Long
    WerRegistrationData             As LARGE_INTEGER
    WerShipAssertPtr                As LARGE_INTEGER
End Type

Private Type PEB_LDR_DATA64
    length                          As Long
    Initialized                     As Long
    SsHandle                        As LARGE_INTEGER
    InLoadOrderModuleList           As LIST_ENTRY64
    InMemoryOrderModuleList         As LIST_ENTRY64
    InInitializationOrderModuleList As LIST_ENTRY64
End Type

Private Type LDR_DATA_TABLE_ENTRY64
    InLoadOrderModuleList           As LIST_ENTRY64
    InMemoryOrderModuleList         As LIST_ENTRY64
    InInitializationOrderModuleList As LIST_ENTRY64
    BaseAddress                     As LARGE_INTEGER
    EntryPoint                      As LARGE_INTEGER
    SizeOfImage                     As LARGE_INTEGER
    FullDllName                     As UNICODE_STRING64
    BaseDllName                     As UNICODE_STRING64
    Flags                           As Long
    LoadCount                       As Integer
    TlsIndex                        As Integer
    HashTableEntry                  As LIST_ENTRY64
    TimeDateStamp                   As LARGE_INTEGER
End Type

Type INPUT_
  dwType      As Long
  wVK         As Integer
  wScan       As Integer
  dwFlags     As Long
  dwTime      As Long
  dwExtraInfo As Long
  dwPadding   As Currency
End Type

Private Declare Function NtWow64QueryInformationProcess64 Lib "ntdll" (ByVal hProcess As Long, ByVal ProcessInformationClass As Long, ByRef pProcessInformation As Any, ByVal uProcessInformationLength As Long, ByRef puReturnLength As Long) As Long
Private Declare Function NtWow64ReadVirtualMemory64 Lib "ntdll" (ByVal hProcess As Long, ByVal BaseAddressL As Long, ByVal BaseAddressH As Long, ByRef Buffer As Any, ByVal BufferLengthL As Long, ByVal BufferLengthH As Long, ByRef ReturnLength As LARGE_INTEGER) As Long
Private Declare Function NtWow64WriteVirtualMemory64 Lib "ntdll" (ByVal hProcess As Long, ByVal BaseAddressL As Long, ByVal BaseAddressH As Long, ByRef Buffer As Any, ByVal BufferLengthL As Long, ByVal BufferLengthH As Long, ByRef OutputLength As LARGE_INTEGER) As Long
Private Declare Function OpenProcess Lib "kernel32.dll" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Const PROCESS_ALL_ACCESS = &H1F0FFF
Public Declare Function CloseHandle Lib "kernel32.dll" (ByVal hObject As Long) As Long
Public Declare Sub RtlMoveMemory Lib "kernel32.dll" (Destination As Any, Source As Any, ByVal length As Long)
Public Declare Sub Sleep Lib "kernel32.dll" (ByVal dwMilliseconds As Long)
Declare Function SendInput Lib "user32" (ByVal nInputs As Long, ByRef pInputs As Any, ByVal cbSize As Long) As Long


Declare Function FindWindowA Lib "user32.dll" _
  ( _
  ByVal lpClassName As String, _
  ByVal lpWindowName As String) As Long
Declare Function GetClassNameA Lib "user32.dll" _
  ( _
  ByVal hwnd As Long, _
  ByVal lpClassName As String, _
  ByVal nMaxCount As Long) As Long
Declare Function GetWindowThreadProcessId Lib "user32.dll" ( _
  ByVal hwnd As Long, _
  lpdwProcessId As Long) As Long
  
  
Sub Magic()
  Dim tPBI        As PROCESS_BASIC_INFORMATION64
  Dim tPeb        As PEB64
  Dim lStatus     As Long
  Dim hPID        As Long
  Dim hProcess    As Long
  Dim liRet       As LARGE_INTEGER
  
  ' // Your handle
  hPID = FindSupermodel
  hProcess = OpenProcess(PROCESS_ALL_ACCESS, 0, hPID)
  
  lStatus = NtWow64QueryInformationProcess64(hProcess, ProcessBasicInformation, tPBI, Len(tPBI), 0)
  If lStatus < 0 Then
    MsgBox "Error 0x" & Hex$(lStatus)
    Exit Sub
  End If
  
  lStatus = NtWow64ReadVirtualMemory64(hProcess, tPBI.PebBaseAddress.lowpart, tPBI.PebBaseAddress.highpart, tPeb, Len(tPeb), 0, liRet)
  If lStatus < 0 Then
    MsgBox "Error 0x" & Hex$(lStatus)
    Exit Sub
  End If
    
  'LoaderData
  Dim tPEB_LDR_DATA64 As PEB_LDR_DATA64
  lStatus = NtWow64ReadVirtualMemory64(hProcess, tPeb.LoaderData.lowpart, tPeb.LoaderData.highpart, tPEB_LDR_DATA64, Len(tPEB_LDR_DATA64), 0, liRet)
  If lStatus < 0 Then
    MsgBox "Error 0x" & Hex$(lStatus)
    Exit Sub
  End If
  
  Dim tLDR_DATA_TABLE_ENTRY64 As LDR_DATA_TABLE_ENTRY64
  Dim first As LARGE_INTEGER, address As LARGE_INTEGER, counter As Long
  Dim Buffer() As Byte, bLength As Long, BaseDllName As String
  Dim supermodel_offset As LARGE_INTEGER
  
  address = tPEB_LDR_DATA64.InLoadOrderModuleList.Flink
  first = address
  counter = 1
  Do
    lStatus = NtWow64ReadVirtualMemory64(hProcess, address.lowpart, address.highpart, tLDR_DATA_TABLE_ENTRY64, LenB(tLDR_DATA_TABLE_ENTRY64), 0, liRet)
    If tLDR_DATA_TABLE_ENTRY64.BaseAddress.highpart = 0 And tLDR_DATA_TABLE_ENTRY64.BaseAddress.lowpart = 0 Then
      Stop
      Exit Do
    End If
    bLength = tLDR_DATA_TABLE_ENTRY64.BaseDllName.MaxLength
    ReDim Buffer(bLength)
    lStatus = NtWow64ReadVirtualMemory64(hProcess, tLDR_DATA_TABLE_ENTRY64.BaseDllName.lpBuffer.lowpart, tLDR_DATA_TABLE_ENTRY64.BaseDllName.lpBuffer.highpart, Buffer(0), bLength, 0, liRet)
    BaseDllName = Left(Buffer, tLDR_DATA_TABLE_ENTRY64.BaseDllName.length / 2)
    Debug.Print Hex(tLDR_DATA_TABLE_ENTRY64.BaseAddress.highpart) & LeadZero(Hex(tLDR_DATA_TABLE_ENTRY64.BaseAddress.lowpart), 8), BaseDllName, Buffer
    
    If BaseDllName = "supermodel.exe" Then
      supermodel_offset = tLDR_DATA_TABLE_ENTRY64.BaseAddress
      Exit Do
    End If
    address = tLDR_DATA_TABLE_ENTRY64.InLoadOrderModuleList.Flink
    counter = counter + 1
    DoEvents
  Loop
  
  Dim workram As LARGE_INTEGER, profile As String
  ReDim Buffer(8)
  lStatus = NtWow64ReadVirtualMemory64(hProcess, &H5FFAD0, 0, Buffer(0), 8, 0, liRet)
  profile = StrConv(Buffer, vbUnicode)
  profile = Left(profile, InStr(1, profile, Chr(0), vbBinaryCompare) - 1)
  Debug.Print profile
  
  lStatus = NtWow64ReadVirtualMemory64(hProcess, supermodel_offset.lowpart + &H432058, supermodel_offset.highpart, workram, 8, 0, liRet)
  Debug.Print Hex(workram.highpart) & LeadZero(Hex(workram.lowpart), 8)
  Dim gamestate As Byte, keyInput As INPUT_
  '+105007
  
  keyInput.dwType = 1 'INPUT_KEYBOARD
  
  Do
    lStatus = NtWow64ReadVirtualMemory64(hProcess, workram.lowpart + &H105007, workram.highpart, gamestate, 1, 0, liRet)
    If lStatus <> 0 Then Exit Do
    Debug.Print gamestate
    If gamestate = 11 Then
      keyInput.dwFlags = &H8
      keyInput.wScan = &H8
      SendInput 1, keyInput, LenB(keyInput)
      
      Sleep 100
      
      keyInput.dwFlags = &HA
      keyInput.wScan = &H8
      SendInput 1, keyInput, LenB(keyInput)
    End If
    Sleep 1000
    DoEvents
  Loop
  CloseHandle hProcess
  End
End Sub

Public Function LeadZero(Data As String, length As Integer) As String
  If Len(Data) < length Then
    LeadZero = String$(length - Len(Data), "0") & Data
  Else
    LeadZero = Data
  End If
End Function

Function FindSupermodel() As Long
  Dim result As Long
  Dim hwnd As Long
  hwnd = FindWindowA("SDL_app", vbNullString) ' (vbNullString,"Supermodel - Daytona USA 2 - Battle on the Edge")
'  Dim Buffer As String * 256
'  Dim length As Long
'  length = GetClassNameA(hwnd, Buffer, Len(Buffer))
'  Debug.Print Left(Buffer, length)
  Dim pID As Long
  result = GetWindowThreadProcessId(hwnd, pID)
  Debug.Print result, hwnd, pID
  FindSupermodel = pID
End Function
