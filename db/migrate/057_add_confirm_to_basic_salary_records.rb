class AddConfirmToBasicSalaryRecords < ActiveRecord::Migration
  def self.up
    add_column :basic_salary_records, :confirm, :boolean, :default => false
    add_column :college_be_records, :confirm, :boolean, :default => false
    add_column :fee_cutting_records, :confirm, :boolean, :default => false
    add_column :retired_basic_salary_records, :confirm, :boolean, :default => false
    add_column :retired_college_be_records, :confirm, :boolean, :default => false
    add_column :retired_fee_cutting_records, :confirm, :boolean, :default => false
  end

  def self.down
    remove_column :basic_salary_records, :confirm
    remove_column :college_be_records, :confirm
    remove_column :fee_cutting_records, :confirm
    remove_column :retired_basic_salary_records, :confirm
    remove_column :retired_college_be_records, :confirm
    remove_column :retired_fee_cutting_records, :confirm
  end
end
