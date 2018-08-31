=pod
January 12th 2015
This script is to copy file from one place to another
=cut

#! C:\Perl64\bin -w
use strict;
use File::Copy "cp";

my $sourcefile="test";
my $destinationfile="test1";

cp("$sourcefile\\split_2.faa","$destinationfile");



