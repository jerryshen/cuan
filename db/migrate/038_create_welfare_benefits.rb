class CreateWelfareBenefits < ActiveRecord::Migration
  def self.up
    create_table :welfare_benefits do |t|
      t.references :user
      t.string :subject
      t.float :fee
      t.datetime :date

      t.timestamps
    end
    add_index :welfare_benefits, :user_id
  end

  def self.down
    drop_table :welfare_benefits
  end
end
