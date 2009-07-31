class CreateEducations < ActiveRecord::Migration
  def self.up
    create_table :educations do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :educations
  end
end
