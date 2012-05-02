#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple qw/get $ua/;

# Error Information
# -1: Invalid Arguments
# 1: Safe
# 2: Unsafe
# 3: Error Communicating, Try again Later
# 4: No information
# 5: Malformed Query (Server Error / Processing Error)

if ($#ARGV != 0) {
    print -1;
	exit -1;
}
$ua->agent('Zybot/0.1');
while (1) {
    my $content = get('http://services.zysys.org/virus-killer/analyze/?program='.$ARGV[0]);
    if (!$content) {
        print 3;
	    exit 3;
    } elsif ($content == 0 || $content == 5) {
	    # Try again
    } else {
        print $content;
	    exit $content;
    }
}