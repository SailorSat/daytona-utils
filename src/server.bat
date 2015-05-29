@echo off
IF EXIST ServerUpdate.exe GOTO update
GOTO end

:update
DEL ControlServer.exe
REN ServerUpdate.exe ControlServer.exe

:end
START ControlServer.exe