#!/bin/bash

# load all data
./bin/rake db:prepare && \
  ./bin/rake db:populate_from_mrc && \
  ./bin/rake db:populate_from_paradox

# address barcodes (order is important)
./bin/rake db:fix_missing_barcodes && \
  ./bin/rake db:normalize_barcodes && \
  ./bin/rake db:set_fake_barcodes && \
  ./bin/rake db:calculate_extents:tapes && \
  ./bin/rake db:calculate_extents:duration && \
  ./bin/rake db:add_secondary_source[src.txt,"United States Holocaust Memorial Museum"]

# generating EAD
bundler exec rake ead:from_single

# locations
bundler exec rake db:generate_locations_sql
