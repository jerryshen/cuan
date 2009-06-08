class CreateScienceBenefits < ActiveRecord::Migration
  def self.up
    create_table :science_benefits do |t|
      t.references :user
      t.float :science_be
      t.string :year
      t.integer :month
      t.datetime :date

      t.timestamps
    end
    add_index :science_benefits, :user_id
  end

  def self.down
    drop_table :science_benefits
  end
end
