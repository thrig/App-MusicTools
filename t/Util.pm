# Shamelessly stolen and adapted from:
# http://api.metacpan.org/source/PETDANCE/ack-1.96/t/Util.pm

# capture stderr output into this file
my $catcherr_file = 'stderr.log';

sub is_win32 {
  return $^O =~ /Win32/;
}

sub build_command_line {
  my @args = @_;

  if ( is_win32() ) {
    for (@args) {
      s/(\\+)$/$1$1/;    # Double all trailing backslashes
      s/"/\\"/g;         # Backslash all quotes
      $_ = qq{"$_"};
    }
  } else {
    @args = map { quotemeta $_ } @args;
  }

  return "$^X ./capture-stderr $catcherr_file @args";
}

sub run_util {
  my @args = @_;

  my ( $stdout, $stderr ) = run_cmd_with_stderr(@args);

  if ($TODO) {
    fail(q{Automatically fail stderr check for TODO tests.});
  } else {
    is( scalar @{$stderr}, 0, "Should have no output to stderr: @args" )
      or diag( join( "\n", "STDERR:", @{$stderr} ) );
  }

  return wantarray ? @{$stdout} : join( "\n", @{$stdout} );
}

{    # scope for $cmd_return_code;

  # capture returncode
  our $cmd_return_code;

  # run the given command, assuming that the command was created with
  # build_command_line (and thus writes its STDERR to $catcherr_file).
  #
  # sets $cmd_return_code and unlinks the $catcherr_file
  #
  # returns chomped STDOUT and STDERR as two array refs
  sub run_cmd {
    my $cmd = shift;

    #diag( "Running command: $cmd" );

    my @stdout = `$cmd`;
    my ( $sig, $core, $rc ) = ( ( $? & 127 ), ( $? & 128 ), ( $? >> 8 ) );
    $ack_return_code = $rc;
    ## XXX what do do with $core or $sig?

    my @stderr;
    open( my $fh, '<', $catcherr_file ) or die $!;
    while (<$fh>) {
      push( @stderr, $_ );
    }
    close $fh or die $!;
    unlink $catcherr_file;

    chomp @stdout;
    chomp @stderr;

    return ( \@stdout, \@stderr );
  }

  sub get_rc {
    return $cmd_return_code;
  }

}    # scope for $cmd_return_code

sub run_cmd_with_stderr {
  my @args = @_;

  my @stdout;
  my @stderr;

  my $cmd = build_command_line(@args);

  return run_cmd($cmd);
}

# pipe into cmd and return STDOUT and STDERR as array refs
sub pipe_into_cmd_with_stderr {
  my $input = shift;
  my @args  = @_;

  my $cmd = build_command_line(@args);
  $cmd = "$^X -pe1 $input | $cmd";

  my ( $stdout, $stderr ) = run_cmd($cmd);
  return ( $stdout, $stderr );
}

# pipe into cmd and return STDOUT as array, for arguments see
# pipe_into_cmd_with_stderr
sub pipe_into_cmd {
  my ( $stdout, $stderr ) = pipe_into_cmd_with_stderr(@_);
  return @$stdout;
}

1;
