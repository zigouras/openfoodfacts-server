#!/usr/bin/perl -w

use strict;
use warnings;

use utf8;

use Test::More;
#use Log::Any::Adapter 'TAP', filter => "none";
use Log::Any::Adapter 'TAP', filter => "info";

use ProductOpener::Products qw/:all/;
use ProductOpener::Tags qw/:all/;
use ProductOpener::ImportConvert qw/:all/;

# dummy product for testing

my $product_ref = {
	lc => "es",
	total_weight => "Peso neto: 480 g (6 x 80 g) Peso neto escurrido: 336 g (6x56 g)",
};

clean_weights($product_ref);

diag explain $product_ref;

is($product_ref->{net_weight}, "480 g");

assign_value($product_ref, "energy_value", "2428.000");

is($product_ref->{energy_value}, "2428");

assign_value($product_ref, "fat_value", "2428.0300");

is($product_ref->{fat_value}, "2428.03");

assign_value($product_ref, "sugars_value", "10.6000");

is($product_ref->{sugars_value}, "10.6");

$product_ref->{some_field} = "Fabriqué en France par EMB59481 pour Auchan Production";

match_taxonomy_tags($product_ref, "some_field", "emb_codes",
{ split => ',|( \/ )|\r|\n|\+|:|;|=|\(|\)|\b(et|par|pour|ou)\b', });

is($product_ref->{emb_codes}, "EMB59481");

$product_ref = { "product_name" => "Champagne brut 35,5 CL" };
assign_quantity_from_field($product_ref, "product_name");
is($product_ref->{product_name}, "Champagne brut");
is($product_ref->{quantity}, "35,5 CL");

$product_ref = { "lc" => "fr", "product_name_fr" => "Soupe bio" };
@fields = qw(product_name_fr);
match_labels_in_product_name($product_ref);
is($product_ref->{labels}, 'en:organic') or diag explain $product_ref;

@fields = qw(quantity net_weight_value_unit);
$product_ref = { "lc" => "fr", net_weight_value_unit => "250 gr", quantity => "10.11.2019" }; clean_weights($product_ref);
is($product_ref->{quantity}, "250 g") or diag explain $product_ref;

$product_ref = { "lc" => "fr", net_weight_value_unit => "250 gr", quantity => "2 tranches" }; clean_weights($product_ref);
is($product_ref->{quantity}, "2 tranches (250 g)") or diag explain $product_ref;

$product_ref = { "lc" => "fr", emb_codes => "EMB 60282A - Gouvieux (Oise, France)" }; 
@fields = ("emb_codes");
clean_fields($product_ref);
is($product_ref->{emb_codes}, "EMB 60282A") or diag explain $product_ref;

done_testing();
