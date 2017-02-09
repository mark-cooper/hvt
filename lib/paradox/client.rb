module Paradox

  class Client

    attr_reader :agents, :records

    def initialize(db)
      @db      = db
      @query   = set_query
      @records = Hash.new { |hash, key| hash[key] = [] }
      @agents  = [] # hash [ { name: "Tom Hardy", role: "Actor" } ]
    end

    def add_agents(row)
      agent_fields.each do |field, role|
        if row.has_key?(field) and !row[field].empty?
          @agents << { name: row[field], role: role } unless has_agent?(row[field], role)
        end
      end
    end

    def agent_fields
      {}
    end

    def has_agent?(name, role)
      @agents.find { |a| a[:name] == name and a[:role] == role }
    end

    def set_query
      @query = nil
    end

  end

end