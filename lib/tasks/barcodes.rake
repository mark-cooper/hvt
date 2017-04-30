# lib/tasks/barcodes.rake
require 'csv'
require 'securerandom'
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
      number  = shared_tape.number
      puts "Updating barcode for #{tape.record_id}:#{tape.recording_type}:#{number}:#{barcode}"
      tape.barcode = barcode
      tape.number  = number
      tape.save
    end
  end

  desc 'Normalize duplicate barcode indicators'
  task normalize_barcodes: :environment do
    sql = <<-SQL
      SELECT id FROM hvt.tapes WHERE barcode IN
      (
        SELECT barcode FROM hvt.tapes GROUP BY barcode HAVING count(barcode) > 1 ORDER BY record_id
      )
      AND barcode != '0'
      AND number != 1
      ORDER BY barcode;
    SQL
    ActiveRecord::Base.connection.select_all(sql).rows.map { |id| id }.each do |id|
      tape = Tape.find(id).first
      puts "Normalizing indicator for #{tape.id} with barcode #{tape.barcode}"
      tape.number = 1
      tape.save
    end
  end

  desc 'Set a fake barcode for those with "0"'
  task set_fake_barcodes: :environment do
    Tape.where(barcode: "0").all.each do |tape|
      barcode = "hvt_#{SecureRandom.hex(5)}" # 14 chars
      puts "Assigning barcode #{barcode} to #{tape.id}"
      tape.barcode = barcode
      tape.save
    end
  end
end