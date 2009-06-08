class CreateRetiredBasicSalaryRecords < ActiveRecord::Migration
  def self.up
    create_table :retired_basic_salary_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float  :basic_fee
      t.float  :stay_be
      t.float  :foreign_be
      t.float  :region_be

      t.timestamps
    end
  end

  def self.down
    drop_table :retired_basic_salary_records
  end
end
