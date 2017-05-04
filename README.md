# HVT

A micro-app for aggregating data from Paradox db and mrc records.

## Setup

- Run mrc to marcxml conversion script.
- Add mrc records (as individual marcxml) to `db/data`.
- Load paradox db into MySQL as `paradox`.
- Copy and unzip mediainfo files in `db/mediainfo`.

```sql
UPDATE persdata SET name = 'Unspecified' WHERE name = '';
UPDATE persdata SET name = 'Green, Eileen' WHERE name = 'Green, IIleen';
UPDATE persdata SET name = 'SMITH, EDYTA' WHERE name = 'SMITH, EDyTA';
UPDATE persdata SET name = 'Villenberg, Samuel' WHERE name = 'WVillenberg, Samuel';
```

Test load data:

```bash
./bin/rake db:prepare && ./bin/rake db:populate_sample_data
./bin/rake db:prepare && ./bin/rake db:populate_from_mrc
./bin/rake db:prepare && ./bin/rake db:populate_from_paradox
```

Loading all data:

```bash
./bin/rake db:prepare && \
  ./bin/rake db:populate_from_mrc && \
  ./bin/rake db:populate_from_paradox

# update barcodes (order is important)
# calculate extents
# set secondary source for matching records
./bin/rake db:fix_missing_barcodes && \
  ./bin/rake db:normalize_barcodes && \
  ./bin/rake db:set_fake_barcodes && \
  ./bin/rake db:calculate_extents:tapes && \
  ./bin/rake db:calculate_extents:duration && \
  ./bin/rake db:add_secondary_source[src.txt,"United States Holocaust Memorial Museum"]
```

Generating EAD:

```
bundler exec rake ead:from_single
bundler exec rake ead:from_collection
```

---
