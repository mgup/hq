class My::Support < ActiveRecord::Base
  self.table_name = 'support'

  alias_attribute :id,         :support_id
  alias_attribute :year,       :support_year
  alias_attribute :month,      :support_month
  alias_attribute :series,     :support_pseries
  alias_attribute :number,     :support_pnumber
  alias_attribute :date,       :support_pdate
  alias_attribute :department, :support_pdepartment
  alias_attribute :birthday,   :support_pbirthday
  alias_attribute :address,    :support_paddress
  alias_attribute :phone,      :support_pphone

  belongs_to :student, class_name: Student, primary_key: :student_group_id,
             foreign_key: :support_student
  has_many :options,  class_name: My::SupportOption, primary_key: :support_id,
           foreign_key: :support_options_support, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  has_many :causes, through: :options

  scope :open, -> {where(accepted: false, deferred: false)}

  default_scope do
    joins('LEFT JOIN support AS S2 ON S2.support_student = support.support_student AND S2.support_year = support.support_year AND S2.support_month = support.support_month AND support.support_id < S2.support_id')
    .where('S2.support_id IS NULL')
  end

  # ! В одном месте для таких случаев предложили наглый выход !
  def readonly?
    false
  end

  scope :with_causes, -> (causes, strict = false) {
    if strict
      joins = []
      causes.each_with_index do |cause, index|
        joins << "INNER JOIN support_options `op#{index+1}` ON support.support_id = `op#{index+1}`.support_options_support AND `op#{index+1}`.support_options_cause = #{cause}"
      end
      joins(joins.join(' ')).where("(SELECT COUNT(*) FROM support_options WHERE support_options_support = support.support_id) = #{causes.size}")
    else
      joins(:options)
      .where('support_options_cause IN (?)', causes)
    end
  }

  scope :with_last_name, -> (last_name) {
    joins(student: :person).where('last_name_hint LIKE ?', "#{last_name}%")
  }

 conditions = ['support_options_cause = 2 AND (SELECT COUNT(*) FROM support_options WHERE support_options_support = support.support_id) = 1',
   'support_options_cause = 1 AND (SELECT COUNT(*) FROM support_options WHERE support_options_support = support.support_id) = 1',
   'support_options_cause = 34',
   'support_options_cause IN (24,10242,10243)',
   'support_options_cause IN (16,17)',
   'support_options_cause IN (13,14,15)',
   'support_options_cause = 25']

  conditions.each_with_index do |c, index|
    scope "list_#{index+1}", -> {joins(:options).where(c)}
  end

  scope :poor, -> {joins('INNER JOIN support_options op1 ON support.support_id = op1.support_options_support AND op1.support_options_cause = 7')}

  causes = [1,2,34,24,10242,10243,16,17,13,14,15,25]
  [[6, 'INNER JOIN support_options op2 ON support.support_id = op2.support_options_support AND op2.support_options_cause = 6'],
   [[8,9,10,11], 'INNER JOIN support_options op2 ON support.support_id = op2.support_options_support AND op2.support_options_cause IN (8,9,10,11)'],
   [[3,4,5], 'INNER JOIN support_options op2 ON support.support_id = op2.support_options_support AND op2.support_options_cause IN (3,4,5)']].each_with_index do |pc, index|
    scope "list_#{index+8}", -> { poor.joins(pc[1]).where("(SELECT COUNT(*) FROM support_options WHERE support_options_support = support.support_id AND support_options_cause IN (#{causes.join(', ')})) = 0")}
    causes << pc[0]
  end

  scope :list_11, -> {poor.where("(SELECT COUNT(*) FROM support_options WHERE support_options_support = support.support_id AND support_options_cause IN (#{causes.join(', ')})) = 0")}

  scope :list_12, -> {where("(SELECT COUNT(*) FROM support_options WHERE support_options_support = support.support_id AND support_options_cause IN (#{causes.push(7).join(', ')})) = 0")}

  def accepted?
    accepted
  end

  def deferred?
    deferred
  end
end