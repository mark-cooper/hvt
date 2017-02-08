# lib/tasks/from_paradox.rake
namespace :db do
  desc 'Populate the database from paradox'
  task populate_from_paradox: :environment do
    client = Mysql2::Client.new(
      host: ENV.fetch('PARADOX_HOST', '127.0.0.1'),
      port: ENV.fetch('PARADOX_PORT', 3306),
      database:ENV.fetch('PARADOX_NAME', 'paradox'),
      username: ENV.fetch('PARADOX_USER', 'root'),
      password:ENV.fetch('PARADOX_PASS', '123456'),
    )
    puts "Connected to MySQL!"

    records = {}
    # record data
    client.query("SELECT * FROM `primary`").each do |row|
      puts row
      id = row["T-number"].to_i
      next if id == 0

      records[id] = { record: {}, interviews: [], tapes: [] }
      break
    end

    # additional record data
    client.query("SELECT * FROM `process`").each do |row|
      puts row
      id = row["T-number"].to_i
      next if id == 0
      break
    end

    # interviews data
    client.query("SELECT * FROM `persdata`").each do |row|
      puts row
      id = row["T-number"].to_i
      next if id == 0
      break
    end

    # tapes data
    client.query("SELECT * FROM `cassette`").each do |row|
      puts row
      id = row["T-number"].to_i
      next if id == 0

      records[id][:tapes] << {
        type:    row["Recording type"],
        number:  row["Cassette number"].to_i,
        format:  row["Tape format"],
        barcode: row["Barcode"],
      }
      break
    end

    puts records
  end
end