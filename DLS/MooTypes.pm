package DLS::MooTypes;
use 5.014;
use warnings;

use Carp qw(confess);
use Scalar::Util qw(looks_like_number);

sub Integer {
  return sub {
    confess "Not an Integer!"
      if not (looks_like_number($_[0]) and $_[0] =~ /^-?\d+\z/a);
  }
}

1;
