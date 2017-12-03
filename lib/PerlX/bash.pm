package PerlX::bash;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT = ('bash');
our @EXPORT_OK = (@EXPORT, 'pwd');
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

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
			my @lines = split("\n", $output);
			return wantarray ? @lines : $lines[0];
		}
		elsif ($capture eq 'words')
		{
			my @words = split(/[$IFS]+/, $output);
			return wantarray ? @words : $words[0];
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


use Cwd ();
*pwd = \&Cwd::cwd;


1;

# ABSTRACT: tighter integration between Perl and bash
# COPYRIGHT
#
# This module is similar to the solution presented here:
# http://stackoverflow.com/questions/571368/how-can-i-use-bash-syntax-in-perls-system

__END__
