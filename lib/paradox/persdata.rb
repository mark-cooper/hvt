module Paradox

  class PersData < Client

    def agent_fields
      {
        "Name" => "Interviewee",
        "First interviewer" => "Interviewer",
        "Second interviewer" => "Interviewer",
        "Third interviewer" => "Interviewer",
        "Fourth interviewer" => "Interviewer",
      }
    end

    def query
      @db.query(@query, cast: false).each do |row|
        id = row["T-number"].to_i
        next if id == 0
        add_agents row

        @records[id] << {
          date: row["Date of interview"],
          length: row["Length of interview"],
          interviewee: row["Name"],
          interviewer_1: row["First interviewer"],
          interviewer_2: row["Second interviewer"],
          interviewer_3: row["Third interviewer"],
          interviewer_4: row["Fourth interviewer"],
          notes: row["Notes"],
        }
        # break
      end
      @records
    end

    def set_query
      @query = "SELECT * FROM `persdata`"
    end

  end

end