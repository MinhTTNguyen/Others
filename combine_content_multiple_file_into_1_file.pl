=pod
20 august 2014
Combine content of multiple files into one file
=cut

#! C:\Perl64\bin -w 
use strict;

print "\nInput working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput folder containing files that you want to combine: ";
my $folderin=<STDIN>;
chomp($folderin);

my $fileout=$folderin.".txt";

opendir(DIR,"$path\\$folderin") || die "Cannot open folder $folderin";
my @fileins=readdir(DIR);
shift(@fileins);shift(@fileins);

open(Out, ">$path\\$fileout") || die "Cannot open file $fileout";

foreach my $filein (@fileins)
{
	open(In,"<$path\\$folderin\\$filein") || die "Cannnot open file $filein";
	while (<In>)
	{
		print Out "$_";
	}
	close(In);
}

closedir(DIR);
close(Out);