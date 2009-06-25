class CreateRetiredCollegeBeRecords < ActiveRecord::Migration
  def self.up
    create_table :retired_college_be_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float :diff_be, :default => 0
      t.float :tv_be, :default => 0
      t.float :beaulty_be, :default => 0
      t.float :other_be1, :default => 0
      t.float :other_be2, :default => 0
      t.float :other_be3, :default => 0


      t.timestamps
    end
  end

  def self.down
    drop_table :retired_college_be_records
  end
end
