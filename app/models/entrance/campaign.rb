class Entrance::Campaign < ActiveRecord::Base
  CURRENT = 2015
  ZAOCHKA = 22015
  CRIMEA = 32015
  ASPIRANT = 42015
  STATELINE = 52015

  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name_prefix = 'entrance_'

  enum status: { not_started: 0, started: 1, finished: 2 }

  has_many :dates, class_name: 'Entrance::Date'
  has_many :events, class_name: 'Entrance::Event'
  has_many :min_scores, class_name: Entrance::MinScore
  has_many :exams, class_name: 'Entrance::Exam'
  has_many :entrants, class_name: 'Entrance::Entrant'
  has_many :applications, class_name: 'Entrance::Application'
  has_many :contracts, class_name: 'Entrance::Contract', through: :applications
  has_and_belongs_to_many :education_forms
  has_many :competitive_groups, class_name: 'Entrance::CompetitiveGroup'
  has_many :items, class_name: 'Entrance::CompetitiveGroupItem', through: :competitive_groups
  has_many :checks, through: :entrants
  has_many :achievement_types, class_name: 'Entrance::AchievementType', foreign_key: :campaign_id
  has_many :achievements, class_name: 'Entrance::Achievement', through: :achievement_types
  
  scope :this_year, -> { where(start_year: Entrance::Campaign::CURRENT) }
end
