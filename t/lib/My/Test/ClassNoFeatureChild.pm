package My::Test::ClassNoFeatureChild;

# Note that because the base Test class specified 'feature => 0', you're not
# going to get them here, either.

use Test::Class::Most parent => 'My::Test::ClassNoFeature';

sub parent { ['My::Test::ClassNoFeature'] }

sub no_features : Tests(1) {
  SKIP: {
        skip "Need 5.10 or better to test features", 1
          unless $] >= 5.010000;
        eval "say '# ignore this diagnostic message'";
        my $error = $@;
        like $error, qr/syntax error/,
          'Even subclasses of "no feature" classes do not get them'
          or diag explain $error;
    }
}

1;
