#!perl

# NOTE trailing whitespace may or may not be present (trimmed and
# ignored in the tests).

use warnings;
use strict;

use Test::More;    # plan is down at bottom

eval 'use Test::Differences';    # display convenience
my $deeply = $@ ? \&is_deeply : \&eq_or_diff;

use lib 't';
use Util;

# Command to run, expected output lines (write a custom test, below, if
# this model does not suffice).
#
# NOTE most of these tests written several months after the code was
# worked out, so might just be confirming bad behavior; if in doubt,
# double check things against some other atonal software or
# documentation! Also, the tests are in no way complete, so more may be
# necessary to properly cover various edge cases or options to the
# various modes.
my @tests = (
  { cmd      => [qw{./atonal-util --sd=16 adjacent_interval_content 0 3 6 10 12}],
    expected => ['01220000'],
  },
  { cmd      => [qw{./atonal-util basic 0 4 7}],
    expected => [ '0,3,7', '001110', "3-11\tMajor and minor triad", "0,4,7\thalf_prime" ],
  },
  { cmd      => [qw{./atonal-util basic c e g}],
    expected => [ '0,3,7', '001110', "3-11\tMajor and minor triad", "0,4,7\thalf_prime" ],
  },
  { cmd      => [qw{./atonal-util basic --ly --tension=cope 0 1 2}],
    expected => [ 'c,cis,d', '210000', '3-1', '1.800  0.800  1.000' ],
  },
  { cmd      => [qw{./atonal-util --rs=_ basic c e g}],
    expected => [ '0_3_7', '001110', "3-11\tMajor and minor triad", "0_4_7\thalf_prime" ],
  },
  { cmd      => [qw{./atonal-util beats2set --scaledegrees=16 x..x ..x. ..x. x...}],
    expected => ['0,3,6,10,12'],
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
  { cmd      => [qw{./atonal-util freq2pitch --cf=422.5 440}],
    expected => ["440.00\t70"],
  },
  { cmd      => [qw{./atonal-util half_prime_form c b g}],
    expected => ['0,4,5'],
  },
  { cmd      => [qw{./atonal-util interval_class_content c fis b}],
    expected => ['100011'],
  },
  { cmd      => [qw{./atonal-util intervals2pcs --pitch=2 3 4 7}],
    expected => ['2,5,9,4'],
  },
  { cmd      => [qw{./atonal-util invariance_matrix 0 2 4}],
    expected => [ '0,2,4', '2,4,6', '4,6,8' ],
  },
  { cmd      => [qw{./atonal-util invert 1 2 3}],
    expected => ['11,10,9'],
  },
  { cmd      => [qw{./atonal-util ly2pitch c'}],
    expected => ['60'],
  },
  { cmd      => [qw{./atonal-util ly2struct --tempo=120 --relative=c' c4 r8}],
    expected => [ "\t{ 262, 500 },\t/* c4 */", "\t{ 0, 250 },\t/* r8 */" ],

  },
  { cmd      => [qw{./atonal-util multiply --factor=2 1 2 3}],
    expected => ['2 4 6'],
  },
  { cmd      => [qw{./atonal-util normal_form e g c}],
    expected => ['0,4,7'],
  },
  { cmd      => [qw{./atonal-util notes2time 1}],
    expected => ['4s'],
  },
  { cmd      => [qw{./atonal-util notes2time --ms --tempo=120 1}],
    expected => ['2000'],
  },
  { cmd      => [qw{./atonal-util notes2time --ms --tempo=160 c4*2/3 c c}],
    expected => [ '250', '250', '250', '= 750' ],
  },
  { cmd      => [qw{./atonal-util notes2time --fraction=2/3 c4. d8 e4}],
    expected => [ '1s', '333ms', '666ms', '= 2s' ],
  },
  { cmd      => [qw{./atonal-util pcs2forte 4 6 3 7}],
    expected => ['4-3'],
  },
  { cmd      => [qw{./atonal-util pcs2intervals 3 4 7}],
    expected => ['1,3'],
  },
  { cmd      => [qw{./atonal-util pitch2freq 60}],
    expected => ["60\t261.63"],
  },
  { cmd      => [qw{./atonal-util pitch2freq --cf=422.5 a'}],
    expected => ["69\t422.50"],
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
  { cmd      => [qw{./atonal-util set2beats --scaledegrees=16 4-z15}],
    expected => ['xx..x.x.........'],
  },
  { cmd      => [qw{./atonal-util set_complex 0 2 7}],
    expected => [ '0,2,7', '10,0,5', '5,7,0' ],
  },
  { cmd => [qw{./atonal-util subsets 3-1}],
    # NOTE might false alarm if permutation module changes ordering; if
    # so, sort the output?
    expected => [ '0,1', '0,2', '1,2', ],
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
  { cmd      => [qw{./atonal-util time2notes 1234}],
    expected => ['c4*123/100'],
  },
  { cmd      => [qw{./atonal-util transpose --transpose=7 0 6 11}],
    expected => ['7,1,6'],
  },
  { cmd      => [qw{./atonal-util transpose_invert --transpose=3 1 2 3}],
    expected => ['2,1,0'],
  },
  { cmd      => [qw{./atonal-util whatscalesfit c d e f g a b}],
    expected => [
      'C  Major                     c     d     e     f     g     a     b',
      'D  Dorian                    d     e     f     g     a     b     c',
      'E  Phrygian                  e     f     g     a     b     c     d',
      'F  Lydian                    f     g     a     b     c     d     e',
      'G  Mixolydian                g     a     b     c     d     e     f',
      'A  Aeolian                   a     b     c     d     e     f     g',
      'B  Locrian                   b     c     d     e     f     g     a',
      'A  Melodic minor     DSC     g     f     e     d     c     b     a',
    ],
  },
);

for my $test (@tests) {
  my @output = run_util( @{ $test->{cmd} } );
  s/\s+$// for @output;
  $deeply->( \@output, $test->{expected}, "@{$test->{cmd}}" );
}

# Custom tests for things that do not fit the above model well

my @fnums = run_util(qw{./atonal-util fnums});
$fnums[0] =~ s/\s+$//;
is( $fnums[0], "3-1\t0,1,2           \t210000", 'first forte number' );
is( scalar @fnums, 208, 'forte numbers count' );

my ( $sout, $serr ) = run_cmd_with_stderr(qw{./atonal-util --help});
ok( $serr->[0] =~ m/^Usage/, 'help emits to stderr' );

my ( $ivars, $ivars_serr ) =
  run_cmd_with_stderr(qw{./atonal-util invariants 3-9});
$deeply->(
  $ivars,
  [ 'T(0)   [ 0,2,7    ] ivars [ 0,2,7    ] 3-9',
    'T(2)   [ 2,4,9    ] ivars [ 2        ]',
    'T(5)   [ 5,7,0    ] ivars [ 7,0      ]',
    'T(7)   [ 7,9,2    ] ivars [ 7,2      ]',
    'T(10)  [ 10,0,5   ] ivars [ 0        ]',
    'Ti(0)  [ 0,10,5   ] ivars [ 0        ]',
    'Ti(2)  [ 2,0,7    ] ivars [ 2,0,7    ] 3-9',
    'Ti(4)  [ 4,2,9    ] ivars [ 2        ]',
    'Ti(7)  [ 7,5,0    ] ivars [ 7,0      ]',
    'Ti(9)  [ 9,7,2    ] ivars [ 7,2      ]',
  ],
  'invariences'
);
$deeply->( $ivars_serr, ['[0,2,7] icc 010020'], 'invarients stderr' );

my @vout = pipe_into_cmd( 't/variances', qw{./atonal-util variances} );
$deeply->( \@vout, [ '0,1,2,3', '4,5', '0,1,2,3,4,5' ], 'variances' );

my @zrouty = pipe_into_cmd( 't/zrelation-yes', qw{./atonal-util zrelation} );
is( $zrouty[0], 1, 'zrelation yes' );

my @zroutn = pipe_into_cmd( 't/zrelation-no', qw{./atonal-util zrelation} );
is( $zroutn[0], 0, 'zrelation no' );

# Util.pm has a was-something-on-stderr test, so times two
plan tests => 9 + @tests * 2;
