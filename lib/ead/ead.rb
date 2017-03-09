require_relative "from_collection"
require_relative "from_record"
require_relative "from_records"

module EAD

  HVT_ADDRESS = [
    "Yale University Library",
    "P.O. Box 208240",
    "New Haven, CT 06520-8240",
    "mssa.assist@yale.edu",
    "URL: ",
  ]

  HVT_URL = "http://www.library.yale.edu/mssa/"

  # subjects = EAD.get_authorities(record, SubjectAuthority, :subject_authorities) etc.
  def self.get_authorities(record, klass, association_method)
    record.send(association_method).all.map {
      |a| { type: klass.element, name: a[:name], source: a[:source] }
    }
  end

  # EAD.id_for_recording_type(tape.recording_type)
  def self.id_for_recording_type(recording_type)
    recording_type.downcase.gsub(/\s/, '_')
  end

end