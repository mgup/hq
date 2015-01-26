class RemoveDictionaryOldIdFromDictionary < ActiveRecord::Migration
  def change
    change_table :dictionary do |t|
      t.remove :dictionary_oldid
    end
  end
end
