class CreateClassBenefits < ActiveRecord::Migration
  def self.up
    create_table :class_benefits do |t|
      t.references :user
      t.float :total_be, :default => 0
      t.string :term
      t.integer :month
      t.datetime :date

      t.timestamps
    end
    add_index :class_benefits, :user_id
  end

  def self.down
    drop_table :class_benefits
  end
end
