class CreateCollegeBeRecords < ActiveRecord::Migration
  def self.up
    create_table :college_be_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float :life_be
      t.float :diff_be
      t.float :livesa_be
      t.float :tv_be
      t.float :beaulty_be
      t.float :other_be

      t.timestamps
    end
  end

  def self.down
    drop_table :college_be_records
  end
end
