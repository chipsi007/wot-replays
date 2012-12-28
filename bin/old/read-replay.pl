#!/usr/bin/perl
use strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WR;
use WR::Parser;

use constant WOT_BF_KEY_STR => 'DE 72 BE A0 DE 04 BE B1 DE FE BE EF DE AD BE EF';
use constant WOT_BF_KEY     => join('', map { chr(hex($_)) } (split(/\s/, WOT_BF_KEY_STR)));
$| = 1;

print 'key length: ', length(WOT_BF_KEY), "\n";

my $parser = WR::Parser->new(
    file    => $ARGV[0], 
    bf_key  => WOT_BF_KEY, 
    traits => [qw/
        LL::File 
        Data::Decrypt
        Data::Reader
    /]
);

print 'WoT version: ', $parser->wot_version, "\n";
