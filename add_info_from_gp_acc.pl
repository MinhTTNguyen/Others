# January 30th 2013
# This script is to add more information to the BLASTP search result file downloaded from NCBI
# The supplemented information include: query/target sequence length, query/target coverage, Target protein name, Organism, taxonomic information
# Input file: Hit table (text file) of the BLASTP search result downloaded from NCBI

#! C:\Perl64\bin -w
use strict;
use HTTP::Request;
use LWP::UserAgent;

print "\nInput a text file containing list of protein accession numbers:";
my $filein=<STDIN>;
chomp($filein);

my $fileout=substr($filein,0,-4);
$fileout=$fileout."_added_taxa.txt";

open (In,"<$filein") || die "Cannot open $filein";
open (Out,">$fileout") || die "Cannot open $fileout";

while(<In>)
{
	$_=~s/\s*//g;
	my $acc=$_;
	my $t1 = LWP::UserAgent->new;
	my $Genpept_entry=HTTP::Request->new(GET => "http\:\/\/eutils\.ncbi\.nlm\.nih\.gov\/entrez\/eutils\/efetch\.fcgi\?db\=protein\&id\=$acc\&rettype\=genpept\&retmode\=gp");
	my $t2 = $t1->request($Genpept_entry, "temp.txt");
	open(FILE,"<temp.txt") || die "\nCannot open file temp.txt\n";
	my($species,$f1,$lineage);
	while (<FILE>)				
	{
		chomp($_);
		
		#	ORGANISM  Odoribacter splanchnicus DSM 20712
		#			  Bacteria; Bacteroidetes; Bacteroidia; Bacteroidales;
		#			  Porphyromonadaceae; Odoribacter.
		#REFERENCE   1
		if ($_=~/^\s+ORGANISM/)
		{
			if ($_=~/^\s+ORGANISM\s*(.+)/){$species=$1;$f1++;}
			else {print "Abnormal LOCUS line:\n$_";exit;}
		}
				
		if ($f1==1)
		{
			unless ($_=~/^\s+ORGANISM/)
			{
				if ($_=~/^\s+(\w*.*)/)
				{
					if ($lineage){$lineage=$lineage." ".$1;}
					else{$lineage=$1;}
				}
				if ($_=~/^\w+/){$f1=2;last;}
			}
		}
	}
	close(FILE);
	print Out "$acc\t$species\t$lineage\n";
}
close(In);
close(Out);
