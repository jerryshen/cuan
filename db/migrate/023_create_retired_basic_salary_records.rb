class CreateRetiredBasicSalaryRecords < ActiveRecord::Migration
  def self.up
    create_table :retired_basic_salary_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float  :basic_fee, :default => 0
      t.float  :stay_be, :default => 0
      t.float  :foreign_be, :default => 0
      t.float  :region_be, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :retired_basic_salary_records
  end
end
