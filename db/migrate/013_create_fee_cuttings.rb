class CreateFeeCuttings < ActiveRecord::Migration
  def self.up
    create_table :fee_cuttings do |t|
      t.references :user
      t.float :room_fee
      t.float :med_fee
      t.float :job_fee
      t.float :selfedu_fee
      t.float :other_fee1
      t.float :other_fee2
      t.float :other_fee3

      t.timestamps
    end
    add_index :fee_cuttings, :user_id
  end

  def self.down
    drop_table :fee_cuttings
  end
end
