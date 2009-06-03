class CreateFeeCuttingRecords < ActiveRecord::Migration
  def self.up
    create_table :fee_cutting_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float :room_fee
      t.float :med_fee
      t.float :elc_fee
      t.float :job_fee
      t.float :selfedu_fee
      t.float :other_fee1
      t.float :other_fee2
      t.float :other_fee3
      t.float :self_tax

      t.timestamps
    end
  end

  def self.down
    drop_table :fee_cutting_records
  end
end
