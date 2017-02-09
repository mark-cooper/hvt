# lib/tasks/from_paradox.rake
require_relative "../paradox/paradox"
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

    records = Hash.new { |hash, key| hash[key] = {} }
    agents  = []

    primary          = Paradox::Primary.new(client)
    primary_records  = primary.query

    process          = Paradox::Process.new(client)
    process_records  = process.query
    agents.concat process.agents

    persdata         = Paradox::PersData.new(client)
    persdata_records = persdata.query
    agents.concat persdata.agents

    cassette         = Paradox::Cassette.new(client)
    cassette_records = cassette.query

    primary_records.keys.each do |id|
      records[id][:record] = primary_records[id].first
      records[id][:record] = records[id][:record].merge(
        process_records[id].first
      ) if process_records.has_key? id
      records[id][:interviews] = persdata_records[id]
      records[id][:tapes] = cassette_records[id]
    end

    puts "Creating agents! #{Time.now}"
    Paradox.create_agents agents
    puts "Creating records! #{Time.now}"
    Paradox.create_records records
    puts "Database updated from Paradox! #{Time.now}"
  end
end