# lib/tasks/locations.rake
namespace :db do
  desc 'Generate top container location rlshp sql'
  task generate_locations_sql: :environment do
    use_copy_locs = Tape.where(recording_type: 'Use copy')
      .pluck(:barcode).uniq.map { |b| "('#{b}', 'SML, B69 [Shelf: unspecified]')"}
    
    other_locs    = Tape.where.not(recording_type: 'Use copy')
      .pluck(:barcode).uniq.map { |b| "('#{b}', 'Library Shelving Facility [LSF]')"}
    
    File.open("locations.sql", "w") do |f|
      f.puts "DROP TABLE IF EXISTS barcode_loc;"
      f.puts "CREATE TABLE barcode_loc (barcode VARCHAR(255), loc VARCHAR(255));"
      f.puts
      f.puts "INSERT INTO barcode_loc (barcode, loc) VALUES"
      f.puts use_copy_locs.join(",\n")
      f.puts ";"
      f.puts
      f.puts "INSERT INTO barcode_loc (barcode, loc) VALUES"
      f.puts other_locs.join(",\n")
      f.puts ";"
      f.puts
      f.puts %{
INSERT INTO top_container_housed_at_rlshp
  (top_container_id, location_id, jsonmodel_type, status, created_by, last_modified_by, system_mtime, user_mtime)
SELECT tc.id, loc.id, 'container_location', 'current', 'admin', 'admin', NOW(), NOW()
  FROM barcode_loc bl
  JOIN top_container tc ON tc.barcode = bl.barcode
  JOIN location loc ON loc.title = bl.loc;

UPDATE top_container tc
  JOIN barcode_loc bl ON bl.barcode = tc.barcode 
  SET system_mtime = NOW();

UPDATE location loc
  JOIN barcode_loc bl ON bl.loc = loc.title 
  SET system_mtime = NOW();
      }
    end
  end
end