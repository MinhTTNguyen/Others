# December 1st 2011
# The input is a list of gene IDs
# Output: FASTA file containing the corresponding sequences
# This cript does not report IDs that are not found in the fasta file

# Modified on January 29 2016
# ID list: AN4493
# ID line in fasta: >AN4493 rpdA
# print list of ID not having sequences

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

my $filein="/home/mnguyen/Research/Aspergillus_exoproteomes/All_CAZymes_currentJGIAspac1_Aspni7_9Mar2018/Exoproteomes/ProteinIDs/AnigerCBS.txt";
my $fasta_file="/home/mnguyen/Research/Aspergillus_exoproteomes/All_CAZymes_currentJGIAspac1_Aspni7_9Mar2018/Proteomes/Aspni_DSM_1_GeneCatalog_proteins_20130526.aa.fasta";
my $fileout="/home/mnguyen/Research/Aspergillus_exoproteomes/All_CAZymes_currentJGIAspac1_Aspni7_9Mar2018/Exoproteomes/Fulseqs/A_clavatus.fasta";

############################################################
open(Fasta_file,"<$fasta_file") || die "Cannot open file:\n$fasta_file\n";
my %fasta;
my $fasta_key="";
my $seq="";

while (<Fasta_file>)
{
	my $fasta_line=$_;
	$fasta_line=~s/\s*$//;
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
		$fasta_key=~s/\s+.*$//;
	}else{$fasta_line=~s/\s*//g;$seq=$seq.$fasta_line;}
}
$seq=~s/\s*//g;
$fasta{$fasta_key}=$seq;
close (Fasta_file);
my @ids=keys(%fasta);
################################################################



open(In,"<$filein")|| die "Cannot open file $filein";
open(Out,">$fileout")|| die "Cannot open file $fileout";
while (<In>)
{
	$_=~s/\s*//g;
	unless ($_){next;}
	my $sequence=$fasta{$_};
	if ($sequence) {print Out ">$_\n$sequence\n";}
	else
	{
		my $id_in_list=$_;
		foreach my $each_fasta_id (@ids)
		{
			if ($each_fasta_id=~/\Q$id_in_list\E/){$id_in_list=$each_fasta_id;last;}
		}
		my $sequence=$fasta{$id_in_list};
		if ($sequence) {print Out ">$_\n$sequence\n";}
		else{print "\nError (line".__LINE__."): no sequence found for this ID: $_\n";exit;}
	}
}

close(In);
close(Out);
