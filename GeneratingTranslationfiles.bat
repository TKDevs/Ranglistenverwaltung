@ECHO OFF
MKDIR %~dp0bin\Debug\data\
MKDIR %~dp0bin\Release\data\
ECHO generating translation files at %~dp0bin
ECHO generating german
COPY %~dp0data\languages\deutsch.ini %~dp0bin\Debug\data\
COPY %~dp0data\languages\deutsch.ini %~dp0bin\Release\data\
ECHO generating english
COPY %~dp0data\languages\englisch.ini %~dp0bin\Debug\data\
COPY %~dp0data\languages\englisch.ini %~dp0bin\Release\data\
ECHO generating images
COPY %~dp0data\images\basketball.png %~dp0bin\Release\data\
COPY %~dp0data\images\basketball.png %~dp0bin\Debug\data\
COPY %~dp0data\images\soccer.png %~dp0bin\Release\data\
COPY %~dp0data\images\soccer.png %~dp0bin\Debug\data\
COPY %~dp0data\images\search.png %~dp0bin\Release\data\
COPY %~dp0data\images\search.png %~dp0bin\Debug\data\
ECHO finished generating