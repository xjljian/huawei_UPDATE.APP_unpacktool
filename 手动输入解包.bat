@echo off
TITLE UPDATE.APP刷机包解包工具 for windows --by xjljian
color A

echo.   您正在试图手动输入命令解包update.app
echo. =================================================
echo.
echo.   Y300与G510/G330高通机型 UPDATE.APP刷机包解包工具。精确文件名，各种用途。
echo.
echo.   1.为避免各种错误，请以管理员登陆。
echo.
echo.   2.您正在使用工具自带的perl。32位win7测试通过。
echo.      
echo.   3.更好地支持解包工作，可能需要下载
echo.   安装perl:   http://www.activestate.com/activeperl/downloads
echo.   选择相应系统的版本安装。安装过程，其自动配置环境变量。
echo.   
ECHO.   4.请确认UPDATE.APP文件与本文件在同一目录下。
echo.   
echo.   5.如果解包其它机型的update.app文件，或者任意MTK机型,不保证输出正确的文件名。
echo.
echo.   6.如果英文提示发现未知文件，是因待解包文件并非Y300/G510/G330高通机型的强刷文件。需要修改
echo.
echo.   7.如果解包指定机型外的机型的强刷文件,即使过程没有任何异常提示,也不保证输出的文件名对应其内容
echo.   
echo.   请按任意键继续。。。   
pause >nul
echo.
echo.
echo.
echo.
echo.     请手动输入perl\bin\perl.exe split_update-windows.pl update.app
echo.
echo.
echo.
echo.
echo.    请按任意键后再输入,并按回车键确认。
pause >nul         
call 1.bat


