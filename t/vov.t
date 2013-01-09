#!perl

use warnings;
use strict;

use Test::More;

use lib 't';
use Util;

my @tests = (
  { name     => 'I, Roman',
    cmd      => [qw{./vov I}],
    expected => q{c e g},
    lines    => 1,
  },
);

# by three as Util.pm has a was-something-on-stderr test in addition to
# the two in the loop below
plan tests => @tests * 3;

for my $test (@tests) {
  my @output = run_util( @{ $test->{cmd} } );
  is( $output[0],     $test->{expected}, $test->{name} . " output" );
  is( scalar @output, $test->{lines},    $test->{name} . " lines" );
}
