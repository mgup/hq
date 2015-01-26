class CreateTemplateStudenGroupStatus < ActiveRecord::Migration
  def change
    create_table :template_student_group_statuses do |t|
      t.belongs_to :template
      t.belongs_to :education_status
    end
  end
end
