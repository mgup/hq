class Student < ActiveRecord::Base
  include Nameable

  self.table_name = 'student_group'

  alias_attribute :id,  :student_group_id

  belongs_to :fname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_fname
  belongs_to :iname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_iname
  belongs_to :oname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_oname

  default_scope do
    select('student_group.*, student.*')
    .joins('INNER JOIN student ON student_id = student_group_student')
    .joins('INNER JOIN dictionary fnames ON fnames.dictionary_id = student_fname')
    .joins('INNER JOIN dictionary inames ON inames.dictionary_id = student_iname')
    .joins('INNER JOIN dictionary onames ON onames.dictionary_id = student_oname')
    .order('fnames.dictionary_ip, inames.dictionary_ip, onames.dictionary_ip')
  end

  scope :filter, -> filters {
    cond = all

    if filters.key?(:name)
      fields = %w(fnames.dictionary_ip inames.dictionary_ip onames.dictionary_ip)
      names = filters[:name].split(' ').map { |n| "%#{n}%" }

      cond = cond.where((["CONCAT_WS(' ', #{fields.join(',')}) LIKE ?"] * names.size).join(' AND '), *names)
    end

    if filters.key?(:status)
      cond = cond.where(student_group_status: filters[:status])
    end

    cond
  }
end