# February 2st 2013
# This script is to downloaded FASTA sequences from NCBI
# Input: a text file containing GI  numbers

#! C:\Perl64\bin -w
use strict;
use HTTP::Request;
use LWP::UserAgent;

print "\nInput path:";
my $path=<STDIN>;
chomp($path);

print "\nInput name of file containing GI numbers:";
my $filein=<STDIN>;
chomp($filein);

my $fileout=substr($filein,0,-4);
$fileout=$fileout.".fasta";

open(In,"<$path\\$filein") || die "\nCannot open file $filein\n";
my $gi_series;
while (<In>)
{
	$_=~s/\s*//g;
	$gi_series=$gi_series.",".$_;
}
my $t1 = LWP::UserAgent->new;
my $seq=HTTP::Request->new(GET => "http\:\/\/eutils\.ncbi\.nlm\.nih\.gov\/entrez\/eutils\/efetch\.fcgi\?db\=protein\&id\=$gi_series\&rettype\=fasta\&retmode\=fasta");
my $t2 = $t1->request($seq, "$path\\$fileout");
close(In);
