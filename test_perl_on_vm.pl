#! /usr/bin/perl -w
use strict;

print "\nTest perl on my VM: it works!\n";

print "\nTest cmd: ls -l\n";
my $cmd="ls -l";

system $cmd;