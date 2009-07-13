class AddNumberToTemp1s < ActiveRecord::Migration
  def self.up
    add_column :temp1s, :number, :string
    add_column :temp2s, :number, :string
    add_column :temp3s, :number, :string
    add_column :temp4s, :number, :string
    add_column :temp5s, :number, :string
    add_column :users,  :number, :string
  end

  def self.down
    remove_column :temp1s, :number
    remove_column :temp2s, :number
    remove_column :temp3s, :number
    remove_column :temp4s, :number
    remove_column :temp5s, :number
    remove_column :users,  :number

  end
end
