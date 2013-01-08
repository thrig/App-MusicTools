#!perl

use warnings;
use strict;

use Test::More tests => 9;

use lib 't';
use Util;

# XXX data structure of command line, expected output, that got one line
# of output could be bundled up then fed to one testing thing
my @default_output = run_util('./scalemogrifier');
is( $default_output[0], q{c d e f g a b c'}, 'default output' );
is( scalar @default_output, 1, 'expect one line default output' );

my @aeolian = run_util(qw{./scalemogrifier --mode=minor --transpose=a});
is( $aeolian[0], q{a b c d e f g a'}, 'aeolian output' );
is( scalar @aeolian, 1, 'expect one line aeolian output' );

my @raw = run_util(qw{./scalemogrifier --raw});
is( $raw[0], q{0 2 4 5 7 9 11 12}, 'default raw output' );
is( scalar @raw, 1, 'expect one line default raw output' );
