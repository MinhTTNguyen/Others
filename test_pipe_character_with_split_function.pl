#! C:\Perl64\bin -w
use strict;
my $pathways="KEGG: 00010+2.7.1.11|KEGG: 00030+2.7.1.11|KEGG: 00051+2.7.1.11|KEGG: 00052+2.7.1.11|KEGG: 00680+2.7.1.11|MetaCyc: PWY-1042|MetaCyc: PWY-1861|MetaCyc: PWY-5484|MetaCyc: PWY-7385|Reactome: REACT_474|UniPathway: UPA00109";
print "\n$pathways\n";
my @all_pwys=split(/\|/,$pathways);
foreach my $element (@all_pwys)
{
	print "$element\n";
}