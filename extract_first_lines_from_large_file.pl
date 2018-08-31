=pod
july 20th 2015
This script is to extract the first 100 lines from a large file
=cut

#! C:\Perl64\bin -w
use strict;

print "\nInput path to the file: ";
my $path=<STDIN>;
chomp($path);

print "\nInput file name: ";
my $filein=<STDIN>;
chomp($filein);

my $fileout=substr($filein,0,-4);
$fileout=$fileout."_first_100_lines.txt";

open(IN,"<$path\\$filein") || die "Cannot open file $filein";
open(OUT,">$path\\$fileout") || die "Cannot open file $fileout";
my $line_count=0;
while (<IN>)
{
	print OUT "$_";
	$line_count++;
	if ($line_count==100){exit;}
}
close(IN);
close(OUT);