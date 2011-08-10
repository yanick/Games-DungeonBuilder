package Games::DungeonBuilder::Grid;

use strict;
no warnings;

use List::MoreUtils qw/ minmax /;

use Moose;
use Method::Signatures;

no warnings;

method to_string {
    my $output;

    my ( $minx, $maxx ) = minmax keys %$self;
    my ( $miny, $maxy ) = minmax  map { keys %$_ } values %$self;

    for my $y ( $miny-1..$maxy+1 ) {
        for my $x ( $minx-1..$maxx+1 ) {
            $output .= $self->{$x}{$y} ? ' ' : '#';
        }
        $output .= "\n";
    }

    return $output;
}

__PACKAGE__->meta->make_immutable;

1;
