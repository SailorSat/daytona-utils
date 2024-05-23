Attribute VB_Name = "WindowsAPI"
Option Explicit


' ---
' Generics
Public Declare Function GetTickCount Lib "kernel32.dll" () As Long
Public Declare Function CloseHandle Lib "kernel32.dll" (ByVal hObject As Long) As Long
Public Declare Sub RtlMoveMemory Lib "kernel32.dll" (Destination As Any, Source As Any, ByVal Length As Long)
Public Declare Function GetSystemDirectoryA Lib "kernel32.dll" (ByVal lpBuffer As String, ByVal nSize As Long) As Long

Public Declare Function SetFocus Lib "user32.dll" (ByVal hWnd As Long) As Long

Public Declare Function CreateWindowExA Lib "user32.dll" (ByVal dwExStyle As Long, ByVal lpClassName As String, ByVal lpWindowName As String, ByVal dwStyle As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hWndParent As Long, ByVal hMenu As Long, ByVal hInstance As Long, lpParam As Any) As Long
Public Declare Function DestroyWindow Lib "user32.dll" (ByVal hWnd As Long) As Long
Public Declare Function RegisterWindowMessageA Lib "user32.dll" (ByVal sString As String) As Long
Public Declare Function CallWindowProcA Lib "user32.dll" (ByVal wndrpcPrev As Long, ByVal hWnd As Long, ByVal lMessage As Long, ByVal wParam As Long, lParam As Any) As Long



' ---
' Sound
Public Declare Function PlaySoundA Lib "winmm.dll" (ByVal lpszName As String, ByVal hModule As Long, ByVal dwFlags As Long) As Long
Public Const SND_ASYNC As Long = &H1
Public Const SND_FILENAME As Long = &H20000


' ---
' IniFiles
Public Declare Function GetPrivateProfileStringA Lib "kernel32.dll" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Public Declare Function WritePrivateProfileStringA Lib "kernel32.dll" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long


' ---
' Timer
Public Declare Function timeGetTime Lib "winmm.dll" () As Long
Public Declare Function timeBeginPeriod Lib "winmm.dll" (ByVal uPeriod As Long) As Long
Public Declare Function timeEndPeriod Lib "winmm.dll" (ByVal uPeriod As Long) As Long

Public Declare Sub Sleep Lib "kernel32.dll" (ByVal dwMilliseconds As Long)

Public Declare Function SetTimer Lib "user32.dll" (ByVal hWnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerFunc As Long) As Long
Public Declare Function KillTimer Lib "user32.dll" (ByVal hWnd As Long, ByVal nIDEvent As Long) As Long

Public Const WM_Timer = &H113


' ---
' ProcessMemory
Public Declare Function OpenProcess Lib "kernel32.dll" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long

Public Declare Function ReadProcessMemory Lib "kernel32.dll" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesRead As Long) As Long
Public Declare Function WriteProcessMemory Lib "kernel32.dll" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long

Public Declare Function CreateToolhelp32Snapshot Lib "kernel32.dll" (ByVal dwFlags As Long, ByVal th32ProcessID As Long) As Long
Public Declare Function Module32First Lib "kernel32.dll" (ByVal hSnapshot As Long, lpme As MODULEENTRY32) As Long
Public Declare Function Module32Next Lib "kernel32.dll" (ByVal hSnapshot As Long, lpme As MODULEENTRY32) As Long
Public Declare Function Process32First Lib "kernel32.dll" (ByVal hSnapshot As Long, lppe As PROCESSENTRY32) As Long
Public Declare Function Process32Next Lib "kernel32.dll" (ByVal hSnapshot As Long, lppe As PROCESSENTRY32) As Long

Public Const PROCESS_ALL_ACCESS = &H1F0FFF
Public Const TH32CS_SNAPMODULE = &H8
Public Const TH32CS_SNAPPROCESS = &H2

Public Type MODULEENTRY32
  dwSize As Long
  th32ModuleID As Long
  th32ProcessID As Long
  GlblcntUsage As Long
  ProccntUsage As Long
  modBaseAddr As Long
  modBaseSize As Long
  hModule As Long
  szModule As String * 256
  szExeFile As String * 260
End Type

Public Type PROCESSENTRY32
  dwSize As Long
  cntUsage As Long
  th32ProcessID As Long
  th32DefaultHeapID As Long
  th32ModuleID As Long
  cntThreads As Long
  th32ParentProcessID As Long
  pcPriClassBase As Long
  dwFlags As Long
  szExeFile As String * 260
End Type


' ---
' Shutdown Windows
Public Declare Function ExitWindowsEx Lib "user32.dll" (ByVal uFlags As Long, ByVal dwReserved As Long) As Long

Public Const EWX_LOGOFF = 0
Public Const EWX_SHUTDOWN = 1
Public Const EWX_REBOOT = 2
Public Const EWX_FORCE = 4


' ---
' Cut Holes in Windows
Public Declare Function CreateRectRgn Lib "gdi32.dll" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Public Declare Function CombineRgn Lib "gdi32.dll" (ByVal hDestRgn As Long, ByVal hSrcRgn1 As Long, ByVal hSrcRgn2 As Long, ByVal nCombineMode As Long) As Long
Public Declare Function DeleteObject Lib "gdi32.dll" (ByVal hObject As Long) As Long
Public Declare Function SetWindowRgn Lib "user32.dll" (ByVal hWnd As Long, ByVal hRgn As Long, ByVal bRedraw As Boolean) As Long

Public Const RGN_DIFF = 4


' ---
' Window Styles
Public Declare Function FindWindowA Lib "user32.dll" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function GetWindowLongA Lib "user32.dll" (ByVal hWnd As Long, ByVal NIndex As Long) As Long
Public Declare Function SetWindowLongA Lib "user32.dll" (ByVal hWnd As Long, ByVal NIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function SetWindowPos Lib "user32.dll" (ByVal hWnd As Long, ByVal hWndInsertAfter As Long, ByVal X As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Public Declare Function GetMenu Lib "user32.dll" (ByVal hWnd As Long) As Long
Public Declare Function SetMenu Lib "user32.dll" (ByVal hWnd As Long, ByVal hMenu As Long) As Long
Public Declare Function SetLayeredWindowAttributes Lib "user32.dll" (ByVal hWnd As Long, ByVal crKey As Long, ByVal bDefaut As Byte, ByVal dwFlags As Long) As Long

Public Const SWP_NOSIZE = &H1&
Public Const SWP_NOMOVE = &H2&
Public Const SWP_NOACTIVATE = &H10&
Public Const SWP_SHOWWINDOW = &H40&

Public Const GWL_STYLE = (-16&)
Public Const GWL_EXSTYLE = (-20&)

Public Const WS_EX_LAYERED = &H80000

Public Const LWA_COLORKEY = &H1&

Public Const HWND_BOTTOM As Long = 1&
Public Const HWND_TOPMOST As Long = -1&
Public Const HWND_NOTOPMOST As Long = -2&


' ---
' BitBlt
Public Declare Function BitBlt Lib "gdi32.dll" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function StretchBlt Lib "gdi32.dll" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long


' ---
' Shell Execute
Public Declare Function ShellExecuteA Lib "shell32.dll" (ByVal hWnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
 
Public Const SW_HIDE As Long = 0&
Public Const SW_SHOWNORMAL As Long = 1&
Public Const SW_SHOWMAXIMIZED As Long = 3&


' ---
' Move Cursor
Public Type POINTAPI
    X As Long
    Y As Long
End Type

Public Declare Function SetCursorPos Lib "user32.dll" (ByVal X As Long, ByVal Y As Long) As Long


' ---
' Serial Port
Public Declare Function CreateFileA Lib "kernel32.dll" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As Long, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Public Declare Function ReadFile Lib "kernel32.dll" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToRead As Long, lpNumberOfBytesRead As Long, ByVal lpOverlapped As Long) As Long
Public Declare Function WriteFile Lib "kernel32.dll" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToWrite As Long, lpNumberOfBytesWritten As Long, ByVal lpOverlapped As Long) As Long
Public Declare Function FlushFileBuffers Lib "kernel32.dll" (ByVal hFile As Long) As Long
Public Declare Function SetCommTimeouts Lib "kernel32.dll" (ByVal hFile As Long, lpCommTimeouts As COMMTIMEOUTS) As Long
Public Declare Function BuildCommDCBA Lib "kernel32.dll" (ByVal lpDef As String, lpDCB As DCB) As Long
Public Declare Function SetCommState Lib "kernel32.dll" (ByVal hCommDev As Long, lpDCB As DCB) As Long
Public Declare Function GetLastError Lib "kernel32.dll" () As Long

Public Const GENERIC_READ = &H80000000
Public Const GENERIC_WRITE = &H40000000

Public Type COMMTIMEOUTS
  ReadIntervalTimeout As Long
  ReadTotalTimeoutMultiplier As Long
  ReadTotalTimeoutConstant As Long
  WriteTotalTimeoutMultiplier As Long
  WriteTotalTimeoutConstant As Long
End Type

Public Type DCB
  DCBlength As Long
  BaudRate As Long
  fBinary As Long
  fParity As Long
  fOutxCtsFlow As Long
  fOutxDsrFlow As Long
  fDtrControl As Long
  fDsrSensitivity As Long
  fTXContinueOnXoff As Long
  fOutX As Long
  fInX As Long
  fErrorChar As Long
  fNull As Long
  fRtsControl As Long
  fAbortOnError As Long
  fDummy2 As Long
  wReserved As Integer
  XonLim As Integer
  XoffLim As Integer
  ByteSize As Byte
  Parity As Byte
  StopBits As Byte
  XonChar As Byte
  XoffChar As Byte
  ErrorChar As Byte
  EofChar As Byte
  EvtChar As Byte
End Type


' ---
' USB
Public Type GUID
  Data1 As Long
  Data2 As Integer
  Data3 As Integer
  Data4(7) As Byte
End Type

Public Type SP_DEVICE_INTERFACE_DATA
  cbSize As Long
  InterfaceClassGuid As GUID
  Flags As Long
  Reserved As Long
End Type

Public Type SP_DEVINFO_DATA
  cbSize As Long
  ClassGuid As GUID
  DevInst As Long
  Reserved As Long
End Type

Public Type SP_DEVICE_INTERFACE_DETAIL_DATA
  cbSize As Long
  DevicePath As Byte
End Type

Public Type SECURITY_ATTRIBUTES
  nLength As Long
  lpSecurityDescriptor As Long
  bInheritHandle As Long
End Type

Public Type HIDD_ATTRIBUTES
  Size As Long
  VendorID As Integer
  ProductID As Integer
  VersionNumber As Integer
End Type

Public Type HIDP_CAPS
  Usage As Integer
  UsagePage As Integer
  InputReportByteLength As Integer
  OutputReportByteLength As Integer
  FeatureReportByteLength As Integer
  Reserved(16) As Integer
  NumberLinkCollectionNodes As Integer
  NumberInputButtonCaps As Integer
  NumberInputValueCaps As Integer
  NumberInputDataIndices As Integer
  NumberOutputButtonCaps As Integer
  NumberOutputValueCaps As Integer
  NumberOutputDataIndices As Integer
  NumberFeatureButtonCaps As Integer
  NumberFeatureValueCaps As Integer
  NumberFeatureDataIndices As Integer
End Type

Public Declare Sub HidD_GetHidGuid Lib "hid.dll" (ByRef HidGuid As GUID)
Public Declare Function HidD_GetAttributes Lib "hid.dll" (ByVal HidDeviceObject As Long, ByRef Attributes As HIDD_ATTRIBUTES) As Long
Public Declare Function HidD_GetPreparsedData Lib "hid.dll" (ByVal HidDeviceObject As Long, ByRef PreparsedData As Long) As Long
Public Declare Function HidP_GetCaps Lib "hid.dll" (ByVal PreparsedData As Long, ByRef Capabilities As HIDP_CAPS) As Long
Public Declare Function HidD_FreePreparsedData Lib "hid.dll" (ByRef PreparsedData As Long) As Long

Public Declare Function SetupDiEnumDeviceInterfaces Lib "setupapi.dll" (ByVal DeviceInfoSet As Long, ByVal DeviceInfoData As Long, ByRef InterfaceClassGuid As GUID, ByVal MemberIndex As Long, ByRef DeviceInterfaceData As SP_DEVICE_INTERFACE_DATA) As Long
Public Declare Function SetupDiGetClassDevsA Lib "setupapi.dll" (ByRef ClassGuid As GUID, ByVal Enumerator As String, ByVal hWndParent As Long, ByVal Flags As Long) As Long
Public Declare Function SetupDiGetDeviceInterfaceDetailA Lib "setupapi.dll" (ByVal DeviceInfoSet As Long, ByRef DeviceInterfaceData As SP_DEVICE_INTERFACE_DATA, ByVal DeviceInterfaceDetailData As Long, ByVal DeviceInterfaceDetailDataSize As Long, ByRef RequiredSize As Long, ByVal DeviceInfoData As Long) As Long
Public Declare Function SetupDiDestroyDeviceInfoList Lib "setupapi.dll" (ByVal DeviceInfoSet As Long) As Long

Public Declare Function FormatMessageA Lib "kernel32.dll" (ByVal dwFlags As Long, ByRef lpSource As Any, ByVal dwMessageId As Long, ByVal dwLanguageZId As Long, ByVal lpBuffer As String, ByVal nSize As Long, ByVal Arguments As Long) As Long

Public Const DIGCF_PRESENT = &H2
Public Const DIGCF_DEVICEINTERFACE = &H10

Public Const FILE_SHARE_READ = &H1
Public Const FILE_SHARE_WRITE = &H2

Public Const OPEN_EXISTING = 3

Public Const FORMAT_MESSAGE_FROM_SYSTEM = &H1000


Public Declare Function QueryPerformanceFrequency Lib "kernel32.dll" (lpFrequency As Any) As Long
Public Declare Function QueryPerformanceCounter Lib "kernel32.dll" (lpPerformanceCount As Any) As Long


' ---
' Resolution
Public Const CDS_UPDATEREGISTRY = &H1

Public Const CCHDEVICENAME = 32
Public Const CCHFORMNAME = 32

Public Type DEVMODE
  dmDeviceName As String * CCHDEVICENAME
  dmSpecVersion As Integer
  dmDriverVersion As Integer
  dmSize As Integer
  dmDriverExtra As Integer
  dmFields As Long
  dmOrientation As Integer
  dmPaperSize As Integer
  dmPaperLength As Integer
  dmPaperWidth As Integer
  dmScale As Integer
  dmCopies As Integer
  dmDefaultSource As Integer
  dmPrintQuality As Integer
  dmColor As Integer
  dmDuplex As Integer
  dmYResolution As Integer
  dmTTOption As Integer
  dmCollate As Integer
  dmFormName As String * CCHFORMNAME
  dmUnusedPadding As Integer
  dmBitsPerPel As Integer
  dmPelsWidth As Long
  dmPelsHeight As Long
  dmDisplayFlags As Long
  dmDisplayFrequency As Long
End Type

Public Declare Function EnumDisplaySettingsA Lib "user32.dll" (ByVal lpszDeviceName As String, ByVal iModeNum As Long, lpDevMode As Any) As Boolean
Public Declare Function ChangeDisplaySettingsExA Lib "user32.dll" (ByVal lpszDeviceName As String, lpDevMode As Any, ByVal hWnd As Long, ByVal dwFlags As Long, ByVal lParam As Long) As Long


' ---
' ProcessMemory64
Public Type LARGE_INTEGER
  lowpart As Long
  highpart As Long
End Type

Public Type LIST_ENTRY64
  Flink As LARGE_INTEGER
  Blink As LARGE_INTEGER
End Type

Public Type UNICODE_STRING64
  Length As Integer
  MaxLength As Integer
  lPad As Long
  lpBuffer As LARGE_INTEGER
End Type

Public Type PROCESS_BASIC_INFORMATION64
  ExitStatus As Long
  Reserved0 As Long
  PebBaseAddress As LARGE_INTEGER
  AffinityMask As LARGE_INTEGER
  BasePriority As Long
  Reserved1 As Long
  uUniqueProcessId As LARGE_INTEGER
  uInheritedFromUniqueProcessId As LARGE_INTEGER
End Type

Public Type PEB64
  InheritedAddressSpace As Byte
  ReadImageFileExecOptions As Byte
  BeingDebugged As Byte
  Spare As Byte
  lPad01 As Long
  Mutant As LARGE_INTEGER
  ImageBaseAddress As LARGE_INTEGER
  LoaderData As LARGE_INTEGER
  ProcessParameters As LARGE_INTEGER
  SubSystemData As LARGE_INTEGER
  ProcessHeap As LARGE_INTEGER
  FastPebLock As LARGE_INTEGER
  AtlThunkSListPtr As LARGE_INTEGER
  IFEOKey As LARGE_INTEGER
  CrossProcessFlags As Long
  ProcessBits As Long
  KernelCallBackTable As LARGE_INTEGER
  EventLogSection As Long
  EventLog As Long
  FreeList As LARGE_INTEGER
  TlsBitMapSize As Long
  lPad02 As Long
  TlsBitMap As LARGE_INTEGER
  TlsBitMapData(1) As Long
  ReadOnlySharedMemoryBase As LARGE_INTEGER
  ReadOnlySharedMemoryHeap As LARGE_INTEGER
  ReadOnlyStaticServerData As LARGE_INTEGER
  InitAnsiCodePageData As LARGE_INTEGER
  InitOemCodePageData As LARGE_INTEGER
  InitUnicodeCaseTableData As LARGE_INTEGER
  NumberOfProcessors As Long
  NtGlobalFlag As Long
  CriticalSectionTimeout As LARGE_INTEGER
  HeapSegmentReserve As LARGE_INTEGER
  HeapSegmentCommit As LARGE_INTEGER
  HeapDeCommitTotalFreeThreshold As LARGE_INTEGER
  HeapDeCommitFreeBlockThreshold As LARGE_INTEGER
  NumberOfHeaps As Long
  MaxNumberOfHeaps As Long
  ProcessHeapsList As LARGE_INTEGER
  GdiSharedHandleTable As LARGE_INTEGER
  ProcessStarterHelper As LARGE_INTEGER
  GdiDCAttributeList As Long
  lPad03 As Long
  LoaderLock As LARGE_INTEGER
  NtMajorVersion As Long
  NtMinorVersion As Long
  NtBuildNumber As Integer
  NtPlatformId As Integer
  PlatformId As Long
  ImageSubsystem As Long
  ImageMajorSubsystemVersion As Long
  ImageMinorSubsystemVersion As Long
  lPad09 As Long
  AffinityMask As LARGE_INTEGER
  GdiHandleBuffer(29) As LARGE_INTEGER
  PostProcessInitRoutine As LARGE_INTEGER
  TlsExpansionBitmap As LARGE_INTEGER
  TlsExpansionBitmapBits(31) As Long
  SessionId As LARGE_INTEGER
  AppCompatFlags As LARGE_INTEGER
  AppCompatFlagsUser As LARGE_INTEGER
  ShimData As LARGE_INTEGER
  AppCompatInfo As LARGE_INTEGER
  CSDVersion As UNICODE_STRING64
  ActivationContextData As LARGE_INTEGER
  ProcessAssemblyStorageMap As LARGE_INTEGER
  SystemDefaultActivationData As LARGE_INTEGER
  SystemAssemblyStorageMap As LARGE_INTEGER
  MinimumStackCommit As Long
  lPad05 As Long
  FlsCallBack As LARGE_INTEGER
  FlsListHead As LIST_ENTRY64
  FlsBitmap As LARGE_INTEGER
  FlsBitmapBits(3) As Long
  FlsHighIndex As Long
  lPad06 As Long
  WerRegistrationData As LARGE_INTEGER
  WerShipAssertPtr As LARGE_INTEGER
End Type

Public Type PEB_LDR_DATA64
  Length As Long
  Initialized As Long
  SsHandle As LARGE_INTEGER
  InLoadOrderModuleList As LIST_ENTRY64
  InMemoryOrderModuleList As LIST_ENTRY64
  InInitializationOrderModuleList As LIST_ENTRY64
End Type

Public Type LDR_DATA_TABLE_ENTRY64
  InLoadOrderModuleList As LIST_ENTRY64
  InMemoryOrderModuleList As LIST_ENTRY64
  InInitializationOrderModuleList As LIST_ENTRY64
  BaseAddress As LARGE_INTEGER
  EntryPoint As LARGE_INTEGER
  SizeOfImage As LARGE_INTEGER
  FullDllName As UNICODE_STRING64
  BaseDllName As UNICODE_STRING64
  Flags As Long
  LoadCount As Integer
  TlsIndex As Integer
  HashTableEntry As LIST_ENTRY64
  TimeDateStamp As LARGE_INTEGER
End Type

Public Declare Function NtWow64QueryInformationProcess64 Lib "ntdll.dll" (ByVal hProcess As Long, ByVal ProcessInformationClass As Long, ByRef pProcessInformation As Any, ByVal uProcessInformationLength As Long, ByRef puReturnLength As Long) As Long
Public Declare Function NtWow64ReadVirtualMemory64 Lib "ntdll.dll" (ByVal hProcess As Long, ByVal BaseAddressL As Long, ByVal BaseAddressH As Long, ByRef Buffer As Any, ByVal BufferLengthL As Long, ByVal BufferLengthH As Long, ByRef ReturnLength As LARGE_INTEGER) As Long
Public Declare Function NtWow64WriteVirtualMemory64 Lib "ntdll.dll" (ByVal hProcess As Long, ByVal BaseAddressL As Long, ByVal BaseAddressH As Long, ByRef Buffer As Any, ByVal BufferLengthL As Long, ByVal BufferLengthH As Long, ByRef OutputLength As LARGE_INTEGER) As Long

Public Const ProcessBasicInformation As Long = 0


' ---
' Input
Public Type INPUT_
  dwType As Long
  wVK As Integer
  wScan As Integer
  dwFlags As Long
  dwTime As Long
  dwExtraInfo As Long
  dwPadding As Currency
End Type

Public Declare Sub mouse_event Lib "user32.dll" (ByVal dwFlags As Long, ByVal dx As Long, ByVal dy As Long, ByVal cButtons As Long, ByVal dwExtraInfo As Long)
Public Declare Function SendInput Lib "user32.dll" (ByVal nInputs As Long, ByRef pInputs As Any, ByVal cbSize As Long) As Long
Public Declare Function MapVirtualKeyA Lib "user32.dll" (ByVal wCode As Long, ByVal wMapType As Long) As Long

Public Const INPUT_KEYBOARD  As Long = 1

Public Const KEYEVENTF_EXTENDEDKEY = &H1
Public Const KEYEVENTF_KEYUP  As Long = 2
Public Const KEYEVENTF_SCANCODE  As Long = 8

Public Const VK_RETURN As Long = &HD
Public Const VK_ESCAPE As Long = &H1B
Public Const VK_LEFT As Long = &H25
Public Const VK_UP As Long = &H26
Public Const VK_RIGHT As Long = &H27
Public Const VK_DOWN As Long = &H28
Public Const VK_7 As Long = &H37

Public Const MAPVK_VK_TO_VSC As Long = 0

Public Const MOUSEEVENTF_MOVE = &H1&

' ---
Public Function GetErrorString(ByVal LastError As Long) As String
  'Returns the error message for the last error.
  'Adapted from Dan Appleman's "Win32 API Puzzle Book"
  Dim Bytes As Long
  Dim ErrorString As String
  ErrorString = String$(129, 0)
  Bytes = FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM, 0&, LastError, 0, ErrorString, 128, 0)
  GetErrorString = LastError & " - " & ErrorString
End Function
