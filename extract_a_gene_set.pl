# December 1st 2011
# The input is a list of gene IDs
# Output: FASTA file containing the corresponding sequences
# This cript does not report IDs that are not found in the fasta file

#! /usr/perl/bin -w
use strict;

=pod
print "\nInput path to the files:";
my $path=<STDIN>;
chomp($path);

print "\nInput file containing list of gene IDs:";
my $filein=<STDIN>;
chomp($filein);

print "\nInput FASTA file containing gene sequences:";
my $fasta_file=<STDIN>;
chomp($fasta_file);
=cut

my $path2="/home/mnguyen/Research/Lysozyme/GH22_all_27Nov2017/CLAN_fullseqs/BLASTP";
my $path1="/home/mnguyen/Research/Lysozyme/GH22_all_27Nov2017/CLAN_fullseqs";
my $filein="Batch6_selected_11Dec2017.txt";
my $fasta_file="GH22_all_full.fasta";
my $fileout=substr($filein,0,-4);
$fileout=$fileout.".fasta";

############################################################
open(Fasta_file,"<$path1/$fasta_file") || die "Cannot open file $fasta_file";
my %fasta;
my $fasta_key="";
my $seq="";

while (<Fasta_file>)
{
	my $fasta_line=$_;
	$fasta_line=~s/^\s*//;$fasta_line=~s/\s*$//;
	if ($fasta_line=~/^\>/)
	{
		if ($seq)
		{
			$seq=~s/\s*//g;
			$fasta{$fasta_key}=$seq;
			$seq="";
			$fasta_key="";
		}
		$fasta_key=$fasta_line;
		$fasta_key=~s/\>//;

		if ($fasta_key=~/^Bacteria\_/){$fasta_key=~s/^Bacteria\_//;}
		else
		{
			if ($fasta_key=~/\|/)
			{
				my @cols=split(/\|/,$fasta_key);
				$fasta_key=$cols[1];
			}else{$fasta_key=~s/^NFE\_//;}
		}

		#$fasta_key=~s/\s*//g;
	}
	else{$seq=$seq.$fasta_line;}
}
$seq=~s/\s*//g;
$fasta{$fasta_key}=$seq;
close (Fasta_file);
################################################################
open(In,"<$path2/$filein")|| die "Cannot open file $filein";
open(Out,">$path2/$fileout")|| die "Cannot open file $fileout";
while (<In>)
{
	# Spoth2p4_010268
	#$_=~s/\s*//g;
	$_=~s/^\s*//;$_=~s/\s*$//;
	$_=~s/\_+$//;
	my $sequence=$fasta{$_};
	if ($sequence){print Out ">$_\n$sequence\n";}
	else{print "\nWarning: (line ".__LINE__."): sequence not found for this ID: $_\n";}
}

close(In);
close(Out);