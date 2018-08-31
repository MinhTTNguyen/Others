#! C:\Perl64\bin -w
use strict;

my $folderin="C:\\Users\\tnguy\\Research\\Albert\\CAZyme\\Anaerobic_fungi\\dbCANv3_CBM10pfam\\Ian_data\\28Apr2015\\Unknown_domains\\Unknown_domain_longer150aa_seq";
my $fileout="Unknown_domain_longer150aa_seq_count.txt";

opendir(DIR,"$folderin") || die "Cannot open folder $folderin";
my @files=readdir(DIR);
shift(@files);shift(@files);
open(Out,">$fileout") || die "Cannot open file $fileout";
print Out "#Filename\tSeq_count\n";
foreach my $filein (@files)
{
	open(In,"<$folderin\\$filein")|| die "Cannot open file $filein";
	my $seq_count=0;
	while (<In>){if ($_=~/^\>/){$seq_count++;}}
	close(In);
	print Out "$filein\t$seq_count\n";
}
closedir(DIR);
close(Out);