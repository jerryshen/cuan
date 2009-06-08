class CreateRetiredFeeCuttingRecords < ActiveRecord::Migration
  def self.up
    create_table :retired_fee_cutting_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float  :elc_fee
      t.float :other_fee1
      t.float :other_fee2
      t.float :other_fee3

      t.timestamps
    end
  end

  def self.down
    drop_table :retired_fee_cutting_records
  end
end
