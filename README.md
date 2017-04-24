# HVT

A micro-app for aggregating data from Paradox db and mrc records.

## Setup

- Run mrc to marcxml conversion script.
- Add mrc records (as individual marcxml) to `db/data`.
- Load paradox db into MySQL as `paradox`.
- `UPDATE persdata SET name = 'Unspecified' WHERE name = '';`

Test load data:

```bash
./bin/rake db:prepare && ./bin/rake db:populate_sample_data
./bin/rake db:prepare && ./bin/rake db:populate_from_mrc
./bin/rake db:prepare && ./bin/rake db:populate_from_paradox
```

Loading all data:

```
./bin/rake db:prepare && \
  ./bin/rake db:populate_from_mrc && \
  ./bin/rake db:populate_from_paradox

# update barcodes (order is important)
./bin/rake db:fix_missing_barcodes && \
  ./bin/rake db:normalize_barcodes && \
  ./bin/rake db:set_fake_barcodes

# set secondary source for matching records
./bin/rake db:add_secondary_source[src.txt,"United States Holocaust Memorial Museum"]
```

Generating EAD:

```
bundler exec rake ead:from_single
bundler exec rake ead:from_collection
```

---