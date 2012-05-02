#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple qw/get $ua/;

if ($#ARGV != 0) {
    print -1;
	exit -1;
}
$ua->agent('Zybot/0.1');
while (1) {
    my $content = get('http://services.zysys.org/virus-killer/time?'.$ARGV[0]);
	open(F, ">" . $ARGV[0]);
	print F $content;
	exit $content;
}