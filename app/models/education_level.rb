class EducationLevel < ActiveRecord::Base
  enum status: { bachelor: 2, reduced_bachelor: 3, applied_bachelor: 19,
                 specialty: 5, magistrates: 4, spo: 17, postgraduate: 18 }

end
