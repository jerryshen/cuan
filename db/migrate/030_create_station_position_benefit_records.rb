class CreateStationPositionBenefitRecords < ActiveRecord::Migration
  def self.up
    create_table :station_position_benefit_records do |t|
      t.string :user
      t.string :year
      t.string :month
      t.float :station_be, :default => 0
      t.float :position_be, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :station_position_benefit_records
  end
end
