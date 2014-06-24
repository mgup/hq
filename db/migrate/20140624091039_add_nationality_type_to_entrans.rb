class AddNationalityTypeToEntrans < ActiveRecord::Migration
  def change
    change_table :entrance_entrants do |t|
      t.belongs_to :nationality_type, default: 1, null: false
    end
  end
end
