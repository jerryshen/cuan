class CreateAssistantBenefitStandards < ActiveRecord::Migration
  def self.up
    create_table :assistant_benefit_standards do |t|
      t.references :assistant
      t.float :benefit
      t.float :other

      t.timestamps
    end
    add_index :assistant_benefit_standards, :assistant_id
  end

  def self.down
    drop_table :assistant_benefit_standards
  end
end
