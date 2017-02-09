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
          type:    row["Recording type"],
          number:  row["Cassette number"].to_i,
          format:  row["Tape format"],
          barcode: row["Barcode"],
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