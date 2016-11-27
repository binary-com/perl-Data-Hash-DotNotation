#!/usr/bin/perl
use strict; use warnings;

use lib 'lib';
use Data::Hash::DotNotation;
use Test::More;
use Test::Exception;

my $dn = Data::Hash::DotNotation->new;

$dn->data({
        name => 'Gurgeh',
        planet  => 'earth',
        score   => {
            contact => 10,
            scrabble => 20,
        },
    });

is $dn->get('score.contact'), 10;

$dn->data({
        k1 => 'v1',
        h1 => {
          k2 => 23,
        }
    });

is $dn->get('score.contact'), undef, "old cache has been invalidated";
is $dn->get('k1'), 'v1';
is $dn->get('h1.k2'), 23;

done_testing;
