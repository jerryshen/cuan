class CreateRetiredBasicSalaries < ActiveRecord::Migration
  def self.up
    create_table :retired_basic_salaries do |t|
      t.references :user
      t.float :basic_fee
      t.float :stay_be
      t.float :foreign_be
      t.float :region_be

      t.timestamps
    end
    add_index :retired_basic_salaries, :user_id
  end

  def self.down
    drop_table :retired_basic_salaries
  end
end
