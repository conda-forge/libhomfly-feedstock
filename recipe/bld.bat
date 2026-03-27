@echo off

cd lib

cl /nologo /O2 /MD /I. /I"%LIBRARY_INC%" /c ^
	bound.c control.c dllink.c homfly.c knot.c model.c order.c poly.c
if errorlevel 1 exit /b 1

link /nologo /DLL /OUT:homfly.dll /IMPLIB:homfly.lib ^
	bound.obj control.obj dllink.obj homfly.obj knot.obj model.obj order.obj poly.obj ^
	"%LIBRARY_LIB%\gc.lib"
if errorlevel 1 exit /b 1

cd ..\test
cl /nologo /O2 /MD /I. /I..\lib /I"%LIBRARY_INC%" /c test_example.c
if errorlevel 1 exit /b 1

link /nologo /OUT:test_example.exe test_example.obj ..\lib\homfly.lib "%LIBRARY_LIB%\gc.lib"
if errorlevel 1 exit /b 1

set "PATH=%CD%\..\lib;%PATH%"
test_example.exe data.txt
if errorlevel 1 exit /b 1

cd ..\lib
copy homfly.dll "%LIBRARY_BIN%\"
if errorlevel 1 exit /b 1

copy homfly.lib "%LIBRARY_LIB%\"
if errorlevel 1 exit /b 1

copy homfly.h "%LIBRARY_INC%\"
if errorlevel 1 exit /b 1