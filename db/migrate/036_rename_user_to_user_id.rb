class RenameUserToUserId < ActiveRecord::Migration
  def self.up
    rename_column :basic_salary_records, :user, :user_id
    rename_column :college_be_records, :user, :user_id
    rename_column :fee_cutting_records, :user, :user_id
    rename_column :retired_basic_salary_records, :user, :user_id
    rename_column :retired_college_be_records, :user, :user_id
    rename_column :retired_fee_cutting_records, :user, :user_id
    rename_column :station_position_benefit_records, :user, :user_id

    change_column :basic_salary_records, :user_id, :integer
    change_column :college_be_records, :user_id, :integer
    change_column :fee_cutting_records, :user_id, :integer
    change_column :retired_basic_salary_records, :user_id, :integer
    change_column :retired_college_be_records, :user_id, :integer
    change_column :retired_fee_cutting_records, :user_id, :integer
    change_column :station_position_benefit_records, :user_id, :integer

    add_index :basic_salary_records, :user_id
    add_index :college_be_records, :user_id
    add_index :fee_cutting_records, :user_id
    add_index :retired_basic_salary_records, :user_id
    add_index :retired_college_be_records, :user_id
    add_index :retired_fee_cutting_records, :user_id
    add_index :station_position_benefit_records, :user_id
  end

  def self.down
    rename_column :basic_salary_records, :user_id, :user
    rename_column :college_be_records, :user_id, :user
    rename_column :fee_cutting_records, :user_id, :user
    rename_column :retired_basic_salary_records, :user_id, :user
    rename_column :retired_college_be_records, :user_id, :user
    rename_column :retired_fee_cutting_records, :user_id, :user
    rename_column :station_position_benefit_records, :user_id, :user

    change_column :basic_salary_records, :user, :string
    change_column :college_be_records, :user, :string
    change_column :fee_cutting_records, :user, :string
    change_column :retired_basic_salary_records, :user, :string
    change_column :retired_college_be_records, :user, :string
    change_column :retired_fee_cutting_records, :user, :string
    change_column :station_position_benefit_records, :user, :string

    remove_index :basic_salary_records, :user_id
    remove_index :college_be_records, :user_id
    remove_index :fee_cutting_records, :user_id
    remove_index :retired_basic_salary_records, :user_id
    remove_index :retired_college_be_records, :user_id
    remove_index :retired_fee_cutting_records, :user_id
    remove_index :station_position_benefit_records, :user_id
  end
end
