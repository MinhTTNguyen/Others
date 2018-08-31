# $remove_first_line:
# 0: remove first lines from 2 files
# 1: default; keep first line of one of the file (first line of 2 files should be the same)
# 2: keep everything from 2 files

#! C:\Perl64\bin -w
use strict;
use Getopt::Long;

my $file1="";
my $file2="";
my $fileout="";
my $remove_first_line=1;
GetOptions ('file1=s'=>\$file1,'file2=s'=>\$file2, 'out=s'=>\$fileout, 'remove_first_line=s'=>\$remove_first_line);

open(FILE1,"<$file1") || die "Cannot open file $file1";
open(FILE2,"<$file2") || die "Cannot open file $file2";
open(OUT,">$fileout") || die "Cannot open file $fileout";
my $firsline_file1=0;
my $firsline_file2=0;
while (<FILE1>)
{
	chomp($_);
	if ($firsline_file1){print OUT "$_\n";}
	else
	{
		$firsline_file1=1;
		if ($remove_first_line){print OUT "$_\n";}
	}
}

while (<FILE2>)
{
	chomp($_);
	if ($firsline_file2){print OUT "$_\n";}
	else
	{
		$firsline_file2=1;
		if ($remove_first_line)
		{
			if ($remove_first_line==2){print OUT "$_\n";}
		}
	}
}
close(FILE1);
close(FILE2);
close(OUT);
