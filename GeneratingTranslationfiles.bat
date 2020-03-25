@ECHO OFF
ECHO generating translation files at %~dp0bin
ECHO generating german
COPY %~dp0Sprache\deutsch.ini %~dp0bin\Debug\data\
COPY %~dp0Sprache\deutsch.ini %~dp0bin\Release\data\
ECHO generating english
COPY %~dp0Sprache\englisch.ini %~dp0bin\Debug\data\
COPY %~dp0Sprache\englisch.ini %~dp0bin\Release\data\
ECHO generating images
COPY %~dp0Images\basketball.png %~dp0bin\Release\data\
COPY %~dp0Images\basketball.png %~dp0bin\Debug\data\
COPY %~dp0Images\soccer.png %~dp0bin\Release\data\
COPY %~dp0Images\soccer.png %~dp0bin\Debug\data\
COPY %~dp0Images\search.png %~dp0bin\Release\data\
COPY %~dp0Images\search.png %~dp0bin\Debug\data\
ECHO finished generating