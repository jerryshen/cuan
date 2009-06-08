class AddIsVerifiedToBenefits < ActiveRecord::Migration
  def self.up
    add_column :science_benefits, :is_verified, :boolean, :default => false
    add_column :class_benefits, :is_verified, :boolean, :default => false
  end

  def self.down
    remove_column :science_benefits, :is_verified
    remove_column :class_benefits, :is_verified
  end
end
