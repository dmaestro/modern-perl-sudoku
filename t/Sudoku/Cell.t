#!/usr/bin/env perl
use 5.014;
use warnings;

use Test::More;
use Test::Exception;

use_ok('Sudoku::Cell') or die;

ok(my $c = Sudoku::Cell->new(),                         'create a Sudoku::Cell');
ok(! $c->has_value(),                                   'no initial value');
lives_ok(sub { $c->set_value(3) },                      'set a value');
ok($c->has_value(),                                     'value is set');
is($c->value,                   3,                      'value is correct');
throws_ok(sub { $c->set_value(2) },     qr/immutable/,  'value may only be set once');

throws_ok(sub {
            Sudoku::Cell->new(value => 0)
          },                    qr/range/i,             'not less than 1');
throws_ok(sub {
            Sudoku::Cell->new(value => 10)
          },                    qr/range/i,             'not greater than 9');

ok(my $ci = Sudoku::Cell->new(value => 9),              'initialize a Sudoku::Cell');
throws_ok(sub { $ci->set_value(5) },    qr/immutable/,  'initialized value is immutable');
TODO: {
  local $TODO = 'Allow "setting" to identical value';
  lives_ok(sub { $ci->set_value(9) },                   'initialized value is immutable');
}

is($ci->value,                  9,                      'value is correct');
is($ci->bitmask,                0x200,                   'mask is correct');

done_testing;
