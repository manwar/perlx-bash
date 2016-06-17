use Test::Most 0.25;

use PerlX::bash;


my $proglet = 'print "A 1\nB  2\n\nC 3\n"';

# capture as string
my $str = bash \string => "$^X -e '$proglet'";
is $str, "A 1\nB  2\n\nC 3\n", "bash \\string captures to scalar";

# capture as lines
my @lines = bash \lines => "$^X -e '$proglet'";
cmp_deeply [@lines], ["A 1", "B  2", "", "C 3"], "bash \\lines captures to array";

# capture as words
my @words = bash \words => "$^X -e '$proglet'";
cmp_deeply [@words], [qw< A 1 B 2 C 3 >], "bash \\words captures to array";

# capture as words but use $IFS
{
	local $ENV{IFS} = ":\n";
	my @words = bash \words => 'echo $PATH';		# this is the $PATH env var (note single quotes)
	cmp_deeply [@words], [split(':', $ENV{PATH})], 'bash \\words uses $IFS';
}


# check for errors
throws_ok { bash \bmoogle => 'exit' } qr/unrecognized capture specification/, 'proper error on unknown';
throws_ok { bash \string => \lines => 'exit' } qr/multiple capture specifications/, 'proper error on multiple';


done_testing;
