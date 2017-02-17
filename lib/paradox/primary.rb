module Paradox

  class Primary < Client

    def query
      @db.query(@query, cast: false).each do |row|
        id = row["T-number"].to_i
        next if id == 0
        add_collection row["Collection"]

        @records[id] << {
          collection: row["Collection"],
          count: row["Master count"].to_i,
        }
        # break
      end
      @records
    end

    def set_query
      @query = "SELECT * FROM `primary`"
    end

  end

end