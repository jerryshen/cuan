class CreateBasicSalaryRecords < ActiveRecord::Migration
  def self.up
    create_table :basic_salary_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float :station_sa, :default => 0
      t.float :position_sa, :default => 0
      t.float :station_be, :default => 0
      t.float :foreign_be, :default => 0
      t.float :region_be, :default => 0
      t.float :add_sa, :default => 0
      t.float :hard_be, :default => 0
      t.float :stay_be, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :basic_salary_records
  end
end
