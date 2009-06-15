class AddNetFeeToFeeCuttings < ActiveRecord::Migration
  def self.up
    add_column :fee_cuttings, :net_fee, :float
    add_column :fee_cuttings, :elc_fee, :float
    add_column :fee_cutting_records, :net_fee, :float
  end

  def self.down
    remove_column :fee_cuttings, :net_fee
    remove_column :fee_cuttings, :elc_fee
    remove_column :fee_cutting_records, :net_fee
  end
end
