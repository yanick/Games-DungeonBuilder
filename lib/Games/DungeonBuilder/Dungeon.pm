package Games::DungeonBuilder::Dungeon;

use strict;

use Moose;
use Method::Signatures;

no warnings;

with 'Games::DungeonBuilder::Digger';

has room_factor => (
    is => 'rw',
    default => 0.4,
);

method create_room ( $location = undef ) {

    unless ( $location ) {
        my $d = $self->region;
        $location->[0] = $d->[0][0] + int rand( $d->[0][1] - $d->[0][0] );
        $location->[1] = $d->[1][0] + int rand( $d->[1][1] - $d->[1][0] );
    }

    my $width = 1;
    $width++ while rand() < $self->room_factor;

    my $height = 1;
    $height++ while rand() < $self->room_factor;

    my @dig;
    for my $x ( $location->[0]..$location->[0] + $width ) {
        for my $y ( $location->[1]..$location->[1] + $height ) {
            push @dig, [ $x, $y ];
        }
    }

    my @system;
    for my $x ( keys %{ $self->grid } ) {
        for my $y ( keys %{ $self->grid->{$x} } ) {
            push @system, [$x,$y];
        }
    }

    my @cave;
    my $connected;

    while ( my $p = shift @dig ) {
        my ( $x, $y ) = @$p;

        next if $self->grid->{$x}{$y};

        $self->grid->{$x}{$y} = 2;
        push @cave, [$x,$y];

        $connected ||= grep { $self->grid->{$_->[0]}{$_->[1]} == 1 } $self->surrounding($x,$y);
    }

    # do they need to be connected?
    if ( @system and not $connected ) {
        $self->tunnel( $cave[ rand @cave ], $system[ rand @system ] );
    }

    for my $x ( keys %{ $self->grid } ) {
        for my $y ( keys %{ $self->grid->{$x} } ) {
            $self->grid->{$x}{$y} = 1 if $self->grid->{$x}{$y} == 2;
        }
    }
}


method tunnel ( $src, $dst ) {
    my $index = rand() < 0.5 ? 0 : 1;

    until( $self->grid->{ $src->[0] }{ $src->[1] } == 1 ) {
        $index = !$index if $src->[$index] == $dst->[$index];
        $src->[$index] += $src->[$index] > $dst->[$index] ? -1 : 1;
        $self->grid->{$src->[0]}{$src->[1]} ||= 2;
    }

}

__PACKAGE__->meta->make_immutable;

1;



