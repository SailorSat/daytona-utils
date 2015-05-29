Attribute VB_Name = "Winsock"
Option Explicit

Private Const SS_Idle As Byte = 0
Private Const SS_Listening As Byte = 1
Private Const SS_Connecting As Byte = 2
Private Const SS_Connected As Byte = 3
Private Const SS_Disconnecting As Byte = 4

Private SocketList As New Collection

Private Type LPWSADATA
  wVersion As Integer
  wHighVersion As Integer
  szDescription As String * 257
  szSystemStatus As String * 129
  iMaxSockets As Integer
  iMaxUdpDg As Integer
  lpVendorInfo As Long
End Type

Private Declare Function RegisterWindowMessageA Lib "user32.dll" (ByVal sString As String) As Long
Private Declare Function CallWindowProcA Lib "user32.dll" (ByVal wndrpcPrev As Long, ByVal hWnd As Long, ByVal lMessage As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Function CreateWindowExA Lib "user32.dll" (ByVal dwExStyle As Long, ByVal lpClassName As String, ByVal lpWindowName As String, ByVal dwStyle As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hWndParent As Long, ByVal hMenu As Long, ByVal hInstance As Long, lpParam As Any) As Long
Private Declare Function DestroyWindow Lib "user32.dll" (ByVal hWnd As Long) As Long
Private Declare Function SetWindowLongA Lib "user32.dll" (ByVal hWnd As Long, ByVal NIndex As Long, ByVal dwNewLong As Long) As Long

Private Declare Function accept Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal sAddress As String, ByRef lAddress As Long) As Long
Private Declare Function closesocket Lib "ws2_32.dll" (ByVal hSocket As Long) As Long
Private Declare Function recv Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal aBuffer As Any, ByVal lBuffer As Long, ByVal lFlags As Long) As Long
Private Declare Function send Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal aBuffer As Any, ByVal lBuffer As Long, ByVal lFlags As Long) As Long
Private Declare Function recvfrom Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal aBuffer As Any, ByVal lBuffer As Long, ByVal lFlags As Long, ByVal sAddress As String, lAddress As Long) As Long
Private Declare Function sendto Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal aBuffer As Any, ByVal lBuffer As Long, ByVal lFlags As Long, ByVal sAddress As String, lAddress As Long) As Long
Private Declare Function Socket Lib "ws2_32.dll" Alias "socket" (ByVal AddressFamily As Long, ByVal SocketType As Long, ByVal Protocol As Long) As Long
Private Declare Function connect Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal sAddress As String, ByVal lAddress As Long) As Long
Private Declare Function listen Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal lBacklog As Long) As Long
Private Declare Function bind Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal sAddress As String, ByVal lAddress As Long) As Long
Private Declare Function shutdown Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal lFlags As Long) As Long
Private Declare Function setsockopt Lib "wsock32.dll" (ByVal hSocket As Long, ByVal lLevel As Long, ByVal lOption As Long, aValue As Any, ByVal lValue As Long) As Long

Private Declare Function WSAAsyncSelect Lib "ws2_32.dll" (ByVal hSocket As Long, ByVal hWindow As Long, ByVal lMessage As Long, ByVal lEvent As Long) As Long
Private Declare Function WSAStringToAddressA Lib "ws2_32.dll" (ByVal sAddress As String, ByVal lFamily As Long, ByVal lProtocol As Long, ByVal sBuffer As String, lBuffer As Long) As Long
Private Declare Function WSAStartup Lib "ws2_32.dll" (ByVal lVersionRequested As Long, lpWSADataType As LPWSADATA) As Long
Private Declare Function WSACleanup Lib "ws2_32.dll" () As Long
Private Declare Function WSAIsBlocking Lib "ws2_32.dll" () As Long
Private Declare Function WSACancelBlockingCall Lib "ws2_32.dll" () As Long

Private Const BUFFER_SIZE = 4096

Private Const ADDRESS_SIZE = 64

Private Const SOCKET_ERROR      As Long = -1
Private Const SOCKET_VERSION_22 As Long = &H202

Private Const FD_READ    As Long = &H1&
Private Const FD_WRITE   As Long = &H2&
Private Const FD_OOB     As Long = &H4&
Private Const FD_ACCEPT  As Long = &H8&
Private Const FD_CONNECT As Long = &H10&
Private Const FD_CLOSE   As Long = &H20&

Private Const AF_INET     As Long = 2

Private Const SOCK_DGRAM  As Long = 2
Private Const SOCK_STREAM As Long = 1

Private Const IPPROTO_IP  As Long = 0&
Private Const IPPROTO_TCP As Long = 6&
Private Const IPPROTO_UDP As Long = 17&

Private Const TCP_NODELAY As Long = 1&

Private Const IP_DONTFRAGMENT As Long = 14&

Private Const SD_BOTH As Long = 2&

Private Const SIZEOF_INT  As Long = 4&

Private Const GWL_WNDPROC = (-4)

Private WSAWindowHandle As Long
Private WSAData As LPWSADATA
Private OldWindowProc As Long
Private WM_Sockets As Long


Public Sub WINSOCK_OnLoad()
  Load
End Sub


Public Sub WINSOCK_OnUnload()
  Unload
End Sub


Private Function HiWord(lngValue As Long) As Long
  If (lngValue And &H80000000) = &H80000000 Then
    HiWord = ((lngValue And &H7FFF0000) \ &H10000) Or &H8000&
  Else
    HiWord = (lngValue And &HFFFF0000) \ &H10000
  End If
End Function

Private Function LoWord(lngValue As Long) As Long
  LoWord = (lngValue And &HFFFF&)
End Function

Public Function WindowProc(ByVal hWindow As Long, ByVal lMessage As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
  If lMessage = WM_Sockets Then
    WindowProc = SocketMessage(wParam, lParam)
  Else
    WindowProc = CallWindowProcA(OldWindowProc, ByVal hWindow, ByVal lMessage, ByVal wParam, ByVal lParam)
  End If
End Function

Public Function SocketMessage(ByVal lHandle As Long, ByVal lParam As Long) As Long
  Dim lResult As Long
  Dim lEvent As Long, lError As Long
  Dim sBuffer As String, lBuffer As Long
  Dim sAddress As String, lAddress As Long
  
  SocketMessage = 0
  
  ',-= Ungültige/Unbekannte Sockets sofort schließen
  lResult = ValidSocket(lHandle)
  If lResult = SOCKET_ERROR Then
    closesocket lHandle
    Exit Function
  End If
  Dim oSocket As Socket
  Set oSocket = SocketList.Item(lResult)
  
  ',-= Event und Fehler ermitteln
  lEvent = LoWord(lParam)
  lError = HiWord(lParam)
  
  ',-= Event abfragen
  If lEvent = FD_READ Then
    If lError = 0 Then
      If oSocket.ProtoF = SOCK_STREAM Then
        ',-= TCP/Stream Daten abfragen
        sBuffer = String$(BUFFER_SIZE, 0)
        lBuffer = recv(lHandle, sBuffer, BUFFER_SIZE, 0)
        While lBuffer > 0
          sBuffer = Left$(sBuffer, lBuffer)
          OnReadTCP lHandle, sBuffer
          sBuffer = String(BUFFER_SIZE, 0)
          lBuffer = recv(lHandle, sBuffer, BUFFER_SIZE, 0)
        Wend
      Else
        ',-= UDP/Datagram Daten abfragen
        sAddress = String$(ADDRESS_SIZE, 0)
        lAddress = ADDRESS_SIZE
        sBuffer = String$(BUFFER_SIZE, 0)
        lBuffer = recvfrom(lHandle, sBuffer, BUFFER_SIZE, 0, sAddress, lAddress)
        While lBuffer > 0
          sBuffer = Left$(sBuffer, lBuffer)
          sAddress = Left$(sAddress, lAddress)
          OnReadUDP lHandle, sBuffer, sAddress
          sAddress = String$(ADDRESS_SIZE, 0)
          lAddress = ADDRESS_SIZE
          sBuffer = String$(BUFFER_SIZE, 0)
          lBuffer = recvfrom(lHandle, sBuffer, BUFFER_SIZE, 0, sAddress, lAddress)
        Wend
      End If
    Else
      RemoveSocket lHandle
    End If
  ElseIf lEvent = FD_WRITE Then
    If lError = 0 Then
      ',-= Nichts tun und Däumchen drehen? *G*
    Else
      RemoveSocket lHandle
    End If
  ElseIf lEvent = FD_CLOSE Then
    RemoveSocket lHandle
  ElseIf lEvent = FD_ACCEPT Then
    If lError = 0 Then
      ',-= Verbindung annehmen
      sAddress = String$(ADDRESS_SIZE, 0)
      lAddress = ADDRESS_SIZE
      lBuffer = accept(lHandle, sAddress, lAddress)
      sAddress = Left$(sAddress, lAddress)
      
      ',-= neuen Socket erstellen
      Dim sSocketNew As New Socket
      Set sSocketNew = New Socket
      sSocketNew.ProtoF = oSocket.ProtoF
      sSocketNew.Status = SS_Connected
      sSocketNew.Handle = lBuffer
      SocketList.Add sSocketNew
      
      ',-= Event auslösen
      OnIncoming lHandle, lBuffer
    Else
      RemoveSocket lHandle
    End If
  ElseIf lEvent = FD_CONNECT Then
    If lError = 0 Then
      ',-= Verbindung hergestellt
      oSocket.Status = SS_Connected
      OnConnected lHandle
    Else
      ',-= Verbindung fehlgeschlagen
      OnConnectError lHandle, lError
      RemoveSocket lHandle
    End If
  ElseIf lEvent = FD_OOB Then
    '2do',-= Nichts tun und Däumchen drehen? *G*
  Else
    RemoveSocket lHandle
  End If
End Function

' ---

Public Function SendTCP(lHandle As Long, sBuffer As String)
  SendTCP = -1
  
  Dim lResult As Long
  Dim oSocket As Socket
  lResult = ValidSocket(lHandle)
  If lResult = SOCKET_ERROR Then Exit Function
  Set oSocket = SocketList.Item(lResult)
  
  If oSocket.ProtoF = SOCK_STREAM Then
    SendTCP = WSASendData(lHandle, sBuffer)
  End If
End Function

Public Function SendUDP(lHandle As Long, sBuffer As String, sAddress As String)
  SendUDP = -1
  
  Dim lResult As Long
  Dim oSocket As Socket
  lResult = ValidSocket(lHandle)
  If lResult = SOCKET_ERROR Then Exit Function
  Set oSocket = SocketList.Item(lResult)
    
  If oSocket.ProtoF = SOCK_DGRAM Then
    SendUDP = WSASendDataTo(lHandle, sBuffer, sAddress)
  End If
End Function

Public Function ConnectTCP(sAddress As String) As Long
  ConnectTCP = -1
  
  ',-= Socket erstellen
  Dim lHandle As Long
  lHandle = Socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
  If lHandle = SOCKET_ERROR Then
    Exit Function
  End If
  
  ',-= Nagle abschalten
  Dim lResult As Long
  lResult = setsockopt(lHandle, IPPROTO_TCP, TCP_NODELAY, 1, SIZEOF_INT)
  If lResult = SOCKET_ERROR Then
    closesocket lHandle
    Exit Function
  End If
  
  ',-= Events setzen
  Dim lEvent As Long
  lEvent = FD_READ Or FD_WRITE Or FD_CLOSE Or FD_CONNECT
  lResult = WSAAsyncSelect(lHandle, WSAWindowHandle, WM_Sockets, lEvent)
  If lResult = SOCKET_ERROR Then
    closesocket lHandle
    Exit Function
  End If

  lResult = connect(lHandle, sAddress, Len(sAddress))
  If lResult = SOCKET_ERROR Then
    Dim oSocket As New Socket
    SocketList.Add oSocket
    oSocket.Status = SS_Connecting
    oSocket.ProtoF = SOCK_STREAM
    oSocket.Handle = lHandle
    ConnectTCP = lHandle
  Else
    closesocket lHandle
    Exit Function
  End If
End Function

',-= ListenTCP - Beginnt auf einer vSock zu lauschen
Public Function ListenTCP(sAddress As String) As Long
  ListenTCP = -1
  
  ',-= Socket erstellen
  Dim lHandle As Long
  lHandle = Socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
  If lHandle = -1 Then
    Exit Function
  End If
    
  ',-= An sAddress binden
  Dim lResult As Long
  lResult = bind(lHandle, sAddress, Len(sAddress))
  If lResult = SOCKET_ERROR Then
    closesocket lHandle
    Exit Function
  End If
    
  ',-= Events setzen
  Dim lEvent As Long
  lEvent = FD_READ Or FD_WRITE Or FD_CLOSE Or FD_ACCEPT
  lResult = WSAAsyncSelect(lHandle, WSAWindowHandle, WM_Sockets, lEvent)
  If lResult = SOCKET_ERROR Then
    closesocket lHandle
    Exit Function
  End If
      
  ',-= anfangen zu lauschen
  lResult = listen(lHandle, 1)
  If lResult = SOCKET_ERROR Then
    closesocket lHandle
    Exit Function
  End If
  
  ',-= Fertig
  Dim oSocket As New Socket
  SocketList.Add oSocket
  oSocket.Status = SS_Listening
  oSocket.ProtoF = SOCK_STREAM
  oSocket.Handle = lHandle
  ListenTCP = lHandle
End Function


Public Function ListenUDP(sAddress As String) As Long
  ListenUDP = -1
  
  ' Socket erstellen
  Dim lHandle As Long
  lHandle = Socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
  If lHandle = SOCKET_ERROR Then
    Exit Function
  End If
    
  ' Socket erstellt - An SockAddr binden
  Dim lResult As Long
  lResult = bind(lHandle, sAddress, Len(sAddress))
  If lResult = SOCKET_ERROR Then
    closesocket lHandle
    Exit Function
  End If
  
'  lResult = setsockopt(lHandle, IPPROTO_IP, IP_DONTFRAGMENT, 1, SIZEOF_INT)
'  If lResult = SOCKET_ERROR Then
'    closesocket lHandle
'    Exit Function
'  End If
  
  ' Events setzen
  Dim lEvent As Long
  lEvent = FD_READ Or FD_WRITE
  lResult = WSAAsyncSelect(lHandle, WSAWindowHandle, WM_Sockets, lEvent)
  If lResult = SOCKET_ERROR Then
    closesocket lHandle
    Exit Function
  End If
      
  ' Fertig
  Dim oSocket As New Socket
  SocketList.Add oSocket
  oSocket.Status = SS_Listening
  oSocket.ProtoF = SOCK_DGRAM
  oSocket.Handle = lHandle
  ListenUDP = lHandle
End Function

Public Sub Disconnect(ByVal lHandle As Long)
  If Not ValidSocket(lHandle) Then Exit Sub

  Dim lResult As Long
  Dim oSocket As Socket
  lResult = ValidSocket(lHandle)
  If lResult = SOCKET_ERROR Then Exit Sub
  Set oSocket = SocketList.Item("H" & lHandle)
  
  If oSocket.Status = SS_Disconnecting Or oSocket.Status = SS_Listening Then
    RemoveSocket lHandle
  Else
    oSocket.Status = SS_Disconnecting
    shutdown lHandle, SD_BOTH
  End If
End Sub

Public Sub Load()
  WM_Sockets = RegisterWindowMessageA("WinsockMessages")
  
  ',-= Winsock StartUp
  If WSAStartup(SOCKET_VERSION_22, WSAData) = -1 Then
    Err.Raise -1, "Winsock", "Winsock zu alt"
    Exit Sub
  End If
  
  ',-= Fenster erstellen
  WSAWindowHandle = CreateWindowExA(0&, "STATIC", "SOCKET_WINDOW", 0&, 0&, 0&, 0&, 0&, 0&, 0&, App.hInstance, ByVal 0&)
  
  ',-= An WindowProc hängen
  OldWindowProc = SetWindowLongA(WSAWindowHandle, GWL_WNDPROC, AddressOf WindowProc)
End Sub

Public Sub Unload()
  ',-= Aus WindowProc ausklinken
  Call SetWindowLongA(WSAWindowHandle, GWL_WNDPROC, OldWindowProc)
  
  ',-= Winsock 'aufräumen'
  If WSAIsBlocking = -1 Then
    WSACancelBlockingCall
  End If
  WSACleanup
  
  ',-= Fenster zerstören
  DestroyWindow WSAWindowHandle
End Sub

' ---

Public Function WSABuildSocketAddress(sHost As String, lPort As Long) As String
  Dim sAddress As String, lAddress As Long
  Dim lResult As Long
  
  ',-= sHost umwandeln
  sAddress = String(ADDRESS_SIZE, 0)
  lAddress = ADDRESS_SIZE
  lResult = WSAStringToAddressA(sHost, AF_INET, 0, sAddress, lAddress)
  
  ',-= Rückgabe verarbeiten
  If lResult = SOCKET_ERROR Or lPort < 0 Then
    WSABuildSocketAddress = ""
  Else
    ',-= lPort schreiben
    Dim lHiByte As Long
    Dim lLoByte As Long
    lHiByte = (lPort \ 256) Mod 256
    lLoByte = lPort Mod 256
    Mid$(sAddress, 3, 1) = Chr$(lHiByte)
    Mid$(sAddress, 4, 1) = Chr$(lLoByte)
    
    WSABuildSocketAddress = Left$(sAddress, lAddress)
  End If
End Function

',-= WSASendData - Sendet Daten auf einem Socket
Private Function WSASendData(ByVal lHandle As Long, ByVal sBuffer As String) As Long
  Dim lResult As Long
  lResult = send(lHandle, sBuffer, Len(sBuffer), 0)
  If lResult = SOCKET_ERROR Then
    WSASendData = -1
  Else
    WSASendData = 0
  End If
End Function

',-= WSASendDataTo - Sendet Daten auf einem Socket an ein spezielles Ziel
Private Function WSASendDataTo(ByVal lHandle As Long, ByVal sBuffer As String, ByVal sAddress As String) As Long
  Dim lResult As Long
  lResult = sendto(lHandle, sBuffer, Len(sBuffer), 0, sAddress, Len(sAddress))
  If lResult = SOCKET_ERROR Then
    WSASendDataTo = -1
  Else
    WSASendDataTo = 0
  End If
End Function

Private Function ValidSocket(lHandle As Long) As Long
  ValidSocket = SOCKET_ERROR
  
  Dim lSocket As Integer
  Dim oSocket As Socket
  For lSocket = 1 To SocketList.Count
    Set oSocket = SocketList.Item(lSocket)
    If oSocket.Handle = lHandle Then
      ValidSocket = lSocket
      Exit Function
    End If
  Next
End Function

Private Sub RemoveSocket(ByVal lHandle As Long)
  Dim lSocket As Long
  Dim oSocket As Socket
  lSocket = ValidSocket(lHandle)
  If lSocket = SOCKET_ERROR Then Exit Sub
  Set oSocket = SocketList.Item(lSocket)
  
  If Not (oSocket.Status = SS_Listening Or oSocket.Status = SS_Disconnecting Or oSocket.Status = SS_Connecting) Then
    OnClose lHandle
  End If
  
  closesocket lHandle
  SocketList.Remove lSocket
End Sub

' ---

' --- Socket Events ---
'public Sub OnReadTCP(lHandle As Long, sBuffer As String)
'  Window.OnReadTCP lHandle, sBuffer
'End Sub
'
'public Sub OnReadUDP(lHandle As Long, sBuffer As String, sAddress As String)
'  Window.OnReadUDP lHandle, sBuffer, sAddress
'End Sub
'
'public Sub OnIncoming(lHandle As Long, sNewSocket As Long)
'  Window.OnIncoming lHandle, sNewSocket
'End Sub
'
'public Sub OnConnected(lHandle As Long)
'  Window.OnConnected lHandle
'End Sub
'
'public Sub OnConnectError(lHandle As Long, lError As Long)
'  Window.OnConnectError lHandle, lError
'End Sub
'
'public Sub OnClose(lHandle As Long)
'  Window.OnClose lHandle
'End Sub

