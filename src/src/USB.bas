Attribute VB_Name = "USB"
Option Explicit

Private mDriveHandle As Long
Private mDriveBuffer(0 To 3) As Byte

Public Function OpenDriveChannel() As Boolean
  If mDriveHandle = -1 Then
    mDriveHandle = OpenUSB(0, &HCA3, &H3CFC, &H1, &H4)
    If mDriveHandle = -1 Then
      OpenDriveChannel = False
    End If
  End If
  OpenDriveChannel = True
End Function

Public Function CloseDriveChannel() As Long
  If mDriveHandle <> -1 Then
    CloseHandle mDriveHandle
    mDriveHandle = -1
    CloseDriveChannel = mDriveHandle
  End If
End Function

Public Sub WriteDriveData(Command As Byte, Value As Byte)
  If mDriveHandle = -1 Then Exit Sub
  
  mDriveBuffer(0) = 0
  mDriveBuffer(1) = Command
  mDriveBuffer(2) = Value
  mDriveBuffer(3) = 0
  
  Dim Size As Long
  Dim Wrote As Long
  Size = 4
  Wrote = 0
  If WriteFile(mDriveHandle, mDriveBuffer(0), Size, Wrote, 0&) <> 1 Then
    CloseDriveChannel
  End If
End Sub

Private Function OpenUSB(Index As Integer, VendorID As Integer, ProductID As Integer, UsagePage As Integer, Usage As Integer) As Long
  Dim Result As Long
  OpenUSB = -1
  
  Dim HidGuid As GUID
  HidD_GetHidGuid HidGuid
  
  Dim DeviceInfoSet As Long
  DeviceInfoSet = SetupDiGetClassDevsA(HidGuid, vbNullString, 0, (DIGCF_PRESENT Or DIGCF_DEVICEINTERFACE))
  If DeviceInfoSet = -1 Then
    Exit Function
  End If
  
  Dim DeviceIndex As Long
  DeviceIndex = 0
  Dim LastDevice As Boolean
  Dim FoundDevice As Boolean
  LastDevice = False
  FoundDevice = False
  
  While (LastDevice = False And FoundDevice = False)
    Dim MyDeviceInterfaceData As SP_DEVICE_INTERFACE_DATA
    MyDeviceInterfaceData.cbSize = LenB(MyDeviceInterfaceData)
    Result = SetupDiEnumDeviceInterfaces(DeviceInfoSet, 0, HidGuid, DeviceIndex, MyDeviceInterfaceData)
    If Result = 0 Then
      LastDevice = True
    Else
      DeviceIndex = DeviceIndex + 1
      
      Dim MyDeviceInterfaceDetailData As SP_DEVICE_INTERFACE_DETAIL_DATA
      
      Dim DetailData As Long
      Dim Needed As Long
      Result = SetupDiGetDeviceInterfaceDetailA(DeviceInfoSet, MyDeviceInterfaceData, 0, DetailData, Needed, 0)
     
      DetailData = 255
      MyDeviceInterfaceDetailData.cbSize = Len(MyDeviceInterfaceDetailData)
      Dim DetailDataBuffer() As Byte
      ReDim DetailDataBuffer(DetailData)
      Call RtlMoveMemory(DetailDataBuffer(0), MyDeviceInterfaceDetailData, 4)

      Result = SetupDiGetDeviceInterfaceDetailA(DeviceInfoSet, MyDeviceInterfaceData, VarPtr(DetailDataBuffer(0)), DetailData, Needed, 0)
      
      Dim DevicePathName As String
      DevicePathName = Mid$(StrConv(DetailDataBuffer, vbUnicode), 5, Needed - 5)
      
      Dim Security As SECURITY_ATTRIBUTES
      Security.lpSecurityDescriptor = 0
      Security.bInheritHandle = True
      Security.nLength = Len(Security)
      
      Dim HIDHandle As Long
      HIDHandle = CreateFileA(DevicePathName, GENERIC_READ Or GENERIC_WRITE, (FILE_SHARE_READ Or FILE_SHARE_WRITE), VarPtr(Security), OPEN_EXISTING, 0&, 0)
      If HIDHandle <> -1 Then
        Dim DeviceAttributes As HIDD_ATTRIBUTES
        DeviceAttributes.Size = LenB(DeviceAttributes)
        Result = HidD_GetAttributes(HIDHandle, DeviceAttributes)
        
        If Result = 0 Then
          CloseHandle HIDHandle
        Else
          ' check vendorid and productid
          If DeviceAttributes.VendorID = VendorID Then
            If DeviceAttributes.ProductID = ProductID Then
              Dim PreparsedData As Long
              Result = HidD_GetPreparsedData(HIDHandle, PreparsedData)
              
              Dim Capabilities As HIDP_CAPS
              Result = HidP_GetCaps(PreparsedData, Capabilities)
              
              If Capabilities.UsagePage = UsagePage Then
                If Capabilities.Usage = Usage Then
                  OpenUSB = HIDHandle
                  Result = HidD_FreePreparsedData(PreparsedData)
                  Exit Function
                End If
              End If
              
              Result = HidD_FreePreparsedData(PreparsedData)
              CloseHandle HIDHandle
            End If
          End If
        End If
      End If
    End If
  Wend
End Function
