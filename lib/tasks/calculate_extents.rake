# lib/tasks/calculate_extents.rake

namespace :db do
  namespace :calculate_extents do

    # ./bin/rake db:calculate_extents:tapes
    desc 'Calculate and update extents for records and collections'
    task tapes: :environment do
      extents = {}
      Collection.find_each do |collection|
        extents[collection] = 0
        collection.records.where(has_mrc: true).includes([
          :tapes,
        ]).references(:tapes)
            .find_each(batch_size: 10).lazy.each do |record|
            extent = 0 # initial extent count for record
            extent += record.tapes.where(recording_type: 'Master').count
            extent += record.tapes.where(recording_type: 'Duplicate').count if extent == 0
            extents[collection] += extent # add to collection extent count

            # update our record if extent is different
            if extent != record.extent
              record.extent = extent
              record.save
            end
        end
        collection.extent = extents[collection]
        collection.save
        puts "Updated tape extents for Collection #{collection.name} to #{collection.extent}"
      end
    end

    # ./bin/rake db:calculate_extents:duration
    desc "Calculate and add extents to records for duration"
    task duration: :environment do
      durations = Hash.new(0)
      Dir["db/mediainfo/*.xml"].each do |xml_file|
        id  = xml_file.split("_")[2].to_i
        duration = File.open(xml_file) { |f| Nokogiri::XML(f) }.css("Duration").first
        durations[id] += duration.text.to_i if duration
      end

      durations.each do |id, duration|
        record = Record.find(id)
        d = Time.at(duration / 1000).utc.strftime("%H:%M:%S")
        record.duration = d
        record.save
        puts "Updated duration extents for record #{id} to #{d}"
      end
    end

  end
end