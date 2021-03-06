# lib/tasks/sample_data.rake
namespace :db do
  def random_date(interval)
    Faker::Time.between(DateTime.now - interval, DateTime.now)
  end

  desc 'Populate the database with sample data'
  task populate_sample_data: :environment do
    r = Record.create!({
      id: 2,
      identifier: 'HVT-2',
      title: Faker::Book.title,
      extent: 2,
      extent_expression: '2 videorecordings (43 min. and 1 hr.) : col.',
      collection: Collection.create!(name: 'Video Collection'),
      abstract: Faker::HarryPotter.quote,
      note: 'NOTE!',
      citation: 'CITE ME!',
      related_record_stmt: 'Associated material HVT-3',
      identification_stmt: '3 copies with time coding.',
      summary_by: [Summarizer.create(name: Faker::Name.name)],
      summary_date: random_date(-365),
      cataloged_by: [Cataloger.create(name: Faker::Name.name)],
      cataloged_date: random_date(-365),
      input_by: [Inputter.create(name: Faker::Name.name)],
      input_date: random_date(-365),
      edited_by: [Editor.create(name: Faker::Name.name)],
      edited_date: random_date(-365),
      corrected_by: [Corrector.create(name: Faker::Name.name)],
      corrected_date: random_date(-365),
      produced_by: [Producer.create(name: Faker::Name.name)],
      produced_date: random_date(-365),
      has_mrc: true,
      has_paradox: true,
    })

    2.times do
      iview = r.interviews.create!({
        date: random_date(-365),
      })
      iview.interviewees << Interviewee.create(name: Faker::Name.name)
      iview.interviewers << Interviewer.create(name: Faker::Name.name)
      iview.interviewers << Interviewer.create(name: Faker::Name.name)
    
      r.proofs.create!({
        proofers: [Proofer.create(name: Faker::Name.name)],
        date: random_date(-365),
      })
    end

    puts 'Populated with sample data!'
  end
end