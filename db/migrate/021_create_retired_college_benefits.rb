class CreateRetiredCollegeBenefits < ActiveRecord::Migration
  def self.up
    create_table :retired_college_benefits do |t|
      t.references :user
      t.float :diff_be, :default => 0
      t.float :tv_be, :default => 0
      t.float :beaulty_be, :default => 0
      t.float :other_be1, :default => 0
      t.float :other_be2, :default => 0
      t.float :other_be3, :default => 0

      t.timestamps
    end
    add_index :retired_college_benefits, :user_id
  end

  def self.down
    drop_table :retired_college_benefits
  end
end
