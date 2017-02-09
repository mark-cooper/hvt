module Paradox

  class Client

    attr_reader :agents, :records

    def initialize(db)
      @db      = db
      @query   = set_query
      @records = Hash.new { |hash, key| hash[key] = [] }
      @agents  = [] # hash [ { name: "Tom Hardy", type: "Actor" } ]
    end

    def add_agents(row)
      agent_fields.each do |field, type|
        if row.has_key?(field) and !row[field].empty?
          @agents << { name: row[field], type: type } unless has_agent?(row[field], type)
        end
      end
    end

    def agent_fields
      {}
    end

    def has_agent?(name, type)
      @agents.find { |a| a[:name] == name and a[:type] == type }
    end

    def set_query
      @query = nil
    end

  end

end