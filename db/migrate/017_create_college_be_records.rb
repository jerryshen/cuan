class CreateCollegeBeRecords < ActiveRecord::Migration
  def self.up
    create_table :college_be_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float :life_be, :default => 0
      t.float :diff_be, :default => 0
      t.float :livesa_be, :default => 0
      t.float :tv_be, :default => 0
      t.float :beaulty_be, :default => 0
      t.float :other_be, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :college_be_records
  end
end
