class AddNetFeeToFeeCuttings < ActiveRecord::Migration
  def self.up
    add_column :fee_cuttings, :net_fee, :float, :default => 0
    add_column :fee_cuttings, :elc_fee, :float, :default => 0
    add_column :fee_cutting_records, :net_fee, :float, :default => 0
  end

  def self.down
    remove_column :fee_cuttings, :net_fee
    remove_column :fee_cuttings, :elc_fee
    remove_column :fee_cutting_records, :net_fee
  end
end
