# -*- Perl -*-

package App::MusicTools;

use 5.010000;
use strict;
use warnings;

our $VERSION = '0.61';

1;
__END__

=head1 NAME

App-MusicTools - command line utilities for music composition and analysis

=head1 SYNOPSIS

  $ atonal-util --ly findin --pitchset=5-25 c e g
  Ti(0)   c,e,g,a,ais
  T(4)    c,e,g,fis,a

  $ export MIDI_EDITOR=timidity
  $ ly-fu --instrument=banjo c des ees c des bes c aes

  $ scalemogrifier --mode=mixolydian --transpose=fis
  fis gis ais b cis dis e fis'

  $ varionator '(I I6) (II IV II6 IV6) (V V7 III) I'
  ...

  $ vov --outputtmpl='<%{chord}> \t% %{vov}' I IV/IV V7/IV IV V7 I
  <c e g> 	% I
  <b dis f> 	% IV/IV
  <c e g b> 	% V7/IV
  <f a c> 	% IV
  <g b d f> 	% V7
  <c e g> 	% I

=head1 DESCRIPTION

This distribution contains a number of command line utilities related to
music composition and analysis, examples of which are shown in the
SYNOPSIS. Run C<perldoc> on the command name for documentation on how to
use each tool.

The C<zsh-compdef> directory of this distribution includes ZSH
completion scripts for the command line utilities. Install these files
to a ZSH C<$fpath> directory, and follow the ZSH documentation on setting
up tab completion.

=head1 SEE ALSO

=over 4

=item *

L<http://www.lilypond.org/> and most notably the Learning and Notation
manuals, as the tools make use of the default lilypond note letter
conventions (e.g. fis for F sharp, ees for E flat, etc.)

=item *

C<ly-fu> expects that a MIDI player and PDF viewer are available on
the system.

=item *

"The Structure of Atonal Music" by Allen Forte (ISBN 978-0-300-02120-2).

=item *

B<Theory of Harmony> by Arnold Schoenberg (ISBN 978-0-520-26608-7).

=item *

L<http://en.wikipedia.org/wiki/Forte_number>

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
