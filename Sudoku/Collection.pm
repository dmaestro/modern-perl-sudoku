package Sudoku::Collection;
use 5.014;
use warnings;

use Moo;
use namespace::Clean;

use DLS::Constants qw(:PERLREF);
use Readonly;

Readonly::Scalar  my $SUDOKU_DIMENSION  =>  9;

has cells   =>  (
  is          =>  'ro',
  isa         =>  sub { die 'cells must be initialized as an array-ref!'
                          if not (
                            ref $_[0] eq $REF_ARRAY
                              and @{ $_[0] } == $SUDOKU_DIMENSION
                          );
                      },
  required    =>  1,
);

has rank    =>  (
  is          =>  'ro',
  isa         =>  sub {
                      DLS::MooTypes->Integer->($_[0]);
                      confess 'Out of range!' if $_[0] < 1 or $_[0] > $SUDOKU_DIMENSION;
                  },
  required    =>  1,
);

sub BUILDARGS {
  my ($class, $rank, $cells, @args) = @_;
  return {
    rank  =>  $rank,
    cells =>  $cells,
    @ARGS,
  };
}

1;

__END__

=head1 NAME

Sudoku::Collection

=head1 SYNOPSIS

use parent qw(Sudoku::Collection);

=head1 DESCRIPTION

This is a base for classes representing Suduko rows, columns, and
3x3 squares.

=head1 Constructor

=head2 new $n, [ 0 0 4 0 1 2 7 0 0 ]

=head2 new $n, [ $row1, $row2, $row3, ... ]

C<$n> is the numeric index (identifier) for the collection. It should have a
value between 0 and C<$SUDOKU_DIMENSION-1>.

=head1 METHODS

=head2 status

Returns an integer representing the OR'ed bitmasks of values remaining to be
filled in for this collection. Returns 1 if the collection is complete (values
1 thru 9 are all present).

=head1 COPYRIGHT

Copyright (c) 2006, 2014 Douglas L. Schrag

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself. See L<http://dev.perl.org/licenses/>.
