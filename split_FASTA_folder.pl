=pod
August 5th 2015
Split a large fasta file which is stored in a folder into smaller fasta files
(files in the fasta folder can contain truncated sequences or sequences without ID lines; therefore, it is necessary to re-create another folder 
containing complete fasta sequences)
=cut

#! C:\Perl64\bin -w
use strict;

print "\nInput working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput fasta folder: ";
my $folderin=<STDIN>;
chomp($folderin);

print "\nInput folder containing output files: ";
my $folderout=<STDIN>;
chomp($folderout);

print "\nNumber of sequences in each output file: ";
my $seqcount_each_file=<STDIN>;
chomp($seqcount_each_file);

print "\nPrefix of output file: ";
my $prefix=<STDIN>;
chomp($prefix);

mkdir "$path\\$folderout";

opendir(DIR,"$path\\$folderin") || die "Cannot open folder $folderin";
my @files=readdir(DIR);
shift(@files);shift(@files);
closedir(DIR);
my $seq="";
my $id="";
my $seq_count=0;
my $filecount=1;
my $fileout=$prefix."_".$filecount.".fasta";
open(Out,">$path\\$folderout\\$fileout") || die "Cannot open file $fileout";
foreach my $filein (@files)
{
	open(In,"<$path\\$folderin\\$filein") || die "Cannot open file $filein";
	while (<In>)
	{
		chomp($_);
		if ($_=~/^\>/)
		{
			if ($seq)
			{
				$seq=uc($seq);
				$seq=~s/\s*//g;
				if ($seq_count>$seqcount_each_file)
				{
					close(Out);
					$filecount++;
					$seq_count=0;
					$fileout=$prefix."_".$filecount.".fasta";
					open(Out,">$path\\$folderout\\$fileout") || die "Cannot open file $fileout";
				}
				print Out "$id\n$seq\n";
				$seq_count++;
				$id="";
				$seq="";
			}
			$id=$_;
		}else{$seq=$seq.$_;}
	}
	close(In);
}


if ($seq)
{
	$seq=uc($seq);
	$seq=~s/\s*//g;
	print Out "$id\n$seq\n";
	close(Out);
}else{print "Warning: no sequence found for the last ID\n";}
	


