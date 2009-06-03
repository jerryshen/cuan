class CreateBasicSalaries < ActiveRecord::Migration
  def self.up
    create_table :basic_salaries do |t|
      t.references :user
      t.float :station_sa
      t.float :position_sa
      t.float :station_be
      t.float :foreign_be
      t.float :region_be
      t.float :hard_be
      t.float :stay_be

      t.timestamps
    end
    add_index :basic_salaries, :user_id
  end

  def self.down
    drop_table :basic_salaries
  end
end
