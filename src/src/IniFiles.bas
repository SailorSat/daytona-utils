Attribute VB_Name = "IniFiles"
Option Explicit

Public Function ReadIni(Filename As String, Section As String, Key As String, Default As String) As String
  Dim Result As Long
  Dim Temp As String * 1024
  If Mid(Filename, 2, 1) <> ":" Then Filename = App.Path & "\" & Filename
  Result = GetPrivateProfileStringA(Section, Key, Default, Temp, Len(Temp), Filename)
  ReadIni = Left$(Temp, Result)
End Function

Public Sub WriteIni(Filename As String, Section As String, Key As String, Value As String)
  WritePrivateProfileStringA Section, Key, Value, Filename
End Sub
