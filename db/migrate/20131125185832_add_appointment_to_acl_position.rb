class AddAppointmentToAclPosition < ActiveRecord::Migration
  def change
    change_table 'acl_position' do |t|
      t.references :appointment
    end
  end
end
