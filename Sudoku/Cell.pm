package Sudoku::Cell;
use 5.014;
use warnings;

use Carp qw(confess);
use Moo;
use DLS::MooTypes;
use namespace::clean;

use DLS::Constants qw(:TINYTEXT);
use Readonly;

Readonly::Scalar  my $SUDOKU_DIMENSION  =>  9;

has value => (
      is        =>  'rwp',
      isa       =>  sub {
                      DLS::MooTypes->Integer->($_[0]);
                      confess 'Out of range!' if $_[0] < 1 or $_[0] > $SUDOKU_DIMENSION;
                    },
      predicate =>  1,
);

sub set_value { ## no critic (FinalReturn)
  my ($self, @args) = @_;
  confess 'Once set, value is immutable!' if $self->has_value;
  $self->_set_value(@args);
}

has initial => (
      is        =>  'rwp',
      default   =>  $EMPTY_STRING,  # false
);

sub BUILD { ## no critic (FinalReturn)
  my ($self) = @_;
  if ($self->has_value) {
    $self->_set_initial(1);
  }
}

sub bitmask {
  my ($self) = @_;
  return $self->has_value ? 1 << $self->value : 0 ;
}

1;
