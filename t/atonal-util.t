#!perl

# XXX need somewhat more complete coverage

use warnings;
use strict;

use Test::More tests => 2;

use lib 't';
use Util;

my @out = run_util(qw{./atonal-util prime_form 0 4 7});
is_deeply( \@out, ['0 3 7'], 'prime_form 0 4 7' );
