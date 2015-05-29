Attribute VB_Name = "IniFiles"
Option Explicit

Private Declare Function GetPrivateProfileStringA Lib "kernel32" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long

Public Function ReadIni(File As String, Section As String, Key As String, Default As String) As String
  Dim Result As Long
  Dim Temp As String * 1024
  Result = GetPrivateProfileStringA(Section, Key, Default, Temp, Len(Temp), App.Path & "\" & File)
  ReadIni = Left$(Temp, Result)
End Function

