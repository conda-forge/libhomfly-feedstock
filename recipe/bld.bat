@echo off
setlocal

echo === Entering lib build directory ===
cd lib
echo CWD=%CD%

echo === Compiling library sources ===
cl /nologo /O2 /MD /I. /I"%LIBRARY_INC%" /c ^
	bound.c control.c dllink.c homfly.c knot.c model.c order.c poly.c
if errorlevel 1 exit /b 1

echo === Linking homfly.dll and homfly.lib ===
link /nologo /DLL /OUT:homfly.dll /IMPLIB:homfly.lib ^
    /EXPORT:homfly_str /EXPORT:homfly /EXPORT:c_homfly ^
	bound.obj control.obj dllink.obj homfly.obj knot.obj model.obj order.obj poly.obj ^
	"%LIBRARY_LIB%\gc.lib"
if errorlevel 1 exit /b 1

echo === Contents of lib directory after link ===
dir

if not exist homfly.lib (
	echo ERROR: homfly.lib was not generated.
	echo Expected import library at %CD%\homfly.lib
	exit /b 1
)

echo === Entering test directory ===
cd ..\test
echo CWD=%CD%

echo === Compiling test_example.c ===
cl /nologo /O2 /MD /I. /I..\lib /I"%LIBRARY_INC%" /c test_example.c
if errorlevel 1 exit /b 1

echo === Linking test_example.exe ===
link /nologo /OUT:test_example.exe test_example.obj ..\lib\homfly.lib "%LIBRARY_LIB%\gc.lib"
if errorlevel 1 exit /b 1

set "PATH=%CD%\..\lib;%PATH%"
echo PATH=%PATH%

echo === Running upstream test suite ===
test_example.exe data.txt
if errorlevel 1 exit /b 1

echo === Installing artifacts ===
cd ..\lib
copy homfly.dll "%LIBRARY_BIN%\"
if errorlevel 1 exit /b 1

copy homfly.lib "%LIBRARY_LIB%\"
if errorlevel 1 exit /b 1

copy homfly.h "%LIBRARY_INC%\"
if errorlevel 1 exit /b 1

echo === Installed files ===
dir "%LIBRARY_BIN%\homfly.dll"
dir "%LIBRARY_LIB%\homfly.lib"
dir "%LIBRARY_INC%\homfly.h"