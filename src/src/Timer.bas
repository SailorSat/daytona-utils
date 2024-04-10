Attribute VB_Name = "Timer"
Option Explicit

Private g_TimerFreq As Currency
Private g_TimerLast As Currency
Private g_TimerStep As Currency
Private g_TimerGoal As Currency
Private g_TimerTick As Currency

Public Sub SetupTimer(pFPS As Single)
  Call QueryPerformanceFrequency(g_TimerFreq)
  
  g_TimerStep = g_TimerFreq / pFPS
  QueryPerformanceCounter g_TimerLast
  g_TimerGoal = g_TimerLast + g_TimerStep
  g_TimerTick = g_TimerLast
End Sub

Public Function WaitTimer() As Single
  Dim TimerTemp As Currency
  QueryPerformanceCounter TimerTemp
  While TimerTemp < g_TimerGoal
    'Sleep 0
    DoEvents
    QueryPerformanceCounter TimerTemp
  Wend
  While TimerTemp >= g_TimerGoal
    g_TimerLast = g_TimerGoal
    g_TimerGoal = g_TimerLast + g_TimerStep
  Wend
  WaitTimer = (TimerTemp - g_TimerTick) / g_TimerFreq
  g_TimerTick = TimerTemp
End Function

