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
	my @opts;
	my $exit_codes = [0..125];

	while ( $_[0] =~ /^-/)
	{
		my $arg = shift;
		if ($arg eq '-e')
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

	run $exit_codes, @cmd, shift;
	return
		BOOL	{	$EXITVAL == 0	}
		SCALAR	{	$EXITVAL		}
	;
}


1;

# ABSTRACT: tighter integration between Perl and bash
# COPYRIGHT

__END__
