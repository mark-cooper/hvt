# HVT

A micro-app for aggregating data from Paradox db and mrc records.

## Setup

- Run mrc to marcxml conversion script.
- Add mrc records (as individual marcxml) to `db/data`.
- Load paradox db into MySQL as `paradox`.
- `UPDATE persdata SET name = 'Unspecified' WHERE name = '';`

```bash
# testing record loads
./bin/rake db:prepare && ./bin/rake db:populate_sample_data
./bin/rake db:prepare && ./bin/rake db:populate_from_mrc
./bin/rake db:prepare && ./bin/rake db:populate_from_paradox

# load all data
./bin/rake db:prepare && \
  ./bin/rake db:populate_from_mrc && \
  ./bin/rake db:populate_from_paradox

# fix missing barcodes
./bin/rake db:fix_missing_barcodes
```

---