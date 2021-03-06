package Games::DungeonBuilder::Base;

use strict;

use Moose;

use Games::DungeonBuilder::Grid;

no warnings qw/ uninitialized /;

has grid => (
    is => 'ro',
    default => sub { Games::DungeonBuilder::Grid->new },
);

has target_density => (
    is => 'rw',
    default => 0.4,
);

has room_factor => (
    is => 'rw',
    default => 0.4,
);

has dimensions => (
    is => 'rw',
    default => sub { 
        [ [ 0, 40 ], [ 0, 40 ] ],
    },
);

sub escavate {
    my $self = shift;

    while ( $self->density < $self->target_density ) {
        $self->create_room;
    }
}

sub density {
    my $self = shift;

    my $d = $self->dimensions;

    my $density;

    for my $x ( $d->[0][0] .. $d->[0][1] ) {
        for my $y ( $d->[1][0]..$d->[1][1] ) {
            $density++ if $self->grid->{$x}{$y};
        }
    }

    return $density / ($d->[0][1] -$d->[0][0] ) / ($d->[1][1] -$d->[1][0] );
}

sub surrounding {
    my ( $self, $x, $y ) = @_;
    return [$x-1,$y], [$x+1,$y], [$x,$y+1], [$x,$y-1];
}

__PACKAGE__->meta->make_immutable;

1;
