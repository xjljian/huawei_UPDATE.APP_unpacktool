UPDATE.APP的大体结构:

windows中用winhex.exe将UPDATE.APP打开.linux下最好使用bless。


1. First 92 bytes are 0x00
2. Each file are started with 55AA 5AA5
3. Then 4 bytes for Packet(header) Length
4. Then 4 bytes for 0x00000001
5. Then 8 bytes for Hardware ID
6. Then 4 bytes for File Sequence (*)
7. Then 4 bytes for Data file length
8. Then 16 byts for File Date
9. Then 16 byts for File time
10.Then 16 byts for The word Input ?
11.Then 16 byts for Blank with 0x00
12.Then 2 bytes for the Checksum of the header
13.Then 2 bytes for always 0x1000 ?
14.Then 2 bytes for Blank [step 2-14 consumes 98bytes)
15.Then ($headerLength-98) bytes for file checksum
16.Then data file length bytes for files.
17.Then repeat 2 to 16




－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－



UPDATE.APP中单个模块分析：
  

这里定义 :定义1：从某个55aa5aa5开始(含)到下一个55aa5aa5(不含)间的数据称为为一个模块（module）;
          定义2：一个模块中,刷进手机分区的某部分数据,称为刷机文件;
	      定义3：一个模块中,去除刷机文件的另一个部分数据,称为头文件;或者去除版本文件后剩余部分也称为头文件.（有两个模块分别包含crc.mbn，MD5_RSA。类似）

          因此,模块=刷机文件+头文件.
		  或者,模块=版本文件+头文件.
		       模块=crc.mbn+头文件。
                        模块=MD5_RSA+头文件。

          定义4：我们将不同模块中相对应位置的多个字节称为结构。各个模块是有规律可寻的，我们一个个结构分析。
          

               

		  以下是UPDATE.APP中的某个模块,经过编辑处理，模块分成十几个结构分析：   
		  
                                        
 
2.Each module are started by     55 AA 5A A5                                             每个模块以55aa5aa5开始,它是UPDATE.APP的标识之一.解包工具首先以它为依据将强刷包分十几个模块（后去掉头文件，才将刷机文件与版本文件等输出到output目录)。

3.header Length                  64 00 00 00  (十六进制表示的字节数,高低位颠倒)          该值表示头文件的长度, 从55aa5aa5开始（含）到真正刷机文件(或版本文件)开始为止的一段文件的大小.即2-15结构包含的总字节. 强刷程序根据它计算刷机文件(在sd卡中)的相对开始地址.        
 
4.0x00000001                     01 00 00 00                                             固定                      

5.Hardware ID	                 48 57 38 78  32 35 FF FF                                8x25

6.File Sequence                  00 00 00 FB   (注意对比split_update.pl文件)             模块序号,作为模块标识,强刷程序根据它确定模块中刷机文件将要刷入哪个分区(当然有些文件不刷进手机，而用于效验).perl脚本根据该结构发现刷机文件.

7.Data file length               28 00 00 00                                             该结构标明真正要刷进手机的刷机文件的大小.强刷程序根据它及前面算出的开始地址校验并读取内容.    

8.File Date                      32 30 31 33  2E 30 33 2E  32 32 00 00  00 00 00 00      注明日期

9.File time                      31 37 2E 35  39 2E 33 33  00 00 00 00  00 00 00 00      时间,精确到秒.

10.The word Input                49 4E 50 55  54 00 00 00  00 00 00 00  00 00 00 00      固定的,作为UPDATE.APP的标识之一,与某些固定字节构成一种特定数据结构.强刷程序识别这样的数据结构是UPDATE.APP的一部分,才进一步将模块中的刷机文件写入手机存储芯片中. 由于sd卡中也可能存在其它包含55aa5aa5的数据结构.因而还需要其它标识构成特定结构.

11.Blank with 0x00               00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00      固定的16个0x00字节.可以与前一结构(第10结构)合并看待.

12.Unknow Checksum               96 86                                                   目前这两个字节我们无法校验生成并通过强刷的效验机制.预计它与crc.mbn,MD5_RSA是配套的.外国在这方面断续研究几年没有结果.原计划的UPDATE.APP重新打包失败.

13.always 0x1000                 00 10                                                   固定

14.2 bytes for Blank             00 00                                                   固定,第13与14结构可合并看待.

15.x bytes for file checksum     39 F3                                                   特殊的crc16的效验结果.外国网友已编译出linux下的效验程序（本工具中的crc）.  另,这里字节数不是固定的.是与刷机文件的大小相关的.这是可以理解的：文件越长，其效验结果需要越多的字节表示。

16.DATA file  :                  到这里刷机文件出现了. ( 该模块中前面部分是头文件. 头文件总字节＝98+第15结构的字节数 .也就是，从第2结构到第14结构结束止，共98字节，是固定的98字节。而第15结构字节数是不固定的。)                     

                                                                      01 00 00 00   
                                 03 00 00 00 00 00 05 60  00 00 54 2D F0 A3 08 00   
                                 F0 A3 08 00 F0 A3 5C 2D  00 00 00 00 F0 A3 5C 2D   
                                 00 00 00 00                                        


								 
								 
								 
								 
接着是下一个模块:
	
2.Each file are started by       55 AA 5A A5

3.                               省略

4.                               省略

...								 

  
  

     
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


解包工具的使用：

window下：
1.安装perl:   http://www.activestate.com/activeperl/downloads
   选择相应系统的版本安装。安装过程，其自动配置环境变量。

2.将UPDATE.APP文件置于与split_update-windows.pl批处理等在同一目录下。

3.双击“双击自动解包.bat”即可解包。

4.也可以使用工具自带的perl，但可能不能在某个系统版本中使用。


linux下的使用：
1.下载安装perl：sudo apt-get install perl

2.定位到工具文件目录，并将UPDATE.APP文件复制到该文件夹

3.给split_update-linux.pl以可执行权限：sudo chmod 755 split_update-linux.pl
  给crc以可执行权限：sudo chmod 755 crc

4.开始解包：  ./split_update-linux.pl UPDATE.APP
或者          ./split_update-linux.pl




该工具在Y300，G510，G330的高通CPU机型间通用.正确的输出文件名,支持各种用途。其它机型自测。MTK机型底层文件不同，所以文件名一定是不对应的。
