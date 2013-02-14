#!perl

use warnings;
use strict;

use Test::More;

eval 'use Test::Differences';    # display convenience
my $deeply = $@ ? \&is_deeply : \&eq_or_diff;

use lib 't';
use Util;

my @help_commands = (
  [qw{./canonical --help}],
  [qw{./canonical exact --help}],
  [qw{./canonical modal --help}],
);

my @tests = (
  # exact mode tests
  { cmd      => [qw{./canonical --relative=c exact --transpose=7  0 4 7}],
    expected => [q{g b d}],
  },
  { cmd      => [qw{./canonical exact --transpose=7  c e g}],
    expected => [q{g b d'}],
  },
  { cmd      => [qw{./canonical exact --transpose=g  c e g}],
    expected => [q{g b d'}],
  },
  { cmd      => [qw{./canonical --raw exact --transpose=g  c e g}],
    expected => [q{55 59 62}],
  },
  { cmd      => [qw{./canonical --relative=c exact --contrary  c f g e a c}],
    expected => [q{c g f gis dis c}],
  },
  { cmd      => [qw{./canonical --raw exact --retrograde  1 2 3}],
    expected => [q{3 2 1}],
  },
  { cmd      => [qw{./canonical --flats exact --transpose=1  c e g}],
    expected => [q{des f aes}],
  },
  # Hindemith overtone ordering in G for something more complicated
  { cmd => [
      qw{./canonical --relative=g' --contrary --retrograde exact},
      "g d' c e b bes ees a, f' aes, fis' cis"
    ],
    expected => [q{cis gis fis' a, f' b, e dis ais d c g'}],
  },

  # modal tests - mostly just copied from Music-Canon/t/Music-
  # Canon.t cases.
  { cmd      => [qw{./canonical --relative=c modal --contrary  0 13}],
    expected => [q{c x}],
  },
  { cmd      => [qw{./canonical --relative=c modal --contrary --undef=q 0 8}],
    expected => [q{c q}],
  },
  { cmd => [
      qw{./canonical modal --contrary --retrograde --raw 0 2 4 5 7 9 11 12 14 16 17 19}
    ],
    expected => [q{-19 -17 -15 -13 -12 -10 -8 -7 -5 -3 -1 0}],
  },
  { cmd      => [qw{./canonical --rel=c modal --flats --sp=c --ep=bes}, '--output=1,4,1,4', qw{c cis d}],
    expected => [q{bes x b}],
  },
  { cmd      => [qw{./canonical --rel=c modal --flats --sp=c --ep=aes}, '--output=2,1,4,1', qw{c cis d}],
    expected => [q{aes a bes}],
  },
  { cmd      => [qw{./canonical --rel=c modal --flats --sp=c --ep=b}, '--output=4,1,4,2', qw{c cis d}],
    expected => [q{b des ees}],
  },
  { cmd      => [qw{./canonical --rel=c modal --chrome=-1 --flats --sp=c --ep=b}, '--output=4,1,4,2', qw{c cis d}],
    expected => [q{b c ees}],
  },
  { cmd      => [qw{./canonical --rel=c modal --chrome=1 --flats --sp=c --ep=b}, '--output=4,1,4,2', qw{c cis d}],
    expected => [q{b d ees}],
  },
);

for my $cmd (@help_commands) {
  my ( $sout, $serr ) = run_cmd_with_stderr(@$cmd);
  ok( $serr->[0] =~ m/^Usage/, "'@$cmd' emits to stderr" );
}

for my $test (@tests) {
  my @output = run_util( @{ $test->{cmd} } );
  s/\s+$// for @output;
  $deeply->( \@output, $test->{expected}, "@{$test->{cmd}}" );
}

plan tests => @help_commands + @tests * 2;
