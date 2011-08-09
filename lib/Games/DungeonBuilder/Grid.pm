package Games::DungeonBuilder::Grid;

use List::MoreUtils qw/ minmax /;

use Moose;

sub to_string {
    my $self = shift;

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
