class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.text :name
      t.timestamps
    end
  end
end
