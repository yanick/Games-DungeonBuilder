package Games::DungeonBuilder::Cave;

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
        
    my @dig = ( $location );

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

        push @dig, grep { rand() < $self->room_factor } $self->surrounding( $x, $y );
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

method tunnel( $src, $dst ) {

    until( $self->grid->{ $src->[0] }{ $src->[1] } == 1 ) {
        my $index = rand() < 0.5;
        $src->[$index] += $src->[$index] > $dst->[$index] ? -1 : 1;
        $self->grid->{$src->[0]}{$src->[1]} ||= 2;
    }

}

__PACKAGE__->meta->make_immutable;

1;


