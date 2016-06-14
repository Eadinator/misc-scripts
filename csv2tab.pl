#!/usr/bin/perl

use warnings;
use strict;

use Text::CSV qw//;

use open qw/:std :utf8/;

my $csv = Text::CSV->new({
binary => 1,
sep_char => ",",
auto_diag => 2,
}) or die Text::CSV->error_diag();

my $file = shift // die "Specify an input file";

open(my $fh, "<", $file) or die "Couldn't open $file: $!";

while (my $row = $csv->getline($fh))
{
	my @fields = @{$row};

	print join("\t", @fields), "\n";
}

$csv->eof or $csv->error_diag();

close($fh);
