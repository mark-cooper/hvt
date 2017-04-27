# lib/tasks/calculate_extents.rake
namespace :db do
  desc 'Calculate and update extents for records and collections'
  task calculate_extents: :environment do
    # TODO
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
      puts "Updated extents for Collection #{collection.name} to #{collection.extent}"
    end
  end
end