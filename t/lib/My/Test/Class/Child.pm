package My::Test::Class::Child;

use Test::Class::Most parent => 'My::Test::Class';

sub parent {
    ['My::Test::Class'];
}

sub child1 { 'from child1' }

1;
