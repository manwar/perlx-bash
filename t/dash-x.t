use Test::Most 0.25;
use Test::Output;

use PerlX::bash;


stderr_is { bash -x => "$^X -e 'exit 0'" } "+ $^X -e 'exit 0'\n", 'basic bash -x works';


done_testing;
