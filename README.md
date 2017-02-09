# HVT

A micro-app for aggregating data from Paradox db and mrc records.

```bash
# testing record loads
./bin/rake db:prepare && ./bin/rake db:populate_sample_data
./bin/rake db:prepare && ./bin/rake db:populate_from_mrc
./bin/rake db:prepare && ./bin/rake db:populate_from_paradox

# full load
./bin/rake db:prepare && \
  ./bin/rake db:populate_from_mrc && \
  ./bin/rake db:populate_from_paradox
```

---