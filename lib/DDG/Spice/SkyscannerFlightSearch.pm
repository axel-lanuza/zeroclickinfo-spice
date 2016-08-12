package DDG::Spice::SkyscannerFlightSearch;

# ABSTRACT: This IA will call Skyscanner's API to retrieve the cheapest flight prices to 
# the chosen destination

use DDG::Spice;
use strict;
use warnings;

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching
spice is_cached => 1;
spice proxy_cache_valid => '200 1d'; # defaults to this automatically

spice wrap_jsonp_callback => 1; # only enable for non-JSONP APIs (i.e. no &callback= parameter)
spice from => '([^/]*)/([^/]*)';
spice to => 'http://partners.api.skyscanner.net/apiservices/browseroutes/v1.0/GB/GBP/en-GB/$1/$2/anytime/anytime?apikey={{ENV{DDG_SPICE_SKYSCANNER_APIKEY}}}';
spice alt_to => {
    skyscanner_images => {
        to => 'https://gateway.skyscanner.net/travel-api/v1/entities?external_ids=$1&enhancers=images&apikey={{ENV{DDG_SPICE_SKYSCANNER_IMAGES_APIKEY}}}'
        # proxy_cache_valid => '418 1d' #disable api response caching, if needed
    }
};

# Triggers - https://duck.co/duckduckhack/spice_triggers
#triggers any => 'skyscanner flights to', 'skycanner show me flights to ', 'skyscanner inspire me';
triggers any => 'skyscanner', 'skycanner flights', 'skyscanner inspire me', 'skyscanner deals';

# Handle statement
handle remainder => sub {
    # get user's location for default origin
    my $origin = "";
    my $destination = "";
    
    # if no origin is specified then use the user's location
    if ($origin eq "") {
        $origin = $loc->country_code;
    }
    # if no destination is specified then use 'anywhere'
    if ($destination eq "") {
        $destination = "anywhere";
    } 
    return $origin, $destination;
    
    # return $_ if $_;
    # Query is in $_ or @_, depending on the handle you chose...if you
    # need to do something with it before returning
    #return "anywhere";
};

1;
