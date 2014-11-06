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

Readonly::Scalar                our $REF_SCALAR       => ref \q{};
Readonly::Scalar                our $REF_ARRAY        => ref [];
Readonly::Scalar                our $REF_HASH         => ref {};
Readonly::Scalar                our $REF_CODE         => sub {};
$EXPORT_TAGS{PERLREF}           = [qw(
                                    $REF_SCALAR
                                    $REF_ARRAY
                                    $REF_HASH
                                    $REF_CODE
                                  )];


for my $tags (values %EXPORT_TAGS) {
  push @EXPORT_OK, @{$tags};
}

1;
