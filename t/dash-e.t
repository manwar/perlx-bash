use Test::Most 0.25;

use PerlX::bash;


lives_ok  { bash -e => "$^X -e 'exit 0'" }                                        'bash -e with clean exit lives';
throws_ok { bash -e => "$^X -e 'exit 1'" } qr/unexpectedly returned exit value /, 'bash -e with dirty exit dies';


done_testing;
