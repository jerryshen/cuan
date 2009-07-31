class AddStationIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_number, :string
    add_column :users, :job_date,  :datetime
    add_column :users, :ensch_date, :datetime
    add_column :users, :gra_school, :string
    add_column :users, :is_signned, :boolean, :default => false

    add_column :users, :station_id, :integer
    add_column :users, :education_id, :integer
    add_column :users, :degree_id, :integer
    add_column :users, :status_id, :integer

    add_index :users, :station_id
    add_index :users, :education_id
    add_index :users, :degree_id
    add_index :users, :status_id
  end

  def self.down
    remove_column :users, :station_id
    remove_column :users, :education_id
    remove_column :users, :degree_id
    remove_column :users, :status_id
    remove_column :users, :user_number
    remove_column :users, :job_date
    remove_column :users, :ensch_date
    remove_column :users, :gra_school
    remove_column :users, :is_signned
  end
end
