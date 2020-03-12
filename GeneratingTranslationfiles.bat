@ECHO OFF
ECHO generating translation files at %~dp0bin
ECHO generating german
COPY %~dp0Sprache\deutsch.ini %~dp0bin\Debug\
COPY %~dp0Sprache\deutsch.ini %~dp0bin\Release\
ECHO generating english
COPY %~dp0Sprache\englisch.ini %~dp0bin\Debug\
COPY %~dp0Sprache\englisch.ini %~dp0bin\Release\
ECHO finished generating