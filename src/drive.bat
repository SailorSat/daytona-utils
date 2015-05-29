@echo off
IF EXIST ControlUpdate.exe GOTO update
GOTO end

:update
DEL DriveControl.exe
REN ControlUpdate.exe DriveControl.exe

:end
START DriveControl.exe