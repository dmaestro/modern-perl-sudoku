package Sudoku::Collection;
use 5.014;
use warnings;

use Carp qw(confess);
use Sudoku::Cell;

use Moo;
use namespace::clean;

use DLS::Constants qw(:PERLREF);
use Readonly;

Readonly::Scalar  my $SUDOKU_DIMENSION  =>  9;
Readonly::Scalar  my $CELL_CLASS        =>  qw(Sudoku::Cell);

has _cells   =>  (
  is          =>  'rw',
  isa         =>  sub { die 'cells must be initialized as an array-ref!'
                          if not (
                            ref $_[0] eq $REF_ARRAY
                              and @{ $_[0] } <= $SUDOKU_DIMENSION
                          );
                      },
  init_arg    =>  'cells',
  required    =>  1,
);

has rank    =>  (
  is          =>  'ro',
  isa         =>  sub {
                      DLS::MooTypes->Integer->($_[0]);
                      confess 'Out of range!'
                        if $_[0] < 0 or $_[0] > $SUDOKU_DIMENSION - 1;
                  },
  required    =>  1,
);

sub BUILDARGS {
  my ($class, $rank, $cells, @args) = @_;
  return {
    rank  =>  $rank,
    cells =>  $cells,
    @args,
  };
}

sub BUILD {
  my ($self) = @_;
  for my $cell (@{$self->_cells}) {
    # $cell is an alias for each array slot - modify in place
    next if $cell->isa($CELL_CLASS);
    if ($cell->isa(__PACKAGE__)) {
      my $collection = $cell; #inheriting cell(s) from another collection
      $cell = $self->_map_cells($collection);
    } elsif (defined $cell) {
      $cell = $CELL_CLASS->new($cell ? (value => $cell) : ());
    }
  }
  # flatten result
  if ($self->cells != $SUDOKU_DIMENSION) {
    $self->_cells( [ map { ref eq $REF_ARRAY ? @{ $_ } : $_ } $self->cells ] );
  }
  confess 'Failed to initialize all cells!'
    if $self->cells != $SUDOKU_DIMENSION;
  for my $cell ($self->cells) {
    $cell->included_in($self);
  }
}

sub cells {
  my ($self, @args) = @_;
  confess 'Setting read-only attribute not allowed'
    if @args;
  return @{ $self->_cells };
}

sub _map_cells {
  my ($self, $other) = @_;
  confess 'Invalid mapping - identical collection types!'
    if ref $self eq ref $other;
  # row to column or column to row method - override for * to square
  return $other->index($self->rank);
}

sub index {
  my ($self, $index) = @_;
  return $self->_cells->[$index];
}

sub status {
  my ($self) = @_;
  my $stat = 0x3ff;
  for my $cell ($self->cells) {
    my $mask = $cell->bitmask;
    confess 'Duplicate cell values in '
            . ( ref $self =~ s/^.*:://r )
            . ', rank ' . $self->rank
      if $cell->has_value and $mask & $stat;
    $stat &= ~$mask;
  }
  return $stat;
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
