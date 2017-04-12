#!/bin/bash

# load all data
./bin/rake db:prepare && \
  ./bin/rake db:populate_from_mrc && \
  ./bin/rake db:populate_from_paradox

# address barcodes (order is important)
./bin/rake db:fix_missing_barcodes && \
  ./bin/rake db:normalize_barcodes && \
  ./bin/rake db:set_fake_barcodes

# generating EAD
bundler exec rake ead:from_single
