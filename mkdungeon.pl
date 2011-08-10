#!/usr/bin/perl 

use strict;

use Games::DungeonBuilder::Cave;
use Games::DungeonBuilder::Dungeon;

my $grid = Games::DungeonBuilder::Grid->new;

Games::DungeonBuilder::Dungeon->new( 
    target_density => 0.3, 
    room_factor => 8/10,
    region => [ [ 0, 50],[0, 50] ],
    grid => $grid,
)->escavate;


Games::DungeonBuilder::Cave->new( 
    target_density => 0.3, 
    region => [ [ 0, 50],[51, 100] ],
    grid => $grid,
)->escavate;

print $grid->to_string;
