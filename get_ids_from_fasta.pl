# April 3rd 2017
# Get ids from fasta file

#! /usr/perl/bin -w
use strict;

my $filein="/home/mnguyen/Research/Albert/Shared/CAZy_family_distribution_in_AF_ANF_RB_NRB/CAZyme_prediction_data/ANF_Apr2017/ANF_corrected_May2017/Proteome_ANF/Neofr_Corrected.proteins.faa";
my $fileout="/home/mnguyen/Research/Albert/Shared/CAZy_family_distribution_in_AF_ANF_RB_NRB/CAZyme_prediction_data/ANF_Apr2017/ANF_corrected_May2017/Proteome_ANF/Neofr_Corrected.proteins_IDs.txt";

open(In,"<$filein") || die "Cannot open file $filein";
open(Out,">$fileout") || die "Cannot open file $fileout";
while (<In>)
{
	$_=~s/^\s*//;$_=~s/\s*$//;
	if ($_=~/^\>/)
	{
		my $id=$_;
		$id=~s/^\>//;
		print Out "$id\n";
	}
}
close(In);
close(Out);