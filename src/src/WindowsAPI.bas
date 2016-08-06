Attribute VB_Name = "WindowsAPI"
Option Explicit

' ---
' Generics

Public Declare Function GetTickCount Lib "kernel32" () As Long

Public Declare Function timeGetTime Lib "winmm.dll" () As Long
Public Declare Function timeBeginPeriod Lib "winmm.dll" (ByVal uPeriod As Long) As Long

Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Declare Sub RtlMoveMemory Lib "kernel32" (Destination As Any, Source As Any, ByVal Length As Long)

' ---
' ProcessMemory

Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long

Public Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long

Public Declare Function CreateToolhelp32Snapshot Lib "kernel32.dll" (ByVal dwFlags As Long, ByVal th32ProcessID As Long) As Long
Public Declare Function Module32First Lib "kernel32" (ByVal hSnapshot As Long, lpme As MODULEENTRY32) As Long
Public Declare Function Module32Next Lib "kernel32" (ByVal hSnapshot As Long, lpme As MODULEENTRY32) As Long
Public Declare Function Process32First Lib "kernel32" (ByVal hSnapshot As Long, lppe As PROCESSENTRY32) As Long
Public Declare Function Process32Next Lib "kernel32" (ByVal hSnapshot As Long, lppe As PROCESSENTRY32) As Long

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

Public Declare Function ExitWindowsEx Lib "user32" (ByVal uFlags As Long, ByVal dwReserved As Long) As Long

Public Const EWX_LOGOFF = 0
Public Const EWX_SHUTDOWN = 1
Public Const EWX_REBOOT = 2
Public Const EWX_FORCE = 4

' ---
' Cut Holes in Windows

Public Declare Function CreateRectRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Public Declare Function CombineRgn Lib "gdi32" (ByVal hDestRgn As Long, ByVal hSrcRgn1 As Long, ByVal hSrcRgn2 As Long, ByVal nCombineMode As Long) As Long
Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Public Declare Function SetWindowRgn Lib "user32" (ByVal hWnd As Long, ByVal hRgn As Long, ByVal bRedraw As Boolean) As Long

Public Const RGN_DIFF = 4

' ---
' Window Styles

Public Declare Function FindWindowA Lib "user32" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function GetWindowLongA Lib "user32" (ByVal hWnd As Long, ByVal NIndex As Long) As Long
Public Declare Function SetWindowLongA Lib "user32" (ByVal hWnd As Long, ByVal NIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function SetWindowPos Lib "user32" (ByVal hWnd As Long, ByVal hWndInsertAfter As Long, ByVal X As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Public Declare Function GetMenu Lib "user32" (ByVal hWnd As Long) As Long
Public Declare Function SetMenu Lib "user32" (ByVal hWnd As Long, ByVal hMenu As Long) As Long
Public Declare Function SetLayeredWindowAttributes Lib "user32" (ByVal hWnd As Long, ByVal crKey As Long, ByVal bDefaut As Byte, ByVal dwFlags As Long) As Long

Public Const SWP_NOSIZE = &H1&
Public Const SWP_NOMOVE = &H2&
Public Const SWP_NOACTIVATE = &H10&
Public Const SWP_SHOWWINDOW = &H40&

Public Const GWL_STYLE = (-16&)
Public Const GWL_EXSTYLE = (-20&)

Public Const WS_EX_LAYERED = &H80000

Public Const LWA_COLORKEY = &H1&

Public Const HWND_TOPMOST = -1&


' ---
' BitBlt

Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long

' ---
' Shell Execute

Public Declare Function ShellExecuteA Lib "shell32.dll" (ByVal hWnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Public Const SW_HIDE = 0

' ---
' Move Cursor

Public Type POINTAPI
    X As Long
    Y As Long
End Type

Public Declare Function SetCursorPos Lib "user32" (ByVal X As Long, ByVal Y As Long) As Long

' ---
' Serial Port

Public Declare Function CreateFileA Lib "kernel32" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As Long, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Public Declare Function ReadFile Lib "kernel32" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToRead As Long, lpNumberOfBytesRead As Long, ByVal lpOverlapped As Long) As Long
Public Declare Function WriteFile Lib "kernel32" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToWrite As Long, lpNumberOfBytesWritten As Long, ByVal lpOverlapped As Long) As Long
Public Declare Function FlushFileBuffers Lib "kernel32" (ByVal hFile As Long) As Long
Public Declare Function SetCommTimeouts Lib "kernel32" (ByVal hFile As Long, lpCommTimeouts As COMMTIMEOUTS) As Long
Public Declare Function BuildCommDCBA Lib "kernel32" (ByVal lpDef As String, lpDCB As DCB) As Long
Public Declare Function SetCommState Lib "kernel32" (ByVal hCommDev As Long, lpDCB As DCB) As Long
Public Declare Function GetLastError Lib "kernel32" () As Long

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

Public Declare Function FormatMessageA Lib "kernel32" (ByVal dwFlags As Long, ByRef lpSource As Any, ByVal dwMessageId As Long, ByVal dwLanguageZId As Long, ByVal lpBuffer As String, ByVal nSize As Long, ByVal Arguments As Long) As Long

Public Const DIGCF_PRESENT = &H2
Public Const DIGCF_DEVICEINTERFACE = &H10

Public Const FILE_SHARE_READ = &H1
Public Const FILE_SHARE_WRITE = &H2

Public Const OPEN_EXISTING = 3

Public Const FORMAT_MESSAGE_FROM_SYSTEM = &H1000

Public Function GetErrorString(ByVal LastError As Long) As String
  'Returns the error message for the last error.
  'Adapted from Dan Appleman's "Win32 API Puzzle Book"
  Dim Bytes As Long
  Dim ErrorString As String
  ErrorString = String(129, 0)
  Bytes = FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM, 0&, LastError, 0, ErrorString, 128, 0)
  GetErrorString = LastError & " - " & ErrorString
End Function


