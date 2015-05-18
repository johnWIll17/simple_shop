class RemoveDefaultActiveUsers < ActiveRecord::Migration
  def change
    change_column :users, :active, :boolean
  end
end
