#! /usr/bin/perl -w

my $folderin="Proteomes";
my $folderout="Proteomes_v2";
mkdir $folderout;
opendir(DIR,"$folderin") || die "Cannot open folder $folderin";
my @files=readdir(DIR);
closedir(DIR);

foreach my $filein (@files)
{
	my $fileout=$filein;
	$fileout=~s/\s+/\_/g;
	$fileout=~s/\.faa/\.fasta/;
	unless (($filein eq ".") || ($filein eq ".."))
	{
		open(In,"<$folderin\/$filein") || die "Cannot open file $filein";
		open(Out,">$folderout\/$fileout") || die "Cannot open file $fileout";
		while (<In>){print Out "$_";}
		close(In);
		close(Out);
	}
}