package DLS::Constants;
use 5.014;
use warnings;

use Exporter qw(import);
use Readonly;

our @EXPORT_OK;
our %EXPORT_TAGS;

Readonly::Scalar                our $EMPTY_STRING     =>  q{};
Readonly::Scalar                our $SPACE            =>  q{ };
$EXPORT_TAGS{TINYTEXT}          = [qw(
                                    $EMPTY_STRING
                                    $SPACE
                                  )];

for my $tags (values %EXPORT_TAGS) {
  push @EXPORT_OK, @{$tags};
}

1;
