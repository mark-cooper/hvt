# lib/tasks/from_ead.rake
require_relative "../ead/ead.rb"
namespace :ead do
  HVT_EAD_DIR = ENV.fetch('HVT_EAD_DIR', "db/ead")
  FileUtils.mkdir_p HVT_EAD_DIR
  FileUtils.rm_rf(Dir.glob("#{HVT_EAD_DIR}/*.xml"))

  def write(filename, ead)
    File.open(File.join(HVT_EAD_DIR, filename), 'w') do |f|
      f.write ead
    end
  end

  desc 'Create an EAD from all HVT records'
  task from_all: :environment do
    records = Record.where(has_mrc: true).all
    puts "Generating EAD from all records: #{records.count}"
    ead = EAD::FromRecords.process(records)
    write "HVT-all.xml", ead
  end

  desc 'Create an EAD from each HVT collection'
  task from_collection: :environment do
    Collection.all.each do |collection|
      records = collection.records.find_all { |r| r.has_mrc }
      puts "Generating EAD for #{collection.name}: #{records.count}"
      ead = EAD::FromCollection.process(collection, records)
      write "HVT-#{collection.name.gsub(/\s/, '_')}.xml", ead
    end
  end

  desc 'Create an EAD from each HVT record'
  task from_single: :environment do
    Record.where(has_mrc: true).all.each do |record|
      puts "Generating EAD for HVT #{record.id}: #{record.title}"
      ead = EAD::FromRecord.process(record)
      write "HVT-#{record.id}.xml", ead
    end
  end
end