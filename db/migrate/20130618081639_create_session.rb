class CreateSession < ActiveRecord::Migration
  def change
    create_table  :sessions do |t|
    	t.string        :year
      t.string        :semester
	  	t.references    :groups
	  	t.string        :subject
	    t.string        :type
	    t.references    :user

	    t.timestamps
    end

    add_index :sessions, :group_id
    add_index :sessions, :user_id
  end
end
