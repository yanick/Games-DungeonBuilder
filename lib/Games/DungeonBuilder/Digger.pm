package Games::DungeonBuilder::Digger;

use strict;

use Moose::Role;
use Method::Signatures;

use Games::DungeonBuilder::Grid;

no warnings qw/ uninitialized /;

requires 'create_room', 'tunnel';

has grid => (
    is => 'ro',
    default => sub { Games::DungeonBuilder::Grid->new },
);

has target_density => (
    is => 'rw',
    default => 0.4,
);

has region => (
    is => 'rw',
    default => sub { 
        [ [ 0, 40 ], [ 0, 40 ] ],
    },
);

method escavate {
    $self->create_room while $self->density < $self->target_density;
}

method density {
    my $d = $self->region;

    my $density;

    for my $x ( $d->[0][0] .. $d->[0][1] ) {
        for my $y ( $d->[1][0]..$d->[1][1] ) {
            $density++ if $self->grid->{$x}{$y};
        }
    }

    return $density / ($d->[0][1] -$d->[0][0] ) / ($d->[1][1] -$d->[1][0] );
}

method surrounding ( $x, $y ) {
    return [$x-1,$y], [$x+1,$y], [$x,$y+1], [$x,$y-1];
}

1;
