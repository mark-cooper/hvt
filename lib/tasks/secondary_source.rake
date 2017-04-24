# lib/tasks/secondary_source.rake
namespace :db do
  desc 'Add secondary source to matching HVT records'
  task :add_secondary_source, [:input, :source] => :environment do |t, args|
    input  = args[:input]
    source = args[:source]
    raise "Invalid input file #{input}" unless File.file? input
    File.open(input).each_line do |line|
      id     = line.chomp.to_i
      record = Record.find(id)
      record.secondary_source = source
      record.save
      puts "Updated #{id}"
    end
  end
end