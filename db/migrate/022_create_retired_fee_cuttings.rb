class CreateRetiredFeeCuttings < ActiveRecord::Migration
  def self.up
    create_table :retired_fee_cuttings do |t|
      t.references :user
      t.float :other_fee1, :default => 0
      t.float :other_fee2, :default => 0
      t.float :other_fee3, :default => 0

      t.timestamps
    end
    add_index :retired_fee_cuttings, :user_id
  end

  def self.down
    drop_table :retired_fee_cuttings
  end
end
