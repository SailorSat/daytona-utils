@echo off
IF EXIST FeedbackUpdate.exe GOTO update
GOTO end

:update
DEL DriveFeedback.exe
REN FeedbackUpdate.exe DriveFeedback.exe

:end
START DriveFeedback.exe