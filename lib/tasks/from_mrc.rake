# lib/tasks/from_mrc.rake
require_relative "../mrc/mrc.rb"
namespace :db do
  desc 'Populate the database from mrc xml records'
  task populate_from_mrc: :environment do
    hvt_mrc_dir = ENV.fetch('HVT_MRC_DIR', "db/data")
    records     = {}

    Dir["#{hvt_mrc_dir}/*.xml"].each do |mrc|
      reader = MARC::XMLReader.new(mrc)
      # each file is 1 record
      for record in reader
        id          = record[MRC::ID_TAG][MRC::ID_SUB].to_i
        records[id] = record
      end
    end

    puts "Creating records! #{Time.now}"
    MRC.create_records records
    puts "Database updated from mrc! #{Time.now}"
  end
end