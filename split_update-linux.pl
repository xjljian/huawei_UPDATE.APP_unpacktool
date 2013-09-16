#!/usr/bin/perl
######################################################################
#
#   File          : split_updata.pl
#   Author(s)     : McSpoon
#   Description   : Unpack a Huawei U8220 'UPDATA.APP' file.
#                   http://pulse.modaco.com
#
#   Last Modified : Thu 24 December 2009
#   By            : McSpoon
#
#   Last Modified : Wed 18 June 2010
#   By            : ZeBadger (z e b a d g e r @ h o t m a i l . c o m)
#   Comment       : Added filename selection
#
#   Last Modified : Wed 19 June 2010
#   By            : ZeBadger (z e b a d g e r @ h o t m a i l . c o m)
#   Comment       : Added CRC checking
#
#   xjljian fixed file name to Y300/G510 (only Qualcomm msm8x25 product not about MTK)  2013.09.10
#
#   How to repack?:http://www.modaco.com/topic/311344-repacking-updataapp-was-new-version-of-split-updatapl/page__hl__%20unpack
#                 :https://github.com/Red54/unupdatapp 
# 
######################################################################
 
use strict;
use warnings;
 
my %fileHash=(	"\x00\x00\x00\x00","system.img.ext4", #                  mmcblk0p17
		"\x00\x00\x00\x30","userdata.img.ext4", #                mmcblk0p18
		"\x00\x00\x00\x40","recovery.img", #                     mmcblk0p13
		"\x00\x00\x00\x70","cust.img.ext4", #                    mmcblk0p16
		"\x00\x00\x00\x80","fat.bin", #                          mmcblk0p3     ;amss.mbn +amsshd.mbn
		"\x00\x00\x00\xD2","partition0.bin", #mbr and ebr                      ;huawei 8x25_msimage.mbn part1 is bootloader_MBR(not equ partition0.bin)
		"\x00\x00\x00\xE0","oemsbl.mbn", #                       mmcblk0p6     ;huawei 8x25_msimage.mbn part4
		"\x00\x00\x00\xE2","qcsbl.mbn", #                        mmcblk0p2     ;huawei 8x25_msimage.mbn part3
                "\x00\x00\x00\xE3","emmc_appsboot.mbn", #              ; mmcblk0p11
                "\x00\x00\x00\xE4","splash.raw565", # bootloader logo  ; mmcblk0p5     ;bootloader fastboot logo
                "\x00\x00\x00\xE8","boot_versions_list.txt", #
                "\x00\x00\x00\xE9","current_boot_versions.txt", #
                "\x00\x00\x00\xEA","versions_list.txt", #
                "\x00\x00\x00\xEC","current_version.txt", #
                "\x00\x00\x00\xED","oeminfo.mbn", #                      mmcblk0p5      ;huawei 8x25_msimage.mbn part5 is oem_info.img(not equ oeminfo.mbn) 
                "\x00\x00\x00\xEE","modem_st1.mbn", #                    mmcblk0p9
                "\x00\x00\x00\xEF","modem_st2.mbn", #                    mmcblk0p10
                "\x00\x00\x00\xF0","qcsblhd_cfgdata.mbn", #              mmcblk0p1      ;huawei 8x25_msimage.mbn part2
                "\x00\x00\x00\xF1","oemsblhd.mbn", #                     mmcblk0p6      ;header of oemsbl    ;huawei 8x25_msimage.mbn part4 hd
                "\x00\x00\x00\xF3","emmc_appsboothd.mbn", #              mmcblk0p11     ;header of emmc_appsboot
                "\x00\x00\x00\xF4","same_40Byte_1_boot_hd.mbn", # boothd
                "\x00\x00\x00\xF6","same_40Byte_2_cust_hd.mbn", # custhd
                "\x00\x00\x00\xF9","same_40Byte_3_system_hd.mbn", # systemhd
                "\x00\x00\x00\xFA","same_40Byte_4_userdata_hd.mbn", # userdatahd
                "\x00\x00\x00\xFB","same_40Byte_5_recovery_hd.mbn", # recoveryhd
                "\x00\x00\x00\xFC","boot.img", #                         mmcblk0p12
                "\x00\x00\x00\xFE","crc.mbn", #crc  ;128B ;in header of UPDATE.APP ,  (begin in 193Byte,offset 192 .It Always 128Byte)
                "\x00\x00\x00\xFF","MD5_RSA", #MD5_RSA ; in header of UPDATE.APP , (after crc.mbn)
		# http://android-dls.com/wiki/index.php?title=How_to_unpack_and_repack_NB0_file
		# https://docs.symbol.com/ReleaseNotes/Release%20Notes%20-%20MC659BOS23001.htm
	);

my $unknown_count=0;

# Turn on print flushing.
$|++;
 
# Unsigned integers are 4 bytes.
use constant UINT_SIZE => 4;
 
# If a filename wasn't specified on the commmand line then
# assume the file to be unpacked is called "UPDATE.APP". 
my $FILENAME = undef;
if ($#ARGV == -1) {
	$FILENAME = "UPDATE.APP";
}
else {
	$FILENAME = $ARGV[0];
}
 
open(INFILE, $FILENAME) or die "Cannot open $FILENAME: $!\n";
binmode INFILE;
 
# Skip the first 92 bytes, they're blank.
#seek(INFILE, 92, 0);
 
# We'll dump the files into a folder called "output".
my $fileLoc=0;
my $BASEPATH = "output/";
mkdir $BASEPATH;

while (!eof(INFILE))
{
	$fileLoc=&find_next_file($fileLoc);
	seek(INFILE, $fileLoc, 0);
	$fileLoc=&dump_file();
}

close INFILE;
 

# Find the next file block in the main file
sub find_next_file
{
	my ($_fileLoc) = @_;
	my $_buffer = undef;
	my $_skipped=0;

	read(INFILE, $_buffer, UINT_SIZE);
	while ($_buffer ne "\x55\xAA\x5A\xA5" && !eof(INFILE))
	{
		read(INFILE, $_buffer, UINT_SIZE);
		$_skipped+=UINT_SIZE;
	}

	return($_fileLoc + $_skipped);
}
 
# Unpack a file block and output the payload to a file.
sub dump_file {
    my $buffer = undef;
    my $outfilename = undef;
    my $fileSeq;
    my $calculatedcrc = undef;
    my $sourcecrc = undef;
    my $fileChecksum;
 
    # Verify the identifier matches.
    read(INFILE, $buffer, UINT_SIZE); # Packet Identifier
    unless ($buffer eq "\x55\xAA\x5A\xA5") { die "Unrecognised file format. Wrong identifier.\n"; }
    read(INFILE, $buffer, UINT_SIZE); # Packet Length.
    my ($headerLength) = unpack("V", $buffer);
    read(INFILE, $buffer, 4);         # Always 01 00 00 00
    read(INFILE, $buffer, 8);         # Hardware ID
    read(INFILE, $fileSeq, 4);        # File Sequence
    if (exists($fileHash{$fileSeq})) {
	$outfilename=$fileHash{$fileSeq};
    } else {
	$outfilename="unknown_file.$unknown_count";
        printf " Unknown file %s found.", slimhexdump($fileSeq);  #  To set it,we can known the $fileSeq of unknownfile,then add it and fix name
	$unknown_count++;
    }
    
    read(INFILE, $buffer, UINT_SIZE); # Data file length
    my ($dataLength) = unpack("V", $buffer);
    read(INFILE, $buffer, 16);        # File date
    read(INFILE, $buffer, 16);        # File time
    read(INFILE, $buffer, 16);        # The word INPUT ?
    read(INFILE, $buffer, 16);        # Blank
    read(INFILE, $buffer, 2);         # Checksum of the header maybe?
    read(INFILE, $buffer, 2);         # Always 00 10
    read(INFILE, $buffer, 2);         # Blank  00 00

    # Grab the checksum of the file
    read(INFILE, $fileChecksum, $headerLength-98);
    $sourcecrc=slimhexdump($fileChecksum);
    
    # Dump the payload.
    read(INFILE, $buffer, $dataLength);
    open(OUTFILE, ">$BASEPATH$outfilename") or die "Unable to create $outfilename: $!\n";
    binmode OUTFILE;
    print OUTFILE $buffer;
    close OUTFILE;

    $calculatedcrc=`./crc $BASEPATH$outfilename`;
    chomp($calculatedcrc);

    print STDOUT "Extracted $outfilename";
    if ($calculatedcrc eq $sourcecrc)
	{
		print " - CRC Okay\n";
	}
	else
	{
		print " - ERROR: CRC did not match\n";
	}
    
    # Ensure we finish on a 4 byte boundary alignment.
    my $remainder = UINT_SIZE - (tell(INFILE) % UINT_SIZE);
    if ($remainder < UINT_SIZE) {
    	# We can ignore the remaining padding.
    	read(INFILE, $buffer, $remainder);
    }
    
    return (tell(INFILE));
}

sub hexdump ()
{
        my $num=0;
        my $i;
        my $rhs;
        my $lhs;
        my ($buf) = @_;
        my $ret_str="";

        foreach $i ($buf =~ m/./gs)
        {
                # This loop is to process each character at a time.
                #
                $lhs .= sprintf(" %02X",ord($i));

                if ($i =~ m/[ -~]/)
                {
                        $rhs .= $i;
                }
                else
                {
                        $rhs .= ".";
                }

                $num++;
                if (($num % 16) == 0)
                {
                        $ret_str.=sprintf("%-50s %s\n",$lhs,$rhs);
                        $lhs="";
                        $rhs="";
                }
        }
        if (($num % 16) != 0)
        {
                $ret_str.=sprintf("%-50s %s\n",$lhs,$rhs);
        }

	return ($ret_str);
}
        
sub slimhexdump ()
{
        my $i;
        my ($buf) = @_;
        my $ret_str="";

        foreach $i ($buf =~ m/./gs)
        {
                # This loop is to process each character at a time.
                #
                $ret_str .= sprintf("%02X",ord($i));
        }

	return ($ret_str);
}
        
