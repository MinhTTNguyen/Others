# January 30th 2013
# This script is to add more information to the BLASTP search result file downloaded from NCBI
# The supplemented information include: query/target sequence length, query/target coverage, Target protein name, Organism, taxonomic information
# Input file: Hit table (text file) of the BLASTP search result downloaded from NCBI

#! C:\Perl64\bin -w
use strict;
use HTTP::Request;
use LWP::UserAgent;

print "\nInput path to folder containing text files of BLASTP hit tables:";
my $path=<STDIN>;
chomp($path);

print "\nInput name of folder containing text files of BLASTP hit tables:";
my $folder_BLASTP=<STDIN>;
chomp($folder_BLASTP);

print "\nInput name of folder containing query sequences (FASTA files):";
my $folder_query=<STDIN>;
chomp($folder_query);

# create %hash_query_len #############################################
my %hash_query_len; #key=query_id, value=len
opendir(Query,"$path\\$folder_query") || die "\nCannot open folder $folder_query\n";
my @query_files=readdir(Query);
shift(@query_files);shift(@query_files);
closedir(Query);
foreach my $query_file (@query_files)
{
	open(Query_file,"<$path\\$folder_query\\$query_file") || die "\nCannot open file $query_file\n";
	my ($query_id, $query_seq);
	while (<Query_file>)
	{
		chomp($_);
		if ($_=~/^\>/)
		{
			if ($query_seq)
			{
				my $query_len=length($query_seq);
				$hash_query_len{$query_id}=$query_len;
				$query_id="";
				$query_seq="";
			}
			$query_id=$_;
			$query_id=~s/^\>//;
		}else {$_=~s/\s*//g;$query_seq=$query_seq.$_;}
	}
	my $query_len=length($query_seq);
	$hash_query_len{$query_id}=$query_len;
	close(Query_file);
}
######################################################################

# add information to hit table #######################################
opendir(BLASTP,"$path\\$folder_BLASTP") || die "\nCannot open folder $folder_BLASTP\n";
my @blastp_files=readdir(BLASTP);
shift(@blastp_files);shift(@blastp_files);
closedir(BLASTP);

my $folderout=$folder_BLASTP."_ADDED_INFO";
mkdir "$path\\$folderout";

foreach my $blastp_file (@blastp_files)
{
	open(Blastp_file,"<$path\\$folder_BLASTP\\$blastp_file") || die "\nCannot open file $blastp_file\n";
	open(Out,">$path\\$folderout\\$blastp_file") || die "\nCannot open output file $blastp_file\n";
	print Out "Query_id\tSubject_id\tProtein_name\tBit_score\tPercent_identity\tPercent_similarity\tE-value\tQuery_cov\tTarger_cov\tOrganism\tLineage\n";
	
	while (<Blastp_file>)
	{
		chomp($_);
		my ($q_id, $s_id, $iden, $si, $evalue, $bit_score, $s_len, $s_name, $species, $f1, $lineage, $q_start, $q_end, $s_start, $s_end, $q_len, $q_cov, $s_cov);
		
		#ANAMU_21170_Ala_cyt	gi|325280523|ref|YP_004253065.1|;gi|324312332|gb|ADY32885.1|	41.44	57.14	847	423	17	16	845	6	796	0.0	  600
		if ($_=~/^(.+)\t(.+)\t(.+)\t(.+)\t.+\t.+\t.+\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)/)
		{
			$q_id=$1;
			$s_id=$2;
			$iden=$3;
			$si=$4;
			$q_start=$5;
			$q_end=$6;
			$s_start=$7;
			$s_end=$8;
			$evalue=$9;
			$bit_score=$10;
			$q_len=$hash_query_len{$q_id};
			$q_cov=($q_end-$q_start+1)/$q_len;
			if ($s_id=~/^gi\|(\d+)/)
			{
				$s_id=$1;
				my $t1 = LWP::UserAgent->new;
				my $Genpept_entry=HTTP::Request->new(GET => "http\:\/\/eutils\.ncbi\.nlm\.nih\.gov\/entrez\/eutils\/efetch\.fcgi\?db\=protein\&id\=$s_id\&rettype\=genpept\&retmode\=gp");
				my $t2 = $t1->request($Genpept_entry, "$path\\temp.txt");
				open(FILE,"<$path\\temp.txt") || die "\nCannot open file temp.txt\n";
				while (<FILE>)				
				{
					chomp($_);
					#LOCUS       YP_004253065             877 aa            linear   BCT 24-DEC-2012
					if ($_=~/^LOCUS/)
					{
						if ($_=~/\s+(\d+)\s*aa\s+/){$s_len=$1;}
						else {print "Abnormal LOCUS line:\n$_";exit;}
					}
					#DEFINITION  alanyl-tRNA synthetase [Odoribacter splanchnicus DSM 20712].
					if ($_=~/^DEFINITION/)
					{
						if ($_=~/^DEFINITION\s+(.*)\s+\[/){$s_name=$1;}
						elsif ($_=~/^DEFINITION\s+(.*)/){$s_name=$1;}
						else {print "Abnormal LOCUS line:\n$_";exit;}
					}
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
			}
			else {print "\nPattern of subject id line is not as described!\n$s_id\n";exit;}
			$s_cov=($s_end-$s_start+1)/$s_len;
			print Out "$q_id\t$s_id\t$s_name\t$bit_score\t$iden\t$si\t$evalue\t$q_cov\t$s_cov\t$species\t$lineage\n";
		}else
		{
			$_=~s/\s*//g;
			if ($_){unless ($_=~/^\#/){print "\nPattern of line is not as described!\n$_\n";exit;}}
		}
	}
	close(Blastp_file);
	close(Out);
}
######################################################################