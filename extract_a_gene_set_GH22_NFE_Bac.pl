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
my $path1="/home/mnguyen/Research/Lysozyme/GH22_all_27Nov2017/CLAN_domain";
my $filein="Batch6_selected_11Dec2017_new.txt";
my $fasta_file="GH22_all_domains.fasta";
my $fileout=substr($filein,0,-4);
$fileout=$fileout."_domain.fasta";


############################################################
open(In,"<$path2/$filein")|| die "Cannot open file $filein";
my %hash_fullseq_id;
while (<In>)
{
	$_=~s/^\s*//;$_=~s/\s*$//;
	$hash_fullseq_id{$_}++;
}
close(In);
############################################################


############################################################
open(Fasta_file,"<$path1/$fasta_file") || die "Cannot open file $fasta_file";
open(Out,">$path2/$fileout")|| die "Cannot open file $fileout";
my $fasta_key="";
my %hash_fastaid_selected;
my $seq="";

while (<Fasta_file>)
{
	my $fasta_line=$_;
	$fasta_line=~s/^\s*//;$fasta_line=~s/\s*$//;
	if ($fasta_line=~/^\>/)
	{
		if ($seq)
		{
			if ($hash_fastaid_selected{$fasta_key})
			{
				$seq=~s/\s*//g;
				print Out ">$fasta_key\n$seq\n";
			}
			$seq="";
			$fasta_key="";
		}
		$fasta_key=$fasta_line;
		$fasta_key=~s/\>//;
		
		my @cols=split(/\|/,$fasta_key);
		my $domain_location=pop(@cols);
		my $temp=join("|",@cols);
		if ($temp=~/^Bacteria\_/){$temp=~s/^Bacteria\_//;}
		else
		{
			if ($temp=~/\|/){$temp=$cols[1];}
			else{$temp=~s/^NFE\_//;}
		}
		$fasta_key=$temp."|".$domain_location;
		if ($hash_fullseq_id{$temp}){$hash_fastaid_selected{$fasta_key}++;delete($hash_fullseq_id{$temp});}
	}else{$seq=$seq.$fasta_line;}
}
$seq=~s/\s*//g;
if ($hash_fastaid_selected{$fasta_key})
{
	$seq=~s/\s*//g;
	print Out ">$fasta_key\n$seq\n";
}
close (Fasta_file);
close(Out);

print "Followings are IDs of proteins whose domain sequences could not be found:\n";
while (my ($k, $v)=each(%hash_fullseq_id)){print "$k\n";}