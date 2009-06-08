class CreateStationPositionBenefits < ActiveRecord::Migration
  def self.up
    create_table :station_position_benefits do |t|
      t.references :user
      t.float :station_be
      t.float :position_be

      t.timestamps
    end
    add_index :station_position_benefits, :user_id
  end

  def self.down
    drop_table :station_position_benefits
  end
end
