require 'date'
require 'pp'
require_relative "client"
require_relative "primary"
require_relative "process"
require_relative "persdata"
require_relative "cassette"

module Paradox

  def self.create_agents(agents)
    agents.each do |agent|
      agent[:role].constantize.create!(name: agent[:name])
    end
  end

  def self.create_records(records)
    records.each do |id, data|
      r      = data[:record]
      i      = data[:interviews]
      t      = data[:tapes]
      
      # create record
      record = Record.find(id) rescue nil
      record = Record.create!(id: id) unless record
      
      record.extent         = r[:count]
      record.collection     = r[:collection]
      record.note           = r[:note] if r.has_key? :note
      record.summary_by     = Paradox.find_agent r[:summary_by], 'Summarizer'
      record.summary_date   = Paradox.parse_date(r[:summary_date])
      record.cataloged_by   = Paradox.find_agent r[:cataloged_by], "Cataloger"
      record.cataloged_date = Paradox.parse_date(r[:cataloged_date])
      record.input_by       = Paradox.find_agent r[:input_by], "Inputter"
      record.input_date     = Paradox.parse_date(r[:input_date])
      record.edited_by      = Paradox.find_agent r[:edited_by], "Editor"
      record.edited_date    = Paradox.parse_date(r[:edited_date])
      record.corrected_by   = Paradox.find_agent r[:corrected_by], "Corrector"
      record.corrected_date = Paradox.parse_date(r[:corrected_date])
      record.produced_by    = Paradox.find_agent r[:produced_by], "Producer"
      record.produced_date  = Paradox.parse_date(r[:produced_date])

      record.save

      # create proofs
      first, second, third = nil
      first  = Paradox.get_proof(r[:first_proof_by], r[:first_proof_date])
      second = Paradox.get_proof(r[:second_proof_by], r[:second_proof_date])
      third  = Paradox.get_proof(r[:third_proof_by], r[:third_proof_date])
      proofs = [first, second, third].compact

      Paradox.create_proofs record, proofs
      
      # create interviews
      Paradox.create_interviews record, i
      
      # create tapes
      Paradox.create_tapes record, t
    end
  end

  def self.create_proofs(record, proofs)
    proofs.each do |proof|
      proofer = Paradox.find_agent(proof[:name], "Proofer")
      date    = Paradox.parse_date(proof[:date])
      record.proofs.create!({
        proofer: proofer,
        date: date,
      })
    end
  end

  def self.get_proof(name, date)
    proof = nil
    proof = { name: name, date: date } if name and !name.empty?
    proof
  end

  def self.create_interviews(record, interviews)
    # TODO
  end

  def self.create_tapes(record, tapes)
    # TODO
  end

  def self.find_agent(name, role = nil)
    agent  = nil
    role   = role ? role.constantize : Role
    agents = role.where(name: name)
    agent  = agents.first if agents and agents.count == 1
    agent
  end

  def self.parse_date(date)
    d = nil
    d = Date.parse(date) if date and !date.empty?
    d
  end

end