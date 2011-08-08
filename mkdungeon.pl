#!/usr/bin/perl 

use strict;

use Games::MapMaker::Cave;
use Games::MapMaker::Dungeon;

my $u = Games::MapMaker::Cave->new( 
    target_density => 0.3, 
    dimensions => [ [ 0, 100],[0, 100] ] 
);
$u->escavate;
print $u->to_string;


$u = Games::MapMaker::Dungeon->new( 
    target_density => 0.3, 
    room_factor => 8/10,
    dimensions => [ [ 0, 100],[0, 100] ] 
);
$u->escavate;
print $u->to_string;


