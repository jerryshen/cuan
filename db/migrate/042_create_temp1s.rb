class CreateTemp1s < ActiveRecord::Migration
  def self.up
    create_table :temp1s do |t|
      t.string :f1
      t.string :f2
      t.string :f3
      t.string :f4
      t.string :f5
      t.string :f6
      t.string :f7

      t.timestamps
    end
  end

  def self.down
    drop_table :temp1s
  end
end
