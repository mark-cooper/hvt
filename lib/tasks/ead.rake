# lib/tasks/from_ead.rake
require_relative "../ead/ead.rb"
namespace :ead do
  HVT_EAD_DIR = ENV.fetch('HVT_EAD_DIR', "db/ead")
  FileUtils.mkdir_p HVT_EAD_DIR

  def write(filename, ead)
    File.open(File.join(HVT_EAD_DIR, filename), 'w:UTF-8') do |f|
      f.write ead
    end
  end

  desc 'Create an EAD from all HVT records'
  task from_all: :environment do
    collections = {}
    Collection.all.includes([
      records: [:interviews, :proofs, :tapes]
    ]).references(:records).each do |collection|
      records = collection.records.find_all { |r| r.has_mrc }
      collections[collection] = records
    end
    ead = EAD::FromRecords.process(collections)
    write "HVT-all.xml", ead
  end

  desc 'Create an EAD from each HVT collection'
  task from_collection: :environment do
    Collection.all.includes([
      records: [:interviews, :proofs, :tapes]
    ]).references(:records).each do |collection|
      records = collection.records.find_all { |r| r.has_mrc }
      ead     = EAD::FromCollection.process(collection, records)
      write "HVT-#{collection.name.gsub(/\s/, '_')}.xml", ead
    end
  end

  desc 'Create an EAD from each HVT record'
  task from_single: :environment do
    Record.where(has_mrc: true).all.includes([
      :interviews,
      :proofs,
      :tapes,
    ]).references(:interviews, :proofs, :tapes).each do |record|
      ead = EAD::FromRecord.process(record)
      write "HVT-#{record.id}.xml", ead
    end
  end
end