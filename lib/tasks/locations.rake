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
      f.puts "CREATE TABLE barcode_loc ("
      f.puts "\tid INT NOT NULL AUTO_INCREMENT PRIMARY KEY, barcode VARCHAR(255), top_container_id INT, loc VARCHAR(255), location_id INT, KEY(barcode), KEY(loc)"
      f.puts ");"
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
UPDATE barcode_loc bl
  JOIN top_container tc ON bl.barcode = tc.barcode
  SET bl.top_container_id = tc.id;

UPDATE barcode_loc bl
  JOIN location l ON bl.loc = l.title
  SET bl.location_id = l.id;

# deaccession related
DELETE FROM barcode_loc WHERE top_container_id IS NULL;

INSERT INTO top_container_housed_at_rlshp
  (top_container_id, location_id, aspace_relationship_position, jsonmodel_type, status, created_by, last_modified_by, system_mtime, user_mtime)
SELECT top_container_id, location_id, 0, 'container_location', 'current', 'admin', 'admin', NOW(), NOW()
  FROM barcode_loc;

UPDATE top_container tc
  JOIN barcode_loc bl ON bl.top_container_id = tc.id
  SET system_mtime = NOW();

UPDATE location loc
  JOIN barcode_loc bl ON bl.location_id = loc.id
  SET system_mtime = NOW();
      }
    end
  end
end