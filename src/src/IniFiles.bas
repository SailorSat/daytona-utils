Attribute VB_Name = "IniFiles"
Option Explicit

Public Function ReadIni(Filename As String, Section As String, Key As String, Default As String) As String
  Dim Result As Long
  Dim Temp As String * 1024
  Result = GetPrivateProfileStringA(Section, Key, Default, Temp, Len(Temp), App.Path & "\" & Filename)
  ReadIni = Left$(Temp, Result)
End Function

Public Sub WriteIni(Filename As String, Section As String, Key As String, Value As String)
  WritePrivateProfileStringA Section, Key, Value, Filename
End Sub
