class RenameTypeToBeType < ActiveRecord::Migration
  def self.up
    rename_column :undefind_fees, :type, :be_type
  end

  def self.down
  end
end
