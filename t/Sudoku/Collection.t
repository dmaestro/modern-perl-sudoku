#!/usr/bin/env perl
use 5.014;
use warnings;

use Test::More;
use Test::Exception;

my $TEST_CLASS = qw(Sudoku::Collection);
my $SUDOKU_DIM = 9;
use_ok($TEST_CLASS) or die;

my @rows = (
  [ 0, 0, 3, 4, 0, 0, 7, 8, 0 ],
  [ 9, 0, 0, 6, 5, 0, 3, 0, 0 ],
  [ 1, 7, 0, 2, 0, 8, 0, 6, 4 ],
);

{
  my $n = 0;
  for my $row (@rows) { # turn the rows into collections
    my $n_init = 4 + ($n & ~1);
    lives_ok(sub {$row = $TEST_CLASS->new($n++, $row)}, "Construct collection object $n");
    ok($row->cells == $SUDOKU_DIM,                      'All cells are initialized');
    my @init = grep { $_->initial } $row->cells;
    is(scalar(@init),           $n_init,                'Correct number of initial cells');
    my @ref = grep { @{ $_->references } == 1 } $row->cells;
    is(scalar(@ref),            $SUDOKU_DIM,            'All cells have collection references');
  }
}

throws_ok(sub { $TEST_CLASS->new(4, [ 0, 0, 0 ]) },
                                qr/all cells/i,         'dies if not enough initializers');

done_testing;
