#!perl

use warnings;
use strict;

use Test::More;

eval 'use Test::Differences';    # display convenience
my $deeply = $@ ? \&is_deeply : \&eq_or_diff;

use lib 't';
use Util;

my @tests = (
  { cmd => [qw{./harmonic-fit c g}],
    expected =>
      [ "84\tc", "27\tg", "8\tf", "8\tais", "1\tcis", "1\tdis", "1\tgis" ],
  },
);

# by three as Util.pm has a was-something-on-stderr test in addition to
# the two in the loop below
plan tests => @tests * 2;

for my $test (@tests) {
  my @output = run_util( @{ $test->{cmd} } );
  s/\s+$// for @output;
  $deeply->( \@output, $test->{expected}, "@{$test->{cmd}}" );
}
