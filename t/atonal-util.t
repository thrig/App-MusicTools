#!perl

# NOTE trailing whitespace may or may not be present (trimmed and
# ignored in the tests).

use warnings;
use strict;

use Test::More;

use lib 't';
use Util;

# Command to run, expected output lines (write a custom test, below, if
# this model does not suffice).
#
# NOTE most of these tests written several months after worked out code,
# so might just be confirming bad behavior; if in doubt, double check
# things against some other atonal software or documentation! Also, the
# tests are in no way complete, so more may be necessary to properly
# cover various edge cases or options to the various modes.
my @tests = (
  { cmd      => [qw{./atonal-util basic 0 4 7}],
    expected => [ '0,3,7', '001110', '3-11' ],
  },
  { cmd      => [qw{./atonal-util basic c e g}],
    expected => [ '0,3,7', '001110', '3-11' ],
  },
  { cmd      => [qw{./atonal-util basic --ly --tension=cope 0 1 2}],
    expected => [ 'c,cis,d', '210000', '3-1', '1.800  0.800  1.000' ],
  },
  { cmd      => [qw{./atonal-util --rs=_ basic c e g}],
    expected => [ '0_3_7', '001110', '3-11' ],
  },
  { cmd      => [qw{./atonal-util circular_permute 0 1 2}],
    expected => [ '0 1 2', '1 2 0', '2 0 1' ],
  },
  { cmd      => [qw{./atonal-util combos 440 880}],
    expected => [
      "440.00+880.00 = 1320.00\t(88 error -1.49)",
      "880.00-440.00 = 440.00\t(69 error 0.00)"
    ],
  },
  { cmd      => [qw{./atonal-util combos c g}],
    expected => [
      "130.81+196.00 = 326.81\t(64 error 2.82)",
      "196.00-130.81 = 65.18\t(36 error 0.22)"
    ],
  },
  { cmd      => [ './atonal-util', 'complement', '0,1,2,3,4,5,7,8,9,10,11' ],
    expected => ['6'],
  },
  { cmd      => [qw{./atonal-util equivs 0 1 2 3 4 5 6 7 8 9 10 11}],
    expected => ['0 1 2 3 4 5 6 7 8 9 10 11'],
  },
  { cmd      => [qw{./atonal-util findall --fn=5 --root=0 c e g b a}],
    expected => ["5-27\tTi(0)\t0,11,9,7,4"],
  },
  { cmd      => [qw{./atonal-util findin --pitchset=4-23 --root=2 0 2 7 9}],
    expected => ["-\tTi(2)\t2,0,9,7"],
  },
  { cmd      => [qw{./atonal-util forte2pcs 9-3}],
    expected => ['0,1,2,3,4,5,6,8,9'],
  },
  { cmd      => [qw{./atonal-util freq2pitch 440}],
    expected => ["440.00\t69"],
  },
  { cmd      => [qw{./atonal-util interval_class_content c fis b}],
    expected => ['100011'],
  },
  { cmd      => [qw{./atonal-util invariance_matrix 0 2 4}],
    expected => [ '0,2,4', '2,4,6', '4,6,8' ],
  },
  { cmd      => [qw{./atonal-util invariants 3-9}],
    expected => [
      '[0,2,7] icc 010020',
      'T(2)   [ 2,4,9    ] invariants are: [ 2        ]',
      'T(5)   [ 5,7,0    ] invariants are: [ 7,0      ]',
      'T(7)   [ 7,9,2    ] invariants are: [ 7,2      ]',
      'T(10)  [ 10,0,5   ] invariants are: [ 0        ]',
      'Ti(2)  [ 2,0,7    ] invariants are: [ 2,0,7    ]',
      'Ti(4)  [ 4,2,9    ] invariants are: [ 2        ]',
      'Ti(7)  [ 7,5,0    ] invariants are: [ 7,0      ]',
      'Ti(9)  [ 9,7,2    ] invariants are: [ 7,2      ]',
    ],
  },
  { cmd      => [qw{./atonal-util invert 1 2 3}],
    expected => ['11,10,9'],
  },
  { cmd      => [qw{./atonal-util ly2pitch c'}],
    expected => ['60'],
  },
  { cmd      => [qw{./atonal-util multiply --factor=2 1 2 3}],
    expected => ['2 4 6'],
  },
  { cmd      => [qw{./atonal-util normal_form e g c}],
    expected => ['0,4,7'],
  },
  { cmd      => [qw{./atonal-util pcs2forte 4 6 3 7}],
    expected => ['4-3'],
  },
  { cmd      => [qw{./atonal-util pitch2freq 60}],
    expected => ["60\t261.63"],
  },
  { cmd      => [qw{./atonal-util pitch2intervalclass 4}],
    expected => ['4'],
  },
  { cmd      => [qw{./atonal-util pitch2intervalclass 8}],
    expected => ['4'],
  },
  { cmd      => [qw{./atonal-util pitch2ly 72}],
    expected => [q{c''}],
  },
  { cmd      => [qw{./atonal-util prime_form 0 4 7}],
    expected => ['0,3,7'],
  },
  { cmd      => [qw{./atonal-util recipe --file=t/rules 0 11 3}],
    expected => ['4,8,7'],
  },
  { cmd      => [qw{./atonal-util retrograde 1 2 3}],
    expected => ['3,2,1'],
  },
  { cmd      => [qw{./atonal-util rotate --rotate=3 1 2 3 4}],
    expected => ['2,3,4,1'],
  },
  { cmd      => [qw{./atonal-util set_complex 0 2 7}],
    expected => [ '0,2,7', '10,0,5', '5,7,0' ],
  },
  { cmd      => [qw{./atonal-util subsets 3-1}],
    expected => [ '0,1', '1,2', '0,2' ],
  },
  { cmd      => [qw{./atonal-util tcs 7-4}],
    expected => ['7 5 4 4 3 3 4 3 3 4 4 5'],
  },
  { cmd      => [qw{./atonal-util tcis 7-4}],
    expected => ['2 4 4 4 5 4 5 6 5 4 4 2'],
  },
  { cmd      => [qw{./atonal-util tension g b d f}],
    expected => ["1.000  0.100  0.700\t0.2,0.1,0.7"],
  },
  { cmd      => [qw{./atonal-util transpose --transpose=7 0 6 11}],
    expected => ['7,1,6'],
  },
  { cmd      => [qw{./atonal-util transpose_invert --transpose=3 1 2 3}],
    expected => ['2,1,0'],
  },
);

# Util.pm has a was-something-on-stderr test in addition to the one
# below, so times two
plan tests => 7 + @tests * 2;

for my $test (@tests) {
  my @output = run_util( @{ $test->{cmd} } );
  s/\s+$// for @output;
  is_deeply( \@output, $test->{expected}, "@{$test->{cmd}}" );
}

# Custom tests for things that do not fit the above model well

my @fnums = run_util(qw{./atonal-util fnums});
$fnums[0] =~ s/\s+$//;
is( $fnums[0], "3-1\t0,1,2           \t210000", 'first forte number' );
is( scalar @fnums, 208, 'forte numbers count' );

my ( $sout, $serr ) = run_cmd_with_stderr(qw{./atonal-util --help});
ok( $serr->[0] =~ m/^Usage/, 'help emits to stderr' );

my @vout = pipe_into_cmd( 't/variances', qw{./atonal-util variances} );
is_deeply( \@vout, [ '0,1,2,3', '4,5', '0,1,2,3,4,5' ], 'variances' );

my @zrouty = pipe_into_cmd( 't/zrelation-yes', qw{./atonal-util zrelation} );
is( $zrouty[0], 1, 'zrelation yes' );

my @zroutn = pipe_into_cmd( 't/zrelation-no', qw{./atonal-util zrelation} );
is( $zroutn[0], 0, 'zrelation no' );
