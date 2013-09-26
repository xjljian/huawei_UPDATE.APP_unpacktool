
&nbsp;<p>一:</p>
<p>
首先说说UPDATE.APP的大体结构。在这方面，三年前就已有第三方开发者进行了研究（如果这算是一种研究）。现在只是在前人的基础上分析华为固件的结构与工作方式.</p>
<p>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr><br></p>
<p>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
windows中用winhex.exe将UPDATE.APP打开。桌面版linux下最好使用bless。</p>
<p><br>
1. First 92 bytes are 0x00</p>
<p><br>
2. Each file are started with 55AA 5AA5<br>
3. Then 4 bytes for Packet(header) Length<br>
4. Then 4 bytes for 0x00000001<br>
5. Then 8 bytes for Hardware ID<br>
6. Then 4 bytes for File Sequence (*)<br>
7. Then 4 bytes for Data file length<br>
8. Then 16 byts for File Date<br>
9. Then 16 byts for File time<br>
10.Then 16 byts for The word Input ?<br>
11.Then 16 byts for Blank with 0x00<br>
12.Then 2 bytes for the Checksum of the header(maybe？)<br>
13.Then 2 bytes for always 0x1000 ?<br>
14.Then 2 bytes for Blank [step 2-14 consumes 98bytes)<br>
15.Then ($headerLength-98) bytes for file checksum<br>
16.Then data file length bytes for files.</p>
<p><br>
17.Then repeat 2 to 16</p>
<p>&nbsp;<wbr></p>
<p>&nbsp;<wbr></p>
<p>&nbsp;<wbr></p>
<p>&nbsp;<wbr>－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－</p>
<p>&nbsp;<wbr></p>
<p>&nbsp;<wbr></p>
<p>二:</p>
<p>UPDATE.APP中单个模块分析：<br>
&nbsp;<wbr></p>
<p>这里定义 :</p>
<p>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
定义1：从某个55 aa 5a a5开始(含)到下一个55 aa 5a
a5(不含)间的(看起来连续的)数据称为一个模块(module)。<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
定义2：一个模块中,刷进手机分区的某部分数据,称为刷机文件。<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
定义3：一个模块中,去除刷机文件的另一个部分数据,称为模块的头文件，简称头文件;或者去除版本文件后剩余部分也称为头文件.（有两个模块分别包含crc.mbn，MD5_RSA。类似）</p>
<p>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
因此,模块=头文件＋刷机文件<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
或者,模块=头文件＋版本文件<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
模块=头文件＋crc.mbn<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
模块=头文件＋MD5_RSA 。<br></p>
<p>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
定义4：我们将不同模块的相对应位置的多个字节称为一种结构。各个模块是有规律可寻的，我们一个个结构分析。<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr></p>
<p>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr></p>
<p>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
以下是UPDATE.APP中的某个模块。经过编辑处理，模块分成十几个结构分析：</p>
<p>&nbsp;<wbr></p>
<p>&nbsp;<wbr>&nbsp;<wbr>
为适应UPDATE.APP整体结构的需要,模块结构从2开始计数。其中，2至15结构为头文件，第16结构为刷机文件或版本文件等.</p>
<table style="WiDTH: 100%" border="1" cellpadding="3" cellspacing="1">
<tbody>
<tr>
<td>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
结构</td>
<td valign="top"><br>
字节数<br></td>
<td>结构相对应的数据(值)</td>
<td>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
简要说明</td>
</tr>
<tr>
<td>2. Each module are started<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
模块的开始<br></td>
<td valign="top"><br>
4<br></td>
<td>55 AA 5A A5</td>
<td>每个模块以55 aa 5a
a5开始,它是UPDATE.APP的标识之一.解包工具首先以它为依据将强刷包分十几个模块（后去掉头文件，才将刷机文件与版本文件等输出到output目录)。</td>
</tr>
<tr>
<td>3. header Length<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
头文件长度<br></td>
<td valign="top"><br>
4<br></td>
<td>64 00 00 00</td>
<td>
十六进制表示的字节数,高低位颠倒.&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
该值表示头文件的长度, 从55 aa 5a a5
开始（含）到真正刷机文件(或版本文件)开始为止的一段文件的大小.即2-15结构包含的总字节.
强刷程序根据它计算刷机文件(在sd卡中)的相对开始地址.</td>
</tr>
<tr>
<td>4. 0x00000001</td>
<td valign="top">4<br></td>
<td>01 00 00 00</td>
<td>固定</td>
</tr>
<tr>
<td>5. Hardware ID<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
硬件ID<br></td>
<td valign="top">8<br></td>
<td>48 57 38 78&nbsp;<wbr>32 35 FF FF</td>
<td>8x25</td>
</tr>
<tr>
<td>6. File Sequence<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
模块序号<br></td>
<td valign="top"><br>
4<br></td>
<td>00 00 00 FB</td>
<td>
(注意对比split_update.pl文件)&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
模块序号,作为模块标识,强刷程序根据它确定模块中刷机文件将要刷入哪个分区(当然有些文件不刷进手机，而用于效验).&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
perl脚本根据该结构发现刷机文件.</td>
</tr>
<tr>
<td>7. Data file length<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
刷机文件(等)的长度<br></td>
<td valign="top">4<br></td>
<td>28 00 00 00</td>
<td>该结构标明真正要刷进手机的刷机文件的大小.强刷程序根据它及前面算出的开始地址校验并读取内容.</td>
</tr>
<tr>
<td>8. File Date<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
日期<br></td>
<td valign="top"><br>
16<br></td>
<td>32 30 31 33&nbsp;<wbr>2E 30 33 2E&nbsp;<wbr>32 32
00 00&nbsp;<wbr>00 00 00 00</td>
<td>注明日期</td>
</tr>
<tr>
<td>9. File time<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
时间<br></td>
<td valign="top"><br>
16<br></td>
<td>31 37 2E 35&nbsp;<wbr>39 2E 33 33&nbsp;<wbr>00 00
00 00&nbsp;<wbr>00 00 00 00</td>
<td>时间,精确到秒.</td>
</tr>
<tr>
<td>10. The word "Input"<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
十六进制编辑器上看到的一个单词，“input”<br></td>
<td valign="top"><br>
<br>
16<br></td>
<td>49 4E 50 55&nbsp;<wbr>54 00 00 00&nbsp;<wbr>00 00
00 00&nbsp;<wbr>00 00 00 00</td>
<td>
固定的,作为UPDATE.APP的标识之一,与某些固定字节构成一种特定数据结构.强刷程序识别这样的数据结构是UPDATE.APP的一部分,才进一步将模块中的刷机文件写入手机存储芯片中.
由于sd卡中也可能存在其它包含55 aa 5a a5的数据结构.因而还需要其它标识构成特定结构.</td>
</tr>
<tr>
<td>11. Blank with 0x00<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
16个0x00<br></td>
<td valign="top"><br>
16<br></td>
<td>00 00 00 00&nbsp;<wbr>00 00 00 00&nbsp;<wbr>00 00
00 00&nbsp;<wbr>00 00 00 00</td>
<td>固定的16个 0x00字节.可以与前一结构(第10结构)合并看待.</td>
</tr>
<tr>
<td>12. Unknow Checksum<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
官方的未知方法生成的效验值<br></td>
<td valign="top"><br>
2<br></td>
<td>96 86</td>
<td>
目前这两个字节我们无法校验生成并通过强刷的效验机制.预计它与crc.mbn,MD5_RSA是配套的.外国在这方面断续研究几年没有结果.原计划的UPDATE.APP重新打包失败.</td>
</tr>
<tr>
<td>13. always 0x1000</td>
<td valign="top">2<br></td>
<td>00 10</td>
<td>固定</td>
</tr>
<tr>
<td>14. 2 byte Blank with 0x00<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
2个0x00<br></td>
<td valign="top">2<br></td>
<td>00 00</td>
<td>固定,第13与14结构可合并看待.</td>
</tr>
<tr>
<td>15. ($headerLength-98) bytes for file checksum<br>
<br>
&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
刷机文件(等)的效验值<br></td>
<td valign="top">不定<br></td>
<td>39 F3</td>
<td>特殊的crc16的效验结果.外国网友已编译出linux下的效验程序（工具中的crc）.&nbsp;<wbr>
另,这里字节数不是固定的.是与刷机文件的大小相关的.这是可以理解的：文件越长，其效验结果需要越多的字节表示。</td>
</tr>
<tr>
<td>16. DATA file<br>
<br>
&nbsp;<wbr>&nbsp;<wbr> 刷机文件(或者是版本文件，crc.mbn，<br>
MD5_RSA)<br></td>
<td valign="top">不定<br></td>
<td>01 00 00 00&nbsp;<wbr>03 00 00 00 00 00 05
60&nbsp;<wbr>00 00 54 2D F0 A3 08 00 F0 A3 08 00 F0 A3 5C
2D&nbsp;<wbr>00 00 00 00 F0 A3 5C 2D 00 00 00 00</td>
<td>到这里刷机文件出现了. ( 该模块中前面部分是头文件. 头文件总字节＝98+第15结构的字节数
.也就是，从第2结构到第14结构结束止，共98字节，是固定的98字节。而第15结构字节数是不固定的。)</td>
</tr>
<tr>
<td>&nbsp;<wbr></td>
<td valign="top"><br></td>
<td>&nbsp;<wbr></td>
<td>&nbsp;<wbr></td>
</tr>
<tr>
<td>紧接着下一个模块:</td>
<td valign="top"><br></td>
<td>&nbsp;<wbr></td>
<td>&nbsp;<wbr></td>
</tr>
<tr>
<td>2.Each file are started by</td>
<td valign="top">4<br></td>
<td>55 AA 5A A5</td>
<td>&nbsp;<wbr></td>
</tr>
<tr>
<td>3. header Length</td>
<td valign="top">4<br></td>
<td>省略</td>
<td>&nbsp;<wbr></td>
</tr>
<tr>
<td>4. 0x00000001</td>
<td valign="top">4<br></td>
<td>省略</td>
<td>&nbsp;<wbr></td>
</tr>
<tr>
<td>...</td>
<td valign="top">...<br></td>
<td>...</td>
<td>&nbsp;<wbr></td>
</tr>
<tr>
<td>16. DATA file</td>
<td valign="top">..<br></td>
<td>省略&nbsp;<wbr></td>
<td>&nbsp;<wbr></td>
</tr>
<tr>
<td>&nbsp;<wbr>下一个模块</td>
<td valign="top"><br></td>
<td>&nbsp;<wbr>...</td>
<td>&nbsp;<wbr></td>
</tr>
</tbody>
</table>
<p>&nbsp;<wbr></p>
<p>&nbsp;<wbr></p>
<p>&nbsp;<wbr></p>
<p>&nbsp;<wbr></p>
<p>－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－</p>
<p>&nbsp;<wbr></p>
<p>&nbsp;<wbr></p>
<p>三:<br>
解包工具的使用：</p>
<p>window下：<br>
1.安装perl:&nbsp;<wbr>&nbsp;<wbr> <a href="http://www.activestate.com/activeperl/downloads">http://www.activestate.com/activeperl/downloads</a><br>

&nbsp;<wbr>&nbsp;<wbr>
选择相应系统的版本安装。安装过程，其自动配置环境变量。</p>
<p>2.将UPDATE.APP文件置于与split_update-windows.pl批处理等在同一目录下。</p>
<p>3.双击“双击自动解包.bat”即可解包。</p>
<p>4.也可以使用工具自带的perl，但可能不能在某个系统版本中使用。</p>
<p><br>
linux下的使用：<br>
1.下载安装perl：sudo apt-get install perl</p>
<p>2.定位到工具文件目录，并将UPDATE.APP文件复制到该文件夹</p>
<p>3.给split_update-linux.pl以可执行权限：sudo chmod 755
split_update-linux.pl</p>
<p>给crc以可执行权限：chmod 755 crc</p>
<p>4.开始解包：&nbsp;<wbr> ./split_update-linux.pl
UPDATE.APP<br>
或者&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>&nbsp;<wbr>
./split_update-linux.pl</p>
<p>&nbsp;<wbr></p>
<p><br></p>
<p>&nbsp;<wbr>&nbsp;<wbr>
在工具目录output文件夹下大致生成20多个文件：</p>
<p><font style="font-size: 14px;" color="#000000">注意：以下所述文件对应分区仅限Y300，G510，G330的高通机型。其它型号与MTK机型不一定一样。更多信息可自行探讨<font color="#000000">。</font></font></p>
<p><font style="font-size: 14px;" color="#000000">方法也很简单，就是用dd<font color="#000000">命令从手机分区读出文件到sd卡<font color="#000000">，再adb
pull到电脑。后用十六进制编辑器对比就行了</font></font><br></font></p>
<p><br></p>
<table style="WiDTH: 100%" border="1" cellpadding="3" cellspacing="1">

<tbody>

<tr>
<td>文件</td>
<td>对应分区</td>
<td>作用</td>
</tr>

<tr>
<td>partition0.bin</td>
<td></td>
<td>乱改分区表文件,手机会变砖:分区描述文件，分为两部分。包括MBR与EBR。前512字节为MBR，后部分为EBR<br></td>
</tr>

<tr>
<td>qcsblhd_cfgdata.mbn</td>
<td>mmcblk0p1</td>
<td>随意修改该分区文件,手机会变砖:huawei bootloader ，<br></td>
</tr>

<tr>
<td>qcsbl.mbn</td>
<td>mmcblk0p2</td>
<td>随意修改该分区文件,手机会变砖: huawei bootloader</td>
</tr>

<tr>
<td>fat.bin</td>
<td>mmcblk0p3</td>
<td>modem，与网络有关</td>
</tr>

<tr>
<td></td>
<td></td>
<td></td>
</tr>

<tr>
<td>oeminfo.mbn</td>
<td>mmcblk0p5<br></td>
<td>包含huawei bootloader与串号，识别码，版本型号等信息，强刷时受到检查。</td>
</tr>

<tr>
<td>splash.raw565</td>
<td>mmcblk0p5</td>
<td>bootloader fastboot logo<br></td>
</tr>

<tr>
<td>oemsblhd.mbn</td>
<td>&nbsp;&nbsp;mmcblk0p6</td>
<td>随意修改该分区文件,手机会变砖:头文件<br></td>
</tr>

<tr>
<td>oemsbl.mbn</td>
<td>&nbsp;&nbsp;mmcblk0p6</td>
<td>随意修改该分区文件,手机会变砖: huawei bootloader</td>
</tr>

<tr>
<td>modem_st1.mbn</td>
<td>&nbsp;&nbsp;mmcblk0p9</td>
<td>与网络有关<br></td>
</tr>

<tr>
<td>modem_st2.mbn</td>
<td>&nbsp;&nbsp;mmcblk0p10</td>
<td>与网络有关</td>
</tr>

<tr>
<td>emmc_appsboothd.mbn</td>
<td>&nbsp;&nbsp;mmcblk0p11</td>
<td>随意修改该分区文件,手机会变砖:头文件</td>
</tr>

<tr>
<td>emmc_appsboot.mbn</td>
<td>&nbsp;&nbsp;mmcblk0p11</td>
<td>随意修改该分区文件,手机会变砖:引导系统启动，接收按键状态</td>
</tr>

<tr>
<td>boot.img</td>
<td>&nbsp;&nbsp;mmcblk0p12</td>
<td>...<br></td>
</tr>

<tr>
<td>recovery.img</td>
<td>&nbsp;&nbsp;mmcblk0p13</td>
<td>...<br></td>
</tr>

<tr>
<td>cust.img.ext4</td>
<td>&nbsp;&nbsp;mmcblk0p16</td>
<td>...<br></td>
</tr>

<tr>
<td>system.img.ext4</td>
<td>&nbsp;&nbsp;mmcblk0p17</td>
<td>...</td>
</tr>

<tr>
<td>userdata.img.ext4</td>
<td>&nbsp;&nbsp;mmcblk0p18</td>
<td>...</td>
</tr>

<tr>
<td>same_40Byte_1_boot_hd.mbn</td>
<td>不刷入手机<br></td>
<td>...</td>
</tr>

<tr>
<td>same_40Byte_2_cust_hd.mbn</td>
<td>不刷入手机</td>
<td>...</td>
</tr>

<tr>
<td>same_40Byte_3_system_hd.mbn</td>
<td>不刷入手机</td>
<td>...</td>
</tr>

<tr>
<td>same_40Byte_4_userdata_hd.mbn</td>
<td>不刷入手机<br></td>
<td>...</td>
</tr>

<tr>
<td>same_40Byte_5_recovery_hd.mbn</td>
<td>不刷入手机</td>
<td>...</td>
</tr>

<tr>
<td>crc.mbn</td>
<td>不刷入手机</td>
<td>强刷包效验依据</td>
</tr>

<tr>
<td>MD5_RSA</td>
<td>不刷入手机</td>
<td>效验值</td>
</tr>

<tr>
<td>current_boot_version.txt</td>
<td>不刷入手机</td>
<td>&nbsp;&nbsp;版本文件</td>
</tr>

<tr>
<td>current_version.txt</td>
<td>不刷入手机</td>
<td>&nbsp;&nbsp;版本文件</td>
</tr>

<tr>
<td>boot_versions_list.txt</td>
<td>不刷入手机</td>
<td>&nbsp;&nbsp;版本文件</td>
</tr>

<tr>
<td>versions_list.txt</td>
<td>不刷入手机</td>
<td>&nbsp;&nbsp;版本文件</td>
</tr>

</tbody>

</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>这些文件相当有用，比以往用于制作刷机包有更多的应用。</p>
<p><br></p>
<p>－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－</p>
<p><br></p>
<p>&nbsp;<wbr>&nbsp;<wbr>
该工具在Y300，G510，G330的高通CPU机型间通用，正确文件名。其它机型未必得到正确文件名（即使没有异常提示）。MTK机型底层文件不同，所以文件名一定是不对应的。</p>
<p>&nbsp;<wbr>&nbsp;<wbr>
据了解，u8825d的最新版本固件，并未发现partition0.mbn文件，也即分区表文件。也就是不更新的。这些需要注意。<br>
</p>
<p><br></p>
&nbsp;<p><wbr>&nbsp;<wbr>
如果有兴趣，可以给每个机型修正文件名。</p>
