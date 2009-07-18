class AddContractNumberToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :contract_number, :string
    add_column :users, :valid_from, :datetime
    add_column :users, :valid_end, :datetime
  end

  def self.down
    remove_column :users, :contract_number
    remove_column :users, :valid_from
    remove_column :users, :valid_end
  end
end
