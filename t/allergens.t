#!/usr/bin/perl -w

use strict;
use warnings;
use utf8;

use Test::More;
use Log::Any::Adapter 'TAP';

use ProductOpener::Products qw/:all/;
use ProductOpener::Tags qw/:all/;
use ProductOpener::Ingredients qw/:all/;

# dummy product for testing

my $product_ref = {
	lc => "fr", lang => "fr",
	ingredients_text_fr => "Eau, LAIT, farine de BLE, sucre, sel, _oeufs_, moutarde, _crustacés_, fruits à coque, _céleri_, POISSON, crème de cassis. Contient mollusques. Peut contenir des traces d'arachide, de _soja_, de LUPIN, et de sésame "
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:celery',
'en:crustaceans',
'en:eggs',
'en:fish',
'en:gluten',
'en:milk',
'en:molluscs',
'en:mustard',
'en:nuts',
]
) || diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{traces_tags},  [
'en:lupin',
'en:peanuts',
'en:sesame-seeds',
'en:soybeans',
]
);

$product_ref = {
	lc => "fr", lang => "fr",
	ingredients_text_fr => "Farine (blé), graines [sésame], condiments (moutarde), sucre de canne, lait de coco"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
"en:gluten",
"en:mustard",
"en:sesame-seeds",
]
);

is_deeply($product_ref->{traces_tags},  [
]
);

is($product_ref->{ingredients_text_with_allergens_fr},
'Farine (<span class="allergen">blé</span>), graines [<span class="allergen">sésame</span>], condiments (<span class="allergen">moutarde</span>), sucre de canne, lait de coco'
);


$product_ref = {
	lc => "fr", lang => "fr",
	ingredients_text_fr => "Farine de blé et de lupin, épices (soja, moutarde et céleri), crème de cassis, traces de fruits à coques, d'arachide et de poisson"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
"en:celery",
"en:gluten",
"en:lupin",
"en:mustard",
"en:soybeans",
]
);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{traces_tags},  [
"en:fish",
"en:nuts",
"en:peanuts",
]
);

is($product_ref->{ingredients_text_with_allergens_fr},
'Farine de <span class="allergen">blé</span> et de <span class="allergen">lupin</span>, épices (<span class="allergen">soja</span>, <span class="allergen">moutarde</span> et <span class="allergen">céleri</span>), crème de cassis, traces de <span class="allergen">fruits à coques</span>, d\'<span class="allergen">arachide</span> et de <span class="allergen">poisson</span>'
);


$product_ref = {
	lc => "fr", lang => "fr",
	ingredients_text_fr => "Garniture 61% : sauce tomate 32% (purée de tomate, eau, farine de blé, sel, amidon de maïs), mozzarella 26%, chiffonnade de jambon cuit standard 21% (jambon de porc, eau, sel, dextrose, sirop de glucose, stabilisant : E451, arômes naturels, gélifiant : E407, lactose, bouillon de porc, antioxydant : E316, conservateur : E250, ferments), champignons de Paris 15% (champignons, extrait naturel de champignon concentré), olives noires avec noyau (stabilisant : E579), roquette 0,6%, basilic et origan. Pourcentages exprimés sur la garniture. Pâte 39% : farine de blé, eau, levure boulangère, sel, farine de blé malté.",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
'en:gluten',
'en:milk',
]
);

is_deeply($product_ref->{traces_tags},  [
]
);

is($product_ref->{ingredients_text_with_allergens_fr},
'Garniture 61% : sauce tomate 32% (purée de tomate, eau, farine de <span class="allergen">blé</span>, sel, amidon de maïs), <span class="allergen">mozzarella</span> 26%, chiffonnade de jambon cuit standard 21% (jambon de porc, eau, sel, dextrose, sirop de glucose, stabilisant : E451, arômes naturels, gélifiant : E407, <span class="allergen">lactose</span>, bouillon de porc, antioxydant : E316, conservateur : E250, ferments), champignons de Paris 15% (champignons, extrait naturel de champignon concentré), olives noires avec noyau (stabilisant : E579), roquette 0,6%, basilic et origan. Pourcentages exprimés sur la garniture. Pâte 39% : farine de blé, eau, levure boulangère, sel, farine de blé malté.'
);


$product_ref = {
	lc => "fr", lang => "fr",
	ingredients_text_fr => "Traces éventuelles de céréales contenant du gluten, fruits à coques, arachide, soja et oeuf.",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
]
);

is_deeply($product_ref->{traces_tags},  [
'en:eggs',
'en:gluten',
'en:nuts',
'en:peanuts',
'en:soybeans',
]
);


$product_ref = {
	lc => "fr", lang => "fr",
	ingredients_text_fr => "Noix de Saint-Jacques"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:molluscs',
]
);


$product_ref = {
        lc => "fr", lang => "fr",
        ingredients_text_fr => "Noix de St-Jacques"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:molluscs',
]
);


$product_ref = {
        lc => "fr", lang => "fr",
        ingredients_text_fr => "Saint Jacques"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:molluscs',
]
);


$product_ref = {
        lc => "fr", lang => "fr",
        ingredients_text_fr => "St Jacques"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:molluscs',
]
);


$product_ref = {
        lc => "fr", lang => "fr",
        ingredients_text_fr => "Farine de blé 97%"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:gluten',
]
);

is($product_ref->{ingredients_text_with_allergens_fr},
'Farine de <span class="allergen">blé</span> 97%'
);

$product_ref = {
        lc => "fr", lang => "fr",
        ingredients_text_fr => "Farine de blé 97%"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:gluten',
]
);

is($product_ref->{ingredients_text_with_allergens_fr},
'Farine de <span class="allergen">blé</span> 97%'
);


$product_ref = {
        lc => "fr", lang => "fr",
        ingredients_text_fr => "Farine de blé 97%",
	allergens => "Sulfites",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:gluten',
'en:sulphur-dioxide-and-sulphites',
]
);


$product_ref = {
        lc => "fr", lang => "fr",
        ingredients_text_fr => "farine de graines de moutarde, 100 % semoule de BLE dur de qualité supérieure Traces éventuelles d'oeufs",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
	'en:gluten',
	'en:mustard',
]
);

is_deeply($product_ref->{traces_tags}, [
	'en:eggs',
]
);


$product_ref = {
lc => "fr", lang => "fr",
allergens => "Lait de vache, autres fruits à coque, autres céréales contenant du gluten",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
'en:gluten',
'en:milk',
'en:nuts',
]
);

#Finnish

$product_ref = {
	lc => "fi", lang => "fi",
	ingredients_text_fi => "Vesi, MAITO, VEHNÄjauho, sokeri, suola, _kananmunat_, sinappi, _äyriäiset_, pähkinöitä, _selleri_, KALA, _nilviäisiä_. Saattaa sisältää pieniä määriä LUPIINEJA, maapähkinöitä, _soijaa_ ja seesamia "
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:celery',
'en:crustaceans',
'en:eggs',
'en:fish',
'en:gluten',
'en:milk',
'en:molluscs',
'en:mustard',
'en:nuts',
]
) || diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{traces_tags},  [
'en:lupin',
'en:peanuts',
'en:sesame-seeds',
'en:soybeans',
]
);

$product_ref = {
	lc => "fi", lang => "fi",
	ingredients_text_fi => "Jauho (vehnä), siemenet [seesami], mausteet (sinappi), ruokosokeri, kookosmaito"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
"en:gluten",
"en:mustard",
"en:sesame-seeds",
]
);

is_deeply($product_ref->{traces_tags},  [
]
);

is($product_ref->{ingredients_text_with_allergens_fi},
'Jauho (<span class="allergen">vehnä</span>), siemenet [<span class="allergen">seesami</span>], mausteet (<span class="allergen">sinappi</span>), ruokosokeri, kookosmaito'
);

$product_ref = {
	lc => "fi", lang => "fi",
	ingredients_text_fi => "vehnä ja lupiinijauho, mausteet (soija, sinappi ja selleri), saattaa sisältää pieniä määriä pähkinöitä, maapähkinöitä ja kalaa"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
"en:celery",
"en:gluten",
"en:lupin",
"en:mustard",
"en:soybeans",
]
);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{traces_tags},  [
"en:fish",
"en:nuts",
"en:peanuts",
]
);

is($product_ref->{ingredients_text_with_allergens_fi},
'<span class="allergen">vehnä</span> ja <span class="allergen">lupiinijauho</span>, mausteet (<span class="allergen">soija</span>, <span class="allergen">sinappi</span> ja <span class="allergen">selleri</span>), saattaa sisältää pieniä määriä <span class="allergen">pähkinöitä</span>, <span class="allergen">maapähkinöitä</span> ja <span class="allergen">kalaa</span>'
);


$product_ref = {
	lc => "fi", lang => "fi",
	ingredients_text_fi => "Täyte 61% : tomaattikastike 32% (tomaattipyree, vesi, vehnäjauho, suola, maissitärkkelys), mozzarella 26%, kinkku 21% (siankinkku, vesi, suola, dekstroosi, glukoosisiirappi, stabilisointiaine : E451, luontaiset aromit, hyytelöimisaine : E407, laktoosi, sianlihaliemi, hapettumisenestoaine : E316, säilöntäaine : E250, hapatteet), herkkusienet 15% (herkkusienet, luontainen herkkusieniuute), mustat oliivit (stabilisointiaine : E579), sinappikaali 0,6%, basilika ja oregano.",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
'en:gluten',
'en:milk',
]
);

is_deeply($product_ref->{traces_tags},  [
]
);

is($product_ref->{ingredients_text_with_allergens_fi},
'Täyte 61% : tomaattikastike 32% (tomaattipyree, vesi, <span class="allergen">vehnäjauho</span>, suola, maissitärkkelys), <span class="allergen">mozzarella</span> 26%, kinkku 21% (siankinkku, vesi, suola, dekstroosi, glukoosisiirappi, stabilisointiaine : E451, luontaiset aromit, hyytelöimisaine : E407, <span class="allergen">laktoosi</span>, sianlihaliemi, hapettumisenestoaine : E316, säilöntäaine : E250, hapatteet), herkkusienet 15% (herkkusienet, luontainen herkkusieniuute), mustat oliivit (stabilisointiaine : E579), sinappikaali 0,6%, basilika ja oregano.'
);

$product_ref = {
	lc => "fi", lang => "fi",
	ingredients_text_fi => "Saattaa sisältää muita gluteenia sisältäviä viljoja, pähkinöitä, maapähkinöitä, soijaa ja kananmunia.",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
]
);

is_deeply($product_ref->{traces_tags},  [
'en:eggs',
'en:gluten',
'en:nuts',
'en:peanuts',
'en:soybeans',
]
);

$product_ref = {
        lc => "fi", lang => "fi",
        ingredients_text_fi => "vehnäjauho 97%"
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:gluten',
]
);

is($product_ref->{ingredients_text_with_allergens_fi},
'<span class="allergen">vehnäjauho</span> 97%'
);

$product_ref = {
        lc => "fi", lang => "fi",
        ingredients_text_fi => "vehnäjauho 97%",
	allergens => "Sulfiitteja",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

diag explain $product_ref->{allergens_tags};

is_deeply($product_ref->{allergens_tags}, [
'en:gluten',
'en:sulphur-dioxide-and-sulphites',
]
);

$product_ref = {
        lc => "fi", lang => "fi",
        ingredients_text_fi => "sinappijauhe, VEHNÄsuurimo. Saattaa sisältää kananmunaa",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
	'en:gluten',
	'en:mustard',
]
);

is_deeply($product_ref->{traces_tags}, [
	'en:eggs',
]
);

$product_ref = {
lc => "fi", lang => "fi",
allergens => "Lehmänmaito, pähkinöitä, gluteenia sisältäviä viljoja.",
};

compute_languages($product_ref);
detect_allergens_from_text($product_ref);

is_deeply($product_ref->{allergens_tags}, [
'en:gluten',
'en:milk',
'en:nuts',
]
);

done_testing();
