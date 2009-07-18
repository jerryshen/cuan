class CreateAssistantBenefits < ActiveRecord::Migration
  def self.up
    create_table :assistant_benefits do |t|
      t.references :assistant
      t.float      :benefit, :default => 0
      t.float      :other,   :default => 0
      t.boolean    :is_verified, :default => false
      t.datetime   :date

      t.timestamps
    end
    add_index :assistant_benefits, :assistant_id
  end

  def self.down
    drop_table :assistant_benefits
  end
end
