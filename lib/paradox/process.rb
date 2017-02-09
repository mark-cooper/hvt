module Paradox

  class Process < Client

    def agent_fields
      {
        "Summary by" => "Summarizer",
        "Cataloged by" => "Cataloger",
        "Edited by" => "Editor",
        "Input by" => "Inputter",
        "Corrected by" => "Corrector",
        "Produced by" => "Producer",
        "First proof by" => "Proofer",
        "Second proof by" => "Proofer",
        "Third proof by" => "Proofer",
      }    
    end

    def query
      @db.query(@query, cast: false).each do |row|
        id = row["T-number"].to_i
        next if id == 0
        add_agents row

        @records[id] << {
          summary_by: row["Summary by"],
          summary_date: row["Summary date"],
          cataloged_by: row["Cataloged by"],
          cataloged_date: row["Cataloged date"],
          input_by: row["Input by"],
          input_date: row["Input date"],
          edited_by: row["Edited by"],
          edited_date: row["Editing date"],
          corrected_by: row["Corrected by"],
          corrected_date: row["Correction date"],
          produced_by: row["Produced by"],
          produced_date: row["Production date"],
          first_proof_by: row["First proof by"],
          first_proof_date: row["First proof date"],
          second_proof_by: row["Second proof by"],
          second_proof_date: row["Second proof date"],
          third_proof_by: row["Third proof by"],
          third_proof_date: row["Third proof date"],
          note: row["Notes"],
        }
        # break
      end
      @records
    end

    def set_query
      @query = "SELECT * FROM `process`"
    end

  end

end