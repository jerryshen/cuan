class AddIndexToModule < ActiveRecord::Migration
  def self.up
    add_column :page_modules, :index, :integer, :default => 1
  end

  def self.down
    remove_column :page_modules, :index
  end
end
