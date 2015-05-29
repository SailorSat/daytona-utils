@echo off
IF EXIST StatsUpdate.exe GOTO update
GOTO end

:update
DEL LiveStats.exe
REN StatsUpdate.exe LiveStats.exe

:end
START LiveStats.exe