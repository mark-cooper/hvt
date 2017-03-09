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

  # TODO subjects = EAD.get_authorities(SubjectAuthority, :subject_authorities) etc.
  # TODO EAD.id_for_recording_type(tape.recording_type)

end