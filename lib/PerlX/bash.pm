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
	run [0..125], qw< bash -c >, shift;
	return
		BOOL	{	$EXITVAL == 0	}
		SCALAR	{	$EXITVAL		}
	;
}


1;

# ABSTRACT: tighter integration between Perl and bash
# COPYRIGHT

__END__
