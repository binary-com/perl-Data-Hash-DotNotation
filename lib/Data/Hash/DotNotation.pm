package Data::Hash::DotNotation;
use 5.010;
use strict;
use warnings;

our $VERSION = '1.00';

=head1 NAME

Data::Hash::DotNotation - Convenient representation for nested Hash structures

=head1 VERSION

1.00

=head1 SYNOPSYS

    use Data::Hash::DotNotation;

    my $dn = Data::Hash::DotNotation->new({
            name => 'Gurgeh',
            planet  => 'earth',
            score   => {
                contact => 10,
                scrabble => 20,
            },
        });

    print $dn->get('score.contact');
    $dn->set('score.scrabble', 50);

    # return the complete modified hashref
    my $gamer_info = $dn->data;

=cut

sub new {
    my ($class, $args) = @_;
    my $data = $args || {};

    my $self->{data} = $data;
    bless $self, $class;

    return $self;
}

sub data {
    my ($self) = @_;
    return $self->{data};
}

sub get {
    my $self = shift;
    my $name = shift or die "No name given";
    return $self->_get($name);
}

sub set {
    my $self  = shift;
    my $name  = shift or die 'No name given';
    my $value = shift;

    $self->_set($name, $value);

    return $value;
}

sub key_exists {
    my $self = shift;
    my $name = shift;
    my $data = $self->data;

    my @parts = split(/\./, $name);
    my $node = pop @parts;
    my $parent_node;

    while ($data and (my $section = shift @parts)) {
        if (ref $data->{$section} eq 'HASH') {
            $data = $data->{$section};
        } else {
            return;
        }
    }

    return exists $data->{$node};
}

sub _get {
    my $self = shift;
    my $name = shift;
    my $data = $self->data;

    my @parts = split(/\./, $name);
    my $node = pop @parts;
    my $parent_node;

    while ($data and (my $section = shift @parts)) {
        if (ref $data->{$section} eq 'HASH') {
            $data = $data->{$section};
        } else {
            return;
        }
    }

    if ($data and exists $data->{$node}) {
        return $data->{$node};
    }

    return;
}

sub _set {
    my $self  = shift;
    my $name  = shift;
    my $value = shift;

    unless ($self->data) {
        $self->data({});
    }

    my @tarts = split(/\./, $name);
    my $node = pop @tarts;

    my $current_location = $self->data;
    foreach my $section (@tarts) {
        $current_location->{$section} //= {};
        $current_location = $current_location->{$section};
    }

    if (defined($value)) {
        $current_location->{$node} = $value;
    } else {
        delete $current_location->{$node};
    }

    return $self->data;
}

1;

=head1 SOURCE CODE

L<GitHub|https://github.com/binary-com/perl-Data-Hash-DotNotation>

=head1 AUTHOR

binary.com, C<< <perl at binary.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-role-registry at rt.cpan.org>, or through the web
interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Hash-DotNotation>.
We will be notified, and then you'll automatically be notified of progress on
your bug as we make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Hash::DotNotation

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Hash-DotNotation>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Data-Hash-DotNotation>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Data-Hash-DotNotation>

=item * Search CPAN

L<http://search.cpan.org/dist/Data-Hash-DotNotation/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2015 binary.com

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

