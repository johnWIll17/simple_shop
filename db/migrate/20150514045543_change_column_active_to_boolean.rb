class ChangeColumnActiveToBoolean < ActiveRecord::Migration
  def change
    change_column :categories, :active, :boolean
    change_column :products, :active, :boolean
    change_column :users, :active, :boolean
  end
end
