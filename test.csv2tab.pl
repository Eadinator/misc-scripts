#!/usr/bin/perl

use warnings;
use strict;

use File::Basename qw/dirname/;
use IPC::System::Simple qw/capture/;

my $script = dirname(__FILE__) . "/csv2tab.pl";

# Rudimentary test script for csv2tab.pl

# Normal csv string
test( in => 'a,b,c', expected => "a\tb\tc" );

# Empty trailing field
test( in => 'a,b,', expected => "a\tb\t" );

# Field with embedded comma
test( in => 'a,"b,b",c', expected => "a\tb,b\tc" );

sub test
{
	my %test = @_;

	my $in = $test{"in"} . '\n';
	my $expected = $test{"expected"} . "\n";

	my $out = capture("bash", "-c", "$script <(echo -ne '$in')");

	if ($out ne $expected)
	{
		substitute_char(\$in, "\n");
		substitute_char(\$in, "\t");

		substitute_char(\$out, "\n");
		substitute_char(\$out, "\t");

		substitute_char(\$expected, "\n");
		substitute_char(\$expected, "\t");

		die qq/Test failed: in => "$in" | out => "$out" | expected => "$expected"\n/;
	}
}

sub substitute_char
{
	my $var = shift;
	my $char = shift;

	my $replacement = ($char eq "\n") ? '\n' :
	                  ($char eq "\t") ? '\t' : $char;

	$$var =~ s/$char/<col>$replacement<nocol>/g;

	$$var =~ s/<col>/\033[0;36m/g;
	$$var =~ s/<nocol>/\033[0m/g;
}
