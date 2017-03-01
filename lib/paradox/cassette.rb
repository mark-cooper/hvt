module Paradox

  class Cassette < Client

    def agent_fields
      {}    
    end

    def query
      @db.query(@query, cast: false).each do |row|
        id = row["T-number"].to_i
        next if id == 0

        @records[id] << {
          recording_type: row["Recording type"],
          number:         row["Cassette number"].to_i,
          format:         row["Tape format"],
          source:         row["Created from"],
          date:           row["Creation date"],
          manufacturer:   row["Stock manufacturer"],
          note:           row["Notes"],
          condition_tape: row["Tape wind"],
          condition_odor: row["Odor"],
          condition_edge: row["Edge damage"],
          barcode:        row["Barcode"],
          shared_with:    row["Shared with"],
          inventory_status: {
            permanent_location:    row["PermanentLocation"],
            temporary_location:    row["TemporaryLocation"],
            location_status:       row["Location status"],
            restoration_code:      row["RestorationCode"],
            offsite_location_code: row["OffsiteLocationCode"],
          }
        }
        # break
      end
      @records
    end

    def set_query
      @query = "SELECT * FROM `cassette`"
    end

  end

end