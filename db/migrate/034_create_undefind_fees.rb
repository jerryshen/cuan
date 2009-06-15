class CreateUndefindFees < ActiveRecord::Migration
  def self.up
    create_table :undefind_fees do |t|
      t.references :user
      t.string :subject
      t.float :fee
      t.datetime :date
      t.string :type

      t.timestamps
    end
    add_index :undefind_fees, :user_id
  end

  def self.down
    drop_table :undefind_fees
  end
end
