class Group < ActiveRecord::Base
  self.table_name = 'group'

  alias_attribute :id,     :group_id
  alias_attribute :course, :group_course
  alias_attribute :number, :group_number

  belongs_to :speciality, primary_key: :speciality_id, foreign_key: :group_speciality

  has_many :students, foreign_key: :student_group_group
  has_many :exams, foreign_key: :exam_group
  has_many :subjects, foreign_key: :subject_group



  scope :from_speciality, -> speciality {
    cond = all
     if speciality.to_i!=0
      cond=cond.where(group_speciality: speciality)
    else
      cond=all
    end
    cond
  }

  scope :from_course, -> course {
    cond = all
     if (course.to_i >= 1)&&(course.to_i <= 6)
      cond=cond.where(group_course: course)
    else
      cond=all
    end
    cond
  }

  scope :from_form, -> form {
    cond = all
     if (form.to_i >= 101)&&(form.to_i <= 105)
      cond=cond.where(group_form: form)
    else
      cond=all
    end
    cond
  }

  scope :from_faculty, -> faculty {
    cond = all
    if faculty!=""
      cond = cond.joins(:speciality).where(speciality: { speciality_faculty: faculty })
    else
    cond=all
    end
    cond
  }

  def name
    n = []

    n << 'Б' if speciality.bachelor?
    n << 'М' if speciality.master?

    n << "-#{course}-#{number}"
    n.join
  end

end