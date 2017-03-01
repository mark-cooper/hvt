# lib/tasks/fix_missing_barcodes.rake
require 'csv'
namespace :db do
  desc 'Find tapes with barcode "0"'
  task find_missing_barcodes: :environment do
    csv_string = CSV.generate do |csv|
      csv << ["record_id", "recording_type", "number", "shared_with"]
      Tape.where(barcode: "0").all.each do |tape|
        csv << [tape.record_id, tape.recording_type, tape.number, tape.shared_with]
      end
    end
    puts csv_string
  end

  desc 'Update barcodes for tapes with barcode "0"'
  task fix_missing_barcodes: :environment do
    Tape.where(barcode: "0").all.each do |tape|
      next if tape.shared_with == 0
      shared_tape = Tape.where(
        record_id: tape.shared_with,
        recording_type: tape.recording_type
      ).first
      next unless shared_tape
      barcode = shared_tape.barcode
      puts "Updating barcode for #{tape.record_id}:#{tape.recording_type}:#{tape.number}:#{barcode}"
      tape.barcode = barcode
      tape.save
    end
  end
end