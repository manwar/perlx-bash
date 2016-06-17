package PerlX::bash;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT = ('bash');

# VERSION


use Contextual::Return;
use IPC::System::Simple qw< run capture EXIT_ANY $EXITVAL >;


sub bash
{
	my (@opts, $capture);
	my $exit_codes = [0..125];

	while ( $_[0] =~ /^-/ or ref $_[0] )
	{
		my $arg = shift;
		if (ref $arg)
		{
			die("bash: multiple capture specifications") if $capture;
			$capture = $$arg;
		}
		elsif ($arg eq '-e')
		{
			$exit_codes = [0];
		}
		else
		{
			push @opts, $arg;
		}
	}

	my @cmd = 'bash';
	push @cmd, @opts;
	push @cmd, '-c';

	if ($capture)
	{
		my $IFS = $ENV{IFS};
		$IFS = " \t\n" unless defined $IFS;

		my $output = capture [0..125], qw< bash -c >, shift;
		if ($capture eq 'string')
		{
			return $output;
		}
		elsif ($capture eq 'lines')
		{
			return split("\n", $output);
		}
		elsif ($capture eq 'words')
		{
			return split(/[$IFS]+/, $output);
		}
		else
		{
			die("bash: unrecognized capture specification [$capture]");
		}
	}
	else
	{
		run $exit_codes, @cmd, shift;
		return
			BOOL	{	$EXITVAL == 0	}
			SCALAR	{	$EXITVAL		}
		;
	}
}


1;

# ABSTRACT: tighter integration between Perl and bash
# COPYRIGHT

__END__
