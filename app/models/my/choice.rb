class My::Choice< ActiveRecord::Base
  self.table_name = 'optional'

  alias_attribute :id,         :optional_id
  alias_attribute :form,       :optional_form
  alias_attribute :speciality, :optional_speciality
  alias_attribute :course,     :optional_course
  alias_attribute :term,       :optional_term
  alias_attribute :option,     :optional_option
  alias_attribute :title,      :optional_title



  has_many :selections,  class_name: My::Select, primary_key: :optional_id,
           foreign_key: :optional_select_optional
  has_many :students, :through => :selections

  scope :from_group, -> group { where(optional_form: group.form,
                                      optional_speciality: group.speciality,
                                      optional_course: group.course) }
end