class CreateTemp2s < ActiveRecord::Migration
  def self.up
    create_table :temp2s do |t|
      t.string :f1
      t.string :f2
      t.string :f3
      t.string :f4
      t.string :f5
      t.string :f6
      t.string :f8
      t.string :f9
      t.string :f10
      t.string :f11
      t.string :f12
      t.string :f13
      t.string :f14
      t.string :f15
      t.string :f16
      t.string :f17
      t.string :f18
      t.string :f19
      t.string :f20
      t.string :f21
      t.string :f22
      t.string :f23
      t.string :f24
      t.string :f25
      t.string :f26


      t.timestamps
    end
  end

  def self.down
    drop_table :temp2s
  end
end
