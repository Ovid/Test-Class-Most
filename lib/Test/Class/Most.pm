package Test::Class::Most;

use warnings;
use strict;
use Test::Class;
use Carp 'croak';

my ( $HAVE510, $HAVEFEATURE, $HAVEMRO );

BEGIN {
    $HAVE510 = $] >= 5.010000;
    if ($HAVE510) {

        # if we get to here, eval really shouldn't be needed, should it?
        eval "use feature ()";
        $HAVEFEATURE = 1 unless $@;
        eval "use mro ()";
        $HAVEMRO = 1 unless $@;
    }
}

=head1 NAME

Test::Class::Most - Test Classes the easy way

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Test::Class::Most parent => 'My::Test::Class';

    sub teststuff : Tests {
        ok 1;
    }


=head1 EXPORT

All functions from L<Test::Most> are automatically exported into your
namespace.

=cut

sub import {
    my ( $class, %args ) = @_;
    my $caller = caller;
    eval "package $caller; use Test::Most;";
    croak($@) if $@;
    warnings->import;
    strict->import;
    if ( my $parent = delete $args{parent} ) {
        if ( ref $parent && 'ARRAY' ne ref $parent ) {
            croak(
"Argument to 'parent' must be a classname or array of classnames, not ($parent)"
            );
        }
        $parent = [$parent] unless ref $parent;
        eval "use $_" foreach @$parent;
        croak($@) if $@;
        no strict 'refs';
        push @{"${caller}::ISA"} => @$parent;
    }
    else {
        no strict 'refs';
        push @{"${caller}::ISA"} => 'Test::Class';
    }
    return unless $HAVE510;
    if ( exists $args{feature} && !$args{feature} ) {

        # the cheap way of shutting it off
        $HAVE510 = 0;
        return;
    }
    feature->import(':5.10') if $HAVEFEATURE;
    mro::set_mro( scalar caller(), 'c3' ) if $HAVEMRO;
}

=head1 AUTHOR

Curtis "Ovid" Poe, C<< <ovid at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-class-most at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Class-Most>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Class::Most


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Class-Most>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Class-Most>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Class-Most>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Class-Most/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Curtis "Ovid" Poe, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;    # End of Test::Class::Most
