class CreateRetiredCollegeBeRecords < ActiveRecord::Migration
  def self.up
    create_table :retired_college_be_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float :diff_be
      t.float :tv_be
      t.float :beaulty_be
      t.float :other_be1
      t.float :other_be2
      t.float :other_be3


      t.timestamps
    end
  end

  def self.down
    drop_table :retired_college_be_records
  end
end
