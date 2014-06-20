class Entrance::Entrant < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  enum gender: { male: 1, female: 0 }
  enum citizenship: { russian: 1 }
  enum acountry: { russia: 0, cis: 1, other_countries: 2 }
  enum military_service: { not: 1, conscript: 2, reservist: 6,
                           free_of_service: 7, too_young: 8 }
  enum foreign_language: { english: 24, german: 12, french: 13, spanish: 14 }

  belongs_to :campaign, class_name: 'Entrance::Campaign'

  has_many :exam_results, class_name: 'Entrance::ExamResult'
  accepts_nested_attributes_for :exam_results, allow_destroy: true

  has_many :applications, class_name: 'Entrance::Application'
  accepts_nested_attributes_for :applications, allow_destroy: true

  def full_name
    [last_name, first_name, patronym].join(' ')
  end

  def short_name
    "#{last_name} #{first_name[0]}. #{patronym[0]}."
  end
end
