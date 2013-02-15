#!perl

use warnings;
use strict;

use Test::More;

eval 'use Test::Differences';    # display convenience
my $deeply = $@ ? \&is_deeply : \&eq_or_diff;

use lib 't';
use Util;

my @tests = (
  { cmd      => [qw{./vov I}],
    expected => [q{c e g}],
  },
  { cmd      => [qw{./vov I6}],
    expected => [q{e g c}],
  },
  { cmd      => [qw{./vov I64}],
    expected => [q{g c e}],
  },
  { cmd      => [qw{./vov --raw I}],
    expected => [q{0 4 7}],
  },
  { cmd      => [qw{./vov II}],
    expected => [q{d fis a}],
  },
  { cmd      => [qw{./vov --flats bII6}],
    expected => [q{f aes des}],
  },
  { cmd      => [qw{./vov --natural II}],
    expected => [q{d f a}],
  },
  { cmd      => [qw{./vov --minor --natural I}],
    expected => [q{c dis g}],
  },
  { cmd      => [qw{./vov --flats III}],
    expected => [q{e aes b}],
  },
  { cmd      => [qw{./vov V7}],
    expected => [q{g b d f}],
  },
  { cmd      => [qw{./vov V65}],
    expected => [q{b d f g}],
  },
  { cmd      => [qw{./vov V43}],
    expected => [q{d f g b}],
  },
  { cmd      => [qw{./vov V2}],
    expected => [q{f g b d}],
  },
  { cmd      => [qw{./vov --natural vii}],
    expected => [q{b d f}],
  },
  # XXX VII is tricky; this is what I intuit should happen without the
  # --natural flag involved, though it does break out of the mode.
  # XXX also must test inversions of VII and whatnot
  { cmd      => [qw{./vov vii*}],
    expected => [q{b d f}],
  },
  # { cmd      => [qw{./vov vii}],
  #   expected => [q{b d fis}],
  # },
  # { cmd      => [qw{./vov VII}],
  #   expected => [q{b dis fis}],
  # },
  # XXX oh also bvii is bad, that diminishes itself, which I would only
  # expect to happen to bvii*

  # and now transpositions
  { cmd      => [qw{./vov --transpose=g I}],
    expected => [q{g b d}],
  },
  { cmd      => [qw{./vov --transpose=7 I}],
    expected => [q{g b d}],
  },
  { cmd      => [qw{./vov --flats --transpose=g i}],
    expected => [q{g bes d}],
  },
  { cmd      => [qw{./vov --transpose=b --mode=locrian i}],
    expected => [q{b d f}],
  },
  { cmd      => [qw{./vov --transpose=b --mode=locrian II}],
    expected => [q{c e g}],
  },
  { cmd      => [qw{./vov --transpose=b --mode=locrian Vb}],
    expected => [q{a c f}],
  },
  { cmd      => [qw{./vov I V7/IV IV V}],
    expected => [ q{c e g}, q{c e g b}, q{f a c}, q{g b d} ],
  },
  { cmd      => [qw{./vov --factor=7 IV}],
    expected => [q{f a c e}],
  },
  { cmd      => [qw{./vov --outputtmpl=%{vov} I}],
    expected => [q{I}],
  },
  { cmd      => [qw{./vov --outputtmpl=x%{chord}x I13g}],
    expected => [q{xa c e g b d fx}],
  },
  { cmd      => [qw{./vov --flats i7**}],
    expected => [q{c ees g bes}],
  },
  { cmd      => [qw{./vov I+}],
    expected => [q{c e gis}],
  },
  { cmd      => [qw{./vov i*}],
    expected => [q{c dis fis}],
  },
  # XXX think about what I* would mean...major 3rd but dim 5th? or throw
  # exception for unknown chord?
  #{ cmd      => [qw{./vov I*}],
  #  expected => [q{c ? fis}],
  #},
);

# by three as Util.pm has a was-something-on-stderr test in addition to
# the two in the loop below
plan tests => @tests * 2;

for my $test (@tests) {
  my @output = run_util( @{ $test->{cmd} } );
  s/\s+$// for @output;
  $deeply->( \@output, $test->{expected}, "@{$test->{cmd}}" );
}
