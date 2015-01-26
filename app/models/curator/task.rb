class Curator::Task < ActiveRecord::Base
  self.table_name = 'curator_task'

  STATUS_ACTIVE = 1
  STATUS_DRAFT = 2
  STATUS_CLOSED = 3

  has_many :task_users, class_name: Curator::TaskUser, foreign_key: :curator_task_id
  has_many :users, through: :task_users

  belongs_to :type, class_name: Curator::TaskType, foreign_key: :curator_task_type_id

  scope :publications, -> {where(status: STATUS_ACTIVE)}
  scope :drafts, -> {where(status: STATUS_DRAFT)}

  scope :without_drafts, -> {where(status: [ STATUS_ACTIVE, STATUS_CLOSED])}
  scope :from_name, -> name { where('name LIKE :prefix', prefix: "%#{name}%")}

  validates :name, presence: true
  validates :status, presence: true
  validates :type, presence: true

  def draft?
    STATUS_DRAFT == status
  end

  def active?
    STATUS_ACTIVE == status
  end

  def closed?
    STATUS_CLOSED == status
  end
end