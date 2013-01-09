#!perl

use warnings;
use strict;

use Test::More tests => 6;

use lib 't';
use Util;

my @IV = run_util(qw{./varionator I V});
is_deeply( \@IV, ['I V'] );

my @IIIIV = run_util( qw{./varionator I}, '(II IV)' );
is_deeply( \@IIIIV, [ 'I II', 'I IV' ] );

my @triple = run_util( qw{./varionator c}, '(d f a)', '(g e b)', 'c' );
is_deeply(
  \@triple,
  [ 'c d g c', 'c d e c', 'c d b c', 'c f g c', 'c f e c', 'c f b c',
    'c a g c', 'c a e c', 'c a b c',
  ]
);
