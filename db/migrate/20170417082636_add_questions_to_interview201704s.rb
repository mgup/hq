class AddQuestionsToInterview201704s < ActiveRecord::Migration
  def change
    add_column :interview201704s, :question2, :text
    add_column :interview201704s, :question3, :text
    add_column :interview201704s, :question5, :text
    add_column :interview201704s, :question7, :text
    add_column :interview201704s, :question8, :text
    add_column :interview201704s, :ip_address, :string
  end
end
