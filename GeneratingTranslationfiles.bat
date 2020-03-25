@ECHO OFF
ECHO generating translation files at %~dp0bin
ECHO generating german
COPY %~dp0Sprache\deutsch.ini %~dp0bin\Debug\
COPY %~dp0Sprache\deutsch.ini %~dp0bin\Release\
ECHO generating english
COPY %~dp0Sprache\englisch.ini %~dp0bin\Debug\
COPY %~dp0Sprache\englisch.ini %~dp0bin\Release\
ECHO generating images
COPY %~dp0Images\basketball.png %~dp0bin\Release\
COPY %~dp0Images\basketball.png %~dp0bin\Debug\
COPY %~dp0Images\soccer.png %~dp0bin\Release\
COPY %~dp0Images\soccer.png %~dp0bin\Debug\
COPY %~dp0Images\search.png %~dp0bin\Release\
COPY %~dp0Images\search.png %~dp0bin\Debug\
ECHO finished generating