class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.references :department
      t.references :td_belongs
      t.string :gender
      t.references :title
      t.references :position
      t.datetime :birthday
      t.string :id_card
      t.string :login_id
      t.string :password
      t.boolean :is_nature
      t.boolean :is_retired

      t.timestamps
    end
    add_index :users, :department_id
    add_index :users, :td_belongs_id
    add_index :users, :title_id
    add_index :users, :position_id
  end

  def self.down
    drop_table :users
  end
end
