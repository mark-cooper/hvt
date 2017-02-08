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
    client
  end
end