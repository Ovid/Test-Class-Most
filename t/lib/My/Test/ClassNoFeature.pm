package My::Test::ClassNoFeature;

use Test::Class::Most feature => 0;
INIT { Test::Class->runtests }

sub parent { ['Test::Class'] }

sub sanity : Tests(3) {
    my $test = shift;
    {
        no strict 'refs';
        my $class = ref $test;
        is_deeply \@{"${class}::ISA"}, $test->parent,
          'Inheritance should be handled correctly';
    }
    eval '$foo = 1';
    my $error = $@;
    like $error, qr/^Global symbol "\$foo" requires explicit package name/,
      '... and we should automatically have strict turned on';
  SKIP: {
        skip "Need 5.10 or better to test features", 1
          unless $] >= 5.010000;
        eval "say '# ignore this diagnostic message'";
        my $error = $@;
        like $error, qr/syntax error/,
          'asking for no features means you get no 5.10 features'
          or diag explain $error;
    }
}

1;
