@echo off
TITLE UPDATE.APP刷机包解包工具 for windows --by xjljian
color A


echo.
echo. =================================================
echo.
echo.   Y300与G510/G330高通机型 UPDATE.APP刷机包解包工具。精确文件名，各种用途。
echo.
echo.   1.为避免各种错误，请以管理员登陆。
echo.   
echo.   2.为了更好支持解包工作，需要下载
echo.   安装perl:   http://www.activestate.com/activeperl/downloads
echo.   选择相应系统的版本安装。安装过程，其自动配置环境变量。
echo.
echo.   3.当然可以使用工具自带的perl，方法：
echo.   启动cmd,并输入：  perl\bin\perl.exe split_update-windows.pl UPDATE.APP
echo.   32位（x86)win7测试通过。
echo.    
ECHO.   4.请确认UPDATE.APP文件与本文件在同一目录下。
echo.   
echo.   5.如果解包其它机型的update.app文件，或者任意MTK机型，不保证输出正确的文件名。
echo.
echo.   6.如果解包指定机型外的机型的强刷文件,即使过程没有任何异常提示,也不保证输出的文件名对应其内容
echo.       
echo.   请按任意键继续或者关闭本窗口退出。
echo.
echo. =================================================
echo.

pause >nul

cls
echo.   正在解包文件，请稍候。。。。。。
echo.
echo.   输出文件保存在本目录下output文件夹中
echo.
echo.    如果UPDATE.APP在工具目录，则正在解包。直到提示“按任意键退出”，解包成功。
echo.    如果英文提示发现未知文件，是因待解包的文件并非Y300/G510/G330高通机型的强刷文件。需要修改
echo.
perl split_update-windows.pl update.app
echo.                解包成功
echo.
echo.
echo.
if not exist update.app cls && echo.   没有找到UPDATE.APP文件，请检查

echo.                任意键退出


pause >nul

exit
