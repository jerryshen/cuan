class CreatePerformanceBenefitRecords < ActiveRecord::Migration
  def self.up
    create_table :performance_benefit_records do |t|
      t.references :user
      t.integer :term
      t.float :fee, :default => 0
      t.datetime :date

      t.timestamps
    end
    add_index :performance_benefit_records, :user_id
  end

  def self.down
    drop_table :performance_benefit_records
  end
end
