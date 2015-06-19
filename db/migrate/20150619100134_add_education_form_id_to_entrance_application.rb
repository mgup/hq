class AddEducationFormIdToEntranceApplication < ActiveRecord::Migration
  def change
    add_column :entrance_applications, :education_form_id, :integer
  end
end
