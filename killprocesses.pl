#!/usr/bin/perl
use strict;
use warnings;
use Win32::Process::List;

my $P = Win32::Process::List->new();
my %list = $P->GetProcesses();
open (DB, ">proc");
foreach my $key (keys %list) {
    print DB $list{$key} . " ;;;;; " . $key . "\n";
	if ($key != 0) {
	    print "Process: " . $list{$key} . "\n";
	    kill(1, $key);
	}
}
close (DB);