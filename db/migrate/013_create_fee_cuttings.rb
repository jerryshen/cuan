class CreateFeeCuttings < ActiveRecord::Migration
  def self.up
    create_table :fee_cuttings do |t|
      t.references :user
      t.float :room_fee, :default => 0
      t.float :med_fee, :default => 0
      t.float :job_fee, :default => 0
      t.float :selfedu_fee, :default => 0
      t.float :other_fee1, :default => 0
      t.float :other_fee2, :default => 0
      t.float :other_fee3, :default => 0

      t.timestamps
    end
    add_index :fee_cuttings, :user_id
  end

  def self.down
    drop_table :fee_cuttings
  end
end
