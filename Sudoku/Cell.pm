package Sudoku::Cell;
use 5.014;
use warnings;

use Carp qw(confess);
use Moo;
use DLS::MooTypes;
use namespace::clean;

use DLS::Constants qw(:TINYTEXT);

has value => (
      is        =>  'rwp',
      isa       =>  sub {
                      DLS::MooTypes->Integer->($_[0]);
                      confess "Out of range!" if $_[0] < 1 or $_[0] > 9;
                    },
      predicate =>  1,
);

sub set_value {
  my $self = shift;
  confess 'Once set, value is immutable!' if $self->has_value;
  $self->_set_value(@_);
}

has initial => (
      is        =>  'rwp',
      default   =>  $EMPTY_STRING,  # false
);

sub BUILD {
  my ($self) = @_;
  if ($self->has_value) {
    $self->_set_initial(1);
  }
}

1;
