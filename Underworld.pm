package Underworld;

use strict;

use Moose;

no warnings qw/ uninitialized /;

has grid => (
    is => 'ro',
    default => sub { {} },
);

has target_density => (
    is => 'rw',
    default => 0.4,
);

has cave_factor => (
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
        $self->create_cave;
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

sub create_cave {
    my ( $self, $location ) = @_;

    unless ( $location ) {
        my $d = $self->dimensions;
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

        push @dig, grep { rand() < $self->cave_factor } $self->surrounding( $x, $y );
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

sub to_string {
    my $self = shift;

    my $output;

    my $d = $self->dimensions;

    for my $y ( $d->[1][0]..$d->[1][1] ) {
        for my $x ( $d->[0][0] .. $d->[0][1] ) {
            $output .= $self->grid->{$x}{$y} ? ' ' : '#';
        }
        $output .= "\n";
    }

    return $output;
}

sub tunnel {
    my ( $self, $src, $dst ) = @_;

    until( $self->grid->{ $src->[0] }{ $src->[1] } == 1 ) {
        my $index = rand() < 0.5;
        $src->[$index] += $src->[$index] > $dst->[$index] ? -1 : 1;
        $self->grid->{$src->[0]}{$src->[1]} ||= 2;
    }

}

sub surrounding {
    my ( $self, $x, $y ) = @_;
    return [$x-1,$y], [$x+1,$y], [$x,$y+1], [$x,$y-1];
}

__PACKAGE__->meta->make_immutable;

1;

package main;

__END__

my %grid;

create_cave( 0, 0 );

while(1) {
    print_world();
    <>;
    create_cave( 30 - int rand(60), 30 - int rand(60) );
}

sub create_cave {
    my @dig = ( [ @_[0,1] ] );

    my @system;
    for my $x ( keys %grid ) {
        for my $y ( keys %{ $grid{$x} } ) {
            push @system, [$x,$y];
        }
    }

    my @cave;
    my $connected;

    while ( my $p = shift @dig ) {
        my ( $x, $y ) = @$p;

        next if $grid{$x}{$y};

        $grid{$x}{$y} = 2;
        push @cave, [$x,$y];

        $connected ||= grep { $grid{$_->[0]}{$_->[1]} == 1 } surrounding($x,$y);

        push @dig, grep { rand() < 0.4 } surrounding( $x, $y );
    }

    # do they need to be connected?
    if ( @system and not $connected ) {
        tunnel( $cave[ rand @cave ], $system[ rand @system ] );
    }

    for my $x ( keys %grid ) {
        for my $y ( keys %{ $grid{$x} } ) {
            $grid{$x}{$y} = 1 if $grid{$x}{$y} == 2;
        }
    }

}

sub tunnel {
    my ( $src, $dst ) = @_;

    until( $grid{ $src->[0] }{ $src->[1] } == 1 ) {
        warn join ":", @$src;
        my $index = rand() < 0.5;
        $src->[$index] += $src->[$index] > $dst->[$index] ? -1 : 1;
        $grid{$src->[0]}{$src->[1]} ||= 2;
    }

}


sub print_world {
    for my $y ( -30..30 ) {
        for my $x ( -30..30 ) {
            print $grid{$x}{$y} ? ' ' : '#';
        }
        print "\n";
    }
}


__END__
$grid[$_] = [ ( ' ' ) x 30 ] for 0..29;

our $prob = 0.4;   
munch( 15, 15 );

print_grid();

sub print_grid {
for ( @grid ) {
    print join '', ( ref $_ ? @$_ : '' ), "\n";
}
}



sub munch {
    my ( $x, $y ) = @_;
    warn "munch";

    $grid[$y][$x] = '#';

    my @moves = ( [-1,0], [1,0], [0,1], [0,-1] );

    for my $m ( @moves ) {
        my $i = $x + $m->[0];
        my $j = $y + $m->[1];
        munch($i,$j) if $grid[$j][$i] eq ' ' and rand() < $prob;
    }

    print_grid();
}


