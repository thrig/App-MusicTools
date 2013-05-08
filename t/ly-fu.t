#!perl

# ly-fu is tricky to test, as how does one automate checking that the
# MIDI generated is correct (difficult) or that the lilypond score is
# okay (much harder)? Also, it requires that lilypond be available.
#
# XXX add author test, below, as time permits.

use warnings;
use strict;
use version;

use File::Spec ();
use Test::More tests => 2;

use lib 't';
use Util;

my $lilypond_path;
for my $d ( split ':', $ENV{PATH} ) {
  my $loc = File::Spec->catfile( $d, 'lilypond' );
  if ( -x $loc ) {
    $lilypond_path = $loc;
    last;
  }
}

# XXX really need to parse `lilypond --version` to ensure using > 2.14
# or whatever minimum is set in ly-fu; however, that output is screwy,
# being neither to stdout nor stderr, so would need to wrap lilypond
# with some IPC foo capable of capturing such shenanigans. Sigh. So will
# get false positives from smoke test machines with older versions of
# lilypond installed.

SKIP: {
  skip "lilypond not installed", 2 unless defined $lilypond_path;

  # Default output should be a temp file that with --layout should not
  # be unlinked automatically and with --silent should not be played.
  diag
    "NOTE ly-fu will fail if lilypond is too old (but only if lilypond installed)";
  my @output = run_util(qw{./ly-fu --layout --silent c});
  ok( -f $output[0], 'check that temp file generated' );
}

# XXX listen, verify something with ear and eye
#if ( $ENV{AUTHOR_TEST_JMATES} ) {
#SKIP: {
#    skip "lilypond not installed", 42 unless defined $lilypond_path;
#  }
#}
