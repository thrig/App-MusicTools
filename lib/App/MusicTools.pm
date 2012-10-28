package App::MusicTools;

use 5.010000;
use strict;
use warnings;

our $VERSION = '0.01';

1;
__END__

=head1 NAME

App-MusicTools - command line utilities for music composition and analysis

=head1 SYNOPSIS

  $ atonal-util --ly findin --pitchset=5-25 c e g
  Ti(0)   c,e,g,a,ais
  T(4)    c,e,g,fis,a

  $ scalemogrifier --mode=mixolydian --transpose=fis
  fis gis ais b cis dis e fis'

  $ vov --natural I IV/IV V7/IV IV V7 I
  c e g
  b d f
  c e g b
  f a c
  g b d f
  c e g

=head1 DESCRIPTION

This distribution contains a number of command line utilities related to
music composition and analysis. Run C<perldoc> on the command name for
documentation on how to use each tool.

The C<zsh-compdef> directory of this distribution includes ZSH
completion scripts for the command line utilities. Install these files
to a ZSH $fpath directory, and follow the ZSH documentation on setting
up tab completion.

=head1 SEE ALSO

=over 4

=item *

http://www.lilypond.org/ and most notably the Learning and Notation
manuals, as the tools make use of the default lilypond note letter
conventions (e.g. fis for F sharp, ees for E flat, etc.)

=item *

"The Structure of Atonal Music" by Allen Forte.

=item *

B<Theory of Harmony> by Arnold Schoenberg (ISBN 978-0-520-26608-7).

=item *

http://en.wikipedia.org/wiki/Forte_number

=item *

L<Music::AtonalUtil>, L<Music::Chord::Positions>,
L<Music::LilyPondUtil>, L<Music::Tension>

=back

=head1 AUTHOR

Jeremy Mates, E<lt>jmates@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Jeremy Mates

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself, either Perl version 5.16 or, at
your option, any later version of Perl 5 you may have available.

=cut
