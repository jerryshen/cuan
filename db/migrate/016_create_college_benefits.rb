class CreateCollegeBenefits < ActiveRecord::Migration
  def self.up
    create_table :college_benefits do |t|
      t.references :user
      t.float :life_be
      t.float :diff_be
      t.float :livesa_be
      t.float :tv_be
      t.float :beaulty_be
      t.float :other_be

      t.timestamps
    end
    add_index :college_benefits, :user_id
  end

  def self.down
    drop_table :college_benefits
  end
end
