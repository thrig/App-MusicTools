use 5.010000;

use strict;
use warnings;
use ExtUtils::MakeMaker;

my %params = (
  NAME         => 'App::MusicTools',
  ABSTRACT     => 'command line utilities for music composition and analysis',
  VERSION_FROM => 'lib/App/MusicTools.pm',
  EXE_FILES    => [
    qw/atonal-util canonical harmonic-fit ly-fu scalemogrifier varionator vov/
  ],
  # Try to list everything due to certain vendors cocking up core Perl... :/
  PREREQ_PM => {
    Carp                      => 0,
    'File::Spec'              => 0,
    'File::Temp'              => 0,
    'Getopt::Long'            => 0,
    'IPC::Open3'              => 0,
    'JSON'                    => 0,
    'List::Util'              => 0,
    'Music::AtonalUtil'       => 1.07,
    'Music::Canon'            => 2.00,
    'Music::Chord::Positions' => 0,
    'Music::LilyPondUtil'     => 0.10,
    'Music::Scala'            => 0.84,
    'Music::Scales'           => 0,
    'Music::Tempo'            => 0,
    'Music::Tension'          => 0.60,
    'Parse::Range'            => 0,
    'Scalar::Util'            => 0,
    'Test::More'              => 0,
    'Text::Roman'             => 0,
    'Text::Wrap'              => 0,
    'Try::Tiny'               => 0,
  },
  ( $] >= 5.005
    ? ( AUTHOR => 'Jeremy Mates <jmates@cpan.org>' )
    : ()
  ),
);

if ( $ExtUtils::MakeMaker::VERSION =~ /^\d\.\d\d$/ and $ExtUtils::MakeMaker::VERSION > 6.30 ) {
  $params{LICENSE} = 'artistic_2';
}

if ( $ExtUtils::MakeMaker::VERSION ge '6.46' ) {
  $params{META_MERGE} = {
    resources => {
      homepage   => 'http://github.com/thrig/App-MusicTools',
      license    => 'http://dev.perl.org/licenses/',
      repository => 'http://github.com/thrig/App-MusicTools',
    }
  };
}

if ( $ExtUtils::MakeMaker::VERSION ge '6.48' ) {
  $params{MIN_PERL_VERSION} = 5.010000;
}

WriteMakefile( ( MM->can('signature_target') ? ( SIGN => 1 ) : () ), %params );
