#!/usr/bin/perl

use LWP::Simple qw/getstore $ua/;
$ua->agent('Zybot/0.1');
getstore("http://services.zysys.org/virus-killer/download/mbam.php", "mbam-setup.exe");
