@echo off
IF EXIST ClientUpdate.exe GOTO update
GOTO end

:update
DEL ControlClient.exe
REN ClientUpdate.exe ControlClient.exe

:end
START ControlClient.exe