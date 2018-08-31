# November 28th 2014
# This script is to split 1 large FASTA file into smaller ones
#
# January 12th 2016
# Modified so that the script can run on Unix system

#! /usr/perl/bin -w
use strict;

print "\nInput working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput FASTA file: ";
my $file_fasta=<STDIN>;
chomp($file_fasta);

print "\nInput number of sequences in each smaller FASTA file: ";
my $num_seq=<STDIN>;
chomp($num_seq);

my $folder_fasta=$file_fasta;
$folder_fasta=~s/\..+$//;

mkdir "$path/$folder_fasta";

###############################################################################################
open(FASTA,"<$path/$file_fasta") || die "Cannot open file $file_fasta"; 
my $id="";
my $seq="";
my $seq_count=0;
my $file_count=1;
my $fileout=$folder_fasta."_".$file_count.".fasta";
open (Out,">$path/$folder_fasta/$fileout") || die "Cannot open file $fileout";
while (<FASTA>)
{
	chomp($_);
	if ($_=~/^\>/)
	{
		if ($seq)
		{
			$seq=uc($seq);		
			$seq_count++;
			if ($seq_count>$num_seq)
			{
				close(Out);
				$file_count++;
				$fileout=$folder_fasta."_".$file_count.".fasta";
				open (Out,">$path/$folder_fasta/$fileout") || die "Cannot open file $fileout";
				$seq_count=1;
			}
			print Out "$id\n$seq\n";
			$seq="";
			$id="";
		}
		
		$id=$_;
	}else{$_=~s/\s*//g;$seq=$seq.$_;}
	
}
print Out "$id\n$seq\n";
close(FASTA);
close(Out);
###############################################################################################