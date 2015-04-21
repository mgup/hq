class AddFormAndCommentToSocialDocument < ActiveRecord::Migration
  def change
    change_table :social_documents do |t|
      t.integer :form
      t.text    :comment
    end
  end
end
