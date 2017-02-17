require 'date'
require 'pp'
require_relative "client"
require_relative "primary"
require_relative "process"
require_relative "persdata"
require_relative "cassette"

module Paradox

  def self.all_agents
    agents = Hash.new { |hash, key| hash[key] = {} }
    Agent.all.each do |agent|
      agents[agent.type][agent.name] = agent
    end
    agents
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

  def self.create_records(records)
    # preload agents ...
    agents = Paradox.all_agents

    records.each do |id, data|
      r      = data[:record]
      i      = data[:interviews]
      t      = data[:tapes]
      
      # create record
      record = Record.find(id) rescue nil
      record = Record.create!(id: id) unless record
      
      record.extent         = r[:count]
      record.collection     = Paradox.find_or_create_collection!(r[:collection])

      # these attributes are merged in from 'process' so need to check conservatively
      record.note           = r[:note] if r.has_key? :note
      record.summary_by     = [ agents["Summarizer"][r[:summary_by]] ].compact
      record.summary_date   = Paradox.parse_date(r[:summary_date])

      record.cataloged_by   = [ agents["Cataloger"][r[:cataloged_by]] ].compact
      record.cataloged_date = Paradox.parse_date(r[:cataloged_date])

      record.input_by       = [ agents["Inputter"][r[:input_by]] ].compact
      record.input_date     = Paradox.parse_date(r[:input_date])

      record.edited_by      = [ agents["Editor"][r[:edited_by]] ].compact
      record.edited_date    = Paradox.parse_date(r[:edited_date])

      record.corrected_by   = [ agents["Corrector"][r[:corrected_by]] ].compact
      record.corrected_date = Paradox.parse_date(r[:corrected_date])

      record.produced_by    = [ agents["Producer"][r[:produced_by]] ].compact
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
      Paradox.create_interviews record, i
      
      # create tapes
      Paradox.create_tapes record, t
    end
  end

  def self.create_proofs(record, proofs, agents)
    proofs.each do |proof|
      proofer = agents["Proofer"][proof[:name]]
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

  def self.create_interviews(record, interviews)
    # TODO
  end

  def self.create_tapes(record, tapes)
    # TODO
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

  def self.parse_date(date)
    Date.parse(date) if date and !date.empty?
  end

end