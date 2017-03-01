require 'date'
require 'pp'
require 'set'
require_relative "client"
require_relative "primary"
require_relative "process"
require_relative "persdata"
require_relative "cassette"

module Paradox

  def self.all_agents
    agents = Hash.new { |hash, key| hash[key] = {} }
    Agent.all.each do |agent|
      # downcase lookups to normalize irregular entries
      agents[agent.type][agent.name.downcase] = agent
    end
    agents
  end

  def self.all_collections
    collections = {}
    Collection.all.each { |c| collections[c[:name]] = c }
    collections
  end

  def self.create_agents(agents)
    agents.each do |agent|
      begin
        agent[:type].constantize.create!(name: agent[:name])
      rescue
        # swallow duplicate agent errors and move along ...
      end
    end
  end

  def self.create_collections(collections)
    collections.each do |collection|
      Collection.create!(name: collection)
    end
  end

  def self.create_records(records)
    # preload agents and collections ...
    agents      = Paradox.all_agents
    collections = Paradox.all_collections

    records.each do |id, data|
      r      = data[:record]
      i      = data[:interviews]
      t      = data[:tapes]
      
      # create record
      record = Record.find(id) rescue nil
      record = Record.create!(id: id) unless record
      
      record.extent         = r[:count]
      record.collection     = collections[r[:collection]]

      # these attributes are merged in from 'process' so need to check conservatively
      record.note           = r[:note] if r.has_key? :note
      record.summary_by     = [ Paradox.lookup_agent(agents, "Summarizer", r[:summary_by]) ].compact
      record.summary_date   = Paradox.parse_date(r[:summary_date])

      record.cataloged_by   = [ Paradox.lookup_agent(agents, "Cataloger", r[:cataloged_by]) ].compact
      record.cataloged_date = Paradox.parse_date(r[:cataloged_date])

      record.input_by       = [ Paradox.lookup_agent(agents, "Inputter", r[:input_by]) ].compact
      record.input_date     = Paradox.parse_date(r[:input_date])

      record.edited_by      = [ Paradox.lookup_agent(agents, "Editor", r[:edited_by]) ].compact
      record.edited_date    = Paradox.parse_date(r[:edited_date])

      record.corrected_by   = [ Paradox.lookup_agent(agents, "Corrector", r[:corrected_by]) ].compact
      record.corrected_date = Paradox.parse_date(r[:corrected_date])

      record.produced_by    = [ Paradox.lookup_agent(agents, "Producer", r[:produced_by]) ].compact
      record.produced_date  = Paradox.parse_date(r[:produced_date])

      record.has_paradox = true
      record.save

      # create proofs
      first, second, third = nil
      first  = Paradox.get_proof(r[:first_proof_by], r[:first_proof_date])
      second = Paradox.get_proof(r[:second_proof_by], r[:second_proof_date])
      third  = Paradox.get_proof(r[:third_proof_by], r[:third_proof_date])
      proofs = [first, second, third].compact

      Paradox.create_proofs record, proofs, agents
      
      # create interviews
      Paradox.create_interviews record, i, agents
      
      # create tapes
      Paradox.create_tapes record, t
    end
  end

  def self.create_proofs(record, proofs, agents)
    proofs.each do |proof|
      proofer = Paradox.lookup_agent(agents, "Proofer", proof[:name])
      date    = Paradox.parse_date(proof[:date])
      record.proofs.create!({
        proofers: [ proofer ],
        date: date,
      })
    end
  end

  def self.get_proof(name, date)
    { name: name, date: date } if name and !name.empty?
  end

  def self.create_interviews(record, interviews, agents)
    interviews.each do |interview|
      interviewee  = Paradox.lookup_agent(agents, "Interviewee", interview[:interviewee])
      interviewer1 = Paradox.lookup_agent(agents, "Interviewer", interview[:interviewer_1])
      interviewer2 = Paradox.lookup_agent(agents, "Interviewer", interview[:interviewer_2])
      interviewer3 = Paradox.lookup_agent(agents, "Interviewer", interview[:interviewer_3])
      interviewer4 = Paradox.lookup_agent(agents, "Interviewer", interview[:interviewer_4])
      interviewers = [interviewer1, interviewer2, interviewer3, interviewer4]
      record.interviews.create!({
        interviewees: [ interviewee ],
        interviewers: interviewers.compact,
        date: interview[:date],
        length: interview[:length],
        note: interview[:notes],
      })
    end
  end

  def self.create_tapes(record, tapes)
    tapes.each do |tape|
      tape[:date] = Paradox.parse_date(tape[:date])
      record.tapes.create!(tape)
    end
  end

  def self.find_agent(name, type = nil)
    type   = type ? type.constantize : Agent
    agents = type.where(name: name)
    agents.first if agents and agents.count == 1
  end

  def self.find_or_create_collection!(name)
    collection = Collection.where(name: name)
    if collection.any?
      collection = collection.first
    else
      collection = Collection.create!(name: name)
    end
    collection
  end

  # agents have downcased name for lookups
  def self.lookup_agent(agents, type, name)
    agents[type][name.downcase] unless name.nil?
  end

  def self.parse_date(date)
    Date.parse(date) if date and !date.empty?
  end

end