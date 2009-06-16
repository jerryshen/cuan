class CreateClassMonthBenefitRecords < ActiveRecord::Migration
  def self.up
    create_table :class_month_benefit_records do |t|
      t.references :user
      t.float :fee
      t.integer :month
      t.integer :date

      t.timestamps
    end
    add_index :class_month_benefit_records, :user_id
  end

  def self.down
    drop_table :class_month_benefit_records
  end
end
