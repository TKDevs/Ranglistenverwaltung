@ECHO OFF
ECHO Generating Translationfiles in %~dp0bin
COPY %~dp0Sprache\deutsch.ini %~dp0bin\Debug\
COPY %~dp0Sprache\deutsch.ini %~dp0bin\Release\
ECHO finished generating
pause