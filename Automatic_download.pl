=pod
October 29th 2014
This script is to automatically download protein tables from Cazy
=cut

#! C:\Perl64\bin -w
use strict;
use File::Fetch;

print "\nInput working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput list of CaZy families to download: ";
my $file_cazy_list=<STDIN>;

mkdir "$path\\Temp";
chdir "$path\\Temp";
open(In,"<$path\\$file_cazy_list") || die "Cannot open file $file_cazy_list";
while (<In>)
{
	my $cazy_family=$_;
	$cazy_family=~s/\s*//g;
	
	#my $url_all='http://www.cazy.org/'.$cazy_family.'_all.html';
	my $url_all='http://metacyc.org/META/NEW-IMAGE?type=PATHWAY&object='.$cazy_family.'.html';
	print "$url_all";exit;
	my $ff = File::Fetch -> new(uri => $url_all);
	my $file = $ff -> fetch() || die $ff -> error;
	print "\nDownload file $file: done\n";
}
#rmdir "$path\\Temp";
close(In);