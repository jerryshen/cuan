class CreateCollegeBenefits < ActiveRecord::Migration
  def self.up
    create_table :college_benefits do |t|
      t.references :user
      t.float :life_be, :default => 0
      t.float :diff_be, :default => 0
      t.float :livesa_be, :default => 0
      t.float :tv_be, :default => 0
      t.float :beaulty_be, :default => 0
      t.float :other_be, :default => 0

      t.timestamps
    end
    add_index :college_benefits, :user_id
  end

  def self.down
    drop_table :college_benefits
  end
end
