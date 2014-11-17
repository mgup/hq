class CreateProof < ActiveRecord::Migration
  def change
    create_table :proofs do |t|
      t.date       :date
      t.date       :from
      t.date       :to

      t.belongs_to :student_group
      t.integer    :ref_type
    end
  end
end
