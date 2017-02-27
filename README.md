# HVT

A micro-app for aggregating data from Paradox db and mrc records.

## Setup

- Add mrc records (individual marcxml) to `db/data`.
- Load paradox db into MySQL as `paradox`.

```bash
# testing record loads
./bin/rake db:prepare && ./bin/rake db:populate_sample_data
./bin/rake db:prepare && ./bin/rake db:populate_from_mrc
./bin/rake db:prepare && ./bin/rake db:populate_from_paradox

# load all data
./bin/rake db:prepare && \
  ./bin/rake db:populate_from_mrc && \
  ./bin/rake db:populate_from_paradox
```

---