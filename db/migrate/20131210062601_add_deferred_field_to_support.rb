class AddDeferredFieldToSupport < ActiveRecord::Migration
  def change
    add_column :support, :deferred, :boolean, default: false
  end
end
