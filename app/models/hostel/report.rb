class Hostel::Report < ActiveRecord::Base
  STATUS_DRAFT = 1
  STATUS_REPORT = 2
  self.table_name = 'hostel_report'

  belongs_to :flat, class_name: Hostel::Flat, primary_key: :flat_id,
           foreign_key: :flat_id
  belongs_to :user, primary_key: :user_id, foreign_key: :user_id

  has_many :report_offenses, class_name: Hostel::ReportOffense, foreign_key: :hostel_report_id, dependent: :destroy
  accepts_nested_attributes_for :report_offenses, allow_destroy: true
  has_many :offenses, class_name: Hostel::Offense, through: :report_offenses
  has_many :applications, class_name: Hostel::ReportApplication, foreign_key: :hostel_report_id, dependent: :destroy
  accepts_nested_attributes_for :applications, allow_destroy: true, reject_if: proc { |attrs| attrs[:name].blank? }

  scope :from_curator, -> curator {where(user_id: curator.id)}
  scope :ready, -> {where(status: STATUS_REPORT)}

  validates :flat_id, presence: true
  validates :date, presence: true
  validates :time, presence: true

  def draft?
    STATUS_DRAFT == status
  end
end
