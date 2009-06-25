class CreateBasicSalaries < ActiveRecord::Migration
  def self.up
    create_table :basic_salaries do |t|
      t.references :user
      t.float :station_sa, :default => 0
      t.float :position_sa, :default => 0
      t.float :station_be, :default => 0
      t.float :foreign_be, :default => 0
      t.float :region_be, :default => 0
      t.float :hard_be, :default => 0
      t.float :stay_be, :default => 0

      t.timestamps
    end
    add_index :basic_salaries, :user_id
  end

  def self.down
    drop_table :basic_salaries
  end
end
