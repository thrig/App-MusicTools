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
  # Hindemith overtone ordering in G for something more complicated
  { cmd => [
      qw{./canonical --relative=g' --contrary --retrograde exact},
      "g d' c e b bes ees a, f' aes, fis' cis"
    ],
    expected => [q{cis gis fis' a, f' b, e dis ais d c g'}],
  },

  # modal mode tests
  # TODO
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
