class CreateTemp5s < ActiveRecord::Migration
  def self.up
    create_table :temp5s do |t|
      t.string :f1
      t.string :f2
      t.string :f3
      t.string :f4
      t.string :f5
      t.string :f6
      t.string :f7
      t.string :f8
      t.string :f9
      t.string :f10
      t.string :f11
      t.string :f12
      t.string :f13
      t.string :f14

      t.timestamps
    end
  end

  def self.down
    drop_table :temp5s
  end
end
