class AddYearToAssistantBenefits < ActiveRecord::Migration
  def self.up
    add_column :assistant_benefits, :year, :integer
    add_column :assistant_benefits, :month, :integer
  end

  def self.down
    remove_column :assistant_benefits, :month
    remove_column :assistant_benefits, :year
  end
end
