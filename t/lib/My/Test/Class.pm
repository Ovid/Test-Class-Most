package My::Test::Class;

use Test::Class::Most;

INIT { Test::Class->runtests }

sub parent { ['Test::Class'] }

sub startup  : Tests(startup)  {}
sub setup    : Tests(setup)    {}
sub teardown : Tests(teardown) {}
sub shutdown : Tests(shutdown) {}

sub sanity : Tests(2) {
    my $test = shift;

    {
        no strict 'refs';
        my $class = ref $test;
        eq_or_diff \@{"${class}::ISA"}, $test->parent,
          'Inheritance should be handled correctly';
    }
    eval '$foo = 1';
    my $error = $@;
    like $error, qr/^Global symbol "\$foo" requires explicit package name/,
      '... and we should automatically have strict turned on';
}

1;
