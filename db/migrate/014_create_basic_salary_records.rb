class CreateBasicSalaryRecords < ActiveRecord::Migration
  def self.up
    create_table :basic_salary_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float :station_sa
      t.float :position_sa
      t.float :station_be
      t.float :foreign_be
      t.float :region_be
      t.float :add_sa
      t.float :hard_be
      t.float :stay_be

      t.timestamps
    end
  end

  def self.down
    drop_table :basic_salary_records
  end
end
