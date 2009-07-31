class AddIndexToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :index, :integer, :default => 0
  end

  def self.down
    remove_column :pages, :index
  end
end
