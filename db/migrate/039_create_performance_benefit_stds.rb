class CreatePerformanceBenefitStds < ActiveRecord::Migration
  def self.up
    create_table :performance_benefit_stds do |t|
      t.references :user
      t.float :std_fee

      t.timestamps
    end
    add_index :performance_benefit_stds, :user_id
  end

  def self.down
    drop_table :performance_benefit_stds
  end
end
