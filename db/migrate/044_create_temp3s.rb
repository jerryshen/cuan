class CreateTemp3s < ActiveRecord::Migration
  def self.up
    create_table :temp3s do |t|
      t.string :f1
      t.string :f2
      t.string :f3
      t.string :f4
      t.string :f5
      t.string :f6
      t.string :f7
      t.string :f8


      t.timestamps
    end
  end

  def self.down
    drop_table :temp3s
  end
end
